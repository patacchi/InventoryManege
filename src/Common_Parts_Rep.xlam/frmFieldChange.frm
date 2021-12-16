VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmFieldChange 
   Caption         =   "�t�B�[���h�A�b�v�f�[�g"
   ClientHeight    =   6255
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   10095
   OleObjectBlob   =   "frmFieldChange.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmFieldChange"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub btnDoUpdate_Click()
    '�t�B�[���h�C���K�p
    If lstBoxTable_Name.ListIndex = -1 Or lstBoxField_Name.ListIndex = -1 Then
        Exit Sub
    End If
    Dim adoFieldUpdate As clsADOHandle
    Set adoFieldUpdate = CreateclsADOHandleInstance
    '�ύX�Ώۂł���Digit_offset�t�B�[���h�����݂��邩�`�F�b�N����
    Dim isDigitOffset As Boolean
    isDigitOffset = adoFieldUpdate.IsFieldExists(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), F_CAT_DIGIT_OFFSET, _
                                                    txtBoxDB_FileName.Text, txtBoxDB_Directory.Text)
    '�A�b�v�f�[�g�`�F�b�N�t�B�[���h�����݂��邩�`�F�b�N����
    Dim isUpdateField As Boolean
    isUpdateField = adoFieldUpdate.IsFieldExists(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), F_DIGIT_UPDATE, _
                                                    txtBoxDB_FileName.Text, txtBoxDB_Directory.Text)
    'Digit_Row�t�B�[���h�����݂��邩�`�F�b�N����
    Dim isDigitRow As Boolean
    isDigitRow = adoFieldUpdate.IsFieldExists(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), F_CAT_DIGIT_ROW, _
                                                    txtBoxDB_FileName.Text, txtBoxDB_Directory.Text)
    'stop
    Stop
End Sub
Private Sub btnGetTableList_Click()
    Dim dbGetTable As clsADOHandle
    Set dbGetTable = New clsADOHandle
    dbGetTable.DBPath = txtBoxDB_Directory.Text
    dbGetTable.DBFileName = txtBoxDB_FileName.Text
    '�e�[�u���ꗗ���擾
    Dim adoxcatChange As adox.Catalog
    Set adoxcatChange = New adox.Catalog
    adoxcatChange.ActiveConnection = dbGetTable.ConnectionString
    Dim adoxTable As adox.Table
    Dim strarrTableName() As String
    Dim longTableCount As Long
    longTableCount = 0
    For Each adoxTable In adoxcatChange.Tables
        If adoxTable.Type = "TABLE" Then
            ReDim Preserve strarrTableName(longTableCount)
            strarrTableName(longTableCount) = adoxTable.Name
            longTableCount = longTableCount + 1
        End If
    Next adoxTable
    lstBoxTable_Name.List = strarrTableName
    Set adoxcatChange = Nothing
    Set dbGetTable = Nothing
End Sub
Private Sub lstBOxField_Name_Change()
    '�e�[�u�����ƃt�B�[���h���ǂ�����I������Ă�����Update�{�^����L���ɂ���
    If lstBoxField_Name.ListIndex >= 0 And lstBoxTable_Name.ListIndex >= 0 Then
        btnDoUpdate.Enabled = True
    Else
        btnDoUpdate.Enabled = False
    End If
End Sub
Private Sub lstBoxTable_Name_Change()
    '���I����ԂȂ甲����
    If lstBoxTable_Name.ListIndex = -1 Then
        Exit Sub
    End If
    Dim dbFieldList As clsADOHandle
    Set dbFieldList = New clsADOHandle
    dbFieldList.DBPath = txtBoxDB_Directory.Text
    dbFieldList.DBFileName = txtBoxDB_FileName.Text
    Dim strSQL As String
    strSQL = "SELECT TOP 1 * FROM " & lstBoxTable_Name.List(lstBoxTable_Name.ListIndex)
    dbFieldList.SQL = strSQL
    Dim isCollect As Boolean
    isCollect = dbFieldList.Do_SQL_with_NO_Transaction()
    If Not isCollect Then
        Exit Sub
    End If
    If dbFieldList.RS.RecordCount <= 0 Then
        lstBoxField_Name.ListIndex = -1
        lstBoxField_Name.Clear
        Exit Sub
    End If
    Dim strarrFieldList() As String
    ReDim strarrFieldList(dbFieldList.RS.Fields.Count - 1)
    Dim longFieldCount As Long
    For longFieldCount = 0 To dbFieldList.RS.Fields.Count - 1
        strarrFieldList(longFieldCount) = dbFieldList.RS.Fields(longFieldCount).Name
    Next longFieldCount
    '�t�B�[���h�����X�g�ɔz���ݒ�
    lstBoxField_Name.List = strarrFieldList
    '�t�B�[���h�����X�g�𖢑I����Ԃɂ���
    lstBoxField_Name.ListIndex = -1
    '�t�B�[���h����I������܂�Update�{�^���𖳌���
    btnDoUpdate.Enabled = False
    Set dbFieldList = Nothing
End Sub
Private Sub UserForm_Initialize()
    '�����l�𓊓�
    Dim dbChange As clsADOHandle
    Set dbChange = New clsADOHandle
    txtBoxDB_Directory.Text = dbChange.DBPath
    txtBoxDB_FileName.Text = dbChange.DBFileName
    txtBoxDate_Max.Text = GetLocalTimeWithMilliSec
    '�e�[�u���ꗗ���擾
    Dim adoxcatChange As adox.Catalog
    Set adoxcatChange = New adox.Catalog
    adoxcatChange.ActiveConnection = dbChange.ConnectionString
    Dim adoxTable As adox.Table
    Dim strarrTableName() As String
    Dim longTableCount As Long
    longTableCount = 0
    For Each adoxTable In adoxcatChange.Tables
        If adoxTable.Type = "TABLE" Then
            ReDim Preserve strarrTableName(longTableCount)
            strarrTableName(longTableCount) = adoxTable.Name
            longTableCount = longTableCount + 1
        End If
    Next adoxTable
'    lstBoxTable_Name.List = strarrTableName
    Set adoxcatChange = Nothing
    Set dbChange = Nothing
End Sub
VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmFieldChange 
   Caption         =   "�t�B�[���h�A�b�v�f�[�g"
   ClientHeight    =   6255
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   12660
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
    'DB�t�@�C�����ƃf�B���N�g�����e�L�X�g�{�b�N�X�̓��e���N���X�C���X�^���X�̃v���p�e�B�ɃZ�b�g���Ă��
    adoFieldUpdate.DBPath = txtBoxDB_Directory.Text
    adoFieldUpdate.DBFileName = txtBoxDB_FileName.Text
    '�ύX�Ώۂł���Digit_offset�t�B�[���h�����݂��邩�`�F�b�N����
    Dim isDigitOffset As Boolean
    'Enum�N���X�̃C���X�^���X�𗘗p����Const�̐��l����������
    Dim clsEnumValue As clsEnum
    Set clsEnumValue = CreateclsEnum
    isDigitOffset = adoFieldUpdate.IsFieldExists(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATDigitField(F_Digit_Offset_cmdg))
    If Not isDigitOffset Then
        '��������DigitOffset�t�B�[���h�������ꍇ
        '�A�b�v�f�[�g�Ώۂ̃t�B�[���h���Ȃ����߂��̏�Ŕ�����
        DebugMsgWithTime "btnDoUpdate: DigitOffset field not found."
        Exit Sub
    End If
    '�A�b�v�f�[�g�`�F�b�N�t�B�[���h�����݂��邩�`�F�b�N����
    Dim isUpdateField As Boolean
    isUpdateField = adoFieldUpdate.IsFieldExists(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm))
    If Not isUpdateField Then
        'update�t�B�[���h���Ȃ���΍쐬����
        Call adoFieldUpdate.AppendField(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm), Boolean_typ)
        '�ȉ��e�X�g accdbType
        Call adoFieldUpdate.AppendField(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm) & "_TEXT", Text_typ)
        Call adoFieldUpdate.AppendField(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm) & "_Integer", Integer_typ)
        Call adoFieldUpdate.AppendField(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm) & "_Decimal", Decimal_typ)
        Call adoFieldUpdate.AppendField(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm) & "_Single", Single_typ)
        Call adoFieldUpdate.AppendField(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm) & "_Double", Double_Typ)
        '�I�[�g�i���o�[�^�̃t�B�[���h�̓e�[�u���Ɉ�̂�
'        Call adoFieldUpdate.AppendField(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATTempField(F_Digit_Update_ctm) & "_Counter", AUTOINCREMENT_typ)
    End If
    'Digit_Row�t�B�[���h�����݂��邩�`�F�b�N����
    Dim isDigitRow As Boolean
'    isDigitRow = adoFieldUpdate.IsFieldExists(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), F_CAT_DIGIT_ROW)
    isDigitRow = adoFieldUpdate.IsFieldExists(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex), clsEnumValue.CATDigitField(F_Digit_Row_cmdg))
    'stop
    Stop
End Sub
Private Sub btnGetTableList_Click()
    Dim dbGetTable As clsADOHandle
    Set dbGetTable = New clsADOHandle
    dbGetTable.DBPath = txtBoxDB_Directory.Text
    dbGetTable.DBFileName = txtBoxDB_FileName.Text
    'DBPath��DBFilename�e�L�X�g�{�b�N�X���폜����Ă���ꍇ�͕W���ݒ�����������Ă�͂��Ȃ̂ŁA�N���X�̃v���p�e�B�̓��e���e�L�X�g�{�b�N�X�ɔ��f���Ă��
    txtBoxDB_Directory.Text = dbGetTable.DBPath
    txtBoxDB_FileName.Text = dbGetTable.DBFileName
    'DBFile�̑��ݗL���m�F
    Dim isDBFileExists As Boolean
    isDBFileExists = dbGetTable.IsDBFileExist(dbGetTable.DBFileName, dbGetTable.DBPath)
    If Not isDBFileExists Then
        '�t�@�C�������݂��Ȃ������甲����
        MsgBox "btnGetTableList_Click Path:  " & dbGetTable.DBPath & vbCrLf & " Filename: " & dbGetTable.DBFileName & " is not exists"
        Exit Sub
    End If
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
Private Sub IEbrowser_BeforeNavigate2(ByVal pDisp As Object, URL As Variant, Flags As Variant, TargetFrameName As Variant, PostData As Variant, Headers As Variant, Cancel As Boolean)
    '�{����Web�y�[�W��\������R���g���[�������A�h���b�O�A���h�h���b�v������URL�Ƀt�@�C���������̂܂ܓ��邽�߁A����𗘗p����
    '�����t�@�C���̑I���͕s��
    '���ۂ�Navigate�����s���Ȃ��悤��Cancel��True�ɃZ�b�g����
    Cancel = True
    Dim fsoFileNameGet As FileSystemObject
    Set fsoFileNameGet = New FileSystemObject
    If Not fsoFileNameGet.FileExists(URL) Then
        'URL�̃t�@�C���������݂��Ȃ��������t�@�C���ȊO���h���b�v���ꂽ�\��������̂ő�������
        DebugMsgWithTime "IEBrowser_BeforeNavigate: file?: " & URL & " not found"
        Exit Sub
    End If
    Dim EnumValue As clsEnum
    Set EnumValue = CreateclsEnum
    If Not LCase(fsoFileNameGet.GetExtensionName(URL)) = LCase(EnumValue.DBFileExetension(accdb_dext)) Then
        '�t�@�C���̊g���q��DBFileExtention�ƈ�v���Ȃ��ꍇ�͏����𒆒f����
        DebugMsgWithTime "IEBrowser_BeforeNavigate: Exetention is not accdb"
        Exit Sub
    End If
    'DB�t�@�C�����ƃf�B���N�g���ɐݒ肵�Ă��
    txtBoxDB_Directory.Text = fsoFileNameGet.GetParentFolderName(URL)
    txtBoxDB_FileName.Text = fsoFileNameGet.GetFileName(URL)
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
    '��U�t�B�[���h���X�g��L���ɂ���
    lstBoxField_Name.Enabled = True
    If dbFieldList.RS.RecordCount <= 0 Then
        lstBoxField_Name.ListIndex = -1
        lstBoxField_Name.Clear
        lstBoxField_Name.AddItem ("���R�[�h������0���ȉ��ł����B")
        '���R�[�h�Ȃ��̏ꍇ�̓t�B�[���h���X�g�{�b�N�X�𖳌��ɂ���
        btnDoUpdate.Enabled = False
        lstBoxField_Name.Enabled = False
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
Private Sub txtBoxDB_Directory_Change()
    '�f�B���N�g�������ω������Ƃ�
    '���X�g�{�b�N�X������������
    Call ClearTableandFieldList
End Sub
Private Sub txtBoxDB_FileName_Change()
    '�t�@�C�������ω������Ƃ�
    '���X�g�{�b�N�X������������
    Call ClearTableandFieldList
End Sub
'''Author Disuke Oota 2021_12_19
'''�������p�A�e�[�u�����X�g�ƃt�B�[���h���X�g����������
Private Sub ClearTableandFieldList()
    '�e�[�u�����X�g�̑I����Ԃ��������A���X�g����������
    lstBoxTable_Name.ListIndex = -1
    lstBoxTable_Name.Clear
    '�t�B�[���h���X�g�̑I����Ԃ��������A���X�g����������
    lstBoxField_Name.ListIndex = -1
    lstBoxField_Name.Clear
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
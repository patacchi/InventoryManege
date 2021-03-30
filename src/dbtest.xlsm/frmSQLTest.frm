VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmSQLTest 
   Caption         =   "SQL�e�X�g"
   ClientHeight    =   10365
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   13785
   OleObjectBlob   =   "frmSQLTest.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmSQLTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub btnCheckKishuTable_Click()
    Call CheckKishuTable_Field
End Sub
Private Sub btnCreateInitialJSON_Click()
    '�����e�[�u���쐬�pJSON�m�F�E����
    Call CheckInitialTableJSON
End Sub
Private Sub btnExportCSV_Click()
    'CSV�o��
    Dim strFilePath As String
    strFilePath = Application.GetSaveAsFilename(InitialFileName:="\\PC24929-tdms\DBLearn\Test\CSV_Output\", filefilter:="CSV�t�@�C��(*.csv),*.csv")
    If strFilePath = "False" Then
        Debug.Print "btnExportCSV�ŃL�����Z���������ꂽ"
        Exit Sub
    End If
    Call OutputArrayToCSV(Me.listBoxSQLResult.List, strFilePath)
    Exit Sub
End Sub
Private Sub btnFieldAndTableAdd_Click()
    CheckNewField
End Sub
Private Sub btnRenumberLast_KishuTable_Click()
    Call RenumberKishuTableLastNumber
End Sub
Private Sub UserForm_Activate()
    '���T�C�Y�@�\�ǉ�
    Call FormResize
End Sub
Private Sub UserForm_Initialize()
    '�o�C���h�p�����[�^�̃f�[�^�^�C�v��ݒ肵�Ă��
    Dim strarrTypeName() As String
    ReDim strarrTypeName(4)
    strarrTypeName = Split("Int32" & "," & "Dbl" & "," & "Text" & "," & "Blob" & "," & "Nul" & "," & "Value", ",")
    cmbBoxParmType1.List = strarrTypeName
    cmbBoxParmType2.List = strarrTypeName
    cmbBoxParmType3.List = strarrTypeName
End Sub
Private Sub UserForm_Resize()
    '�t�H�[�����T�C�Y���ɁA���̃��X�g�{�b�N�X���T�C�Y�ύX���Ă��
    Dim intListHeight As Integer
    Dim intListWidth As Integer
    intListHeight = Me.InsideHeight - listBoxSQLResult.Top * 2
    intListWidth = Me.InsideWidth - (txtboxSQLText.Left * 2) - txtboxSQLText.Width - (listBoxSQLResult.Left - txtboxSQLText.Width - txtboxSQLText.Left)
    If (intListHeight > 0 And intListWidth > 0) Then
        listBoxSQLResult.Height = intListHeight
        listBoxSQLResult.Width = intListWidth
    End If
End Sub
Private Sub btnBulkDataInput_Click()
    Dim strSQL
    Randomize
    frmBulkInsertTest.Show
    '����͈̗͂����̔����̂�����
    'Int((�͈͏���l - �͈͉����l + 1) * Rnd + �͈͉����l)
End Sub
Private Sub btnSQLGo_Click()
    '�G���[�`�F�b�N�Ƃ��قƂ�ǂȂ�
    '�e�L�X�g�{�b�N�X�ɓ��ꂽSQL�����s����t�H�[�����ۂ���
    If txtboxSQLText.Text = "" Then
        MsgBox "�󔒂͂�����ƁE�E�E"
        Exit Sub
    End If
    Dim dbSQLite3 As clsSQLiteHandle
    Dim varRetValue As Variant
    Dim isCollect As Boolean
    Dim strWidths As String
    Dim isDBFile As Boolean
    Dim longDataType As Long
    Set dbSQLite3 = New clsSQLiteHandle
    isDBFile = IsDBFileExist
    If Not isDBFile Then
        'DB�t�@�C���쐬�E�m�F���ɉ����������񂾂ˁE�E
        Debug.Print "DB�t�@�C���쐬�E�m�F���ɉ���������"
        Exit Sub
    End If
    If chkBoxLocalDB Then
        '���[�J��DB��]�̏ꍇ
        dbSQLite3.LocalMode = True
    Else
        '�ʏ�͂������i�����[�g�j
        dbSQLite3.LocalMode = False
    End If
    If chkBoxUseNamedParm Then
        'NamedParm���g�������ꍇ
        'SQL�ݒ�
        dbSQLite3.SQL = txtboxSQLText.Text
        '�o�C���h�p�����[�^�̃v���p�e�B���Z�b�g���Ă��
        If Not txtBoxParName1 = "" Then
            longDataType = GetDataTypeNumber(cmbBoxParmType1.Text)
            Set dbSQLite3.NamedParm = dbSQLite3.GetNamedList(txtBoxParName1.Text, longDataType, txtBoxParmData1.Text)
        End If
        If Not txtBoxParName2 = "" Then
            longDataType = GetDataTypeNumber(cmbBoxParmType2.Text)
            Set dbSQLite3.NamedParm = dbSQLite3.GetNamedList(txtBoxParName2.Text, longDataType, txtBoxParmData2.Text)
        End If
        If Not txtBoxParName3 = "" Then
            longDataType = GetDataTypeNumber(cmbBoxParmType3.Text)
            Set dbSQLite3.NamedParm = dbSQLite3.GetNamedList(txtBoxParName3.Text, longDataType, txtBoxParmData3.Text)
        End If
        isCollect = dbSQLite3.Do_SQL_Use_NamedParm_NO_Transaction
    Else
        isCollect = dbSQLite3.DoSQL_No_Transaction(txtboxSQLText.Text)
    End If
    If isCollect Then
        If chkboxNoTitle.Value = True Then
            '�^�C�g���Ȃ�����]�̏ꍇ�͂�����
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=False)
            strWidths = GetColumnWidthString(varRetValue, 0)
        Else
            '�f�t�H���g�̓^�C�g������
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=True)
            strWidths = GetColumnWidthString(varRetValue, 1)
        End If
    Else
        '�G���[���������ꍇ�̏����E�E�E�Ȃ񂾂���
        '�G���[���b�Z�[�W�����̂܂ܕ\������΂����̂ł́E�E�E
        If chkboxNoTitle.Value = True Then
            '�^�C�g���Ȃ�����]�̏ꍇ�͂�����
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=False)
            strWidths = GetColumnWidthString(varRetValue, 0)
        Else
            '�f�t�H���g�̓^�C�g������
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=True)
            strWidths = GetColumnWidthString(varRetValue, 1)
        End If
    End If
    Set dbSQLite3 = Nothing
    If VarType(varRetValue) = vbEmpty Then
        listBoxSQLResult.Clear
        listBoxSQLResult.AddItem "�f�[�^�Ȃ�"
        Exit Sub
    End If
    Set dbSQLite3 = Nothing
    If chkBoxMaxLength.Value = True Then
        '�ő啶����������������������
        strWidths = GetColumnWidthString(varRetValue, boolMaxLengthFind:=True)
    End If
    With listBoxSQLResult
        .ColumnCount = UBound(varRetValue, 2) - LBound(varRetValue, 2) + 1
        .ColumnWidths = strWidths
        '.List = Join(varRetValue)
        .List = varRetValue
        '.AddItem (varRetValue(1)(1))
    End With
End Sub
Private Function GetDataTypeNumber(ByVal strargDataType As String) As Long
    '�w�肳�ꂽ��������BindData�̒萔���E��
    Select Case strargDataType
    Case "Int32"
        GetDataTypeNumber = BindType.Int32
        Exit Function
    Case "Dbl"
        GetDataTypeNumber = BindType.Dbl
        Exit Function
    Case "Text"
        GetDataTypeNumber = BindType.Text
        Exit Function
    Case "Blob"
        GetDataTypeNumber = BindType.Blob
        Exit Function
    Case "Nul"
        GetDataTypeNumber = BindType.Nul
        Exit Function
    Case "Value"
        GetDataTypeNumber = BindType.Value
        Exit Function
    Case Else
        MsgBox "�w��`���ȊO���I������܂���"
    End Select
End Function
Private Sub listBoxSQLResult_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    '���X�g�_�u���N���b�N������N���b�v�{�[�h�ɃR�s�[���Ă݂��悤
    Dim objDataObj As DataObject
    Dim intCounterColumn As Integer
    Dim strListText As String
    Set objDataObj = New DataObject
        objDataObj.SetText (listBoxSQLResult.List(listBoxSQLResult.ListIndex))
        objDataObj.PutInClipboard
        strListText = ""
        For intCounterColumn = 0 To listBoxSQLResult.ColumnCount - 1
            If IsNull(listBoxSQLResult.List(listBoxSQLResult.ListIndex, intCounterColumn)) Then
                'Null�̏ꍇ��NULL���ē���Ă�낤
                strListText = strListText & " NULL"
            Else
                strListText = strListText & " " & CStr(listBoxSQLResult.List(listBoxSQLResult.ListIndex, intCounterColumn))
            End If
        Next intCounterColumn
        LTrim (strListText)
        MsgBox strListText
        Debug.Print strListText
End Sub
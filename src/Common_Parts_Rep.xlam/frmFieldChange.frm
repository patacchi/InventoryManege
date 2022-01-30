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
Private Const SQL_DigitOffset_Update_Check_0_Tablename_1UpdateField As String = "SELECT * FROM {0} WHERE {1} = FALSE"
Private Sub btnDoUpdate_Click()
    '�t�B�[���h�C���K�p
    '�S�e�[�u�����[�h���ǂ����ŏ����𕪊򂷂�
    Select Case chkBoxAllTable.Value
    Case True
        '�S�e�[�u���ꊇ���[�h�̎�
        '�e�[�u�������X�g�{�b�N�X�̃e�[�u����For Each�ŉ�
        Dim varKey As Variant
        For Each varKey In lstBoxTable_Name.List
            Call DoUpdateTable(CStr(varKey))
        Next varKey
    Case False
        '�ʏ탂�[�h�̏ꍇ�̓e�[�u�����̑I���͕K�{
        If lstBoxTable_Name.ListIndex = -1 Or lstBoxField_Name.ListIndex = -1 Then
            Exit Sub
        End If
        Call DoUpdateTable(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex))
    End Select
End Sub
'''Author Patacchi 2021_12_26
'''�e�[�u�����������Ƃ��āA�e�[�u���̏C����Ƃ��s��
Private Sub DoUpdateTable(strargTableName As String)
    Dim adoFieldUpdate As clsADOHandle
    Set adoFieldUpdate = CreateclsADOHandleInstance
    'DB�t�@�C�����ƃf�B���N�g�����e�L�X�g�{�b�N�X�̓��e���N���X�C���X�^���X�̃v���p�e�B�ɃZ�b�g���Ă��
    adoFieldUpdate.DBPath = txtBoxDB_Directory.Text
    adoFieldUpdate.DBFileName = txtBoxDB_FileName.Text
    'Enum�N���X�̃C���X�^���X�𗘗p����Const�̐��l����������
    Dim clsEnumValue As clsEnum
    Set clsEnumValue = CreateclsEnum
    'StringBuilder�N���X�̃C���X�^���X
    Dim strBC As clsSQLStringBuilder
    Set strBC = CreateclsSQLStringBuilder
    '�t�B�[���h���e�C�����
    'DigitOffset
    '�ύX�Ώۂł���Digit_offset�t�B�[���h�����݂��邩�`�F�b�N����
    Dim isDigitOffset As Boolean
    isDigitOffset = adoFieldUpdate.IsFieldExists(strargTableName, clsEnumValue.CATDigitField(F_Digit_Offset_cmdg))
    If Not isDigitOffset Or strargTableName = clsEnumValue.CATDigitField(T_Name_cmdg) Then
        '��������DigitOffset�t�B�[���h�������ꍇ
        '�������̓e�[�u������DigitMaster�e�[�u���ł������ꍇ
        '�A�b�v�f�[�g�Ώۂ̃t�B�[���h���Ȃ�����DigitOffset�֘A�̏C���͂��Ȃ�
        DebugMsgWithTime "btnDoUpdate: DigitOffset field not found."
    Else
        'DigitOffset�C���ΏۂȂ̂ŁA�C�����s
        '�A�b�v�f�[�g�`�F�b�N�t�B�[���h�����݂��邩�`�F�b�N����
        Dim isUpdateField As Boolean
        isUpdateField = adoFieldUpdate.IsFieldExists(strargTableName, clsEnumValue.CATTempField(F_Digit_Update_ctm))
        If Not isUpdateField Then
            'update�t�B�[���h���Ȃ���΍쐬����
            Call adoFieldUpdate.AppendField(strargTableName, clsEnumValue.CATTempField(F_Digit_Update_ctm), Boolean_typ)
        End If
        'Digit_Row�t�B�[���h�����݂��邩�`�F�b�N����
        Dim isDigitRow As Boolean
        isDigitRow = adoFieldUpdate.IsFieldExists(strargTableName, clsEnumValue.CATDigitField(F_Digit_Row_cmdg))
        If Not isDigitRow Then
            'DigitRow�t�B�[���h���Ȃ���΍쐬����
            Call adoFieldUpdate.AppendField(strargTableName, clsEnumValue.CATDigitField(F_Digit_Row_cmdg), Integer_typ)
        End If
        'DigitOffset�t�B�[���h�f�[�^�^��Text��
        Dim isCollect As Boolean
        isCollect = adoFieldUpdate.ChangeDataType(strargTableName, clsEnumValue.CATDigitField(F_Digit_Offset_cmdg), Text_typ, "(31)")
        If Not isCollect Then
            '�f�[�^�^�ύX���s
            DebugMsgWithTime "DoUpdateTable: fail change DataType"
            Exit Sub
        End If
        'DigitOffset�t�B�[���h�C��
'        CAT_CONST.SQL_FIX_DIGITOFFSET_0_TableName_1_DigitOffset_2_DigitRow_3_DigitUpdate
        'DigitOffset�C���p�p�����[�^Dictionary�ݒ�
        Dim dicFixDigitOffset As Dictionary
        Set dicFixDigitOffset = New Dictionary
        '0_TableName_1_DigitOffset_2_DigitRow_3_DigitUpdate
        dicFixDigitOffset.Add 0, strargTableName
        dicFixDigitOffset.Add 1, clsEnumValue.CATDigitField(F_Digit_Offset_cmdg)
        dicFixDigitOffset.Add 2, clsEnumValue.CATDigitField(F_Digit_Row_cmdg)
        dicFixDigitOffset.Add 3, clsEnumValue.CATTempField(F_Digit_Update_ctm)
        'SQL�쐬
        Dim strSQL_FixDigitOffset As String
        strSQL_FixDigitOffset = strBC.ReplaceParm(CAT_CONST.SQL_FIX_DIGITOFFSET_0_TableName_1_DigitOffset_2_DigitRow_3_DigitUpdate, dicFixDigitOffset)
        'ConnectMode��Write�t���O�̏�Ԃ𒲂ׂ�
        If Not adoFieldUpdate.ConnectMode And adModeWrite Then
            adoFieldUpdate.ConnectMode = adoFieldUpdate.ConnectMode Or adModeWrite
        End If
        'SQL���s
        isCollect = adoFieldUpdate.Do_SQL_with_NO_Transaction(strSQL_FixDigitOffset)
        If Not isCollect Then
            'DigitRow�ݒ莞�Ɏ��s�������ۂ�
            DebugMsgWithTime "DoUpdateTable: fail Fix DigitRow"
            Exit Sub
        End If
        '�C�������m�F
        'Updated��False���c���ĂȂ����ǂ���
        '�u���p�����[�^�pDictionary������
        dicFixDigitOffset.RemoveAll
        '0_Tablename 1_UpdateFieldName
        '�u���pDictionary�쐬
        dicFixDigitOffset.Add 0, strargTableName
        dicFixDigitOffset.Add 1, clsEnumValue.CATTempField(F_Digit_Update_ctm)
        strSQL_FixDigitOffset = strBC.ReplaceParm(SQL_DigitOffset_Update_Check_0_Tablename_1UpdateField, dicFixDigitOffset)
        Call adoFieldUpdate.Do_SQL_with_NO_Transaction(strSQL_FixDigitOffset)
        If adoFieldUpdate.RecordCount >= 1 Then
            'Update��False���܂��c���Ă�
            '���b�Z�[�W�{�b�N�X�o���ď����𒆒f
            DebugMsgWithTime "DoUpdateTable Table: " & strargTableName & " Update update NOT complete.check master table"
            MsgBox strargTableName & " �e�[�u���ŃA�b�v�f�[�g�������Ă��Ȃ��t�B�[���h���c���Ă���悤�ł��B�}�X�^�[�t�@�C�����m�F���ĉ������B"
        Else
            '�S�ăA�b�v�f�[�g��������
            'DigitOffset�t�B�[���h����
            Call adoFieldUpdate.DeleteField(strargTableName, clsEnumValue.CATDigitField(F_Digit_Offset_cmdg))
        End If
    End If
    'InputDate�t�B�[���h�����邩�`�F�b�N����
    Dim isInputDate As Boolean
    isInputDate = adoFieldUpdate.IsFieldExists(strargTableName, clsEnumValue.CATMasterDetailField(F_InputDate_cmdt))
    If isInputDate Then
        '�C���Ώۂ�InputDate�t�B�[���h������ꍇ�̂ݏC����Ƃ𑱍s����
        '�u���p�����[�^�p��Dictionary�쐬
        Dim dicFixInputDate As Dictionary
        Set dicFixInputDate = New Dictionary
        dicFixInputDate.Add 0, strargTableName
        Dim strSQL_FixInputDate As String
        strSQL_FixInputDate = strBC.ReplaceParm(CAT_CONST.SQL_FIX_INPUTDATE_0_TableName, dicFixInputDate)
        '�C�����s
        Call adoFieldUpdate.Do_SQL_with_NO_Transaction(strSQL_FixInputDate)
        'Write�t���O��������
        adoFieldUpdate.ConnectMode = adoFieldUpdate.ConnectMode And Not adModeWrite
    End If
    Set clsEnumValue = Nothing
    Set adoFieldUpdate = Nothing
    Set strBC = Nothing
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
    Dim adoxcatChange As ADOX.Catalog
    Set adoxcatChange = New ADOX.Catalog
    adoxcatChange.ActiveConnection = dbGetTable.ConnectionString
    Dim adoxTable As ADOX.Table
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
    If lstBoxTable_Name.ListCount >= 1 Then
        '�e�[�u�������X�g�{�b�N�X�Ƀf�[�^���������ꍇ�A�S�e�[�u���{�^����Visible��True�ɂ��Ă��
        chkBoxAllTable.Visible = True
    Else
        '�e�[�u����������Ȃ������ꍇ�́A�S�e�[�u���{�^����Visible��False�ɂ��Ă��
        chkBoxAllTable.Visible = False
    End If
    Set adoxcatChange = Nothing
    Set dbGetTable = Nothing
End Sub
Private Sub chkBoxAllTable_Change()
    '�S�e�[�u���K�p�`�F�b�N�{�^���̏�Ԃ��ω������ꍇ�Ɏ��s
    Select Case chkBoxAllTable.Value
    Case True
        '�S�e�[�u�����[�h�̏ꍇ
        '�e�[�u���I�����X�g�{�b�N�X�ƃt�B�[���h�I�����X�g�{�b�N�X��Enable��False�ɂ��A���I����Ԃɂ���
        lstBoxTable_Name.Enabled = False
        lstBoxTable_Name.ListIndex = -1
        lstBoxField_Name.Enabled = False
        lstBoxField_Name.ListIndex = -1
        '�A�b�v�f�[�g�{�^����L����
        btnDoUpdate.Enabled = True
    Case False
        '�ʏ탂�[�h
        '���X�g�{�b�N�X��L���ɂ��Ă��
        lstBoxTable_Name.Enabled = True
        lstBoxField_Name.Enabled = True
        '�e�[�u�������X�g�{�b�N�X�����I����ԂȂ�A�b�v�f�[�g�{�^���𖳌��ɂ��Ă��
        If lstBoxTable_Name.ListIndex = -1 Then
            '�e�[�u���������I�����
            btnDoUpdate.Enabled = False
        End If
    End Select
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
    '�g���q���DB�̃t�@�C�����ǂ����𔻒肷��
    Dim adoExtention As clsADOHandle
    Set adoExtention = CreateclsADOHandleInstance
    If Not adoExtention.IsDBExtention(CStr(URL)) Then
        'DB�t�@�C���̊g���q�ł͖��������ꍇ
        '�������Ȃ��Ŕ�����
        DebugMsgWithTime "GetFileName_Brouser: Target file is not DB file " & URL
        GoTo CloseAndExit
        Exit Sub
    End If
    'DB�t�@�C�����ƃf�B���N�g���ɐݒ肵�Ă��
    txtBoxDB_Directory.Text = fsoFileNameGet.GetParentFolderName(URL)
    txtBoxDB_FileName.Text = fsoFileNameGet.GetFileName(URL)
    GoTo CloseAndExit
CloseAndExit:
    Set adoExtention = Nothing
    Set fsoFileNameGet = Nothing
    Exit Sub
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
    'Adox�𗘗p���āA�t�B�[���h�ꗗ���擾����
    Dim adoxCatField As ADOX.Catalog
    Set adoxCatField = New ADOX.Catalog
    adoxCatField.ActiveConnection = dbFieldList.ConnectionString
    If adoxCatField.Tables(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex)).Columns.Count >= 1 Then
        '�񐔂̃J�E���g��1�ȏ�̏ꍇ
        '�����̃t�B�[���h�����X�g�{�b�N�X������
        lstBoxField_Name.Clear
        lstBoxField_Name.ListIndex = -1
        Dim adoxColumn As ADOX.Column
        For Each adoxColumn In adoxCatField.Tables(lstBoxTable_Name.List(lstBoxTable_Name.ListIndex)).Columns
            '���X�g�{�b�N�X�ɗ񖼂�ǉ�����
            lstBoxField_Name.AddItem adoxColumn.Name
        Next adoxColumn
        Set adoxCatField = Nothing
    Else
        '�񐔂��Ȃ������ꍇ
        lstBoxField_Name.ListIndex = -1
        lstBoxField_Name.Clear
        lstBoxField_Name.AddItem ("���R�[�h������0���ȉ��ł����B")
        '���R�[�h�Ȃ��̏ꍇ�̓t�B�[���h���X�g�{�b�N�X�𖳌��ɂ���
        btnDoUpdate.Enabled = False
        lstBoxField_Name.Enabled = False
        Exit Sub
    End If
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
    '�S�e�[�u���{�^����Visible��False�ɂ��Ă��
    chkBoxAllTable.Visible = False
End Sub
Private Sub UserForm_Initialize()
    '�����l�𓊓�
    Dim dbChange As clsADOHandle
    Set dbChange = New clsADOHandle
    txtBoxDB_Directory.Text = dbChange.DBPath
    txtBoxDB_FileName.Text = dbChange.DBFileName
    txtBoxDate_Max.Text = GetLocalTimeWithMilliSec
    '�e�[�u���ꗗ���擾
    Dim adoxcatChange As ADOX.Catalog
    Set adoxcatChange = New ADOX.Catalog
    adoxcatChange.ActiveConnection = dbChange.ConnectionString
    Dim adoxTable As ADOX.Table
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
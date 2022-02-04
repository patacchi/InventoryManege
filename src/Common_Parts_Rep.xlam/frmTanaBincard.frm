VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmTanaBincard 
   Caption         =   "�I��BIN�J�[�h�`�F�b�N�p�t�H�[��"
   ClientHeight    =   8490.001
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8160
   OleObjectBlob   =   "frmTanaBincard.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmTanaBincard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'�t�H�[�������L�ϐ�
Private clsADOfrmBIN As clsADOHandle
Private clsINVDBfrmBIN As clsINVDB
Private clsEnumfrmBIN As clsEnum
Private clsSQLBc As clsSQLStringBuilder
Private objExcelFrmBIN As Excel.Application
Private dicObjNameToFieldName As Dictionary
Private clsIncrementalfrmBIN As clsIncrementalSerch
'�����o�ϐ�
Private rsfrmBIN As ADODB.Recordset
'------------------------------------------------------------------------
'�萔��`
'T_INV_CSV�͂����ʂł�������Ȃ��̂ŁAPrivate�ł����v
'F_CSV_Status
Private Const CSV_STATUS_BIN_INPUT As Long = &H1    'BIN�J�[�h�c����Null����Ȃ�
Private Const CSV_STATUS_BIN_DATAOK As Long = &H2   'BIN�J�[�h�c���ƃf�[�^�c������v
Private Const CSV_STATUS_REAL_INPU As Long = &H4    '���i�c��Null����Ȃ�
Private Const CSV_STATUS_REAL_DATAOK As Long = &H8  '���i�c�ƃf�[�^�c������v
'SQL
'�I�����ؓ��f�[�^�擾SQL
'{0}    ���ؓ�
'{1}    T_INV_CSV
'{2}    (AfterINWord)
Private Const CSV_SQL_ENDDAY_LIST As String = "SELECT DISTINCT {0} FROM {1} IN""""{2}"
'�I���`�F�b�N�p�f�t�H���g�f�[�^�擾SQL
'{0}    (selectField As �K�{)
'{1}    T_INV_CSV
'{2}    (After IN Word)
'{3}    (TCSVtana? Alias)
'{4}    ���P�[�V����
'{5}    ���ؓ�
'{6}    (lstBox_EndDay�̑I���e�L�X�g)
'{7}    (�ǉ�����Where��������΁A�Ȃ����"")
'{8}    (ORDER BY���� F_���P�[�V���� ASC �H)
Private Const CSV_SQL_TANA_DEFAULT As String = "SELECT {0} FROM {1} IN """"{2} AS {3} " & vbCrLf & _
"WHERE {4} LIKE ""K%"" AND LEN{4} >= 2 AND {5} = {6} {7}" & vbCrLf & _
"ORDER BY {8}"
Private Sub btnRegistTanaCSVtoDB_Click()
    '�ŏ���CSV�t�@�C����I�����Ă��炤
    Dim strCSVFullPath As String
    '�J�����g�f�B���N�g�����_�E�����[�h�f�B���N�g���ɕύX����
    Call ChCurrentDirW(GetDownloadPath)
    MsgBox "�f�C���[�I���Ń_�E�����[�h����CSV�t�@�C����I�����ĉ�����"
    strCSVFullPath = CStr(Application.GetOpenFilename("CSV�t�@�C��,*.csv", 1, "�f�C���[�I���Ń_�E�����[�h����CSV�t�@�C����I�����ĉ�����"))
    If strCSVFullPath = "False" Then
        '�L�����Z���{�^���������ꂽ
        MsgBox "�L�����Z�����܂���"
        Exit Sub
    End If
    Dim longAffected As Long
#If DontRemoveZaikoSH Then
    'DL�����t�@�C�����c���Ă����i�e�X�g�������j
    '�擾�����t�@�C�����������ɂ���DB�ɓo�^�i�g���q�ɂ���ď��������򂳂��͂��j
    longAffected = clsINVDBfrmBIN.UpsertINVPartsMasterfromZaikoSH(strCSVFullPath, objExcelFrmBIN, clsINVDBfrmBIN, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc, True)
#Else
    longAffected = clsINVDBfrmBIN.UpsertINVPartsMasterfromZaikoSH(strCSVFullPath, objExcelFrmBIN, clsINVDBfrmBIN, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc, False)
#End If
    '�o�^�������I�������A���X�g���č\������
    setEndDayList
End Sub
Private Sub lstBoxEndDay_Click()
    '���ؓ����X�g�I�����ꂽ
    '�I�����ꂽ���ؓ�����f�[�^�擾���A�����o�ϐ���rs�ɃZ�b�g���Ă��
    Dim isCollect As Boolean
    isCollect = setDefaultDataToRS(lstBoxEndDay.List(lstBoxEndDay.ListIndex))
    If Not isCollect Then
        MsgBox "�I�����ؓ�: " & lstBoxEndDay.List(lstBoxEndDay.ListIndex) & " �̃f�[�^�̎擾�Ɏ��s���܂���"
        Exit Sub
    End If
End Sub
'�t�H�[������������
Private Sub UserForm_Initialize()
    '�����o�C���X�^���X�ϐ��Z�b�g
    If clsADOfrmBIN Is Nothing Then
        Set clsADOfrmBIN = CreateclsADOHandleInstance
    End If
    If clsINVDBfrmBIN Is Nothing Then
        Set clsINVDBfrmBIN = CreateclsINVDB
    End If
    If clsEnumfrmBIN Is Nothing Then
        Set clsEnumfrmBIN = CreateclsEnum
    End If
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
    End If
    If objExcelFrmBIN Is Nothing Then
        Set objExcelFrmBIN = New Excel.Application
    End If
    If dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = New Dictionary
    End If
    If clsIncrementalfrmBIN Is Nothing Then
        Set clsIncrementalfrmBIN = CreateclsIncrementalSerch
    End If
    If rsfrmBIN Is Nothing Then
        Set rsfrmBIN = New ADODB.Recordset
    End If
    '�I�����ؓ����X�g��ݒ�
    Dim isCollect As Boolean
    isCollect = setEndDayList
    If Not isCollect Then
        MsgBox "�I��CSV��DB�f�[�^�ǂݍ��݂ŃG���[���������܂���"
        Unload Me
    End If
    'divObjToField��ݒ�
    setDicObjToField
End Sub
Private Sub ClearAllContents(strargExceptControlName As String)
End Sub
'''���ؓ����X�g��ݒ肷��
'''Return Bool  ����������True�A����ȊO��False
Private Function setEndDayList() As Boolean
    On Error GoTo ErrorCatch
''{0}    ���ؓ�
''{1}    T_INV_CSV
''{2}    (AfterINWord)
'Private Const CSV_SQL_ENDDAY_LIST As String = "SELECT DISTINCT {0} FROM {1} IN""""{2}"
    Dim dicReplaceEndDay As Dictionary
    Set dicReplaceEndDay = New Dictionary
    dicReplaceEndDay.Add 0, clsEnumfrmBIN.CSVTanafield(F_EndDay_ICS)
    dicReplaceEndDay.Add 1, INV_CONST.T_INV_CSV
    'DBPath���f�t�H���g��
    clsADOfrmBIN.SetDBPathandFilenameDefault
    Dim fsoEndDay As FileSystemObject
    Set fsoEndDay = New FileSystemObject
    dicReplaceEndDay.Add 2, clsSQLBc.CreateAfterIN_WordFromSHFullPath(fsoEndDay.BuildPath(clsADOfrmBIN.DBPath, clsADOfrmBIN.DBFileName), clsEnumfrmBIN)
    '�u�����s�ASQL�ݒ�
    clsADOfrmBIN.SQL = clsSQLBc.ReplaceParm(CSV_SQL_ENDDAY_LIST, dicReplaceEndDay)
    Dim isCollect As Boolean
    'SQL���s
    isCollect = clsADOfrmBIN.Do_SQL_with_NO_Transaction
    If Not isCollect Then
        MsgBox "setEndDayList �I��CSV��DB�f�[�^�ǂݎ��Ɏ��s���܂���"
        setEndDayList = False
        GoTo CloseAndExit
    End If
    '��U2�����z��ŁA�^�C�g�������̔z����󂯎��
    Dim SQL2DimmentionResult() As Variant
    SQL2DimmentionResult = clsADOfrmBIN.RS_Array(True)
    '����1�����z��ɕϊ��������̂��󂯎��
    Dim SQL1DimmentionList() As Variant
    SQL1DimmentionList = clsSQLBc.SQLResutArrayto1Dimmention(SQL2DimmentionResult)
    '���X�g�{�b�N�X�ɐݒ肵�Ă��
    lstBoxEndDay.Clear
    lstBoxEndDay.List = SQL1DimmentionList
    'True��Ԃ��ďI��
    setEndDayList = True
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "setEndDayList code: " & err.Number & " Description: " & err.Description
    setEndDayList = False
    GoTo CloseAndExit
CloseAndExit:
    Set dicReplaceEndDay = Nothing
    Set fsoEndDay = Nothing
    Exit Function
End Function
'''dicObjToFieldName�̐ݒ���s��
'''key ���I�u�W�F�N�g���Avalue ���e�[�u���G�C���A�X�t���t�B�[���h��
Private Sub setDicObjToField()
    On Error GoTo ErrorCatch
    If dicObjNameToFieldName Is Nothing Then
        '����������Ă��Ȃ������珉��������
        Set dicObjNameToFieldName = New Dictionary
    End If
    '�ŏ��ɑS����
    dicObjNameToFieldName.RemoveAll
    dicObjNameToFieldName.Add txtBox_F_CSV_No.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_CSV_No_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_Tana_Local_Text.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Location_Text_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_Tehai_Code.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Tehai_Code_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_DB_Amount.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Stock_Amount_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_BIN_Amount.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Bin_Amount_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_Real_Amount.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Available_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_System_Name.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_System_Name_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_System_Spac.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_System_Spec_ICS), clsEnumfrmBIN)
    '�ȉ��͉�ʕ\���͂��Ȃ����̂́ARS�Ńf�[�^�Ƃ��ĕێ��͂�����̂Ȃ̂ŁAKey��DB�̃t�B�[���h���i�e�[�u���G�C���A�X�v���t�B�b�N�X�����j�AValue�̓v���t�B�b�N�X�L��Ƃ���
    dicObjNameToFieldName.Add clsEnumfrmBIN.CSVTanafield(F_Status_ICS), clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Status_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add clsEnumfrmBIN.CSVTanafield(F_EndDay_ICS), clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_EndDay_ICS), clsEnumfrmBIN)
    GoTo CloseAndExit
    Exit Sub
ErrorCatch:
    DebugMsgWithTime "dicObjNameToFieldName code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''�f�t�H���g(�t�B���^�|����O�j��Select���ʂ�RS�ɓ����
'''Retrun bool ����������True�A����ȊO��false
'''args
'''strargEndDay        ���ؓ���10����
Private Function setDefaultDataToRS(strargEndDay As String) As Boolean
    On Error GoTo ErrorCatch
    '�ݒ肳�ꂽ����������SQL��g�ݗ��Ă�
''�I���`�F�b�N�p�f�t�H���g�f�[�^�擾SQL
''{0}    (selectField As �K�{)
''{1}    T_INV_CSV
''{2}    (After IN Word)
''{3}    (TCSVtana? Alias)
''{4}    ���P�[�V����
''{5}    ���ؓ�
''{6}    (lstBox_EndDay�̑I���e�L�X�g)
''{7}    (�ǉ�����Where��������΁A�Ȃ����"")
''{8}    (ORDER BY���� F_���P�[�V���� ASC �H)
'Private Const CSV_SQL_TANA_DEFAULT As String = "SELECT {0} FROM {1} IN """"{2} AS {3} " & vbCrLf &
    '�u���pdic�錾�A������
    Dim dicReplaceSetDefault As Dictionary
    Set dicReplaceSetDefault = New Dictionary
    'DBPath���f�t�H���g��
    clsADOfrmBIN.SetDBPathandFilenameDefault
    dicReplaceSetDefault.RemoveAll
    Dim strSelectField As String
    strSelectField = clsSQLBc.GetSELECTfieldListFromDicObjctToFieldName(dicObjNameToFieldName)
    dicReplaceSetDefault.Add 0, strSelectField
    dicReplaceSetDefault.Add 1, INV_CONST.T_INV_CSV
    Dim fsoSetDefault As FileSystemObject
    Set fsoSetDefault = New FileSystemObject
    dicReplaceSetDefault.Add 2, clsSQLBc.CreateAfterIN_WordFromSHFullPath(fsoSetDefault.BuildPath(clsADOfrmBIN.DBPath, clsADOfrmBIN.DBFileName), clsEnumfrmBIN)
    dicReplaceSetDefault.Add 3, clsEnumfrmBIN.SQL_INV_Alias(TanaCSV_Alias_sia)
    dicReplaceSetDefault.Add 4, clsEnumfrmBIN.CSVTanafield(F_Location_Text_ICS)
    dicReplaceSetDefault.Add 5, clsEnumfrmBIN.CSVTanafield(F_EndDay_ICS)
    dicReplaceSetDefault.Add 6, strargEndDay
    '(�ǉ�����������΂����ŉ�������)
    '�Ƃ肠�����͍i�荞�݂Ȃ�
    dicReplaceSetDefault.Add 7, ""
    dicReplaceSetDefault.Add 8, Replace(dicObjNameToFieldName(txtBox_F_CSV_Tana_Local_Text.Name), ".", "_") & " ASC"
    'Replace���s�ASQL�ݒ�
    clsADOfrmBIN.SQL = clsSQLBc.ReplaceParm(CSV_SQL_TANA_DEFAULT, dicReplaceSetDefault)
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "setDefaultDataToRS code: " & err.Number & " Description: " & err.Description
    setDefaultDataToRS = False
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
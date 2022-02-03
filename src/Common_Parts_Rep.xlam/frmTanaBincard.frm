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
Private dicoObjNameToFieldName As Dictionary
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
    If dicoObjNameToFieldName Is Nothing Then
        Set dicoObjNameToFieldName = New Dictionary
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
'''�f�t�H���g(�t�B���^�|����O�j��Select���ʂ�RS�ɓ����
'''Retrun bool ����������True�A����ȊO��false
'''args
'''strEndDay        ���ؓ���10����
Private Function setDefaultDataToRS(strEndDay As String) As Boolean
    On Error GoTo ErrorCatch
    '�ݒ肳�ꂽ����������SQL��g�ݗ��Ă�
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "setDefaultDataToRS code: " & err.Number & " Description: " & err.Description
    setDefaultDataToRS = False
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmTanaBincard 
   Caption         =   "�I��BIN�J�[�h�`�F�b�N�p�t�H�[��"
   ClientHeight    =   9240.001
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
Private confrmBIN As ADODB.Connection
Private StopEvents As Boolean
'------------------------------------------------------------------------
'�萔��`
'T_INV_CSV�͂����ʂł�������Ȃ��̂ŁAPrivate�ł����v
'F_CSV_Status
Private Const CSV_STATUS_BIN_INPUT As Long = &H1    'BIN�J�[�h�c����Null����Ȃ�
Private Const CSV_STATUS_BIN_DATAOK As Long = &H2   'BIN�J�[�h�c���ƃf�[�^�c������v
Private Const CSV_STATUS_REAL_INPU As Long = &H4    '���i�c��Null����Ȃ�
Private Const CSV_STATUS_REAL_DATAOK As Long = &H8  '���i�c�ƃf�[�^�c������v
'enum
'Status
Private Enum Enum_frmBIN_Status
    BINInput = &H1
    BINDataOK = &H2
    RealInput = &H4
    RealDataOK = &H8
    AllOK = Enum_frmBIN_Status.BINInput Or Enum_frmBIN_Status.BINDataOK Or Enum_frmBIN_Status.RealInput Or Enum_frmBIN_Status.RealDataOK
End Enum
'------------------------------------------------------------------------
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
'{8}    (ORDER BY���� TCSVTana.���P�[�V���� ASC �H)
Private Const CSV_SQL_TANA_DEFAULT As String = "SELECT {0} FROM {1}  AS {3} IN""""{2}  " & vbCrLf & _
"WHERE {3}.{4} LIKE ""K%"" AND LEN({3}.{4}) >= 2 AND {3}.{5} = ""{6}"" {7}" & vbCrLf & _
"ORDER BY {8}"
'�ǉ������p
'�w��r�b�g�������Ă��Ȃ����̂ݒ��o
'NOT ((TCSVTana.F_CSV_Status MOD(2*2)) >= 2)
'{0}    TCSVTana.F_CSV_Status
'{1}    2 ���Ƃ������r�b�g�������グ��Long
Private Const CSV_SQL_BIT_NOT_INCLUDE As String = "NOT (({0} MOD({1}*2)) >= {1})"
'�������Like����
'TCSVTana.���P�[�V���� LIKE ""K%""
'{0}    TCSVTana.���P�[�V����
'{1}    K ����������A�O����v
Private Const CSV_SQL_WHERE_LIKE As String = "{0} LIKE ""{1}%"""
'---------------------------------------------------------------------------------------------------------------------
'�C�x���g�n���h��
'�t�H�[������������
Private Sub UserForm_Initialize()
    ConstRactor
End Sub
'�t�H�[���I��������
Private Sub UserForm_Terminate()
    Destractor
End Sub
'DB�̓��e��������CSV(xlsx�ł�)�ɒǋL����
Private Sub btnSaveDBtoCSV_Click()
    If lstBoxEndDay.ListIndex = -1 Then
        MsgBox "�I�����ؓ���I�����ĉ������B"
        Exit Sub
        GoTo CloseAndExit
    End If
    On Error GoTo ErrorCatch
    '�J�����g���_�E�����[�h�f�B���N�g���ֈړ�
    ChCurrentDirW GetDownloadPath
    MsgBox "����ǋL����CSV�t�@�C����I�����ĉ�����"
    Dim strSaveToFileName As String
    strSaveToFileName = CStr(Application.GetOpenFilename("CSV�t�@�C��,*.csv", 1, "�f�C���[�I���Ń_�E�����[�h����CSV�t�@�C����I�����ĉ�����"))
    If strSaveToFileName = "False" Then
        '�L�����Z���������ꂽ
        MsgBox "�L�����Z�����܂���"
        GoTo CloseAndExit
        Exit Sub
    End If
    '���s�O�Ɏ��t�H�[����RS��Connection�̐ڑ���ؒf���Ă��
    '�C�x���g��~
    StopEvents = True
    '�S���ڏ���
    ClearAllContents
    'RS��Conneciton�̐ڑ���ؒf
    If rsfrmBIN.State And ObjectStateEnum.adStateOpen Then
        rsfrmBIN.ActiveConnection.Close
    End If
    If confrmBIN.State And ObjectStateEnum.adStateOpen Then
        confrmBIN.Close
    End If
    'clsINVDB�̏�����
    Dim isCollect As Boolean
    isCollect = clsINVDBfrmBIN.SetShareInsance(objExcelFrmBIN, clsINVDBfrmBIN, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc)
    If Not isCollect Then
        MsgBox "���L�C���X�^���X�̐ݒ�ŃG���[���������܂����B"
        GoTo CloseAndExit
        Exit Sub
    End If
    Dim strBackUpFilePath As String
    strBackUpFilePath = clsINVDBfrmBIN.SetDBDatatoTanaCSV(strSaveToFileName, lstBoxEndDay.List(lstBoxEndDay.ListIndex))
    If strBackUpFilePath = "" Then
        MsgBox "CSV�t�@�C���ǋL���ɃG���[���������܂���"
        GoTo CloseAndExit
        Exit Sub
    End If
    MsgBox strSaveToFileName & vbCrLf & " �t�@�C���ɒǋL���s���A�I���W�i���̃t�@�C���͎��̖��O�Ƀ��l�[�����܂��� " & vbCrLf & strBackUpFilePath
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "btnSaveDBtoCSV code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
    Exit Sub
CloseAndExit:
    'RS�Ď擾
    setDefaultDataToRS (lstBoxEndDay.List(lstBoxEndDay.ListIndex))
    'RS���f�[�^�擾
    getValueFromRS
    '�C�x���g�ĊJ
    StopEvents = False
End Sub
'�I��CSV����DB�ɓo�^����{�^��
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
    'RS��Conneciton���ڑ����Ă�����ؒf����
    'RS
    If rsfrmBIN.State And ObjectStateEnum.adStateOpen Then
        rsfrmBIN.ActiveConnection.Close
    End If
    'Connection
    If confrmBIN.State And ObjectStateEnum.adStateOpen Then
        confrmBIN.Close
    End If
'#If DontRemoveZaikoSH Then
    'DL�����t�@�C�����c���Ă����i�e�X�g�������j
    'DL����CSV�ɏ����߂�������ǉ������̂ŁACSV�t�@�C���͂��̂܂܎c����������������
    '�擾�����t�@�C�����������ɂ���DB�ɓo�^�i�g���q�ɂ���ď��������򂳂��͂��j
    longAffected = clsINVDBfrmBIN.UpsertINVPartsMasterfromZaikoSH(strCSVFullPath, objExcelFrmBIN, clsINVDBfrmBIN, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc, True)
''#Else
    '�ȉ��̓t�@�C���폜����ꍇ������ǂ��E�E�E
'    longAffected = clsINVDBfrmBIN.UpsertINVPartsMasterfromZaikoSH(strCSVFullPath, objExcelFrmBIN, clsINVDBfrmBIN, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc, False)
'#End If
    '�o�^�������I�������A������x�����ݒ�����A���X�g���č\������
    ConstRactor
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
    'RS���擾����f�[�^�S�N���A
    ClearAllContents
    'RS����l�擾�A�\��
    getValueFromRS
End Sub
'�O��ړ��{�^��
Private Sub btnMoveNextData_Click()
    '����
    MoveRecord vbKeyRight
End Sub
Private Sub btnMovePreviosData_Click()
    '�O��
    MoveRecord vbKeyLeft
End Sub
'No Real
Private Sub chkBoxShowNOReal_Click()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă���
        Exit Sub
    End If
    AditionalWhereFilter ActiveControl
End Sub
'No BIN
Private Sub chkBoxShowNotBIN_Click()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă���
        Exit Sub
    End If
    AditionalWhereFilter ActiveControl
End Sub
'Change�C�x���g
Private Sub txtBox_F_CSV_BIN_Amount_Change()
    'BIN�J�[�h�c��
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă����璆�~
        Exit Sub
    End If
    If txtBox_F_CSV_BIN_Amount.Text = "" Then
        '�󔒂������甲����
        Exit Sub
    End If
    If Not IsNumeric(txtBox_F_CSV_BIN_Amount.Text) Then
        MsgBox "BIN�J�[�h�c���ɓ��͂��ꂽ�����񂪐��l�Ƃ��ĔF���o���܂���B"
        Exit Sub
    End If
    '�f�[�^�`�F�b�N��DB�o�^�����s
    CheckDataAndUpdateDB txtBox_F_CSV_BIN_Amount
End Sub
Private Sub txtBox_F_CSV_Real_Amount_Change()
    '���c��
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă���
        Exit Sub
    End If
    If txtBox_F_CSV_Real_Amount.Text = "" Then
        '�󔒂������甲����
        Exit Sub
    End If
    If Not IsNumeric(txtBox_F_CSV_Real_Amount.Text) Then
        MsgBox "���c���ɓ��͂��ꂽ�����񂪐��l�Ƃ��ĔF���o���܂���B"
        Exit Sub
    End If
    '�f�[�^�`�F�b�N��DB�o�^�����s
    CheckDataAndUpdateDB txtBox_F_CSV_Real_Amount
End Sub
'Filter_Location
Private Sub txtBox_Filter_F_CSV_Tana_Local_Text_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă���
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    '�܂���UCASE���|����
    If txtBox_Filter_F_CSV_Tana_Local_Text.Text <> "" Then
        txtBox_Filter_F_CSV_Tana_Local_Text.Text = UCase(txtBox_Filter_F_CSV_Tana_Local_Text.Text)
    End If
    '�C�x���g�ĊJ����
    StopEvents = False
    '�����i�荞�ݎ��s
    AditionalWhereFilter ActiveControl
End Sub
'Filter_Tehai_Code
Private Sub txtBox_Filter_F_CSV_Tehai_Code_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă���
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    'Ucase�|����
    If txtBox_Filter_F_CSV_Tehai_Code.Text <> "" Then
        txtBox_Filter_F_CSV_Tehai_Code.Text = UCase(txtBox_Filter_F_CSV_Tehai_Code.Text)
    End If
    '�C�x���g�ĊJ����
    StopEvents = False
    '�����i�荞�ݎ��s
    AditionalWhereFilter ActiveControl
End Sub
'KeyDown�C�x���g
Private Sub txtBox_F_CSV_BIN_Amount_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    Select Case KeyCode
    Case vbKeyLeft, vbKeyRight
        '���E���L�[
        If chkBoxInputContiue.Value Then
            '�A�����̓��[�h��������
            '���R�[�h�ړ�
            MoveRecord (KeyCode)
            KeyCode = 0
        End If
    End Select
End Sub
Private Sub txtBox_F_CSV_Real_Amount_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    Select Case KeyCode
    Case vbKeyLeft, vbKeyRight
        '���E���L�[
        If chkBoxInputContiue.Value Then
            '�A�����̓��[�h��������
            '���R�[�h�ړ�
            MoveRecord (KeyCode)
            KeyCode = 0
        End If
    End Select
End Sub
Private Sub btnMoveNextData_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    Select Case KeyCode
    Case vbKeyLeft, vbKeyRight
        '���E���L�[
        If chkBoxInputContiue.Value Then
            '�A�����̓��[�h��������
            '���R�[�h�ړ�
            MoveRecord (KeyCode)
            KeyCode = 0
        End If
    End Select
End Sub
Private Sub btnMovePreviosData_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    Select Case KeyCode
    Case vbKeyLeft, vbKeyRight
        '���E���L�[
        If chkBoxInputContiue.Value Then
            '�A�����̓��[�h��������
            '���R�[�h�ړ�
            MoveRecord (KeyCode)
            KeyCode = 0
        End If
    End Select
End Sub
'---------------------------------------------------------------------------------------------------------------------
'�v���V�[�W��
Private Sub ConstRactor()
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
    If confrmBIN Is Nothing Then
        Set confrmBIN = New ADODB.Connection
    End If
    '�I�����ؓ����X�g��ݒ�
    Dim isCollect As Boolean
    isCollect = setEndDayList
    If Not isCollect Then
        MsgBox "�I��CSV��DB�f�[�^�ǂݍ��݂ŃG���[���������܂���"
'        Unload Me
        Exit Sub
    End If
    'divObjToField��ݒ�
    setDicObjToField
    Exit Sub
End Sub
'�t�H�[���I�����Ɏ��s����v���V�[�W��
Private Sub Destractor()
    '�����o�ϐ��̉��
    If Not clsADOfrmBIN Is Nothing Then
        clsADOfrmBIN.CloseClassConnection
        Set clsADOfrmBIN = Nothing
    End If
    If Not clsINVDBfrmBIN Is Nothing Then
        Set clsINVDBfrmBIN = Nothing
    End If
    If Not clsEnumfrmBIN Is Nothing Then
        Set clsEnumfrmBIN = Nothing
    End If
    If Not clsSQLBc Is Nothing Then
        Set clsSQLBc = Nothing
    End If
    If Not objExcelFrmBIN Is Nothing Then
        Set objExcelFrmBIN = Nothing
    End If
    If Not dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = Nothing
    End If
    If Not clsIncrementalfrmBIN Is Nothing Then
        Set clsIncrementalfrmBIN = Nothing
    End If
    If Not rsfrmBIN Is Nothing Then
        If rsfrmBIN.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����J���Ă��������
            rsfrmBIN.Close
        End If
        Set rsfrmBIN = Nothing
    End If
    If Not confrmBIN Is Nothing Then
        If confrmBIN.State And ObjectStateEnum.adStateOpen Then
            'open�t���O�������Ă��������
            confrmBIN.Close
        End If
        Set confrmBIN = Nothing
    End If
    Exit Sub
End Sub
'''dicObjToField�ɑ��݂���R���g���[���̓��e���������Ă���
'''args
'''strargExceptControlName  �I�v�V�����A�w�肳�ꂽName�̃I�u�W�F�N�g�̂͏������Ȃ�
Private Sub ClearAllContents(Optional strargExceptControlName As String)
    Dim controlKey As Control
    For Each controlKey In Me.Controls
        If dicObjNameToFieldName.Exists(controlKey.Name) And (strargExceptControlName <> controlKey.Name) Then
            'dicObjtoField�ɑ��݂��A�Ȃ��������̏��O�R���g���[�����ƈ�v���Ȃ������ꍇ
            Select Case TypeName(controlKey)
            Case "TextBox"
                '�e�L�X�g�{�b�N�X�������ꍇ
                controlKey.Text = ""
            Case "Label"
                '���x���������ꍇ
                controlKey.Caption = ""
            End Select
        End If
    Next controlKey
End Sub
'''RS���e�R���g���[���֒l���Z�b�g����
'''args
'''NotMoveFocus     True�ɃZ�b�g����ƍŌ�̃t�H�[�J�X�ړ������Ȃ�
Private Sub getValueFromRS(Optional NotMoveFocus As Boolean = False)
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    '�ŏ��ɑS���ڃN���A
    ClearAllContents
    'txtBox_F_CSV_No
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_No.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_No.Text = ""
    Else
        txtBox_F_CSV_No.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_No.Name), ".", "_")).Value
    End If
    'txtBox_F_CSV_Tana_Local_Text
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_Tana_Local_Text.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_Tana_Local_Text.Text = ""
    Else
        txtBox_F_CSV_Tana_Local_Text.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_Tana_Local_Text.Name), ".", "_")).Value
    End If
    'txtBox_F_CSV_Tehai_Code
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_Tehai_Code.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_Tehai_Code.Text = ""
    Else
        txtBox_F_CSV_Tehai_Code.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_Tehai_Code.Name), ".", "_")).Value
    End If
    'txtBox_F_CSV_DB_Amount
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_DB_Amount.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_DB_Amount.Text = ""
    Else
        txtBox_F_CSV_DB_Amount.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_DB_Amount.Name), ".", "_")).Value
    End If
    'txtBox_F_CSV_BIN_Amount
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_BIN_Amount.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_BIN_Amount.Text = ""
    Else
        txtBox_F_CSV_BIN_Amount.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_BIN_Amount.Name), ".", "_")).Value
    End If
    'txtBox_F_CSV_Real_Amount
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_Real_Amount.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_Real_Amount.Text = ""
    Else
        txtBox_F_CSV_Real_Amount.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_Real_Amount.Name), ".", "_")).Value
    End If
    'txtBox_F_CSV_System_Name
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_System_Name.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_System_Name.Text = ""
    Else
        txtBox_F_CSV_System_Name.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_System_Name.Name), ".", "_")).Value
    End If
    'txtBox_F_CSV_System_Spac
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_System_Spac.Name), ".", "_")).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_System_Spac.Text = ""
    Else
        txtBox_F_CSV_System_Spac.Text = rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_System_Spac.Name), ".", "_")).Value
    End If
    '�X�e�[�^�X�`�F�b�N
    StatusCheck
    'RS���Status���擾
    Dim longStatusValue As Long
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value) Then
        'Null�������ꍇ
        longStatusValue = 0
    Else
        longStatusValue = CLng(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value)
    End If
    If Not NotMoveFocus Then
        '�t�H�[�J�X�ړ��֎~�t���O�������Ă��Ȃ�������
        'BIN�J�[�h�c�����f�[�^�`�F�b�NOK�ł͂Ȃ�������t�H�[�J�X��BIN�J�[�h�c���ցAOK�Ȃ猻�i�c�փt�H�[�J�X�ړ�
        If longStatusValue = Enum_frmBIN_Status.AllOK Then
            '�S�f�[�^OK�̎�
            '���փ{�^���Ƀt�H�[�J�X
            btnMoveNextData.SetFocus
        ElseIf Not longStatusValue And BINDataOK Then
            'BIN�J�[�h�c�����f�[�^OK�ł͂Ȃ�
            txtBox_F_CSV_BIN_Amount.SetFocus
            '������S�I����Ԃɂ���
            txtBox_F_CSV_BIN_Amount.SelStart = 0
            txtBox_F_CSV_BIN_Amount.SelLength = Len(txtBox_F_CSV_BIN_Amount.Text)
        ElseIf Not longStatusValue And RealDataOK Then
            '���i�c��DataOK����Ȃ���
            '�t�H�[�J�X�����i�c�e�L�X�g�{�b�N�X�Ɉړ�
            txtBox_F_CSV_Real_Amount.SetFocus
            '������S�I����Ԃɂ���
            txtBox_F_CSV_Real_Amount.SelStart = 0
            txtBox_F_CSV_Real_Amount.SelLength = txtBox_F_CSV_Real_Amount.TextLength
        End If
    End If
    '�C�x���g�ĊJ
    StopEvents = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "getValueFromRS code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
Private Sub StatusCheck()
    On Error GoTo ErrorCatch
    '�܂�RS����Status�̐��l���󂯎��
    Dim longStatusValue As Long
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value) Then
        'Null�������ꍇ
        longStatusValue = 0
    Else
        longStatusValue = CLng(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value)
    End If
    'Status�Ɋ�Â��t���O�`�F�b�N���A�\���E��\�������߂�
    'Bin Input
    If longStatusValue And Enum_frmBIN_Status.BINInput Then
        lbl_BINcard_Input.Visible = True
        'BIN���͂���Ă�����Ƃ肠�������ɂ��Ă��
        txtBox_F_CSV_BIN_Amount.BackColor = &H80000005
    Else
        lbl_BINcard_Input.Visible = False
        '�����͂Ȃ琅�F�ɂ��Ă��
        txtBox_F_CSV_BIN_Amount.BackColor = &HFFFFC0
    End If
    'BIN Data OK
    If longStatusValue And Enum_frmBIN_Status.BINDataOK Then
        lbl_BINcard_DataOK.Visible = True
        'OK�Ȃ甒�Ŋm��
        txtBox_F_CSV_BIN_Amount.BackColor = &H80000005
    Else
        lbl_BINcard_DataOK.Visible = False
        'Bin NG�Ȃ甖�����F�ɂ��Ă��
        If longStatusValue And BINInput Then
            'BIN Input��OK�̎������ύX����
            txtBox_F_CSV_BIN_Amount.BackColor = &H80FFFF
        End If
    End If
    'Real Input
    If longStatusValue And Enum_frmBIN_Status.RealInput Then
        lbl_RealAmount_Input.Visible = True
        '�Ƃ肠�������͂��ꂽ���U����
        txtBox_F_CSV_Real_Amount.BackColor = &H80000005
    Else
        lbl_RealAmount_Input.Visible = False
        '�����͂Ȃ琅�F��
        txtBox_F_CSV_Real_Amount.BackColor = &HFFFFC0
    End If
    'Real Data OK
    If longStatusValue And Enum_frmBIN_Status.RealDataOK Then
        lbl_RealAmount_DataOK.Visible = True
        '�f�[�^OK�Ȃ甒�m��
        txtBox_F_CSV_Real_Amount.BackColor = &H80000005
    Else
        lbl_RealAmount_DataOK.Visible = False
        If longStatusValue And RealInput Then
            'Real NG�Ȃ甖�����F��
            'Real InputOK�̎������ύX����
            txtBox_F_CSV_Real_Amount.BackColor = &H80FFFF
        End If
    End If
    'AllOK
    If longStatusValue = Enum_frmBIN_Status.AllOK Then
        lbl_AllData_OK.Visible = True
        lbl_Data_NG.Visible = False
    Else
        lbl_AllData_OK.Visible = False
        lbl_Data_NG.Visible = True
    End If
    GoTo CloseAndExit
    Exit Sub
ErrorCatch:
    DebugMsgWithTime "StatusCheck code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
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
'''strargAditionalWhere �ǉ���Where������String�Ŏw��
Private Function setDefaultDataToRS(strargEndDay As String, Optional strargAditionalWhere As String) As Boolean
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
    dicReplaceSetDefault.Add 7, strargAditionalWhere
    dicReplaceSetDefault.Add 8, dicObjNameToFieldName(txtBox_F_CSV_Tana_Local_Text.Name) & " ASC"
    'Replace���s�ASQL�ݒ�
    clsADOfrmBIN.SQL = clsSQLBc.ReplaceParm(CSV_SQL_TANA_DEFAULT, dicReplaceSetDefault)
    '�N���X�Őڑ����Ă����瑽�d�ڑ��ɂȂ�\��������̂ŁA�����I�ɐؒf���Ă��
    clsADOfrmBIN.CloseClassConnection
    'SQL�g�ݗ��Ċ��������̂ŁA�f�[�^����荞��RS�̃v���p�e�B��ݒ肵�Ă���
    If rsfrmBIN.State And ObjectStateEnum.adStateConnecting Then
        '�ڑ�����Ă������U�ؒf����
        rsfrmBIN.Close
    End If
    If confrmBIN.State And ObjectStateEnum.adStateOpen Then
        'connection���J���Ă�����ڑ������
        confrmBIN.Close
    End If
    'Connection�I�u�W�F�N�g�̐ݒ���s��
    confrmBIN.ConnectionString = clsADOfrmBIN.CreateConnectionString(clsADOfrmBIN.DBPath, clsADOfrmBIN.DBFileName)
    confrmBIN.Mode = adModeReadWrite Or adModeShareDenyNone
    '���R�[�h�Z�b�g��Source�Ƃ���clADO��SQL��ݒ肷��
    rsfrmBIN.Source = clsADOfrmBIN.SQL
    '�����X�V���[�h�̏�Ԃɂ���ď����𕪊�(�����X�V���o�b�`�X�V��)
    Select Case chkBoxUpdateASAP
    Case True
        '�����X�V�L���̏ꍇ
        If confrmBIN.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����J���Ă������U����
            confrmBIN.Close
        End If
        confrmBIN.CursorLocation = adUseServer
        '�ڑ����I�[�v��
        confrmBIN.Open
        'rs��ActiveConnection�Ƀ����o�ϐ���Connection��ݒ�
        Set rsfrmBIN.ActiveConnection = confrmBIN
        '���R�[�h�Z�b�g��r���I���b�N�ŊJ��(CursorLocation��Cliant�̎��͋��L�I���b�N�ł����J���Ȃ�)
        rsfrmBIN.LockType = adLockPessimistic
        '���I�J�[�\���ɂ��A�ق��̐l���s�����ύX�͌���邪�A�ǉ����͌���Ȃ��J�[�\���^�C�v�ɂ���
        'CursorLocation��Server�ɂȂ�̂ŁARecordCount�͎g���Ȃ��Ȃ�
        rsfrmBIN.CursorLocation = adUseServer
        rsfrmBIN.CursorType = adOpenDynamic
        rsfrmBIN.Open , , , , CommandTypeEnum.adCmdText
        '�o�^�{�^���𖳌���
        btnDoUpdate.Enabled = False
    Case False
        '�o�b�`�X�V���[�h
        If confrmBIN.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����J���Ă������U����
            confrmBIN.Close
        End If
        confrmBIN.CursorLocation = adUseClient
        '�ڑ����J��
        confrmBIN.Open
        'rs��ActiveConnection�Ƀ����o�ϐ������蓖�Ă�
        Set rsfrmBIN.ActiveConnection = confrmBIN
        '���b�N�^�C�v���o�b�`�X�V���[�h�ɂ���
        rsfrmBIN.LockType = adLockBatchOptimistic
        '���I�J�[�\���ɂ��A���̐l���s�����ύX�������J�[�\���^�C�v�ɂ���
        rsfrmBIN.CursorLocation = adUseClient
        'CursorLocation��Cliant�̎��̓J�[�\���^�C�v�̓X�^�e�B�b�N��FowerdOnly�����I�ׂȂ��E�E�̂��ȁH
        rsfrmBIN.CursorType = adOpenStatic
        rsfrmBIN.Open , , , , CommandTypeEnum.adCmdText
        '�o�^�{�^����L����
        btnDoUpdate.Enabled = True
    End Select
    'Filter�Ƃ���adFilterFetchedRecords���Z�b�g���Ă��A�t�F�b�`�ς݂̍s�����ɂ���
    rsfrmBIN.Filter = adFilterFetchedRecords
    '������BOF�AEOF������True�ɂȂ��Ă���擾���s���Ă���
    If rsfrmBIN.BOF And rsfrmBIN.EOF Then
        '�擾���s(0��)
        setDefaultDataToRS = False
        GoTo CloseAndExit
    Else
        '�擾����
        '�t�B���^�������A�ŏ��̃��R�[�h�Ɉړ�
        rsfrmBIN.Filter = adFilterNone
        rsfrmBIN.MoveFirst
        setDefaultDataToRS = True
        GoTo CloseAndExit
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "setDefaultDataToRS code: " & err.Number & " Description: " & err.Description
    setDefaultDataToRS = False
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''���R�[�h�ړ�
'''args
'''argKeyCode   KeyCode ���Ȃ玟�ցA���Ȃ�O��
Private Sub MoveRecord(argKeyCode As Integer)
    On Error GoTo ErrorCatch
    If rsfrmBIN.State = ObjectStateEnum.adStateClosed Then
        'RS�����Ă����牽�������ɔ�����
        DebugMsgWithTime "MoveRecord : RS not open"
        GoTo CloseAndExit
        Exit Sub
    End If
    Select Case argKeyCode
    Case vbKeyRight
        '�E�̏ꍇ�A����
        '�Ƃ肠����MoveNext����
        rsfrmBIN.MoveNext
        'EOF�̏�Ԃ��m�F
        If rsfrmBIN.EOF Then
            '�ړ��O���ŏI���R�[�h�������ꍇ
            MsgBox "���݂̃��R�[�h���ŏI���R�[�h�ł�"
            rsfrmBIN.MovePrevious
            GoTo CloseAndExit
        End If
    Case vbKeyLeft
        '���̏ꍇ�A�O��
        '�Ƃ肠����MovePrevious����
        rsfrmBIN.MovePrevious
        'BOF�̏�Ԃ��m�F
        If rsfrmBIN.BOF Then
            '�ړ��O���ŏ��̃��R�[�h������
            MsgBox "���݂̃��R�[�h���擪���R�[�h�ł�"
            rsfrmBIN.MoveNext
            GoTo CloseAndExit
        End If
    End Select
    '���R�[�h�ړ������̂ŁARS����l���擾����
    '�C�x���g��~
    StopEvents = True
    getValueFromRS
    '�C�x���g�ĊJ
    StopEvents = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "MoveRecord code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''���͂��ꂽ���l���`�F�b�N���ARS(DB)��Update����
'''TextBox��Change�C�x���g����Ă΂��O��
'''args
'''argTxtBox    �C�x���g�����������R���g���[���̎Q��
Private Sub CheckDataAndUpdateDB(ByRef argTxtBox As MSForms.TextBox)
    On Error GoTo ErrorCatch
    If argTxtBox Is Nothing Then
        DebugMsgWithTime "CheckDataAndUpdateDB : Control name is empty"
        GoTo CloseAndExit
    End If
    If Not IsNumeric(argTxtBox.Text) Then
        MsgBox "���͂��ꂽ���������l�Ƃ��ĔF���ł��܂���ł���"
        DebugMsgWithTime "CheckDataAndUpdateDB : cant cast number txtboxname: " & argTxtBox.Name
        GoTo CloseAndExit
    End If
    If rsfrmBIN.State = ObjectStateEnum.adStateClosed Then
        'RS�����Ă����牽�������ɔ�����
        DebugMsgWithTime "CheckDataAndUpdateDB : RS not open."
        GoTo CloseAndExit
    End If
    '�e�L�X�g�{�b�N�X�ɓ��͂��ꂽ������RS�̐��l�������������牽�����Ȃ�
    If rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(argTxtBox.Name), ".", "_")).Value = CDbl(argTxtBox.Text) Then
        GoTo CloseAndExit
    End If
    '�t�B�[���h�w���RS�ɓo�^���s
    UpdateSpecificField argTxtBox
    '�t���O�`�F�b�N�Ɛݒ�
    ChekStatusAndSetFlag
    'RS�̃t���O�������ƂɃ��x�����X�V����
    StatusCheck
    '�����X�V���L���Ȃ炱����Update������
    If chkBoxUpdateASAP.Value Then
        Dim isCollect As Boolean
        isCollect = UpdateDBfromRS
        If Not isCollect Then
            MsgBox "DB�ւ̓o�^���ɃG���[���������܂���"
            GoTo CloseAndExit
        End If
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "CheckDataAndUpdateDB code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''�w�肳�ꂽ�R���g���[�����ɑΉ�����RS�Ƀf�[�^��o�^����
'''args
'''argTxtBox    ����Ώۂ̃R���g���[���̎Q��
Private Sub UpdateSpecificField(ByRef argTxtBox As MSForms.TextBox)
    On Error GoTo ErrorCatch
    If argTxtBox.Text = "" Then
        '�Ώۂ̃e�L�X�g���󔒂������牽�������ɔ�����
        GoTo CloseAndExit
        Exit Sub
    End If
    'RS�̒l�ƈ���Ă�����Ή�����RS�ɒl���Z�b�g����
    If IsNull(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(argTxtBox.Name), ".", "_")).Value) Or rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(argTxtBox.Name), ".", "_")).Value <> CDbl(argTxtBox.Text) Then
        'Value��Null���A�e�L�X�g�{�b�N�X�̐��l�ƈ���Ă����ꍇ
        rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(argTxtBox.Name), ".", "_")).Value = _
        CDbl(argTxtBox.Text)
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "UpdateSpecificField code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'RS��̐��l��]�����A�t���O�̏グ�������s���ARS�ɓo�^����
'RS�Ƀe�L�X�g�{�b�N�X�̐��l�𔽉f��������Ɏ��s����(DB�o�^�G���[�̃��X�N�����炵����)
Private Sub ChekStatusAndSetFlag()
    On Error GoTo ErrorCatch
    If rsfrmBIN.EditMode = adEditNone Then
        'RS�ɕύX���Ȃ��Ƃ��͉������Ȃ�
        GoTo CloseAndExit
    End If
    'BinCard
    'Select Case �� Case�̓V���[�g�T�[�L�b�g�ɂȂ邱�Ƃ𗘗p
    Select Case True
    Case Not IsNumeric(txtBox_F_CSV_BIN_Amount.Text)
        '���l�Ƃ��ĔF������Ȃ��ꍇ
        '���ɉ������Ȃ�
    Case CDbl(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_BIN_Amount.Name), ".", "_")).Value) = _
        CDbl(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_DB_Amount.Name), ".", "_")).Value)
        'RS���BIN�J�[�h�c���ƃV�[�g�c������v�����ꍇ
        'BIN DataOK�t���O��Bin Input�t���O�𗼕����Ă�(���͂��ĂȂ���OK�ɂȂ�Ȃ��O��)
        rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value = _
        rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value Or Enum_frmBIN_Status.BINDataOK Or Enum_frmBIN_Status.BINInput
    Case txtBox_F_CSV_BIN_Amount.Text <> ""
        '�󔒂ł͂Ȃ������ꍇ
        'Bin Input�t���O�𗧂ĂāABI OK�t���O�𗎂Ƃ�
        rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value = _
        (rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value Or Enum_frmBIN_Status.BINInput) And Not Enum_frmBIN_Status.BINDataOK
    End Select
    'RealAmount
    'Select Case �� Case�̓V���[�g�T�[�L�b�g�ɂȂ邱�Ƃ𗘗p
    Select Case True
    Case Not IsNumeric(txtBox_F_CSV_Real_Amount.Text)
        '���l�Ƃ��ĔF������Ȃ��ꍇ
        '���ɉ������Ȃ�
    Case CDbl(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_Real_Amount.Name), ".", "_")).Value) = _
        CDbl(rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(txtBox_F_CSV_DB_Amount.Name), ".", "_")).Value)
        'RS���BIN�J�[�h�c���ƃV�[�g�c������v�����ꍇ
        'Real DataOK�t���O��Real Input�t���O�𗼕����Ă�(���͂��ĂȂ���OK�ɂȂ�Ȃ��O��)
        rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value = _
        rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value Or Enum_frmBIN_Status.RealDataOK Or Enum_frmBIN_Status.RealInput
    Case txtBox_F_CSV_Real_Amount.Text <> ""
        '�󔒂ł͂Ȃ������ꍇ
        'Real Input�t���O�𗧂ĂāAReal OK�t���O�𗎂Ƃ�
        rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value = _
        (rsfrmBIN.Fields(REPLACE(dicObjNameToFieldName(clsEnumfrmBIN.CSVTanafield(F_Status_ICS)), ".", "_")).Value Or Enum_frmBIN_Status.RealInput) And Not RealDataOK
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "ChekStatusAndSetFlag code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''RS�̓��e��DB��Update����
'''Return bool ����������True�A����ȊO��False
Private Function UpdateDBfromRS() As Boolean
    On Error GoTo ErrorCatch
    If rsfrmBIN.EditMode = adEditNone Then
        '�ύX���Ȃ������ꍇ
        '���������ɔ�����
        DebugMsgWithTime "UpdateDBfromRS : No data changed. Do nothing"
        UpdateDBfromRS = True
        GoTo CloseAndExit
        Exit Function
    End If
    '�ڑ��󋵂𒲂ׁA�ڑ����ĂȂ�������ڑ�����
    If Not rsfrmBIN.State And ObjectStateEnum.adStateOpen Then
        'RS�����ڑ�������
        '�X��Connection�I�u�W�F�N�g�̐ڑ��󋵂����ׂ�
        If Not confrmBIN.State And ObjectStateEnum.adStateOpen Then
            'Connection�����ڑ�������
            confrmBIN.Open
        End If
        Set rsfrmBIN.ActiveConnection = confrmBIN
    End If
    'Update���s����
    rsfrmBIN.Update
    UpdateDBfromRS = True
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "UpdateDBfromRS code: " & err.Number & " Description: " & err.Description
    UpdateDBfromRS = False
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'�i�荞�݂��s��
'''args
'''argSouceCtrl     �Ăяo�����̃R���g���[���̎Q��
Private Sub AditionalWhereFilter(ByRef argSouceCtrl As Control)
    On Error GoTo ErrorCatch
    '�I�����ؓ��I������ĂȂ������烁�b�Z�[�W�o���Ĕ�����
    If lstBoxEndDay.ListIndex = -1 Then
        '�I�����ؓ����X�g���I������ĂȂ�����
        MsgBox "�I�����ؓ����I������Ă��܂���B�I�����ؓ���I�����ĉ������B"
        GoTo CloseAndExit
    End If
    '�e�R���g���[���̏�Ԃɉ����āA�ǉ�Where������g�ݗ��Ă�
    Dim strarrAddWhere() As String
    ReDim strarrAddWhere(0)
    '0�Ԗڂɂ͑O�̏����ƌq���邽�߂� AND �p�ɋ����������
    strarrAddWhere(0) = " AND 1=1"
    '�ȉ��A���ꂼ��K�؂Ȗ��ߍ��ݒ萔�𗘗p���A��������g�ݗ��Ă�
    Dim dicReplaceAddWhere As Dictionary
    Set dicReplaceAddWhere = New Dictionary
    'no Bin
    If chkBoxShowNotBIN.Value Then
        '�����z����g��
        ReDim Preserve strarrAddWhere(UBound(strarrAddWhere) + 1)
        dicReplaceAddWhere.RemoveAll
        dicReplaceAddWhere.Add 0, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Status_ICS), clsEnumfrmBIN)
        dicReplaceAddWhere.Add 1, BINDataOK
        strarrAddWhere(UBound(strarrAddWhere)) = clsSQLBc.ReplaceParm(CSV_SQL_BIT_NOT_INCLUDE, dicReplaceAddWhere)
    End If
    'no Real
    If chkBoxShowNOReal.Value Then
        '�����z����g��
        ReDim Preserve strarrAddWhere(UBound(strarrAddWhere) + 1)
        dicReplaceAddWhere.RemoveAll
        dicReplaceAddWhere.Add 0, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Status_ICS), clsEnumfrmBIN)
        dicReplaceAddWhere.Add 1, RealDataOK
        strarrAddWhere(UBound(strarrAddWhere)) = clsSQLBc.ReplaceParm(CSV_SQL_BIT_NOT_INCLUDE, dicReplaceAddWhere)
    End If
    'Location
    If txtBox_Filter_F_CSV_Tana_Local_Text.Text <> "" Then
        '�����z����g��
        ReDim Preserve strarrAddWhere(UBound(strarrAddWhere) + 1)
        dicReplaceAddWhere.RemoveAll
        dicReplaceAddWhere.Add 0, dicObjNameToFieldName(txtBox_F_CSV_Tana_Local_Text.Name)
        dicReplaceAddWhere.Add 1, txtBox_Filter_F_CSV_Tana_Local_Text.Text
        strarrAddWhere(UBound(strarrAddWhere)) = clsSQLBc.ReplaceParm(CSV_SQL_WHERE_LIKE, dicReplaceAddWhere)
    End If
    'TehaiCode
    If txtBox_Filter_F_CSV_Tehai_Code.Text <> "" Then
        '�����z����g��
        ReDim Preserve strarrAddWhere(UBound(strarrAddWhere) + 1)
        dicReplaceAddWhere.RemoveAll
        dicReplaceAddWhere.Add 0, dicObjNameToFieldName(txtBox_F_CSV_Tehai_Code.Name)
        dicReplaceAddWhere.Add 1, txtBox_Filter_F_CSV_Tehai_Code.Text
        strarrAddWhere(UBound(strarrAddWhere)) = clsSQLBc.ReplaceParm(CSV_SQL_WHERE_LIKE, dicReplaceAddWhere)
    End If
    '�w�肵�������ŏ������w�肵�A�匳�̃f�[�^���X�V���Ă��
    Dim isCollect As Boolean
    isCollect = setDefaultDataToRS(lstBoxEndDay.List(lstBoxEndDay.ListIndex), Join(strarrAddWhere, " AND "))
    If Not isCollect Then
        MsgBox "�w������œK�����郌�R�[�h������܂���ł����B�i�荞�ݏ��������ɖ߂��A�f�[�^�Ď擾���܂��B"
        '�C�x���g��~
        StopEvents = True
        'RS���擾����f�[�^�S�N���A
        ClearAllContents
        '�����ݒ�R���g���[���̏�Ԃ��o���邾�����ɖ߂�
        '�Ăяo�����̃R���g���[���̎�ނɂ�菈���𕪊�
        Select Case TypeName(argSouceCtrl)
        Case "TextBox"
            '�e�L�X�g�{�b�N�X������
            '���X�̒�����Len -1 ��������擾
            argSouceCtrl.Text = Mid(argSouceCtrl.Text, 1, Len(argSouceCtrl.Text) - 1)
        Case "CheckBox"
            '�`�F�b�N�{�b�N�X
            'not�Ŕ��]����
            argSouceCtrl.Value = Not (argSouceCtrl.Value)
        End Select
'        '�C�x���g�ĊJ
'        StopEvents = False
'        '�ǉ������Ȃ��Ńf�[�^�Ď擾
'        isCollect = setDefaultDataToRS(lstBoxEndDay.List(lstBoxEndDay.ListIndex))
'        If Not isCollect Then
'            MsgBox "�i�荞�ݏ����Ȃ��̃f�[�^�擾�Ɏ��s���܂����BExcel�t�@�C�����J���Ȃ����Ă�����x�����ĉ������B"
'            Unload Me
'            GoTo CloseAndExit
'        End If
'        '�C�x���g��~
'        StopEvents = True
'        'RS����l�擾�A�\��
'        getValueFromRS
        '�_��������������߂��Ă�̂ŁA����1�񎩐M���ċA�Ăяo������
        AditionalWhereFilter argSouceCtrl
        '�t�H�[�J�X�ړ�������RS����f�[�^�擾
        getValueFromRS True
        '�C�x���g�ĊJ
        StopEvents = False
        GoTo CloseAndExit
    End If
    '�����������ۂ�
    '�C�x���g��~
    StopEvents = True
    'RS����l�擾�A�\��
    getValueFromRS True
    '�C�x���g�ĊJ
    StopEvents = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "AditionalWhereFilter code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Set dicReplaceAddWhere = Nothing
    Exit Sub
End Sub
VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmTanaBincard 
   Caption         =   "�I��BIN�J�[�h�`�F�b�N�p�t�H�[��"
   ClientHeight    =   9555.001
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8115
   OleObjectBlob   =   "frmTanaBincard.frx":0000
   ShowModal       =   0   'False
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
Private confrmBIN As ADODB.Connection
Private StopEvents As Boolean
Public strOriginEndDay As String                        '�p�����ƂȂ�EndDay���i�[����ϐ�
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
Private Const CSV_SQL_ENDDAY_LIST As String = "SELECT DISTINCT {0} FROM {1} IN""""{2} ORDER BY {0} ASC"
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
'------------------------------------------------------------------------------------------------
'BIN�J�[�h�c���ƌ��i�c���p������SQL
'{0}    T_INV_CSV
'{1}    T_Dst
'{2}    ���P�[�V����
'{3}    �I�����ؓ�
'{4}    (Origin EndDay)
'{5}    T_Orig
'{6}    ��z�R�[�h
'{7}    F_CSV_BIN_Amount
'{8}    ���i�c
'{9}    (Dst EndDay)
Private Const CSV_SQL_INHERIT_AMOUNT As String = "UPDATE {0} AS {1} " & vbCrLf & _
"    INNER JOIN (" & vbCrLf & _
"        SELECT * FROM {0} " & vbCrLf & _
"        WHERE {2} LIKE ""K%"" AND LEN({2}) >= 2 AND {3} = ""{4}""" & vbCrLf & _
"        ) AS {5} " & vbCrLf & _
"    ON {1}.{6} = {5}.{6} " & vbCrLf & _
"SET {1}.{7} = {5}.{7},{1}.{8} = {5}.{8} " & vbCrLf & _
"WHERE {1}.{3} = ""{9}"""
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
    If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
        clsADOfrmBIN.RS.ActiveConnection.Close
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
    DebugMsgWithTime "btnSaveDBtoCSV code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
    Exit Sub
CloseAndExit:
    'RS�Ď擾
    setDefaultDatatoRS (lstBoxEndDay.List(lstBoxEndDay.ListIndex))
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
    If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
        clsADOfrmBIN.RS.ActiveConnection.Close
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
End Sub
'''BIN�J�[�h�c���A���i�c��O�̃f�[�^����p������
Private Sub btnInheritAmount_Click()
    InheritAmount
End Sub
Private Sub lstBoxEndDay_Click()
    '���ؓ����X�g�I�����ꂽ
    '�I�����ꂽ���ؓ�����f�[�^�擾���A�����o�ϐ���rs�ɃZ�b�g���Ă��
    Dim isCollect As Boolean
    isCollect = setDefaultDatatoRS(lstBoxEndDay.List(lstBoxEndDay.ListIndex))
    If Not isCollect Then
        MsgBox "�I�����ؓ�: " & lstBoxEndDay.List(lstBoxEndDay.ListIndex) & " �̃f�[�^�̎擾�Ɏ��s���܂���"
        Exit Sub
    End If
    '�C�x���g���~����
    StopEvents = True
    'RS���擾����f�[�^�S�N���A
    ClearAllContents
    '�f�[�^���������x���ɃZ�b�g
    lbl_TotalAmount.Caption = CStr(clsADOfrmBIN.GetRecordCountFromRS(clsADOfrmBIN.RS))
    'RS����l�擾�A�\��
    getValueFromRS
    '�C�x���g���ĊJ
    StopEvents = False
End Sub
'�C���N�������^���T�[�`�̃��X�g���肱
Private Sub lstBox_IncrementalSerch_Click()
    On Error GoTo ErrorCatch
    '�C�x���g��~
    StopEvents = True
    If clsIncrementalfrmBIN.Incremental_LstBox_Click Then
        '���̒��ɓ����Ă鎞�_��RS�Ƀt�B���^���������Ă�
        'clsincremental�̃C�x���g����~����
        clsIncrementalfrmBIN.StopEvent = True
        'AditionalFilter�̂��߂Ƀt�B���^�[�e�L�X�g�{�b�N�X�ɃC���N�������^�����X�g�̒l���Z�b�g
        clsIncrementalfrmBIN.txtBoxRef.Text = lstBox_IncrementalSerch.List(lstBox_IncrementalSerch.ListIndex)
'        �C���N�������^�����X�g�{�b�N�X���\�����Keyup��MouseUp�ɔC����
        'RS�̃f�[�^���f
        getValueFromRS True
'        '�ǉ������ݒ�͂����ł͂��Ȃ��Ă�����
'        AditionalWhereFilter clsIncrementalfrmBIN.txtBoxRef
        'clsIncremantal�̃C�x���g���ĊJ���Ă��
        clsIncrementalfrmBIN.StopEvent = False
    End If
    '�C�x���g�ĊJ
    StopEvents = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "lstBox_IncrementalSerch_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
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
'Enter�C�x���g
'�I�ԃt�B���^�[�e�L�X�g�{�b�N�XEnter
Private Sub txtBox_Filter_F_CSV_Tana_Local_Text_Enter()
    '�C�x���g��~����
    StopEvents = True
    'clsIncremtental.txtBoxref�ɂ������ԃR���g���[����ݒ�
    Set clsIncrementalfrmBIN.txtBoxRef = txtBox_Filter_F_CSV_Tana_Local_Text
    '�ǉ������ݒ肵�Ă��
    AditionalWhereFilter clsIncrementalfrmBIN.txtBoxRef
    '�t�B���^�e�L�X�g�{�b�N�X�ƕ\���e�L�X�g�{�b�N�X�̓��e���Ⴄ�Ƃ��̂݃C���N�������^��
    If txtBox_F_CSV_Tana_Local_Text.Text <> clsIncrementalfrmBIN.txtBoxRef.Text Then
        '�C�x���g��~����
        StopEvents = True
        clsIncrementalfrmBIN.Incremental_TextBox_Enter clsIncrementalfrmBIN.txtBoxRef, lstBox_IncrementalSerch
        'RS���l���擾���Ȃ���(�t�H�[�J�X�ړ�����)
        getValueFromRS True
    End If
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
Private Sub txtBox_Filter_F_CSV_Tehai_Code_Enter()
    '�C�x���g��~����
    StopEvents = True
    'clsIncremental��txtBox�̎Q�Ƃɂ������ԃR���g���[����ݒ肵�Ă��
    Set clsIncrementalfrmBIN.txtBoxRef = txtBox_Filter_F_CSV_Tehai_Code
    '�ǉ������ݒ肵�Ă��
    AditionalWhereFilter clsIncrementalfrmBIN.txtBoxRef
    '�t�B���^�e�L�X�g�{�b�N�X�Ǝ�z�R�[�h���Ⴄ�Ƃ��̂݃G���^�[�C�x���g
    If txtBox_F_CSV_Tehai_Code.Text <> clsIncrementalfrmBIN.txtBoxRef.Text Then
        '�C�x���g��~����
        StopEvents = True
        clsIncrementalfrmBIN.Incremental_TextBox_Enter clsIncrementalfrmBIN.txtBoxRef, lstBox_IncrementalSerch
        '�C���N�������^���T�[�`�ň�U�l��������Ă�̂ŁA�擾���Ȃ���
        getValueFromRS True
    End If
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'�C���N�������^�����X�gEnter
Private Sub lstBox_IncrementalSerch_Enter()
    '�C�x���g��~����
    StopEvents = True
    clsIncrementalfrmBIN.Incremental_LstBox_Enter
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
Private Sub btnMoveNextData_Enter()
    If lstBox_IncrementalSerch.ListCount <= 1 Then
        lstBox_IncrementalSerch.Height = 0
    Else
        lstBox_IncrementalSerch.Visible = False
    End If
End Sub
Private Sub btnMovePreviosData_Enter()
    If lstBox_IncrementalSerch.ListCount <= 1 Then
        lstBox_IncrementalSerch.Height = 0
    Else
        lstBox_IncrementalSerch.Visible = False
    End If
End Sub
Private Sub txtBox_F_CSV_BIN_Amount_Enter()
    If lstBox_IncrementalSerch.ListCount <= 1 Then
        lstBox_IncrementalSerch.Height = 0
    Else
        lstBox_IncrementalSerch.Visible = False
    End If
End Sub
Private Sub txtBox_F_CSV_Real_Amount_Enter()
    If lstBox_IncrementalSerch.ListCount <= 1 Then
        lstBox_IncrementalSerch.Height = 0
    Else
        lstBox_IncrementalSerch.Visible = False
    End If
End Sub
'Change�C�x���g
Private Sub txtBox_F_CSV_BIN_Amount_Change()
    'BIN�J�[�h�c��
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă����璆�~
        Exit Sub
    End If
    '�󔒂ŏ����iNull�Z�b�g)����悤�ɂ���̂ŁA�󔒂ŃC�x���g�͂��肦��
    '�f�[�^�`�F�b�N��DB�o�^�����s
    CheckDataAndUpdateDB txtBox_F_CSV_BIN_Amount
End Sub
Private Sub txtBox_F_CSV_Real_Amount_Change()
    '���c��
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă���
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
    '�����i�荞�ݎ��s
    AditionalWhereFilter clsIncrementalfrmBIN.txtBoxRef
    'clsIncremental.textBoxref�ƕ\���f�[�^���Ⴄ�ꍇ�̂݃C���N�������^�����s
    If txtBox_F_CSV_Tana_Local_Text.Text <> clsIncrementalfrmBIN.txtBoxRef.Text Then
        '�C�x���g��~����
        StopEvents = True
        clsIncrementalfrmBIN.Incremental_TextBox_Change
        'RS����l���擾���Ȃ����A�ӂ����[���ړ�����
        getValueFromRS True
    End If
    '�C�x���g�ĊJ����
    StopEvents = False
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
    '�����i�荞�ݎ��s
    AditionalWhereFilter clsIncrementalfrmBIN.txtBoxRef
    '�i�荞�݂�������clsIncremental.txtBoxref�ƕ\���f�[�^���Ⴄ�Ƃ��̂݃C���N�������^���T�[�`�J�n
    If txtBox_F_CSV_Tehai_Code.Text <> clsIncrementalfrmBIN.txtBoxRef.Text Then
        '�C�x���g��~����
        StopEvents = True
        'clsIncreMental�̃C�x���g���ĊJ����
        clsIncrementalfrmBIN.StopEvent = False
        clsIncrementalfrmBIN.Incremental_TextBox_Change
        '�C���N�������^���T�[�`�ň�U�S���X�g��������Ă�̂ŁA�l��RS����擾���Ȃ���
        getValueFromRS True
    End If
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'KeyDown�C�x���g
Private Sub txtBox_F_CSV_BIN_Amount_KeyDown(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If StopEvents Then
        '�C�x���g��~�t���O�����Ă���Ԃ̓L�[���͖����ɂ���
        KeyCode = 0
        Exit Sub
    End If
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
    If StopEvents Then
        '�C�x���g��~�t���O�����Ă���Ԃ̓L�[���͂𖳌��ɂ���
        KeyCode = 0
        Exit Sub
    End If
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
    If StopEvents Then
        '�C�x���g��~�t���O�����Ă��甲����
        Exit Sub
    End If
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
    If StopEvents Then
        '�C�x���g��~�t���O�����Ă��甲����
        Exit Sub
    End If
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
'KeyUp�C�x���g
Private Sub lstBox_IncrementalSerch_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If StopEvents Then
        '�C�x���g��~�t���O�����Ă��甲����
        Exit Sub
    End If
    '�C�x���g��~
    StopEvents = True
    '�C���N�������^�����X�g�̃L�[�C�x���g
    clsIncrementalfrmBIN.Incremental_LstBox_Key_UP KeyCode, Shift
    Select Case KeyCode
    Case vbKeyEscape, vbKeyReturn
        '�L�[��Return��ESC��������
        '�t�H�[�J�X�ړ��ړI��RS���f�[�^�擾
        getValueFromRS
    End Select
    '�C�x���g�ĊJ
    StopEvents = False
End Sub
'MouseUp�C�x���g
Private Sub lstBox_IncrementalSerch_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    If StopEvents Then
        '�C�x���g��~�t���O�����Ă��甲����
        Exit Sub
    End If
    '�C�x���g��~
    StopEvents = True
    '�C���N�������^�����X�g�}�E�X�A�b�v�C�x���g
    clsIncrementalfrmBIN.Incremental_LstBox_Mouse_UP Button
    Select Case Button
    Case vbMouseLeft
        '�}�E�X���N���b�N��������
        '�t�H�[�J�X�ړ��ړI��RS���f�[�^�擾
        getValueFromRS
    End Select
    '�C�x���g�ĊJ
    StopEvents = False
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
    If clsADOfrmBIN.RS Is Nothing Then
        Set clsADOfrmBIN.RS = New ADODB.Recordset
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
#If DebugDB Then
    MsgBox "DebugDB Enable"
#End If
    'divObjToField��ݒ�
    setDicObjToField
    'clsIncrementalSerch�R���X�g���N�^
    clsIncrementalfrmBIN.ConstRuctor Me, dicObjNameToFieldName, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc
    If chkBox_SelectNewData.Value Then
        '�N�����ŐV�f�[�^�I���t���O�������Ă����烊�X�g�̈�ԉ���I������
        lstBoxEndDay.ListIndex = lstBoxEndDay.ListCount - 1
    End If
    Exit Sub
End Sub
'�t�H�[���I�����Ɏ��s����v���V�[�W��
Private Sub Destractor()
    '�����o�ϐ��̉��
    If Not clsADOfrmBIN.RS Is Nothing Then
        If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����J���Ă��������
            clsADOfrmBIN.RS.Close
        End If
        Set clsADOfrmBIN.RS = Nothing
    End If
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
        objExcelFrmBIN.Quit
        Set objExcelFrmBIN = Nothing
    End If
    If Not dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = Nothing
    End If
    If Not clsIncrementalfrmBIN Is Nothing Then
        Set clsIncrementalfrmBIN = Nothing
    End If
    If Not confrmBIN Is Nothing Then
        If confrmBIN.State And ObjectStateEnum.adStateOpen Then
            'open�t���O�������Ă��������
            confrmBIN.Close
        End If
        Set confrmBIN = Nothing
    End If
    Me.Hide
    Unload Me
    Exit Sub
End Sub
'''dicObjToField�ɑ��݂���R���g���[���̓��e���������Ă���
'''args
'''strargExceptControlName  �I�v�V�����A�w�肳�ꂽName�̃I�u�W�F�N�g�̂͏������Ȃ�
Private Sub ClearAllContents(Optional strargExceptControlName As String)
    '�C�x���g��~����
    StopEvents = True
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
    '��������������C�x���g�ĊJ����
    StopEvents = False
End Sub
'''RS���e�R���g���[���֒l���Z�b�g����
'''args
'''NotMoveFocus     True�ɃZ�b�g����ƍŌ�̃t�H�[�J�X�ړ������Ȃ�
Private Sub getValueFromRS(Optional NotMoveFocus As Boolean = False)
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    '�ŏ��ɑS���ڃN���A
    Select Case True
    Case clsIncrementalfrmBIN.txtBoxRef Is Nothing
        '�C���N�������^���T�[�`�̃e�L�X�g�{�b�N�X�Q�Ƃ�Nothing�������ꍇ
        ClearAllContents
    Case Else
        '�C���N�������^���T�[�`�̃e�L�X�g�{�b�N�X�Q�Ƃ����݂��Ă����ꍇ
        '�C���N�������^���T�[�`���̃e�L�X�g�{�b�N�X�͏������Ȃ�
        ClearAllContents clsIncrementalfrmBIN.txtBoxRef.Name
    End Select
    'txtBox_F_CSV_No
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_No.Name)).Value) Then
'    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_No.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_No.Text = ""
    Else
        txtBox_F_CSV_No.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_No.Name)).Value
    End If
    'txtBox_F_CSV_Tana_Local_Text
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Tana_Local_Text.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_Tana_Local_Text.Text = ""
    Else
        txtBox_F_CSV_Tana_Local_Text.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Tana_Local_Text.Name)).Value
    End If
    'txtBox_F_CSV_Tehai_Code
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Tehai_Code.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_Tehai_Code.Text = ""
    Else
        txtBox_F_CSV_Tehai_Code.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Tehai_Code.Name)).Value
    End If
    'txtBox_F_CSV_DB_Amount
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_DB_Amount.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_DB_Amount.Text = ""
    Else
        txtBox_F_CSV_DB_Amount.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_DB_Amount.Name)).Value
    End If
    'txtBox_F_CSV_BIN_Amount
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_BIN_Amount.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_BIN_Amount.Text = ""
    Else
        txtBox_F_CSV_BIN_Amount.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_BIN_Amount.Name)).Value
    End If
    'txtBox_F_CSV_Real_Amount
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Real_Amount.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_Real_Amount.Text = ""
    Else
        txtBox_F_CSV_Real_Amount.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Real_Amount.Name)).Value
    End If
    'txtBox_F_CSV_System_Name
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_System_Name.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_System_Name.Text = ""
    Else
        txtBox_F_CSV_System_Name.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_System_Name.Name)).Value
    End If
    'txtBox_F_CSV_System_Spac
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_System_Spac.Name)).Value) Then
        'Null�������ꍇ
        txtBox_F_CSV_System_Spac.Text = ""
    Else
        txtBox_F_CSV_System_Spac.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_System_Spac.Name)).Value
    End If
    '�X�e�[�^�X�`�F�b�N
    StatusCheck
    'RS���Status���擾
    Dim longStatusValue As Long
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value) Then
        'Null�������ꍇ
        longStatusValue = 0
    Else
        longStatusValue = CLng(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value)
    End If
    '�C�x���g��~
    StopEvents = True
    '���݂̃��R�[�h����CurrentRecord���x���ɐݒ�
    lbl_CurrentAmount.Caption = CStr(clsADOfrmBIN.GetRecordCountFromRS(clsADOfrmBIN.RS))
    '�p�[�Z���g���x���X�V
    lbl_PerCent.Caption = Format(CSng(lbl_CurrentAmount.Caption) / CSng(lbl_TotalAmount.Caption), "0%")
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
    DebugMsgWithTime "getValueFromRS code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
Private Sub StatusCheck()
    On Error GoTo ErrorCatch
    '�܂�RS����Status�̐��l���󂯎��
    Dim longStatusValue As Long
    If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value) Then
        'Null�������ꍇ
        longStatusValue = 0
    Else
        longStatusValue = CLng(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value)
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
    DebugMsgWithTime "StatusCheck code: " & Err.Number & " Description: " & Err.Description
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
    DebugMsgWithTime "setEndDayList code: " & Err.Number & " Description: " & Err.Description
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
    '�I�ԃ��[�J���e�L�X�g�t�B���^
    dicObjNameToFieldName.Add txtBox_Filter_F_CSV_Tana_Local_Text.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Location_Text_ICS), clsEnumfrmBIN)
    dicObjNameToFieldName.Add txtBox_F_CSV_Tehai_Code.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Tehai_Code_ICS), clsEnumfrmBIN)
    '��z�R�[�h�t�B���^
    dicObjNameToFieldName.Add txtBox_Filter_F_CSV_Tehai_Code.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(TanaCSV_Alias_sia, clsEnumfrmBIN.CSVTanafield(F_Tehai_Code_ICS), clsEnumfrmBIN)
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
    DebugMsgWithTime "dicObjNameToFieldName code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''�f�t�H���g(�t�B���^�|����O�j��Select���ʂ�RS�ɓ����
'''Retrun bool ����������True�A����ȊO��false
'''args
'''strargEndDay        ���ؓ���10����
'''strargAditionalWhere �ǉ���Where������String�Ŏw��
Private Function setDefaultDatatoRS(strargEndDay As String, Optional strargAditionalWhere As String) As Boolean
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
    If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateConnecting Then
        '�ڑ�����Ă������U�ؒf����
        clsADOfrmBIN.RS.Close
    End If
    If confrmBIN.State And ObjectStateEnum.adStateOpen Then
        'connection���J���Ă�����ڑ������
        confrmBIN.Close
    End If
    'Connection�I�u�W�F�N�g�̐ݒ���s��
    confrmBIN.ConnectionString = clsADOfrmBIN.CreateConnectionString(clsADOfrmBIN.DBPath, clsADOfrmBIN.DBFileName)
    confrmBIN.Mode = adModeReadWrite Or adModeShareDenyNone
    '���R�[�h�Z�b�g��Source�Ƃ���clADO��SQL��ݒ肷��
    clsADOfrmBIN.RS.Source = clsADOfrmBIN.SQL
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
        Set clsADOfrmBIN.RS.ActiveConnection = confrmBIN
        '���R�[�h�Z�b�g��r���I���b�N�ŊJ��(CursorLocation��Cliant�̎��͋��L�I���b�N�ł����J���Ȃ�)
        clsADOfrmBIN.RS.LockType = adLockPessimistic
        '���I�J�[�\���ɂ��A�ق��̐l���s�����ύX�͌���邪�A�ǉ����͌���Ȃ��J�[�\���^�C�v�ɂ���
        'CursorLocation��Server�ɂȂ�̂ŁARecordCount�͎g���Ȃ��Ȃ�
        clsADOfrmBIN.RS.CursorLocation = adUseServer
        clsADOfrmBIN.RS.CursorType = adOpenDynamic
        clsADOfrmBIN.RS.Open , , , , CommandTypeEnum.adCmdText
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
        Set clsADOfrmBIN.RS.ActiveConnection = confrmBIN
        '���b�N�^�C�v���o�b�`�X�V���[�h�ɂ���
        clsADOfrmBIN.RS.LockType = adLockBatchOptimistic
        '���I�J�[�\���ɂ��A���̐l���s�����ύX�������J�[�\���^�C�v�ɂ���
        clsADOfrmBIN.RS.CursorLocation = adUseClient
        'CursorLocation��Cliant�̎��̓J�[�\���^�C�v�̓X�^�e�B�b�N��FowerdOnly�����I�ׂȂ��E�E�̂��ȁH
        clsADOfrmBIN.RS.CursorType = adOpenStatic
        clsADOfrmBIN.RS.Open , , , , CommandTypeEnum.adCmdText
        '�o�^�{�^����L����
        btnDoUpdate.Enabled = True
    End Select
    'Filter�Ƃ���adFilterFetchedRecords���Z�b�g���Ă��A�t�F�b�`�ς݂̍s�����ɂ���
    clsADOfrmBIN.RS.Filter = adFilterFetchedRecords
    '������BOF�AEOF������True�ɂȂ��Ă���擾���s���Ă���
    If clsADOfrmBIN.RS.BOF And clsADOfrmBIN.RS.EOF Then
        '�擾���s(0��)
        setDefaultDatatoRS = False
        GoTo CloseAndExit
    Else
        '�擾����
        '�t�B���^�������A�ŏ��̃��R�[�h�Ɉړ�
        clsADOfrmBIN.RS.Filter = adFilterNone
        clsADOfrmBIN.RS.MoveFirst
        setDefaultDatatoRS = True
        GoTo CloseAndExit
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "setDefaultDataToRS code: " & Err.Number & " Description: " & Err.Description
    setDefaultDatatoRS = False
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''���R�[�h�ړ�
'''args
'''argKeyCode   KeyCode ���Ȃ玟�ցA���Ȃ�O��
Private Sub MoveRecord(argKeyCode As Integer)
    On Error GoTo ErrorCatch
    If clsADOfrmBIN.RS.State = ObjectStateEnum.adStateClosed Then
        'RS�����Ă����牽�������ɔ�����
        DebugMsgWithTime "MoveRecord : RS not open"
        GoTo CloseAndExit
        Exit Sub
    End If
    Do While clsADOfrmBIN.RS.State And (ObjectStateEnum.adStateConnecting Or ObjectStateEnum.adStateExecuting Or ObjectStateEnum.adStateFetching)
        'RS�ō�ƒ��͑ҋ@����
        DebugMsgWithTime "MoveRecord : RS Busy.wait 300 millisec"
        Sleep 300
    Loop
    Select Case argKeyCode
    Case vbKeyRight
        '�E�̏ꍇ�A����
        '�Ƃ肠����MoveNext����
        clsADOfrmBIN.RS.MoveNext
        'EOF�̏�Ԃ��m�F
        If clsADOfrmBIN.RS.EOF Then
            '�ړ��O���ŏI���R�[�h�������ꍇ
            MsgBox "���݂̃��R�[�h���ŏI���R�[�h�ł�"
            clsADOfrmBIN.RS.MovePrevious
            GoTo CloseAndExit
        End If
    Case vbKeyLeft
        '���̏ꍇ�A�O��
        '�Ƃ肠����MovePrevious����
        clsADOfrmBIN.RS.MovePrevious
        'BOF�̏�Ԃ��m�F
        If clsADOfrmBIN.RS.BOF Then
            '�ړ��O���ŏ��̃��R�[�h������
            MsgBox "���݂̃��R�[�h���擪���R�[�h�ł�"
            clsADOfrmBIN.RS.MoveNext
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
    DebugMsgWithTime "MoveRecord code: " & Err.Number & " Description: " & Err.Description
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
    '�C�x���g��~����
    StopEvents = True
    Select Case argTxtBox.Text
    Case ""
        '�󔒂������ꍇ
        'chkBoxNoConfirmDelete�̏�Ԃɂ���Ė₢���킹�����{�A���ʂ��ʂ�΋����폜���[�h��Update���\�b�h���Ăяo��
        If Not chkBoxNoConfirmatDelete.Value Then
            '�폜�m�F����̏ꍇ
            Dim lonMsgBoxMSG As Long
            lonMsgBoxMSG = MsgBox("�e�L�X�g�{�b�N�X���󔒂ɂȂ����̂ŁA�Y���̃f�[�^�𖢓��͂ɂ��܂��B��낵���ł����H", vbYesNo)
            If lonMsgBoxMSG = vbNo Then
                '�m�F������No������
                MsgBox "�폜�����𒆒f���܂�"
                '�Y���e�L�X�g�{�b�N�X�̒l��RS�ɕۑ�����Ă���l�ɕ�������
                If Not IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, argTxtBox.Name)).Value) Then
                    argTxtBox.Text = clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, argTxtBox.Name)).Value
                End If
                Exit Sub
            End If
        End If
        UpdateSpecificField argTxtBox, True
    Case Else
        '�ʏ퓮��͂�����
        If Not IsNumeric(argTxtBox.Text) Then
            MsgBox "���͂��ꂽ���������l�Ƃ��ĔF���ł��܂���ł���"
            DebugMsgWithTime "CheckDataAndUpdateDB : cant cast number txtboxname: " & argTxtBox.Name
            GoTo CloseAndExit
        End If
        If clsADOfrmBIN.RS.State = ObjectStateEnum.adStateClosed Then
            'RS�����Ă����牽�������ɔ�����
            DebugMsgWithTime "CheckDataAndUpdateDB : RS not open."
            GoTo CloseAndExit
        End If
        '�e�L�X�g�{�b�N�X�ɓ��͂��ꂽ������RS�̐��l�������������牽�����Ȃ�
        If clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, argTxtBox.Name)).Value = CDbl(argTxtBox.Text) Then
            GoTo CloseAndExit
        End If
        '�t�B�[���h�w���RS�ɓo�^���s
        UpdateSpecificField argTxtBox
    End Select
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
    DebugMsgWithTime "CheckDataAndUpdateDB code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'''�w�肳�ꂽ�R���g���[�����ɑΉ�����RS�Ƀf�[�^��o�^����
'''args
'''argTxtBox    ����Ώۂ̃R���g���[���̎Q��
'''Optional ForceSetNull    True�ɃZ�b�g����Ɩ������Ŏw��t�B�[���h��Null���Z�b�g����i�������[�h�j
Private Sub UpdateSpecificField(ByRef argTxtBox As MSForms.TextBox, Optional ForceSetNull As Boolean = False)
    On Error GoTo ErrorCatch
    Select Case ForceSetNull
    Case True
        '����Null�Z�b�g���[�h�͂�����
        '�Ή�����RS��Null���Z�b�g����
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, argTxtBox.Name)).Value = Null
        GoTo CloseAndExit
    Case False
        '�ʏ퓮��͂�����
        If argTxtBox.Text = "" Then
            '�Ώۂ̃e�L�X�g���󔒂������牽�������ɔ�����
            GoTo CloseAndExit
            Exit Sub
        End If
        'RS�̒l�ƈ���Ă�����Ή�����RS�ɒl���Z�b�g����
        If IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, argTxtBox.Name)).Value) Or clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, argTxtBox.Name)).Value <> CDbl(argTxtBox.Text) Then
            'Value��Null���A�e�L�X�g�{�b�N�X�̐��l�ƈ���Ă����ꍇ
            clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, argTxtBox.Name)).Value = _
            CDbl(argTxtBox.Text)
        End If
        GoTo CloseAndExit
    End Select
ErrorCatch:
    DebugMsgWithTime "UpdateSpecificField code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'RS��̐��l��]�����A�t���O�̏グ�������s���ARS�ɓo�^����
'RS�Ƀe�L�X�g�{�b�N�X�̐��l�𔽉f��������Ɏ��s����(DB�o�^�G���[�̃��X�N�����炵����)
Private Sub ChekStatusAndSetFlag()
    On Error GoTo ErrorCatch
'    If clsADOfrmBIN.RS.EditMode = adEditNone Then
'        'RS�ɕύX���Ȃ��Ƃ��͉������Ȃ�
'        GoTo CloseAndExit
'    End If
    'BinCard
    'Select Case �� Case�̓V���[�g�T�[�L�b�g�ɂȂ邱�Ƃ𗘗p
    Select Case True
    Case IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_BIN_Amount.Name)).Value)
        'Null�������ꍇ
        'Bin �� Input �� DataOK�t���O���܂Ƃ߂ė��Ƃ�
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value And Not (Enum_frmBIN_Status.BINDataOK Or Enum_frmBIN_Status.BINInput)
    Case Not IsNumeric(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_BIN_Amount.Name)).Value)
        '���l�Ƃ��ĔF������Ȃ��ꍇ
        'Bin �� Input �� DataOK�t���O���܂Ƃ߂ė��Ƃ�
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value And Not (Enum_frmBIN_Status.BINDataOK Or Enum_frmBIN_Status.BINInput)
    Case CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_BIN_Amount.Name)).Value) = _
        CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_DB_Amount.Name)).Value)
        'RS���BIN�J�[�h�c���ƃV�[�g�c������v�����ꍇ
        'BIN DataOK�t���O��Bin Input�t���O�𗼕����Ă�(���͂��ĂȂ���OK�ɂȂ�Ȃ��O��)
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value Or Enum_frmBIN_Status.BINDataOK Or Enum_frmBIN_Status.BINInput
    Case CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_BIN_Amount.Name)).Value) <> _
        CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_DB_Amount.Name)).Value)
        'BIN�c���ƃV�X�e���c������v���Ȃ������ꍇ
        'Bin Input�t���O�𗧂ĂāABI OK�t���O�𗎂Ƃ�
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        (clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value Or Enum_frmBIN_Status.BINInput) And Not Enum_frmBIN_Status.BINDataOK
    End Select
    'RealAmount
    'Select Case �� Case�̓V���[�g�T�[�L�b�g�ɂȂ邱�Ƃ𗘗p
    Select Case True
    Case IsNull(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Real_Amount.Name)).Value)
        'Null�������ꍇ
        'Real �� input �� DataOK�����܂Ƃ߂ė��Ƃ�
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value And Not (Enum_frmBIN_Status.RealDataOK Or Enum_frmBIN_Status.RealInput)
    Case Not IsNumeric(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Real_Amount.Name)).Value)
        '���l�Ƃ��ĔF������Ȃ��ꍇ
        'Real �� input �� DataOK�����܂Ƃ߂ė��Ƃ�
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value And Not (Enum_frmBIN_Status.RealDataOK Or Enum_frmBIN_Status.RealInput)
    Case CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Real_Amount.Name)).Value) = _
        CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_DB_Amount.Name)).Value)
        'RS���BIN�J�[�h�c���ƃV�[�g�c������v�����ꍇ
        'Real DataOK�t���O��Real Input�t���O�𗼕����Ă�(���͂��ĂȂ���OK�ɂȂ�Ȃ��O��)
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value Or Enum_frmBIN_Status.RealDataOK Or Enum_frmBIN_Status.RealInput
    Case CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_Real_Amount.Name)).Value) <> _
        CDbl(clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, txtBox_F_CSV_DB_Amount.Name)).Value)
        '���i�c�ƃV�X�e����̎c������v���Ȃ������ꍇ
        'Real Input�t���O�𗧂ĂāAReal OK�t���O�𗎂Ƃ�
        clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value = _
        (clsADOfrmBIN.RS.Fields(clsSQLBc.RepDotField(dicObjNameToFieldName, clsEnumfrmBIN.CSVTanafield(F_Status_ICS))).Value Or Enum_frmBIN_Status.RealInput) And Not RealDataOK
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "ChekStatusAndSetFlag code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''RS�̓��e��DB��Update����
'''Return bool ����������True�A����ȊO��False
Private Function UpdateDBfromRS() As Boolean
    On Error GoTo ErrorCatch
    If clsADOfrmBIN.RS.EditMode = adEditNone Then
        '�ύX���Ȃ������ꍇ
        '���������ɔ�����
        DebugMsgWithTime "UpdateDBfromRS : No data changed. Do nothing"
        UpdateDBfromRS = True
        GoTo CloseAndExit
        Exit Function
    End If
    '�ڑ��󋵂𒲂ׁA�ڑ����ĂȂ�������ڑ�����
    If Not clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
        'RS�����ڑ�������
        '�X��Connection�I�u�W�F�N�g�̐ڑ��󋵂����ׂ�
        If Not confrmBIN.State And ObjectStateEnum.adStateOpen Then
            'Connection�����ڑ�������
            confrmBIN.Open
        End If
        Set clsADOfrmBIN.RS.ActiveConnection = confrmBIN
    End If
    'Update���s����
    clsADOfrmBIN.RS.Update
    If chkBoxUpdateASAP.Value Then
        '�����X�V���[�h�̎��́A�X�V��������܂őҋ@����
        Do Until clsADOfrmBIN.RS.EditMode = adEditNone
            DebugMsgWithTime "UpdateDBfromRS : RS is busy.wait 100 millisec"
            Sleep 100
        Loop
    End If
    '�R�}���h���s�����܂őҋ@����
    Do While clsADOfrmBIN.RS.State And (ObjectStateEnum.adStateConnecting Or ObjectStateEnum.adStateExecuting Or ObjectStateEnum.adStateFetching)
        DebugMsgWithTime "UpdateDBfromRS : RS is busy.wait 100 millisec"
        Sleep 100
    Loop
    UpdateDBfromRS = True
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "UpdateDBfromRS code: " & Err.Number & " Description: " & Err.Description
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
    If argSouceCtrl Is Nothing Then
        DebugMsgWithTime "AditionalWhereFilter : arg ctrl Nothing"
        GoTo CloseAndExit
    End If
    '�C���N�������^�����X�g���\���ɂ���
    If lstBox_IncrementalSerch.ListCount >= 2 Then
        lstBox_IncrementalSerch.Visible = False
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
    '��URS�̃t�B���^�[����������
    clsADOfrmBIN.RS.Filter = adFilterNone
    '�w�肵�������ŏ������w�肵�A�匳�̃f�[�^���X�V���Ă��
    Dim isCollect As Boolean
    isCollect = setDefaultDatatoRS(lstBoxEndDay.List(lstBoxEndDay.ListIndex), Join(strarrAddWhere, " AND "))
    If Not isCollect Then
        MsgBox "�w������œK�����郌�R�[�h������܂���ł����B�i�荞�ݏ��������ɖ߂��A�f�[�^�Ď擾���܂��B"
        '�C�x���g��~
        StopEvents = True
        '�����ݒ�R���g���[���̏�Ԃ��o���邾�����ɖ߂�
        '�Ăяo�����̃R���g���[���̎�ނɂ�菈���𕪊�
        Select Case TypeName(argSouceCtrl)
        Case "TextBox"
            '�e�L�X�g�{�b�N�X������
            '���X�̒�����Len -1 ��������擾
            If argSouceCtrl.TextLength > 1 Then
                '�e�L�X�g�{�b�N�X�̕�������1���傫���ꍇ�ɂ̂ݎ��s
                argSouceCtrl.Text = Mid(argSouceCtrl.Text, 1, Len(argSouceCtrl.Text) - 1)
            Else
                '��������1�ȉ��������ꍇ�́A�Y���e�L�X�g�{�b�N�X�̕�������������
                argSouceCtrl.Text = ""
            End If
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
'        '�t�H�[�J�X�ړ�������RS����f�[�^�擾
'        getValueFromRS True
        '�C�x���g�ĊJ
        StopEvents = False
        GoTo CloseAndExit
    End If
    '�����������ۂ�
    '�C�x���g��~
    StopEvents = True
    'RS���擾����f�[�^�S�N���A
    ClearAllContents argSouceCtrl.Name
    'RS����l�擾�A�\��
    getValueFromRS True
    '�C�x���g�ĊJ
    StopEvents = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "AditionalWhereFilter code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Set dicReplaceAddWhere = Nothing
    Exit Sub
End Sub
'''BIN�J�[�h�c���A���i�c���p�����f�[�^����p������
Private Sub InheritAmount()
    On Error GoTo ErrorCatch
    If lstBoxEndDay.ListCount < 2 Then
        '���ؓ��f�[�^��2�����������甲����
        MsgBox "�I�����ؓ��̃f�[�^��1��ވȉ��ł��B�p�����̃f�[�^�ƌp����̃f�[�^��o�^���Ă�����s���Ă�������"
        GoTo CloseAndExit
    End If
    If lstBoxEndDay.ListIndex = -1 Then
        '���X�g�I������Ă��Ȃ������甲����
        MsgBox "�p����(�V�����f�[�^)��I�����Ă�����s���Ă�������"
        GoTo CloseAndExit
    End If
    '���s���Ă������ǂ����₢���킹
    Dim longMsgBoxReturn As Long
    longMsgBoxReturn = MsgBox("���s����ƑΏۂ� " & lstBoxEndDay.List(lstBoxEndDay.ListIndex) & " �̃f�[�^�͏㏑������܂����A��낵���ł����H", vbYesNo)
    If longMsgBoxReturn = vbNo Then
        '�₢���킹��No�ƌ���ꂽ
        MsgBox "�L�����Z�����܂���"
        GoTo CloseAndExit
    End If
    'OriginEndDay�����o�ϐ�������
    frmTanaBincard.strOriginEndDay = ""
    'frmSelectOriginEndDay Load
    Load frmSelectOriginEndDay
    '�p����I���t�H�[���̐ݒ�A�\��
    Dim longEndDayRowCount As Long
    'lstBoxEndDay���[�v
    For longEndDayRowCount = LBound(lstBoxEndDay.List) To UBound(lstBoxEndDay.List)
        If Not longEndDayRowCount = lstBoxEndDay.ListIndex Then
            '���ݑI������Ă��鍀�ڂƈ�����ꍇ��OriginEndDay�̃R���{�{�b�N�X�ɒǉ�����
            frmSelectOriginEndDay.cmbBoxOriginEndDay.AddItem lstBoxEndDay.List(longEndDayRowCount)
        End If
    Next longEndDayRowCount
    'SelectOriginEndDay�t�H�[�����[�_���\���A���ʊm�肵���珟���Unload���Ė߂��Ă���͂�
    frmSelectOriginEndDay.Show
    If frmTanaBincard.strOriginEndDay = "" Then
        '�����o�ϐ����󕶎��������甲����
        MsgBox "�p�������ؓ��̑I���Ɏ��s���܂���"
        GoTo CloseAndExit
    End If
    'SQL�̑g���ɓ���
''{0}    T_INV_CSV
''{1}    T_Dst
''{2}    ���P�[�V����
''{3}    �I�����ؓ�
''{4}    (Origin EndDay)
''{5}    T_Orig
''{6}    ��z�R�[�h
''{7}    F_CSV_BIN_Amount
''{8}    ���i�c
''{9}    (Dst EndDay)
'Private Const CSV_SQL_INHERIT_AMOUNT As String = "UPDATE {0} AS {1} " & vbCrLf
    Dim dicReplaceInherit As Dictionary
    Set dicReplaceInherit = New Dictionary
    dicReplaceInherit.RemoveAll
    dicReplaceInherit.Add 0, INV_CONST.T_INV_CSV
    dicReplaceInherit.Add 1, clsEnumfrmBIN.SQL_INV_Alias(DstTable_sia)
    dicReplaceInherit.Add 2, clsEnumfrmBIN.CSVTanafield(F_Location_Text_ICS)
    dicReplaceInherit.Add 3, clsEnumfrmBIN.CSVTanafield(F_EndDay_ICS)
    dicReplaceInherit.Add 4, frmTanaBincard.strOriginEndDay
    dicReplaceInherit.Add 5, clsEnumfrmBIN.SQL_INV_Alias(OriginTable_sia)
    dicReplaceInherit.Add 6, clsEnumfrmBIN.CSVTanafield(F_Tehai_Code_ICS)
    dicReplaceInherit.Add 7, clsEnumfrmBIN.CSVTanafield(F_Bin_Amount_ICS)
    dicReplaceInherit.Add 8, clsEnumfrmBIN.CSVTanafield(F_Available_ICS)
    dicReplaceInherit.Add 9, lstBoxEndDay.List(lstBoxEndDay.ListIndex)
    '�C�x���g��~����
    StopEvents = True
    '�t�H�[�����LRS��Open���Ă���Close����
    If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
        clsADOfrmBIN.RS.Close
    End If
    'clsAdo��P�Ǝw�肷��
    Dim clsAdoInherit As clsADOHandle
    Set clsAdoInherit = CreateclsADOHandleInstance
    'DBPath,DBFilename���f�t�H���g��
    clsAdoInherit.SetDBPathandFilenameDefault
    'Replace���s�ASQL�ݒ�
    clsAdoInherit.SQL = clsSQLBc.ReplaceParm(CSV_SQL_INHERIT_AMOUNT, dicReplaceInherit)
    Dim isCollect As Boolean
    'Write�t���O�グ��
    clsAdoInherit.ConnectMode = clsAdoInherit.ConnectMode Or adModeWrite
    'SQL���s
    isCollect = clsAdoInherit.Do_SQL_with_NO_Transaction
    'Wite�t���O������
    clsAdoInherit.ConnectMode = clsAdoInherit.ConnectMode And Not adModeWrite
    'clsADO�ؒf
    clsAdoInherit.CloseClassConnection
    If Not isCollect Then
        MsgBox "�p��SQL���s����ۂɃG���[���������܂����B"
        GoTo CloseAndExit
    End If
    '�����܂ł�DB�X�V�͊������Ă��邪�AStatus�͎������f����Ȃ��̂�EndDay���X�g��Click�C�x���g������������StatusSet���Ă��
    '���݂�lstboxEndDay��ListIndex��ޔ�
    Dim longOldListIndex As Long
    longOldListIndex = lstBoxEndDay.ListIndex
    '��UEndDay�̑I��������
    lstBoxEndDay.ListIndex = -1
    '�C�x���g�ĊJ
    StopEvents = False
    'lstBoxEndDay��Lisindex�𕜌�(Click�C�x���g�������ăf�[�^���ɍs���͂�)
    lstBoxEndDay.ListIndex = longOldListIndex
    '�S���R�[�h��Status�X�V
    SetRsAllStatus
    MsgBox "�p������I�����܂���"
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "InheritAmount code: " & Err.Number & " Descriptoin: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsAdoInherit Is Nothing Then
        clsAdoInherit.CloseClassConnection
        Set clsAdoInherit = Nothing
    End If
    Exit Sub
End Sub
'''DB��F_CSV_Status���X�V����
Private Sub SetRsAllStatus()
    On Error GoTo ErrorCatch
    If clsADOfrmBIN.RS.State = ObjectStateEnum.adStateClosed Then
        '�ڑ������Ă����甲����
        DebugMsgWithTime "SetRsAllStatus : RS is closed"
        GoTo CloseAndExit
    End If
    '�C�x���g��~����
    StopEvents = True
    'RS�S���R�[�h���[�v
    clsADOfrmBIN.RS.MoveFirst
    Do
        '�X�e�[�^�X�Z�b�g�v���V�[�W��
        ChekStatusAndSetFlag
        '����̃��[�v��RS���m��
        clsADOfrmBIN.RS.Update
        '���̃��R�[�h��
        clsADOfrmBIN.RS.MoveNext
    Loop While Not clsADOfrmBIN.RS.EOF
    '�S���R�[�h�������I�������adFilterPendingRecords�Ńt�B���^���|���Č��ʂ������UpdateBatch��DB�ɔ��f
    clsADOfrmBIN.RS.Filter = adFilterPendingRecords
    If clsADOfrmBIN.RS.RecordCount >= 1 Then
        '�ύX�������UpdateBatch
        clsADOfrmBIN.RS.UpdateBatch adAffectGroup
        If Not clsADOfrmBIN.RS.Status And ADODB.RecordStatusEnum.adRecUnmodified Then
            '�ύX�Ȃ��t���O�������Ă��Ȃ������烁�b�Z�[�W�o��
            MsgBox "Status�̏�Ԃ�DB�ɓo�^����ۂɃG���[���������܂���"
            GoTo CloseAndExit
        End If
    End If
    clsADOfrmBIN.RS.Filter = adFilterNone
    '�ŏ��̃��R�[�h�ɖ߂�StatusCheck�ŐF���𔽉f�����ďI���
    clsADOfrmBIN.RS.MoveFirst
    '�C�x���g�ĊJ����
    StopEvents = False
    'StatusCheck
    StatusCheck
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "SetRsAllStatus code : " & Err.Number & " Description : " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmBinLabel 
   Caption         =   "BIN�J�[�h���x��������ڕҏW���"
   ClientHeight    =   5895
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8610.001
   OleObjectBlob   =   "frmBinLabel.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmBinLabel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'�t�H�[�������L�ϐ�
Private clsADOfrmBIN As clsADOHandle
Private clsEnumfrmBIN As clsEnum
Private clsSQLBc As clsSQLStringBuilder
Private dicObjNameToFieldName As Dictionary
Private clsIncrementalfrmBIN As clsIncrementalSerch
'�����o�ϐ�
Private rsfrmBIN As ADODB.Recordset
Private confrmBIN As ADODB.Connection
Private StopEvents As Boolean
'�萔
Private Const MAX_LABEL_TEXT_LENGTH As Long = 18
Private Const TXTBOX_BACKCOLORE_EDITABLE As Long = &HC0FFC0         '������
Private Const TXTBOX_BACKCOLORE_NORMAL As Long = &H80000005         '�E�B���h�E�̔w�i
'------------------------------------------------------------------------------------------------------
'SQL
Private Const SQL_BIN_LABEL_DEFAULT_DATA As String = "SELECT TDBPrt.F_INV_Tehai_ID,TDBTana.F_INV_Tana_ID,TDBTana.F_INV_Tana_Local_Text as F_INV_Tana_Local_Text,TDBPrt.F_INV_Tehai_Code as F_INV_Tehai_Code,TDBPrt.F_INV_Label_Name_1 as F_INV_Label_Name_1,TDBPrt.F_INV_Label_Name_2 as F_INV_Label_Name_2,TDBPrt.F_INV_Label_Remark_1 as F_INV_Label_Remark_1,TDBPrt.F_INV_Label_Remark_2 as F_INV_Label_Remark_2" & vbCrLf & _
"FROM T_INV_M_Parts AS TDBPrt " & vbCrLf & _
"    INNER JOIN T_INV_M_Tana as TDBTana " & vbCrLf & _
"    ON TDBPrt.F_INV_Tana_ID = TDBTana.F_INV_Tana_ID"
'------------------------------------------------------------------------------------------------------
'�C�x���g
'Form Initial
Private Sub UserForm_Initialize()
    '�t�H�[����������
    ConstRuctor
End Sub
'Form Terminate
Private Sub UserForm_Terminate()
    Destructor
End Sub
'Click
Private Sub btnMovePrevious_Click()
    '�O�֖߂�
    MoveRecord vbKeyLeft
End Sub
Private Sub btnMoveNext_Click()
    '���֐i��
    MoveRecord vbKeyRight
End Sub
'�ҏW��������
Private Sub btnEnableEdit_Click()
    SwitchtBoxEditmode True
End Sub
'�ŏI�I��DB��Update����
Private Sub btnDoUpdate_Click()
    DoUpdateBatch
End Sub
'Change
'RS�ɒl�Z�b�g����e�L�X�g�{�b�N�X
'�I��
Private Sub txtBox_F_INV_Tana_Local_Text_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
'    If Len(ActiveControl.Text) > MAX_LABEL_TEXT_LENGTH Then
'        MsgBox "�ݒ�\�ȕ�����" & MAX_LABEL_TEXT_LENGTH & " �𒴂��Ă��܂��B"
'        Exit Sub
'    End If
    'Update���\�b�h��
    UpdateRSFromContrl ActiveControl
End Sub
'�i��1
Private Sub txtBox_F_INV_Label_Name_1_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
'    If Len(ActiveControl.Text) > MAX_LABEL_TEXT_LENGTH Then
'        MsgBox "�ݒ�\�ȕ�����" & MAX_LABEL_TEXT_LENGTH & " �𒴂��Ă��܂��B"
'        Exit Sub
'    End If
    'Update���\�b�h��
    UpdateRSFromContrl ActiveControl
End Sub
'�i��2
Private Sub txtBox_F_INV_Label_Name_2_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
'    If Len(ActiveControl.Text) > MAX_LABEL_TEXT_LENGTH Then
'        MsgBox "�ݒ�\�ȕ�����" & MAX_LABEL_TEXT_LENGTH & " �𒴂��Ă��܂��B"
'        Exit Sub
'    End If
    'Update���\�b�h��
    UpdateRSFromContrl ActiveControl
End Sub
'���l1
Private Sub txtBox_F_INV_Label_Remark_1_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
'    If Len(ActiveControl.Text) > MAX_LABEL_TEXT_LENGTH Then
'        MsgBox "�ݒ�\�ȕ�����" & MAX_LABEL_TEXT_LENGTH & " �𒴂��Ă��܂��B"
'        Exit Sub
'    End If
    'Update���\�b�h��
    UpdateRSFromContrl ActiveControl
End Sub
'���l2
Private Sub txtBox_F_INV_Label_Remark_2_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
'    If Len(ActiveControl.Text) > MAX_LABEL_TEXT_LENGTH Then
'        MsgBox "�ݒ�\�ȕ�����" & MAX_LABEL_TEXT_LENGTH & " �𒴂��Ă��܂��B"
'        Exit Sub
'    End If
    'Update���\�b�h��
    UpdateRSFromContrl ActiveControl
End Sub
'��z�R�[�h�t�B���^
Private Sub txtBox_Filter_Tehai_Code_Change()
    If StopEvents Then
        Exit Sub
    End If
    '�C�x���g��~
    StopEvents = True
    If Len(ActiveControl.Text) >= 1 Then
        ActiveControl.Text = UCase(ActiveControl.Text)
    End If
    SetFilter ActiveControl
End Sub
'�I�ԃt�B���^�[
Private Sub txtBox_Filter_Local_Tana_Change()
    If StopEvents Then
        Exit Sub
    End If
    '�C�x���g��~
    StopEvents = True
    If Len(ActiveControl.Text) >= 1 Then
        ActiveControl.Text = UCase(ActiveControl.Text)
    End If
    SetFilter ActiveControl
End Sub
'------------------------------------------------------------------------------------------------------
'���\�b�h
'''�R���X�g���N�^
Private Sub ConstRuctor()
    '�C���X�^���X���L�ϐ��̏�����
    If clsADOfrmBIN Is Nothing Then
        Set clsADOfrmBIN = CreateclsADOHandleInstance
    End If
    If clsEnumfrmBIN Is Nothing Then
        Set clsEnumfrmBIN = CreateclsEnum
    End If
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
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
    '�Ƃ肠�����C�x���g�͒�~��Ԃɂ���
    StopEvents = True
    '����f�[�^�ݒ�
    SetDefaultValuetoRS
    'objToFieldName��ݒ�
    setObjToFieldNameDic
    'RS�̃f�[�^���擾����
    GetValuFromRS
#If DebugDB Then
    MsgBox "DebugDB�L��"
#End If
End Sub
'''�f�X�g���N�^
Private Sub Destructor()
    '�����o�ϐ��̉���A���ɐڑ����֘A���Ă�����̂͏d�_�I��
    If Not clsADOfrmBIN Is Nothing Then
        clsADOfrmBIN.CloseClassConnection
        Set clsADOfrmBIN = Nothing
    End If
    If Not rsfrmBIN Is Nothing Then
        rsfrmBIN.ActiveConnection.Close
'        rsfrmBIN.Close
        Set rsfrmBIN = Nothing
    End If
    If Not confrmBIN Is Nothing Then
        If confrmBIN.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����Ă��������
            confrmBIN.Close
        End If
        Set confrmBIN = Nothing
    End If
End Sub
'''�����o�ϐ���RecordSet�ɏ����f�[�^��ݒ肷��
'''
Private Sub SetDefaultValuetoRS()
    '�ŏ���clsado��DBPath��DBFilname���f�t�H���g��
    clsADOfrmBIN.SetDBPathandFilenameDefault
    '�����ڑ�����Ă�����ؒf����
    If rsfrmBIN.State And ObjectStateEnum.adStateOpen Then
        rsfrmBIN.Close
    End If
    If confrmBIN.State And ObjectStateEnum.adStateOpen Then
        confrmBIN.Close
    End If
    'Connection�̐ݒ������
    confrmBIN.ConnectionString = clsADOfrmBIN.CreateConnectionString(clsADOfrmBIN.DBPath, clsADOfrmBIN.DBFileName)
    confrmBIN.CursorLocation = adUseClient
    confrmBIN.Mode = adModeRead Or adModeShareDenyNone
    '�ڑ��I�[�v��
    confrmBIN.Open
    'RS�̃v���p�e�B��ݒ肵�Ă���
    rsfrmBIN.LockType = adLockBatchOptimistic
    rsfrmBIN.CursorType = adOpenStatic
    'rs��Source��SQL�ݒ�(��Ńp�����[�^�Ή�����)
    rsfrmBIN.Source = SQL_BIN_LABEL_DEFAULT_DATA
    'rs��ActiveConnection��Connection�I�u�W�F�N�g�w��
    Set rsfrmBIN.ActiveConnection = confrmBIN
    'rs�I�[�v��
    rsfrmBIN.Open , , , , CommandTypeEnum.adCmdText
    '�ȉ��͐���ɓ���
    '�X�V�ɕK�v�ȃL�[��̏�񂪁`�E�E�E�������̃e�[�u���̎�L�[��SELECT�̃t�B�[���h�Ɋ܂߂�Ɖ���
'    rsfrmBIN.Fields("F_INV_Label_Name_2").Value = "InputTest"
'    rsfrmBIN.Fields("F_INV_Tana_Local_Text").Value = "K23 A01"
'    rsfrmBIN.Update
'    rsfrmBIN.UpdateBatch
    DebugMsgWithTime "Default Data count: " & rsfrmBIN.RecordCount
End Sub
'dicobjToFieldName�̐ݒ�
Private Sub setObjToFieldNameDic()
    If dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = New Dictionary
    End If
    '�ŏ��ɑS����
    dicObjNameToFieldName.RemoveAll
    '���ڂ�ǉ����Ă���
    '����̓e�[�u�����Ƀt�B�[���h�����Ɨ����Ă���̂ŁA�e�[�u���v���t�B�b�N�X�͖�����RS�Ŋi�[���Ă���
    dicObjNameToFieldName.Add txtBox_F_INV_Tana_Local_Text.Name, clsEnumfrmBIN.INVMasterTana(F_INV_Tana_Local_Text_IMT)
    dicObjNameToFieldName.Add txtBox_F_INV_Tehai_Code.Name, clsEnumfrmBIN.INVMasterParts(F_Tehai_Code_IMPrt)
    dicObjNameToFieldName.Add txtBox_F_INV_Label_Name_1.Name, clsEnumfrmBIN.INVMasterParts(F_Label_Name_1_IMPrt)
    dicObjNameToFieldName.Add txtBox_F_INV_Label_Name_2.Name, clsEnumfrmBIN.INVMasterParts(F_Label_Name_2_IMPrt)
    dicObjNameToFieldName.Add txtBox_F_INV_Label_Remark_1.Name, clsEnumfrmBIN.INVMasterParts(F_Label_Remark_1_IMPrt)
    dicObjNameToFieldName.Add txtBox_F_INV_Label_Remark_2.Name, clsEnumfrmBIN.INVMasterParts(F_Label_Remark_2_IMPrt)
End Sub
'cidObjToField�ɂ���R���g���[���̒l�����ׂď�������
Private Sub ClearAllContents()
    Dim varKeyobjDic As Variant
    'dicObjtoField���[�v
    For Each varKeyobjDic In dicObjNameToFieldName
        Select Case TypeName(Me.Controls(varKeyobjDic))
        Case "TextBox"
            'TextBox��������
            Me.Controls(varKeyobjDic).Text = ""
        Case "Label"
            'Label��������
            Me.Controls(varKeyobjDic).Caption = ""
        End Select
    Next varKeyobjDic
End Sub
'RS����l���Ƃ��Ă���
Private Sub GetValuFromRS()
    On Error GoTo ErrorCatch
    If rsfrmBIN.EOF And rsfrmBIN.BOF Then
            'BOF��EOF���������ɗ����Ă����烌�R�[�h�������̂Ŕ�����
        Exit Sub
    End If
    '�C�x���g��~
    StopEvents = True
    '��U�S���ڏ���
    ClearAllContents
    Dim varKeyobjDic As Variant
    'dicObjtoField�����[�v
    For Each varKeyobjDic In dicObjNameToFieldName
        Select Case True
        Case IsNull(rsfrmBIN.Fields(dicObjNameToFieldName(varKeyobjDic)).Value)
            'Null�������ꍇ
            '�Ƃ肠�����󕶎��ɂ���
            Select Case TypeName(Me.Controls(varKeyobjDic))
            Case "TextBox"
                '�e�L�X�g�{�b�N�X��������
                Me.Controls(varKeyobjDic).Text = ""
            Case "Label"
                '���x��������
                Me.Controls(varKeyobjDic).Caption = ""
            End Select
        Case Else
            '�f�[�^���������ꍇ
            'RS�̃f�[�^�����̂܂ܓK�p����
            Select Case TypeName(Me.Controls(varKeyobjDic))
            Case "TextBox"
                '�e�L�X�g�{�b�N�X
                Me.Controls(varKeyobjDic).Text = rsfrmBIN.Fields(dicObjNameToFieldName(varKeyobjDic)).Value
            Case "Label"
                '���x��
                Me.Controls(varKeyobjDic).Caption = rsfrmBIN.Fields(dicObjNameToFieldName(varKeyobjDic)).Value
            End Select
        End Select
    Next varKeyobjDic
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "GetValuFromRS code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ
    StopEvents = False
    Exit Sub
End Sub
'''���R�[�h��i�񂾂�߂����肷��
'''args
'''intargKeyCode    ��{�̓L�[����ɂ���A���Ŏ��ցA���őO��
Private Sub MoveRecord(intargKeyCode As Integer)
    If rsfrmBIN.BOF And rsfrmBIN.EOF Then
        'BOF��EOF���������Ă��甲����
    End If
    '�C�x���g��~����
    StopEvents = True
    Select Case intargKeyCode
    Case vbKeyRight
        '�E�A����
        rsfrmBIN.MoveNext
        If rsfrmBIN.EOF Then
            MsgBox "���݂̃��R�[�h���ŏI���R�[�h�ł�"
            rsfrmBIN.MovePrevious
        End If
    Case vbKeyLeft
        '���A�O��
        rsfrmBIN.MovePrevious
        If rsfrmBIN.BOF Then
            MsgBox "���݂̃��R�[�h���擪���R�[�h�ł�"
            rsfrmBIN.MoveNext
        End If
    End Select
    '�l�̎擾������
    GetValuFromRS
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "MoveRecord code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'�t�B���^�e�L�X�g�{�b�N�X��Change�C�x���g������������RS��Filter�ݒ肵�Ă��
Private Sub SetFilter(ByRef argCtrl As Control)
    If rsfrmBIN.BOF And rsfrmBIN.EOF Then
        'RS�ɒ��g�����������甲����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    Select Case argCtrl.Text
    Case ""
        '�󔒂�������AFilter��adFilterNon���Z�b�g���ăt�B���^���N���A����
        rsfrmBIN.Filter = adFilterNone
        '�l�擾����
        GetValuFromRS
    Case Else
        '�������當���񂪓����Ă���ALike �`%�Ƃ����������őO����v�ŏ�����g��
        Dim strFilter(3) As String
        Select Case argCtrl.Name
        Case txtBox_Filter_Local_Tana.Name
            '�I�Ԃ������ꍇ
            strFilter(0) = dicObjNameToFieldName(txtBox_F_INV_Tana_Local_Text.Name)
        Case txtBox_Filter_Tehai_Code.Name
            '��z�R�[�h�������ꍇ
            strFilter(0) = dicObjNameToFieldName(txtBox_F_INV_Tehai_Code.Name)
        End Select
        '���ʕ����𖄂߂Ă���
        strFilter(1) = " LIKE '"
        strFilter(2) = argCtrl.Text
        '�Ō�Ƀ��C���h�J�[�h�t�^
        strFilter(3) = "%'"
        'Filter�Z�b�g
        rsfrmBIN.Filter = Join(strFilter, "")
        '�l�擾����
        GetValuFromRS
    End Select
    '���R�[�h��0��������񍐂���
    If rsfrmBIN.BOF And rsfrmBIN.EOF Then
        MsgBox "���݂̎w������ł͊Y�����郌�R�[�h������܂���"
        '��U�t�B���^��������
        rsfrmBIN.Filter = adFilterNone
        '�e�L�X�g�{�b�N�X�̕������ɂ�菈���𕪊�
        '�C�x���g�ĊJ
        StopEvents = False
        Select Case Len(argCtrl.Text)
        Case Is = 1
            '1�����ڂŃ_����������e�L�X�g��S����
            argCtrl.Text = ""
        Case Is >= 2
            '2�����ȏ゠������t�B���^������1�������炵�čăZ�b�g
            argCtrl.Text = Mid(argCtrl.Text, 1, Len(argCtrl.Text) - 1)
        End Select
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "SetFilter code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'''�e�L�X�g�{�b�N�X�̕ҏW�\��Ԃ�؂�ւ���
'''args
'''Editable     True�ɃZ�b�g����ƕύX�\�ɁAFalse�ŕύX�s�ɂ���
Private Sub SwitchtBoxEditmode(Editable As Boolean)
    Select Case Editable
    Case True
        '�ҏW�\�ɂ���Ƃ�
        btnDoUpdate.Enabled = True
        'Locked��False�ɂ��āABackColore�𔖗΂ɂ���
        txtBox_F_INV_Tana_Local_Text.Locked = False
        txtBox_F_INV_Tana_Local_Text.BackColor = TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Name_1.Locked = False
        txtBox_F_INV_Label_Name_1.BackColor = TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Name_2.Locked = False
        txtBox_F_INV_Label_Name_2.BackColor = TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Remark_1.Locked = False
        txtBox_F_INV_Label_Remark_1.BackColor = TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Remark_2.Locked = False
        txtBox_F_INV_Label_Remark_2.BackColor = TXTBOX_BACKCOLORE_EDITABLE
        '�ҏW�\�ݒ�{�^���𖳌���
        btnEnableEdit.Enabled = False
    Case False
        '�ҏW�s�ɂ���Ƃ�
        'UpdateBatck�{�^����False��
        btnDoUpdate.Enabled = False
        'Locked��True�ɂ��āABackColore��W���w�i�F�ɂ���
        txtBox_F_INV_Tana_Local_Text.Locked = True
        txtBox_F_INV_Tana_Local_Text.BackColor = TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Name_1.Locked = True
        txtBox_F_INV_Label_Name_1.BackColor = TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Name_2.Locked = True
        txtBox_F_INV_Label_Name_2.BackColor = TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Remark_1.Locked = True
        txtBox_F_INV_Label_Remark_1.BackColor = TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Remark_2.Locked = True
        txtBox_F_INV_Label_Remark_2.BackColor = TXTBOX_BACKCOLORE_NORMAL
        '�ҏW�\�ݒ�{�^����L����
        btnEnableEdit.Enabled = True
    End Select
End Sub
'�e�R���g���[���̒l��RS�ɃZ�b�g����
Private Sub UpdateRSFromContrl(argCtrl As Control)
    On Error GoTo ErrorCatch
    If Not dicObjNameToFieldName.Exists(argCtrl.Name) Then
        'dicobjToField�ɑ��݂��Ȃ��R���g���[�����̏ꍇ�͔�����
        Exit Sub
    End If
    Select Case True
    '�ŏ��ɕ������`�F�b�N���s���A�I�[�o�[���Ă�����ݒ�l�܂Ő؂艺����
    Case Len(argCtrl.Text) > rsfrmBIN.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize
        '���������t�B�[���h�ݒ�l�I�[�o�[
        MsgBox "���͂��ꂽ���������ݒ�� " & rsfrmBIN.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize & " �����𒴂��Ă��܂��B"
        argCtrl.Text = Mid(argCtrl.Text, 1, rsfrmBIN.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize)
        GoTo CloseAndExit
    Case IsNull(rsfrmBIN.Fields(dicObjNameToFieldName(argCtrl.Name)).Value), rsfrmBIN.Fields(dicObjNameToFieldName(argCtrl.Name)).Value <> argCtrl.Text
        'RS�̒l��Null���A�����̃R���g���[����text�ƈ���Ă���ꍇ
        'rs�ɒl���Z�b�g���āAUpdate�܂ł���iDB�ɔ��f����ɂ�UpdateBatch���Ȃ��ƃ_���j
        rsfrmBIN.Fields(dicObjNameToFieldName(argCtrl.Name)).Value = _
        argCtrl.Text
        rsfrmBIN.Update
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "UpdateRSFromContrl code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'Update��RS�ɃR�~�b�g���ꂽ�ύX��DB�Ƀv�b�V������
Private Sub DoUpdateBatch()
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    If rsfrmBIN.Status And adRecModified Then
        rsfrmBIN.UpdateBatch
'        If (rsfrmBIN.Status And ADODB.RecordStatusEnum.adRecUnmodified) Or (rsfrmBIN.Status = ADODB.RecordStatusEnum.adRecOK) Then
        If (rsfrmBIN.Status And ADODB.RecordStatusEnum.adRecUnmodified) Then
            MsgBox "����ɍX�V����܂���"
            '�ҏW�s���[�h��
            SwitchtBoxEditmode False
            GoTo CloseAndExit
        Else
            MsgBox "�X�V�Ɏ��s�����\��������܂� RSStasus: " & rsfrmBIN.Status
            GoTo CloseAndExit
        End If
    ElseIf rsfrmBIN.Status And ADODB.RecordStatusEnum.adRecUnmodified Then
        MsgBox "�ύX�_�͂���܂���ł����B"
        GoTo CloseAndExit
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "DoUpdateBatch code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
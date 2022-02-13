VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmBinLabel 
   Caption         =   "BIN�J�[�h���x��������ڕҏW���"
   ClientHeight    =   5895
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8610.001
   OleObjectBlob   =   "frmBinLabel.frx":0000
   ShowModal       =   0   'False
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
Private confrmBIN As ADODB.Connection
Private rsLabelTemp As ADODB.Recordset
Private StopEvents As Boolean
Private UpdateMode As Boolean                                       '�ҏW�\��ԂɂȂ��Ă�Ƃ���True���Z�b�g
Private strStartTime As String
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
    Constructor
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
'�ύX��j��
Private Sub btnCancelUpdate_Click()
    CancelUpdateBatch
End Sub
'���x���ꎞ�e�[�u���ɒǉ�����
Private Sub btnAddnewLabelTemp_Click()
    If strStartTime = "" Then
        '�t�H�[���X�^�[�g���Ԃ��󕶎��������獡��̃t�H�[���ł̏�����s�Ƃ݂Ȃ�
        '�܂��̓e�[�u������蒼��
        Dim isCollect As Boolean
        isCollect = RecreateLabelTempTable
        If Not isCollect Then
            '�ꎞ�e�[�u���쐬�Ɏ��s
            MsgBox "�ꎞ�e�[�u���쐬�Ɏ��s�������߁A�����𒆒f���܂�"
            Exit Sub
        End If
        '�t�H�[���X�^�[�g���Ԃ�ݒ肷��
        strStartTime = GetLocalTimeWithMilliSec
    End If
    '���ɃJ�����g���R�[�h��TempTable�ɒǉ�����
    AddNewRStoLabelTemp
End Sub
'�C���N�������^�����X�gClick
Private Sub lstBox_Incremental_Click()
    If StopEvents Or UpdateMode Then
        '�C�x���g�X�g�b�v��UpdateMode�̎��͔�����
        Exit Sub
    End If
    If clsIncrementalfrmBIN.Incremental_LstBox_Click Then
        '���̒��ɓ����Ă鎞�_��RS�Ƀt�B���^�[���K�p����Ă���
        '�C�x���g��~
        StopEvents = True
        'RS����l�擾
        GetValuFromRS
        '��\����keyup�C�x���g�ōs�����Ƃɂ���
'        '���X�g���\���ɂ���
'        lstBox_Incremental.ListIndex = -1
'        If lstBox_Incremental.ListCount >= 2 Then
'            lstBox_Incremental.Visible = False
'        Else
'            lstBox_Incremental.Height = 0
'        End If
        '�����܂łŒl�̎擾���������Ă���̂ŁA�ʏ�̕ҏW�s���[�h��
        SwitchtBoxEditmode False
        '�C�x���g�ĊJ
        StopEvents = False
    End If
End Sub
'Change
Private Sub txtBox_F_INV_Tehai_Code_Change()
    '�C�x���g��~��Ԃł͂Ȃ��A�X�ɃA�b�v�f�[�g���[�h�ł��Ȃ��Ƃ��ɃC���N�������^�����s
    If StopEvents Or UpdateMode Then
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    '�e�L�X�g��Ucase������
    If ActiveControl.TextLength >= 1 Then
        ActiveControl.Text = UCase(ActiveControl.Text)
    End If
    '�C���N�������^�����s
    clsIncrementalfrmBIN.Incremental_TextBox_Change
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'keyup
'�C���N�������^�����X�gKeyUp
Private Sub lstBox_Incremental_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    '�C�x���g��~
    StopEvents = True
    '�C���N�������^���Ɋۓ���
    clsIncrementalfrmBIN.Incremental_LstBox_Key_UP KeyCode, Shift
    '�C�x���g�ĊJ
    StopEvents = False
End Sub
'mouseup
'�C���N�������^�����X�gMouseUP
Private Sub lstBox_Incremental_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    '�C�x���g��~
    StopEvents = True
    '�C���N�������^��
    clsIncrementalfrmBIN.Incremental_LstBox_Mouse_UP Button
    '�C�x���g�ĊJ
    StopEvents = False
End Sub
'RS�ɒl�Z�b�g����e�L�X�g�{�b�N�X
'�I��
Private Sub txtBox_F_INV_Tana_Local_Text_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    Select Case UpdateMode
    Case True
        '�A�b�v�f�[�g���[�h�̎�
        UpdateRSFromContrl ActiveControl
        Exit Sub
    Case False
        '�������[�h(?)�̎�
        '�C�x���g��~
        StopEvents = True
        'RS������e���擾(listbox��Click�C�x���g�ŌĂ΂��͂�)�����܂�UpdateMode�ɂ��Ă͂����Ȃ�
        'btnEnableEdit��False��
        btnEnableEdit.Enabled = False
        'Ucase�|����
        If ActiveControl.TextLength >= 1 Then
            ActiveControl.Text = UCase(ActiveControl.Text)
        End If
        clsIncrementalfrmBIN.Incremental_TextBox_Change
        '�C�x���g�ĊJ
        StopEvents = False
        Exit Sub
    End Select
End Sub
'�i��1
Private Sub txtBox_F_INV_Label_Name_1_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    If UpdateMode Then
        'UpdateMode�̎���Update���\�b�h��
        UpdateRSFromContrl ActiveControl
    End If
End Sub
'�i��2
Private Sub txtBox_F_INV_Label_Name_2_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    If UpdateMode Then
        'UpdateMode�̎���Update���\�b�h��
        UpdateRSFromContrl ActiveControl
    End If
End Sub
'���l1
Private Sub txtBox_F_INV_Label_Remark_1_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    If UpdateMode Then
        'UpdateMode�̎���Update���\�b�h��
        UpdateRSFromContrl ActiveControl
    End If
End Sub
'���l2
Private Sub txtBox_F_INV_Label_Remark_2_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    If UpdateMode Then
        'UpdateMode�̎���Update���\�b�h��
        UpdateRSFromContrl ActiveControl
    End If
End Sub
'��z�R�[�h�t�B���^
Private Sub txtBox_Filter_Tehai_Code_Change()
'    If StopEvents Then
'        Exit Sub
'    End If
'    '�C�x���g��~
'    StopEvents = True
'    If Len(ActiveControl.Text) >= 1 Then
'        ActiveControl.Text = UCase(ActiveControl.Text)
'    End If
'    SetFilter ActiveControl
End Sub
'�I�ԃt�B���^�[
Private Sub txtBox_Filter_Local_Tana_Change()
'    If StopEvents Then
'        Exit Sub
'    End If
'    '�C�x���g��~
'    StopEvents = True
'    If Len(ActiveControl.Text) >= 1 Then
'        ActiveControl.Text = UCase(ActiveControl.Text)
'    End If
'    SetFilter ActiveControl
End Sub
'Enter
'�I�ԃe�L�X�g�{�b�N�XEnter
Private Sub txtBox_F_INV_Tana_Local_Text_Enter()
    If StopEvents Or UpdateMode Then
        'StopEvent �� UpdateMode�������甲����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    '�C���N�������^�����s�AEnter
    clsIncrementalfrmBIN.Incremental_TextBox_Enter txtBox_F_INV_Tana_Local_Text, lstBox_Incremental
    '�C�x���g�ĊJ
    StopEvents = False
    Exit Sub
End Sub
Private Sub txtBox_F_INV_Tehai_Code_Enter()
    '�C�x���g��~��Ԃł͂Ȃ��A�X�ɃA�b�v�f�[�g���[�h�ł��Ȃ��Ƃ��ɃC���N�������^�����s
    If StopEvents Or UpdateMode Then
        'StopEvents��UpdateMode�̎��͔�����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    '�C���N�������^�����s�A���X�g��\������̂��ړI
    clsIncrementalfrmBIN.Incremental_TextBox_Enter ActiveControl, lstBox_Incremental
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'�C���N�������^�����X�gEnter
Private Sub lstBox_Incremental_Enter()
    If StopEvents Or UpdateMode Then
        'StopEbent��UpdateMode�̎��͔�����
        Exit Sub
    End If
    '�c���₪1��������Click�C�x���g���������邾��
    clsIncrementalfrmBIN.Incremental_LstBox_Enter
    Exit Sub
End Sub
'------------------------------------------------------------------------------------------------------
'���\�b�h
'''�R���X�g���N�^
Private Sub Constructor()
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
    If clsADOfrmBIN.RS Is Nothing Then
        Set clsADOfrmBIN.RS = New ADODB.Recordset
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
    clsIncrementalfrmBIN.Constructor Me, dicObjNameToFieldName, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc
    'RS�̃f�[�^���擾����
    '�����ł͎擾���Ȃ��ŁA�C���N�������^���T�[�`�ɔC����
'    GetValuFromRS
    '�C�x���g�ĊJ����
    StopEvents = False
#If DebugDB Then
    MsgBox "DebugDB�L��"
#End If
End Sub
'''�f�X�g���N�^
Private Sub Destructor()
    '�����o�ϐ��̉���A���ɐڑ����֘A���Ă�����̂͏d�_�I��
    If Not clsADOfrmBIN.RS Is Nothing Then
        clsADOfrmBIN.RS.ActiveConnection.Close
'        clsADOfrmBIN.RS.Close
        Set clsADOfrmBIN.RS = Nothing
    End If
    If Not clsADOfrmBIN Is Nothing Then
        clsADOfrmBIN.CloseClassConnection
        Set clsADOfrmBIN = Nothing
    End If
    If Not confrmBIN Is Nothing Then
        If confrmBIN.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����Ă��������
            confrmBIN.Close
        End If
        Set confrmBIN = Nothing
    End If
    If Not clsIncrementalfrmBIN Is Nothing Then
        Set clsIncrementalfrmBIN = Nothing
    End If
    Me.Hide
    Unload Me
End Sub
'''�����o�ϐ���RecordSet�ɏ����f�[�^��ݒ肷��
'''
Private Sub SetDefaultValuetoRS()
    '�ŏ���clsado��DBPath��DBFilname���f�t�H���g��
    clsADOfrmBIN.SetDBPathandFilenameDefault
    '�����ڑ�����Ă�����ؒf����
    If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
        clsADOfrmBIN.RS.Close
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
    clsADOfrmBIN.RS.LockType = adLockBatchOptimistic
    clsADOfrmBIN.RS.CursorType = adOpenStatic
    'rs��Source��SQL�ݒ�(��Ńp�����[�^�Ή�����)
    clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_DEFAULT_DATA
    'rs��ActiveConnection��Connection�I�u�W�F�N�g�w��
    Set clsADOfrmBIN.RS.ActiveConnection = confrmBIN
    'rs�I�[�v��
    clsADOfrmBIN.RS.Open , , , , CommandTypeEnum.adCmdText
    '�ȉ��͐���ɓ���
    '�X�V�ɕK�v�ȃL�[��̏�񂪁`�E�E�E�������̃e�[�u���̎�L�[��SELECT�̃t�B�[���h�Ɋ܂߂�Ɖ���
'    clsADOfrmBIN.RS.Fields("F_INV_Label_Name_2").Value = "InputTest"
'    clsADOfrmBIN.RS.Fields("F_INV_Tana_Local_Text").Value = "K23 A01"
'    clsADOfrmBIN.RS.Update
'    clsADOfrmBIN.RS.UpdateBatch
    DebugMsgWithTime "Default Data count: " & clsADOfrmBIN.RS.RecordCount
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
    If UpdateMode Then
        'UpdateMod�������甲����
        GoTo CloseAndExit
    End If
    If clsADOfrmBIN.RS.EOF And clsADOfrmBIN.RS.BOF Then
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
        Case IsNull(clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(varKeyobjDic)).Value)
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
                Me.Controls(varKeyobjDic).Text = clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(varKeyobjDic)).Value
            Case "Label"
                '���x��
                Me.Controls(varKeyobjDic).Caption = clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(varKeyobjDic)).Value
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
    If clsADOfrmBIN.RS.BOF And clsADOfrmBIN.RS.EOF Then
        'BOF��EOF���������Ă��甲����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    Select Case intargKeyCode
    Case vbKeyRight
        '�E�A����
        clsADOfrmBIN.RS.MoveNext
        If clsADOfrmBIN.RS.EOF Then
            MsgBox "���݂̃��R�[�h���ŏI���R�[�h�ł�"
            clsADOfrmBIN.RS.MovePrevious
        End If
    Case vbKeyLeft
        '���A�O��
        clsADOfrmBIN.RS.MovePrevious
        If clsADOfrmBIN.RS.BOF Then
            MsgBox "���݂̃��R�[�h���擪���R�[�h�ł�"
            clsADOfrmBIN.RS.MoveNext
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
    If clsADOfrmBIN.RS.BOF And clsADOfrmBIN.RS.EOF Then
        'RS�ɒ��g�����������甲����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    Select Case argCtrl.Text
    Case ""
        '�󔒂�������AFilter��adFilterNon���Z�b�g���ăt�B���^���N���A����
        clsADOfrmBIN.RS.Filter = adFilterNone
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
        clsADOfrmBIN.RS.Filter = Join(strFilter, "")
        '�l�擾����
        GetValuFromRS
    End Select
    '���R�[�h��0��������񍐂���
    If clsADOfrmBIN.RS.BOF And clsADOfrmBIN.RS.EOF Then
        MsgBox "���݂̎w������ł͊Y�����郌�R�[�h������܂���"
        '��U�t�B���^��������
        clsADOfrmBIN.RS.Filter = adFilterNone
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
        UpdateMode = True
        btnDoUpdate.Enabled = True
        btnCancelUpdate.Enabled = True
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
        UpdateMode = False
        'UpdateBatck�{�^����False��
        btnDoUpdate.Enabled = False
        btnCancelUpdate.Enabled = False
        'Locked��True�ɂ��āABackColore��W���w�i�F�ɂ���
        '�I�ԃe�L�X�g�{�b�N�X�͕ҏW�s���[�h�̎��̓C���N�������^���Ɏg���̂�Lock�͂��Ȃ�
'        txtBox_F_INV_Tana_Local_Text.Locked = True
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
    Case Len(argCtrl.Text) > clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize
        '���������t�B�[���h�ݒ�l�I�[�o�[
        MsgBox "���͂��ꂽ���������ݒ�� " & clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize & " �����𒴂��Ă��܂��B"
        argCtrl.Text = Mid(argCtrl.Text, 1, clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize)
        GoTo CloseAndExit
    Case IsNull(clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).Value), clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).Value <> argCtrl.Text
        'RS�̒l��Null���A�����̃R���g���[����text�ƈ���Ă���ꍇ
        'rs�ɒl���Z�b�g���āAUpdate�܂ł���iDB�ɔ��f����ɂ�UpdateBatch���Ȃ��ƃ_���j
        clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).Value = _
        argCtrl.Text
        clsADOfrmBIN.RS.Update
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
    Dim varOldFilter As Variant
    Dim varBookMark As Variant
    '���݂�BookMark���擾
    varBookMark = clsADOfrmBIN.RS.Bookmark
    '�Â��t�B���^�[��ޔ�
    varOldFilter = clsADOfrmBIN.RS.Filter
    '��U�t�B���^��������
    clsADOfrmBIN.RS.Filter = adFilterNone
    'rs��Filter�� adFilterPendingRecords�A�T�[�o�[�ɖ����M�̕ύX�̂��郌�R�[�h�����A�ɂ���
    clsADOfrmBIN.RS.Filter = adFilterPendingRecords
    Select Case True
    Case (clsADOfrmBIN.RS.BOF And clsADOfrmBIN.RS.EOF), clsADOfrmBIN.RS.Status And ADODB.RecordStatusEnum.adRecUnmodified
        'adFilterPendingRecords�|�����ヌ�R�[�h���Ȃ��������AUnmodified�t���O�������Ă����ꍇ
        MsgBox "�ύX�_�͂���܂���ł����B"
        '�t�B���^��߂��Ă��
        clsADOfrmBIN.RS.Filter = varOldFilter
        GoTo CloseAndExit
    Case clsADOfrmBIN.RS.Status And adRecModified
        'UpdateBatck�ň�����^���Ȃ��Ƃ��܂��X�V�ł��Ȃ����Ƃ�����݂����Ȃ̂ŁAadAffectGroup�Ars.filter(�萔)�Œ��o���ꂽ���R�[�h�����ɉe��������
        'adAffectCurrent��Filter�Ŏw�肳�ꂽ���R�[�h�̂ݍX�V����������w��
        clsADOfrmBIN.RS.UpdateBatch adAffectGroup
'        'Filter��߂��Ă��
'        clsADOfrmBIN.RS.Filter = varOldFilter
        'BookMark��߂�
        clsADOfrmBIN.RS.Bookmark = varBookMark
        If (clsADOfrmBIN.RS.Status And ADODB.RecordStatusEnum.adRecUnmodified) Then
            MsgBox "����ɍX�V����܂���"
            '�ҏW�s���[�h��
            SwitchtBoxEditmode False
            'RS���f�[�^���擾����
            GetValuFromRS
            GoTo CloseAndExit
        Else
            MsgBox "�X�V�Ɏ��s�����\��������܂� RSStasus: " & clsADOfrmBIN.RS.Status
            GoTo CloseAndExit
        End If
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "DoUpdateBatch code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'�ύX���ꂽ���e��j�����Č��ɖ߂�
Private Sub CancelUpdateBatch()
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    '���݂�BookMark��ޔ�
    If clsADOfrmBIN.RS.Supports(adBookmark) Then
        'BookMark���L����������
        Dim varBookMark As Variant
        varBookMark = clsADOfrmBIN.RS.Bookmark
    End If
    '���̃t�B���^��ޔ�
    Dim varOldFilter As Variant
    varOldFilter = clsADOfrmBIN.RS.Filter
    '��U�t�B���^����
    clsADOfrmBIN.RS.Filter = adFilterNone
    '�V���� adfilterPendingRecords�ŕύX�_�̂��郌�R�[�h�����ɍi�荞��
    clsADOfrmBIN.RS.Filter = adFilterPendingRecords
    Select Case True
    Case clsADOfrmBIN.RS.BOF And clsADOfrmBIN.RS.EOF, clsADOfrmBIN.RS.Status And ADODB.RecordStatusEnum.adRecUnmodified
        'EOR,BOF�������ɗ����Ă邩(�ύX���R�[�h����)�AStatus��Unmodified�ɂȂ��Ă���Ƃ�
        MsgBox "�ύX�_�͂���܂���ł���"
        '�t�B���^��߂��H
        clsADOfrmBIN.RS.Filter = varOldFilter
        If clsADOfrmBIN.RS.Supports(adBookmark) Then
            'BookMark�L���Ȃ�BookMark��߂�
            clsADOfrmBIN.RS.Bookmark = varBookMark
        End If
        '�ҏW�s���[�h��
        SwitchtBoxEditmode False
        GoTo CloseAndExit
    Case clsADOfrmBIN.RS.Status And adRecModified
        'Status���ύX�L�ɂȂ��Ă���
        '�L�����Z�����Ă������₢���킹
        Dim longMsgBoxRet As Long
        longMsgBoxRet = MsgBox("���e���ύX����Ă��܂��A�ύX��j�����Ă��ǂ��ł���?", vbYesNo)
        If longMsgBoxRet = vbNo Then
            '�L�����Z�����ꂽ
            MsgBox "�ύX�̔j�����L�����Z�����܂����B�f�[�^�͕ύX��̂܂܂ł��B"
            '�t�B���^��߂�
            clsADOfrmBIN.RS.Filter = varOldFilter
            If clsADOfrmBIN.RS.Supports(adBookmark) Then
                'BookMark�L���Ȃ�BookMark��߂�
                clsADOfrmBIN.RS.Bookmark = varBookMark
            End If
            Exit Sub
        End If
        '�t�B���^��̃��R�[�h�����CancelBatch
        clsADOfrmBIN.RS.CancelBatch adAffectGroup
'        If (clsADOfrmBIN.RS.Status And ADODB.RecordStatusEnum.adRecUnmodified) Or (clsADOfrmBIN.RS.Status = ADODB.RecordStatusEnum.adRecOK) Then
        If (clsADOfrmBIN.RS.Status And ADODB.RecordStatusEnum.adRecUnmodified) Then
            MsgBox "�ύX�_�𖳎��ɔj�����܂����B"
            '�t�B���^��߂��H
            clsADOfrmBIN.RS.Filter = varOldFilter
            If clsADOfrmBIN.RS.Supports(adBookmark) Then
                'BookMark�L���Ȃ�BookMark��߂�
                clsADOfrmBIN.RS.Bookmark = varBookMark
            End If
            '�ҏW�s���[�h��
            SwitchtBoxEditmode False
            'RS���l���擾����
            GetValuFromRS
            GoTo CloseAndExit
        Else
            MsgBox "�ύX�̔j���Ɏ��s�����\��������܂� RSStasus: " & clsADOfrmBIN.RS.Status
            GoTo CloseAndExit
        End If
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "CancelUpdateBatch code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'''���x���o�͗p�ꎞ�e�[�u�����쐬����
'''�����̃e�[�u�������݂��Ă����狭���I�ɍ폜���Ă���V���ɍ쐬����
Private Function RecreateLabelTempTable() As Boolean
    On Error GoTo ErrorCatch
    '�ȉ��̑���͓Ɨ�����Connection���肽���̂ŁA�N���X���LclsADO�C���X�^���X�͎g�p���Ȃ�
    Dim clsADOLabelTemp As clsADOHandle
    Set clsADOLabelTemp = CreateclsADOHandleInstance
    'DBPath�̓f�t�H���g�ADBFilename�͈ꎞ�e�[�u���i�[DB�̂��̂ɂ���
    clsADOLabelTemp.SetDBPathandFilenameDefault
    clsADOLabelTemp.DBFileName = PublicConst.TEMP_DB_FILENAME
    '�܂��͊����̃��x���ꎞ�e�[�u�����폜
    Dim isCollect As Boolean
    isCollect = clsADOLabelTemp.DropTable(INV_CONST.T_INV_LABEL_TEMP)
    If Not isCollect Then
        DebugMsgWithTime "RecreateLabelTempTable : fail delete already label tamp table"
        MsgBox "���x���o�͈ꎞ�e�[�u���̍쐬�Ɏ��s���܂���"
        RecreateLabelTempTable = False
        GoTo CloseAndExit
        Exit Function
    End If
    '���x���ꎞ�e�[�u�����쐬����
''{0} T_INV_LABEL_TEMP
''{1} F_INV_Tana_Local_Text
''{2} F_INV_Tehai_Code
''{3} F_INV_Label_Name_1
''{4} F_INV_Label_Name_2
''{5} F_INV_Label_Remark_1
''{6} F_INV_Label_Remark_2
''{7} InputDate
'Public Const SQL_INV_CREATE_LABEL_TEMP_TABLE As String = "CREATE TABLE {0} (" & vbCrLf &
    Dim dicReplaceLabelTemp As Dictionary
    Set dicReplaceLabelTemp = New Dictionary
    dicReplaceLabelTemp.Add 0, INV_CONST.T_INV_LABEL_TEMP
    dicReplaceLabelTemp.Add 1, clsEnumfrmBIN.INVMasterTana(F_INV_Tana_Local_Text_IMT)
    dicReplaceLabelTemp.Add 2, clsEnumfrmBIN.INVMasterParts(F_Tehai_Code_IMPrt)
    dicReplaceLabelTemp.Add 3, clsEnumfrmBIN.INVMasterParts(F_Label_Name_1_IMPrt)
    dicReplaceLabelTemp.Add 4, clsEnumfrmBIN.INVMasterParts(F_Label_Name_2_IMPrt)
    dicReplaceLabelTemp.Add 5, clsEnumfrmBIN.INVMasterParts(F_Label_Remark_1_IMPrt)
    dicReplaceLabelTemp.Add 6, clsEnumfrmBIN.INVMasterParts(F_Label_Remark_2_IMPrt)
    dicReplaceLabelTemp.Add 7, PublicConst.INPUT_DATE
    'Replace���s�ASQL�ݒ�
    clsADOLabelTemp.SQL = clsSQLBc.ReplaceParm(INV_CONST.SQL_INV_CREATE_LABEL_TEMP_TABLE, dicReplaceLabelTemp)
    'Write�t���O���Ă�
    clsADOLabelTemp.ConnectMode = clsADOLabelTemp.ConnectMode Or adModeWrite
    'SQL���s
    isCollect = clsADOLabelTemp.Do_SQL_with_NO_Transaction
    'Write�t���O������
    clsADOLabelTemp.ConnectMode = clsADOLabelTemp.ConnectMode And Not adModeWrite
    If Not isCollect Then
        'SQL���s���s
        DebugMsgWithTime "RecreateLabelTempTable : do sql fail..."
        MsgBox "RecreateLabelTempTable��SQL�̎��s�Ɏ��s���܂���"
        RecreateLabelTempTable = False
        GoTo CloseAndExit
    End If
    '�����o�ϐ���RecordSet�Ɉꎞ�e�[�u���̓��e�𔽉f����
    If rsLabelTemp Is Nothing Then
        Set rsLabelTemp = New ADODB.Recordset
    End If
    If rsLabelTemp.State And ObjectStateEnum.adStateOpen Then
        '�ڑ����J���Ă��������
        rsLabelTemp.Close
    End If
    rsLabelTemp.ActiveConnection = clsADOLabelTemp.ConnectionString
    rsLabelTemp.Source = "SELECT * FROM " & INV_CONST.T_INV_LABEL_TEMP
    rsLabelTemp.CursorLocation = adUseClient
    rsLabelTemp.CursorType = adOpenStatic
    rsLabelTemp.LockType = adLockBatchOptimistic
    rsLabelTemp.Open , , , , adCmdText
    clsADOLabelTemp.CloseClassConnection
    DebugMsgWithTime "RecreateLabelTempTable: Recreate Label Temp Table Success"
    RecreateLabelTempTable = True
    GoTo CloseAndExit
    Exit Function
ErrorCatch:
    DebugMsgWithTime "RecreateLabelTempTable code: " & err.Number & " Description: " & err.Description
    RecreateLabelTempTable = False
    GoTo CloseAndExit
CloseAndExit:
    If Not clsADOLabelTemp Is Nothing Then
        clsADOLabelTemp.CloseClassConnection
        Set clsADOLabelTemp = Nothing
    End If
    Exit Function
End Function
'���݂�RS�̃f�[�^�����x���e�[�u���ɒǉ�����
Private Sub AddNewRStoLabelTemp()
    On Error GoTo ErrorCatch
    If Not rsLabelTemp.State And ObjectStateEnum.adStateOpen Then
        '�ڑ����Ă��Ȃ�������ڑ�����
        rsLabelTemp.Open
    End If
    '�V�K���R�[�h��ǉ�����
    rsLabelTemp.AddNew
    Dim varKeyobjDic As Variant
    'dicObjtoField�����[�v���ArsLabelTemp�Ƀf�[�^��ݒ肷��
    If dicObjNameToFieldName.Exists(Empty) Then
        dicObjNameToFieldName.Remove Empty
    End If
    For Each varKeyobjDic In dicObjNameToFieldName
        Select Case True
        Case IsNull(clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(varKeyobjDic)).Value)
            'Null�������ꍇ
            '�Ƃ肠�����󕶎��ɂ���
            rsLabelTemp.Fields(dicObjNameToFieldName(varKeyobjDic)).Value = ""
        Case Else
            '�f�[�^���������ꍇ
            'RS�̃f�[�^�����̂܂ܓK�p����
            rsLabelTemp.Fields(dicObjNameToFieldName(varKeyobjDic)).Value = _
            clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(varKeyobjDic)).Value
        End Select
    Next varKeyobjDic
    '����̃t�H�[���X�^�[�g���Ԃ�InputDate�Ƃ��ē���
    rsLabelTemp.Fields(PublicConst.INPUT_DATE).Value = strStartTime
    'Update�Ń��[�J����RS���m�肷��
    rsLabelTemp.Update
    'rsLabel��Filter��PendingRecords�A�ύX�𖢑��M�ɐݒ肵�AUpdateBatch�������ADB�ɔ��f����
    rsLabelTemp.Filter = adFilterNone
    rsLabelTemp.Filter = adFilterPendingRecords
    rsLabelTemp.UpdateBatch adAffectGroup
    rsLabelTemp.Filter = adFilterNone
    If rsLabelTemp.Status And ADODB.RecordStatusEnum.adRecUnmodified Then
        MsgBox "����Ɉꎞ�e�[�u���ɒǉ�����܂���"
    End If
    GoTo CloseAndExit
    Exit Sub
ErrorCatch:
    DebugMsgWithTime "AddNewRStoLabelTemp code: " & err.Number & " Description: " & err.Description
    MsgBox "���x������p�ꎞ�e�[�u���o�^���ɃG���[�������������߁A����̓o�^�̓L�����Z������܂���"
    rsLabelTemp.CancelUpdate
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmBinLabel 
   Caption         =   "BIN�J�[�h���x��������ڕҏW���"
   ClientHeight    =   9105.001
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
Private rsOnlyPartsMaster As ADODB.Recordset                        '�b��Ή��ɂȂ邩���HAddNew���Ɏg�p����PartsMaster�݂̂�Select�������ʂ��i�[(Addnew��)����RS
Private StopEvents As Boolean
Public UpdateMode As Boolean                                        '�ҏW�\��ԂɂȂ��Ă�Ƃ���True���Z�b�g
Private AddnewMode As Boolean                                       '�V�K�ǉ����[�h�̎���True���Z�b�g
Private strStartTime As String
Public strSavePoint As String                                       'LabelTemp�ɒǉ�����ۂ�SavePoint������
Public varstrarrSelectedSavepoint As Variant                        '����ΏۂƂȂ�SavePoint���i�[����string�z��
'�萔
Private Const MAX_LABEL_TEXT_LENGTH As Long = 18
Private Const LABEL_TEMP_DELETE_FLAG As String = "LabelTempDelete"  'LabenTemp�e�[�u�����폜���鎞��StartTime�ɃZ�b�g����萔
'------------------------------------------------------------------------------------------------------
'SQL
'binLabel�̊�b�f�[�^�擾SQL
Private Const SQL_BIN_LABEL_DEFAULT_DATA As String = "SELECT TDBPrt.F_INV_Tehai_ID,TDBTana.F_INV_Tana_ID,TDBTana.F_INV_Tana_Local_Text as F_INV_Tana_Local_Text,TDBPrt.F_INV_Tehai_Code as F_INV_Tehai_Code,TDBPrt.F_INV_Label_Name_1 as F_INV_Label_Name_1,TDBPrt.F_INV_Label_Name_2 as F_INV_Label_Name_2,TDBPrt.F_INV_Label_Remark_1 as F_INV_Label_Remark_1,TDBPrt.F_INV_Label_Remark_2 as F_INV_Label_Remark_2,TDBTana.F_INV_Tana_System_Text as F_INV_Tana_System_Text," & vbCrLf & _
"TDBPrt.F_INV_Store_Code as F_INV_Store_Code " & vbCrLf & _
"FROM T_INV_M_Parts AS TDBPrt " & vbCrLf & _
"    INNER JOIN T_INV_M_Tana as TDBTana " & vbCrLf & _
"    ON TDBPrt.F_INV_Tana_ID = TDBTana.F_INV_Tana_ID"
'''binLabel�ɂ����āA4701�̃f�[�^�݂̂Ɍ��肷��SQL�A���Ŋ��Ɏg�p���Ă����z�R�[�h�����邽��
Private Const SQL_BIN_LABEL_DEFAULT_DATA_ONLY_4701 As String = "SELECT TDBPrt.F_INV_Tehai_ID,TDBTana.F_INV_Tana_ID,TDBTana.F_INV_Tana_Local_Text as F_INV_Tana_Local_Text,TDBPrt.F_INV_Tehai_Code as F_INV_Tehai_Code,TDBPrt.F_INV_Label_Name_1 as F_INV_Label_Name_1,TDBPrt.F_INV_Label_Name_2 as F_INV_Label_Name_2,TDBPrt.F_INV_Label_Remark_1 as F_INV_Label_Remark_1,TDBPrt.F_INV_Label_Remark_2 as F_INV_Label_Remark_2,TDBTana.F_INV_Tana_System_Text as F_INV_Tana_System_Text," & vbCrLf & _
"TDBPrt.F_INV_Store_Code as F_INV_Store_Code " & vbCrLf & _
"FROM T_INV_M_Parts AS TDBPrt " & vbCrLf & _
"    INNER JOIN T_INV_M_Tana as TDBTana " & vbCrLf & _
"    ON TDBPrt.F_INV_Tana_ID = TDBTana.F_INV_Tana_ID " & vbCrLf & _
"    WHERE F_INV_Tana_System_Text LIKE ""BL%"" OR F_INV_Tana_System_Text LIKE ""K%"""
'�V�K�ǉ�����SQL�A�|�C���g��T_INV_N_TANA��RightJoin���A���o�^�̒I�Ԃ�RS�Ɋ܂߂�_
'�I�ԃ��X�g��Filter��M_Parts��Tana_ID��Null�̕��𒊏o����
Private Const SQL_BIN_LABEL_ADDNEW_TEHAI_CODE As String = "SELECT TDBPrt.F_INV_Tehai_ID,TDBTana.F_INV_Tana_ID,TDBPrt.F_INV_Tana_ID AS TDBPrts_F_INV_Tana_ID,TDBTana.F_INV_Tana_Local_Text as F_INV_Tana_Local_Text,TDBPrt.F_INV_Tehai_Code as F_INV_Tehai_Code,TDBPrt.F_INV_Label_Name_1 as F_INV_Label_Name_1,TDBPrt.F_INV_Label_Name_2 as F_INV_Label_Name_2,TDBPrt.F_INV_Label_Remark_1 as F_INV_Label_Remark_1,TDBPrt.F_INV_Label_Remark_2 as F_INV_Label_Remark_2,TDBTana.F_INV_Tana_System_Text as F_INV_Tana_System_Text," & vbCrLf & _
"TDBPrt.F_INV_Store_Code as F_INV_Store_Code " & vbCrLf & _
"FROM T_INV_M_Parts AS TDBPrt " & vbCrLf & _
"    RIGHT JOIN T_INV_M_Tana as TDBTana " & vbCrLf & _
"    ON TDBPrt.F_INV_Tana_ID = TDBTana.F_INV_Tana_ID " & vbCrLf & _
"    WHERE TDBPrt.F_INV_Tana_ID IS NULL"
'AddNew�ł��܂������Ȃ������̂ŁAM_Parts�P�Ƃ�Select��
Private Const SQL_BIN_LABEL_ONLY_PARTS As String = "SELECT TDBPrt.F_INV_Tehai_ID,TDBPrt.F_INV_Tana_ID,TDBPrt.F_INV_Tehai_Code as F_INV_Tehai_Code,TDBPrt.F_INV_Label_Name_1 as F_INV_Label_Name_1,TDBPrt.F_INV_Label_Name_2 as F_INV_Label_Name_2,TDBPrt.F_INV_Label_Remark_1 as F_INV_Label_Remark_1,TDBPrt.F_INV_Label_Remark_2 as F_INV_Label_Remark_2,InputDate," & vbCrLf & _
"TDBPrt.F_INV_Store_Code as F_INV_Store_Code " & vbCrLf & _
"FROM T_INV_M_Parts AS TDBPrt "
'�������(SavePoint �I���ς�)�̃f�[�^���폜����
'{0}    INV_CONST.T_INV_LABEL_TEMP
'{1}    (MailMergeWhere)
Private Const SQL_DELET_COMP_DATA_FROM_LABEL_TEMP As String = "DELETE FROM {0} " & vbCrLf & _
"WHERE {1}"
Private Sub btnAddNewTehaiCode_Click()
    SwitchAddNewMode True
End Sub
'------------------------------------------------------------------------------------------------------
'�C�x���g
'Form Initial
Private Sub UserForm_Initialize()
    '�t�H�[����������
    ConstRuctor
End Sub
'Form Terminate
Private Sub UserForm_Terminate()
    DestRuctor
End Sub
'Click
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
'�V�K���ʖ��Ƀ`�F���W
Private Sub btnNewSavePoint_Click()
    Dim longMsgBoxReturn As Long
    longMsgBoxReturn = MsgBox("���x���ꎞ�e�[�u���o�^���̎��ʖ���ύX���܂����H(�o�͐�p����ύX���鎞�Ȃ�)", vbYesNo)
    Select Case longMsgBoxReturn
    Case vbYes
        '�ύX����ꍇ
        strSavePoint = ""
        SetSavePoint
        Exit Sub
    Case vbNo
        '�L�����Z�������ꍇ
        MsgBox "�L�����Z�����܂���"
        Exit Sub
    End Select
End Sub
'���x���ꎞ�e�[�u���ɒǉ�����
Private Sub btnAddnewLabelTemp_Click()
    Dim isCollect As Boolean
    isCollect = RecreateLabelTempTable
    If Not isCollect Then
        '�ꎞ�e�[�u���쐬�Ɏ��s
        MsgBox "�ꎞ�e�[�u���쐬�Ɏ��s�������߁A�����𒆒f���܂�"
        Exit Sub
    End If
    'SavePoint�̐ݒ�
    SetSavePoint
    '���ɃJ�����g���R�[�h��TempTable�ɒǉ�����
    AddNewRStoLabelTemp
    'UpdateMode�ŕҏW��Ԕj���t���O(�`�F�b�N�{�b�N�X)�������Ă�����m�F�����ŃL�����Z������(���������ňꎞ�L�������ꍇ��)
    If UpdateMode And chkBoxCancelUpdateModeatLabelTemp.Value Then
        'UpdateMode�łȂ����ҏW��ԕs�`�F�b�N�{�b�N�X��True������
        CancelUpdateBatch True
    End If
End Sub
'DB����f�[�^����������A�������݈���̌��ʂ�Doc��\������
'���x���v�����^�pBIN�J�[�h�\�����x��
Private Sub btnCreateLabelDoc_Click()
    On Error GoTo ErrorCatch
    'clsado���`���邪�ADBPath���擾����ʂɂ����g��Ȃ��̂ŁA���L�ϐ��Ƃ͕ʂɒ�`����
    Dim clsADOMailMerge As clsADOHandle
    Set clsADOMailMerge = CreateclsADOHandleInstance
    Dim fsoMailMerge  As FileSystemObject
    Set fsoMailMerge = New FileSystemObject
    'clsADO�𖾎��I�Ƀf�t�H���g��
    clsADOMailMerge.SetDBPathandFilenameDefault
    '���x��������̓v�����^�̐ݒ肪�K�v(�C�x���g�쓮)�Ȃ̂ŁAPlane�t�@�C�����w��K�{
    MailMergeDocCreate fsoMailMerge.BuildPath(clsADOMailMerge.DBPath, INV_CONST.INV_DOC_LABEL_MAILMERGE), _
                    fsoMailMerge.BuildPath(clsADOMailMerge.DBPath, INV_CONST.INV_DOC_LABEL_PLANE)
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "btnCreateLabelDoc_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsADOMailMerge Is Nothing Then
        clsADOMailMerge.CloseClassConnection
        Set clsADOMailMerge = Nothing
    End If
    If Not fsoMailMerge Is Nothing Then
        Set fsoMailMerge = Nothing
    End If
    Exit Sub
End Sub
'���i�[(��)�쐬
Private Sub btnCreateGenpinSmall_Click()
    On Error GoTo ErrorCatch
    'clsado���`���邪�ADBPath���擾����ʂɂ����g��Ȃ��̂ŁA���L�ϐ��Ƃ͕ʂɒ�`����
    Dim clsADOMailMerge As clsADOHandle
    Set clsADOMailMerge = CreateclsADOHandleInstance
    Dim fsoMailMerge  As FileSystemObject
    Set fsoMailMerge = New FileSystemObject
    'clsADO�𖾎��I�Ƀf�t�H���g��
    clsADOMailMerge.SetDBPathandFilenameDefault
    'MailMerge���s
    MailMergeDocCreate fsoMailMerge.BuildPath(clsADOMailMerge.DBPath, INV_CONST.INV_DOC_LABEL_GENPIN_SMALL)
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "btnCreateGenpinSmall_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsADOMailMerge Is Nothing Then
        clsADOMailMerge.CloseClassConnection
        Set clsADOMailMerge = Nothing
    End If
    If Not fsoMailMerge Is Nothing Then
        Set fsoMailMerge = Nothing
    End If
    Exit Sub
End Sub
'�X�y�b�N�V�[�g_�ڍ׌��i�[(��)�쐬�A�\��
Private Sub btnCreateSpecSheetSmall_Click()
    On Error GoTo ErrorCatch
    'clsado���`���邪�ADBPath���擾����ʂɂ����g��Ȃ��̂ŁA���L�ϐ��Ƃ͕ʂɒ�`����
    Dim clsADOMailMerge As clsADOHandle
    Set clsADOMailMerge = CreateclsADOHandleInstance
    Dim fsoMailMerge  As FileSystemObject
    Set fsoMailMerge = New FileSystemObject
    'clsADO�𖾎��I�Ƀf�t�H���g��
    clsADOMailMerge.SetDBPathandFilenameDefault
    'MailMerge���s
    MailMergeDocCreate fsoMailMerge.BuildPath(clsADOMailMerge.DBPath, INV_CONST.INV_DOC_LABEL_SPECSHEET_Small)
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "btnCreateSpecSheetSmall_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsADOMailMerge Is Nothing Then
        clsADOMailMerge.CloseClassConnection
        Set clsADOMailMerge = Nothing
    End If
    If Not fsoMailMerge Is Nothing Then
        Set fsoMailMerge = Nothing
    End If
    Exit Sub
End Sub
'''�I�\��_��󖳂�
Private Sub btnCreateTanaNoArrow_Click()
    On Error GoTo ErrorCatch
    'clsado���`���邪�ADBPath���擾����ʂɂ����g��Ȃ��̂ŁA���L�ϐ��Ƃ͕ʂɒ�`����
    Dim clsADOMailMerge As clsADOHandle
    Set clsADOMailMerge = CreateclsADOHandleInstance
    Dim fsoMailMerge  As FileSystemObject
    Set fsoMailMerge = New FileSystemObject
    'clsADO�𖾎��I�Ƀf�t�H���g��
    clsADOMailMerge.SetDBPathandFilenameDefault
    'MailMerge���s
    MailMergeDocCreate fsoMailMerge.BuildPath(clsADOMailMerge.DBPath, INV_CONST.INV_DOC_LABEL_TANA_NO_ARROW)
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "btnCreateTanaNoArrow_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsADOMailMerge Is Nothing Then
        clsADOMailMerge.CloseClassConnection
        Set clsADOMailMerge = Nothing
    End If
    If Not fsoMailMerge Is Nothing Then
        Set fsoMailMerge = Nothing
    End If
    Exit Sub
End Sub
'��z�R�[�h���Z�b�g�����p�[�c�}�X�^�[��ʂ�\������
Private Sub btnShowPMList_Click()
    If txtBox_F_INV_Tehai_Code.Text = "" Then
        Exit Sub
    End If
    Load frmINV_PartsMaster_List
    frmINV_PartsMaster_List.txtBox_F_INV_Tehai_Code.SetFocus
    frmINV_PartsMaster_List.txtBox_F_INV_Tehai_Code.Text = frmBinLabel.txtBox_F_INV_Tehai_Code.Text
    frmINV_PartsMaster_List.lstBox_Incremental.ListIndex = 0
    frmINV_PartsMaster_List.lstBox_Incremental.Visible = False
    frmINV_PartsMaster_List.Show
End Sub
'�V�K�I�ԓo�^��ʕ\��
Private Sub btnRegistNewLocationfrmShow_Click()
    modCreateInstanceforAddin.ShowFrmRegistNewLocation
End Sub
'�C���N�������^�����X�gClick
Private Sub lstBox_Incremental_Click()
    If (StopEvents Or UpdateMode) And Not AddnewMode Then
        '�C�x���g�X�g�b�v��UpdateMode�ŁA�X��AddNewMode����Ȃ����͔�����
        Exit Sub
    End If
    If AddnewMode And clsIncrementalfrmBIN.txtBoxRef.Name <> txtBox_F_INV_Tana_Local_Text.Name Then
        'AddnewMode�̎��A����ɂ���̂͒I�ԃe�L�X�g�{�b�N�X�̎��Ȃ̂ŁA����ȊO�̏ꍇ�͒P���Ƀ��X�g�������ďI���
        lstBox_Incremental.Visible = False
        Exit Sub
    End If
    If clsIncrementalfrmBIN.Incremental_LstBox_Click Then
        '���̒��ɓ����Ă鎞�_��RS�Ƀt�B���^�[���K�p����Ă���
        '�C�x���g��~
        StopEvents = True
        'AddnewMode�̏�Ԃ̉����ď����𕪊�
        Select Case AddnewMode And clsIncrementalfrmBIN.txtBoxRef.Name = txtBox_F_INV_Tana_Local_Text.Name
        Case True
            'AddNewMode�̎�
            'AddNew�̎���RS����f�[�^�擾����̂͒I�Ԃ݂̂Ȃ̂ł����Œ��ڒl���Z�b�g���Ă��܂�
            'Tana_Local
            txtBox_F_INV_Tana_Local_Text.Text = _
            clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(txtBox_F_INV_Tana_Local_Text.Name)).Value
            'Tana_System
            lbl_F_INV_Tana_System_Text.Caption = _
            clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(lbl_F_INV_Tana_System_Text.Name)).Value
            '�����ŃC���N�������^�����X�g��\���ɂ��Ă��܂�
            lstBox_Incremental.Visible = False
        Case False
            '�ʏ퓮��
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
        End Select
        '�C�x���g�ĊJ
        StopEvents = False
    End If
End Sub
'keyup
'�C���N�������^�����X�gKeyUp
Private Sub lstBox_Incremental_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    If AddnewMode Then
        '�V�K�ǉ����[�h�̎��͔�����
        Exit Sub
    End If
    '�C�x���g��~
    StopEvents = True
    '�C���N�������^���Ɋۓ���
    clsIncrementalfrmBIN.Incremental_LstBox_Key_UP KeyCode, Shift
    '�C���N�������^���̌��ʁA�C���N�������^�����X�g����\���ɂȂ��Ă�����I�[�_�[No�{�b�N�X�Ƀt�H�[�J�X
    If lstBox_Incremental.Visible = False Or lstBox_Incremental.Height = 0 Then
        '�I�[�_�[No�{�b�N�X��SetFocus
        txtBox_OrderNumber.SetFocus
    End If
    '�C�x���g�ĊJ
    StopEvents = False
End Sub
'mouseup
'�C���N�������^�����X�gMouseUP
Private Sub lstBox_Incremental_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    '�V�K�ǉ����[�h�̎��͔�����
    If AddnewMode Then
        Exit Sub
    End If
    '�C�x���g��~
    StopEvents = True
    '�C���N�������^��
    clsIncrementalfrmBIN.Incremental_LstBox_Mouse_UP Button
    '�C���N�������^���̌��ʁA�C���N�������^�����X�g����\���ɂȂ��Ă�����I�[�_�[No�{�b�N�X�Ƀt�H�[�J�X
    If lstBox_Incremental.Visible = False Then
        '�I�[�_�[No�{�b�N�X��SetFocus
        txtBox_OrderNumber.SetFocus
    End If
    '�C�x���g�ĊJ
    StopEvents = False
End Sub
'Change
'�I�[�_�[No�e�L�X�g�{�b�N�X
Private Sub txtBox_OrderNumber_Change()
    If StopEvents Then
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    'Ucase�|����
    txtBox_OrderNumber.Text = UCase(txtBox_OrderNumber.Text)
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'��z�R�[�h
Private Sub txtBox_F_INV_Tehai_Code_Change()
    '�C�x���g��~��Ԃł͂Ȃ��A�X�ɃA�b�v�f�[�g���[�h�ł��Ȃ��Ƃ��ɃC���N�������^�����s
    If (StopEvents Or UpdateMode) And Not AddnewMode Then
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    '�e�L�X�g��Ucase������
    If frmBinLabel.txtBox_F_INV_Tehai_Code.TextLength >= 1 Then
        frmBinLabel.txtBox_F_INV_Tehai_Code.Text = UCase(frmBinLabel.txtBox_F_INV_Tehai_Code.Text)
    End If
    Select Case AddnewMode
    Case True
        'AddNewMode�̎�(���ʂ�0���ɂȂ��Ă����b�Z�[�W�\�������A���̂܂܃��X�g���\���ɂ���)
        clsIncrementalfrmBIN.Incremental_TextBox_Change True, , True
        'RS�ɔ��f������
        UpdateRSFromContrl ActiveControl
    Case False
        '�ʏ탂�[�h�̎�(����0���ɂȂ����烁�b�Z�[�W�\��)
        '�C���N�������^�����s
        clsIncrementalfrmBIN.Incremental_TextBox_Change False
    End Select
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'�I��
Private Sub txtBox_F_INV_Tana_Local_Text_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    'Ucase
    If frmBinLabel.txtBox_F_INV_Tana_Local_Text.TextLength >= 1 Then
        '���������͂���Ă�����Ucase�|����
        '�C�x���g��~
        StopEvents = True
        'Ucase
        frmBinLabel.txtBox_F_INV_Tana_Local_Text.Text = UCase(frmBinLabel.txtBox_F_INV_Tana_Local_Text.Text)
        '�C�x���g�ĊJ
        StopEvents = False
    End If
    Select Case True
    Case (UpdateMode = True) And (AddnewMode = False)
        '�A�b�v�f�[�g���[�h�ŁA�Ȃ�����AddNewMode����Ȃ���
        'RS�Ɍ��݂̒l��ݒ肷��
        UpdateRSFromContrl ActiveControl
        Exit Sub
    Case (UpdateMode = False) Or (AddnewMode = True)
        '�������[�h(?)�̎����AAddNewMode�̎�(�C���N�������^�����g�p���郂�[�h)
        If TypeName(ActiveControl) <> "TextBox" Then
            '�A�N�e�B�u�R���g���[�����e�L�X�g�{�b�N�X����Ȃ������甲����
            Exit Sub
        End If
        '�C�x���g��~
        StopEvents = True
        'RS������e���擾(listbox��Click�C�x���g�ŌĂ΂��͂�)�����܂�UpdateMode�ɂ��Ă͂����Ȃ�
        'btnEnableEdit��False��
        btnEnableEdit.Enabled = False
        'Ucase�|����
        If ActiveControl.TextLength >= 1 Then
            ActiveControl.Text = UCase(ActiveControl.Text)
        End If
        Select Case AddnewMode
        Case True
            'AddNewMode�̎��AChange���Ă����̃e�L�X�g�{�b�N�X�̒l���������Ȃ�
            clsIncrementalfrmBIN.Incremental_TextBox_Change , , True
        Case False
            '�ʏ퓮��
            clsIncrementalfrmBIN.Incremental_TextBox_Change
        End Select
        If AddnewMode And lstBox_Incremental.ListCount = 1 Then
            '�V�K�ǉ����[�h�ŁA�Ȃ�����₪�c��1�ɂȂ����ꍇ
            '�I�ԃ{�b�N�X�Ƀ��X�g�̒l��ݒ肵�A���X�g���\���ɂ��Ă��܂�
            txtBox_F_INV_Tana_Local_Text.Text = lstBox_Incremental.List(0)
            lstBox_Incremental.Visible = False
        End If
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
    '�C�x���g��~����
    StopEvents = True
    'RS��Update���\�b�h��
    UpdateRSFromContrl ActiveControl
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'�i��2
Private Sub txtBox_F_INV_Label_Name_2_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    'RS��Update���\�b�h��
    UpdateRSFromContrl ActiveControl
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'���l1
Private Sub txtBox_F_INV_Label_Remark_1_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    'RS��Update���\�b�h��
    UpdateRSFromContrl ActiveControl
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'���l2
Private Sub txtBox_F_INV_Label_Remark_2_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    'RS��Update���\�b�h��
    UpdateRSFromContrl ActiveControl
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'''�����L��
Private Sub txtBox_F_INV_Store_Code_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�������Ă��璆�~
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    'Ucase�|����
    txtBox_F_INV_Store_Code.Text = UCase(txtBox_F_INV_Store_Code.Text)
    'RS��Update���\�b�h��
    UpdateRSFromContrl ActiveControl
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'''4701����`�F�b�N�{�b�N�X
Private Sub chkBox_Only4701_Change()
    If StopEvents Or UpdateMode Or AddnewMode Then
        '�C�x���g��~�AUpdateMode�AAddnewMode�����ꂩ�̃t���O�������Ă����珈���𒆒f
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    '�S���ڏ���
    ClearAllContents
    '�f�t�H���g�f�[�^�擾�v���V�[�W��
    SetDefaultValuetoRS
    '�C�x���g�ĊJ
    StopEvents = False
    '�I�ԃ{�b�N�X�Ƀt�H�[�J�X(�C���N�������^�������������͂�)
    txtBox_F_INV_Tana_Local_Text.SetFocus
    Exit Sub
End Sub
'Enter
'�I�ԃe�L�X�g�{�b�N�XEnter
Private Sub txtBox_F_INV_Tana_Local_Text_Enter()
    If (StopEvents Or UpdateMode) And Not AddnewMode Then
        'StopEvent �� UpdateMode�ŁA�Ȃ�����AddNewMode����Ȃ������甲����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    If AddnewMode And chkBoxShowUnUseLocationOnly.Value Then
        'AddNewMode�łȂ������g�p�I�Ԃ̂ݕ\���I�v�V�������Z�b�g����Ă�����A�ŏ��Ɍ��f�[�^��SQL��ύX���A�f�[�^�Ď擾����
        If clsADOfrmBIN.RS.State = ObjectStateEnum.adStateOpen Then
            clsADOfrmBIN.RS.Close
        End If
        clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_ADDNEW_TEHAI_CODE
        clsADOfrmBIN.RS.Open
        clsADOfrmBIN.RS.Filter = ""
        If clsADOfrmBIN.RS.RecordCount < 1 Then
            '���g�p�̒I�Ԃ������Ƃ���RecordCount��0�ɂȂ��Ă�͂�
            MsgBox "���g�p�̒I�Ԃ�����܂���ł����B�V�K�I�ԓo�^�{�^������o�^���ĉ������B"
            'AddNewMode����
            SwitchAddNewMode False
            Exit Sub
        End If
        '�C���N�������^�����s�AEnter�A�t�B���^�ǉ����[�h
        clsIncrementalfrmBIN.Incremental_TextBox_Enter txtBox_F_INV_Tana_Local_Text, lstBox_Incremental, True
    Else
        '�ʏ퓮��
        '�C���N�������^�����s�AEnter
        clsIncrementalfrmBIN.Incremental_TextBox_Enter txtBox_F_INV_Tana_Local_Text, lstBox_Incremental, False
    End If
    '�C�x���g�ĊJ
    StopEvents = False
    Exit Sub
End Sub
Private Sub txtBox_F_INV_Tehai_Code_Enter()
    '�C�x���g��~��Ԃł͂Ȃ��A�X�ɃA�b�v�f�[�g���[�h�ł��Ȃ��Ƃ��ɃC���N�������^�����s
    If (StopEvents Or UpdateMode) And Not AddnewMode Then
        'StopEvents��UpdateMode�łȂ�����AddnewMode����Ȃ����͔�����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    '�C���N�������^�����s�A���X�g��\������̂��ړI
    If AddnewMode Then
        'AddNewMode�̎���SQL����U�ʏ�̂��̂ɕς���Requery����
        If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
            clsADOfrmBIN.RS.Close
        End If
        clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_DEFAULT_DATA
        clsADOfrmBIN.RS.Open
    End If
    clsIncrementalfrmBIN.Incremental_TextBox_Enter frmBinLabel.txtBox_F_INV_Tehai_Code, frmBinLabel.lstBox_Incremental
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
    clsIncrementalfrmBIN.ConstRuctor Me, dicObjNameToFieldName, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc
    'RS�̃f�[�^���擾����
    '�����ł͎擾���Ȃ��ŁA�C���N�������^���T�[�`�ɔC����
'    GetValuFromRS
    '���x���ǉ������R���{�{�b�N�X�̏�����
    Dim longRowCounter As Long
    Dim longarrAddCount(9) As Long
    For longRowCounter = 0 To 9
        longarrAddCount(longRowCounter) = longRowCounter + 1
    Next longRowCounter
    '�I�[�_�[No�e�L�X�g�{�b�N�X��MaxLength�ݒ肷��ړI��LabelTemp�e�[�u���쐬�v���V�[�W���𑖂点��
    RecreateLabelTempTable
    cmbBox_AddLabelCount.List = longarrAddCount
    '�C�x���g�ĊJ����
    StopEvents = False
#If DebugDB Then
    MsgBox "DebugDB�L��"
#End If
End Sub
'''�f�X�g���N�^
Private Sub DestRuctor()
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
'''args
'''AddNewMode(�N���X�ϐ�)      True���Z�b�g����Ă�����A�r����Join��Right Join�ɂȂ�A���g�p�̒I�Ԃ�RS�Ɋ܂܂��悤�ɂȂ�
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
    'AddNewMode�ɂ�菈���𕪊�
    Select Case AddnewMode
    Case True
        '�V�K�ǉ����[�h
        'Tana_��RightJoin�ɂȂ�
        clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_ADDNEW_TEHAI_CODE
    Case False
        '�ʏ퓮��
        '4701����t���O�̗L����SQL�𕪂���
        If chkBox_Only4701.Value Then
            '4701����t���O�������Ă����ꍇ
            clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_DEFAULT_DATA_ONLY_4701
        Else
            '�S�Ẵf�[�^��Ώۂɂ���ꍇ
            clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_DEFAULT_DATA
        End If
    End Select
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
    dicObjNameToFieldName.Add lbl_F_INV_Tana_System_Text.Name, clsEnumfrmBIN.INVMasterTana(F_INV_Tana_System_Text_IMT)
    dicObjNameToFieldName.Add txtBox_F_INV_Store_Code.Name, clsEnumfrmBIN.INVMasterParts(F_Store_Code_IMPrt)
End Sub
'cidObjToField�ɂ���R���g���[���̒l�����ׂď�������
Private Sub ClearAllContents()
    '�C�x���g��~����
    StopEvents = True
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
    '�P�ƂŃI�[�_�[No����
    txtBox_OrderNumber.Text = ""
    '�������X�g�{�b�N�XListIndex��0(1��)��
    cmbBox_AddLabelCount.ListIndex = 0
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
    DebugMsgWithTime "GetValuFromRS code: " & Err.Number & " Description: " & Err.Description
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
    DebugMsgWithTime "MoveRecord code: " & Err.Number & " Description: " & Err.Description
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
        chkBox_Only4701.Enabled = False
        '��z�R�[�h�e�L�X�g�{�b�N�X��Locked�ɂ���
        txtBox_F_INV_Tehai_Code.Locked = True
        'Locked��False�ɂ��āABackColore�𔖗΂ɂ���
        txtBox_F_INV_Tana_Local_Text.Locked = False
        txtBox_F_INV_Tana_Local_Text.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Name_1.Locked = False
        txtBox_F_INV_Label_Name_1.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Name_2.Locked = False
        txtBox_F_INV_Label_Name_2.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Remark_1.Locked = False
        txtBox_F_INV_Label_Remark_1.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Label_Remark_2.Locked = False
        txtBox_F_INV_Label_Remark_2.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
        txtBox_F_INV_Store_Code.Locked = False
        txtBox_F_INV_Store_Code.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
        '�ҏW�\�ݒ�{�^���𖳌���
        btnEnableEdit.Enabled = False
    Case False
        '�ҏW�s�ɂ���Ƃ�
        UpdateMode = False
        chkBox_Only4701.Enabled = True
        'UpdateBatck�{�^����False��
        btnDoUpdate.Enabled = False
        btnCancelUpdate.Enabled = False
        '��z�R�[�h�e�L�X�g�{�b�N�X��Locked����������(�C���N�������^�������ɓ��͂ł���悤�ɂ���)
        txtBox_F_INV_Tehai_Code.Locked = False
        'Locked��True�ɂ��āABackColore��W���w�i�F�ɂ���
        '�I�ԃe�L�X�g�{�b�N�X�͕ҏW�s���[�h�̎��̓C���N�������^���Ɏg���̂�Lock�͂��Ȃ�
'        txtBox_F_INV_Tana_Local_Text.Locked = True
        txtBox_F_INV_Tana_Local_Text.BackColor = FormCommon.TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Name_1.Locked = True
        txtBox_F_INV_Label_Name_1.BackColor = FormCommon.TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Name_2.Locked = True
        txtBox_F_INV_Label_Name_2.BackColor = FormCommon.TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Remark_1.Locked = True
        txtBox_F_INV_Label_Remark_1.BackColor = FormCommon.TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Label_Remark_2.Locked = True
        txtBox_F_INV_Label_Remark_2.BackColor = FormCommon.TXTBOX_BACKCOLORE_NORMAL
        txtBox_F_INV_Store_Code.Locked = True
        txtBox_F_INV_Store_Code.BackColor = FormCommon.TXTBOX_BACKCOLORE_NORMAL
        '�ҏW�\�ݒ�{�^����L����
        btnEnableEdit.Enabled = True
    End Select
End Sub
'''�V�K�ǉ����[�h�ƒʏ탂�[�h���X�C�b�`����
'''���̃��\�b�h���ĂԂ��т�RS�̃f�[�^�̓��Z�b�g�����
'''args
'''IsAddNewMode     True�ɃZ�b�g����ƐV�K�ǉ����[�h�AFalse�ɂ���ƒʏ탂�[�h
Private Sub SwitchAddNewMode(IsAddNewMode As Boolean)
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    'clsIncremental�̃C�x���g���ꎞ��~����
    clsIncrementalfrmBIN.StopEvent = True
    '�C���N�������^�����X�g��Visible��False��
    lstBox_Incremental.Visible = False
    Select Case IsAddNewMode
    Case True
        '�V�K�ǉ����[�h�ɂ���ꍇ
        'AddNew�t���O�𗧂Ă�
        AddnewMode = True
        'UpdateMode���Z�b�g����
        SwitchtBoxEditmode True
        '�ǉ��Ŏ�z�R�[�h�{�b�N�X���ҏW�\�ɂ���
        txtBox_F_INV_Tehai_Code.Locked = False
        txtBox_F_INV_Tehai_Code.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
        '�V�K�ǉ����[�h�{�^��Enabled��False��
        btnAddNewTehaiCode.Enabled = False
        '���g�p�I�ԃ`�F�b�N�{�b�N�XEnabled True
        chkBoxShowUnUseLocationOnly.Enabled = True
        '4701����`�F�b�N�{�b�N�XEnable
        chkBox_Only4701.Enabled = False
        '�S���ڏ���
        ClearAllContents
        'DB���f�[�^�Ď擾
        SetDefaultValuetoRS
        '��U�t�H�[�J�X��I�ԃe�L�X�g�{�b�N�X����O��
        txtBox_F_INV_Tehai_Code.SetFocus
    Case False
        '�ʏ탂�[�h�ɂ���ꍇ
        'AddNew�t���O��������
        AddnewMode = False
        SwitchtBoxEditmode False
        '�V�K�ǉ����[�h�{�^�����g�p�\��
        btnAddNewTehaiCode.Enabled = True
        '���g�p�I�ԃ`�F�b�N�{�b�N�XEnabled False
        chkBoxShowUnUseLocationOnly.Enabled = False
        '4701����`�F�b�N�{�b�N�XEnable
        chkBox_Only4701.Enabled = True
        '��z�R�[�h�{�b�N�X��ҏW�s�ɖ߂�
        '�C���N�������^���Ŏg�p����̂�Locked�͂��̂܂�
        '�F�����߂�
        txtBox_F_INV_Tehai_Code.BackColor = FormCommon.TXTBOX_BACKCOLORE_NORMAL
        '�S���ڏ���
        ClearAllContents
        'DB���f�[�^�Ď擾
        SetDefaultValuetoRS
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "SwitchAddNewMode code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    '�I�ԃe�L�X�g�{�b�N�X�Ƀt�H�[�J�X�Z�b�g(�C�j�V�����l�Z�b�g�����͂�)
    txtBox_F_INV_Tana_Local_Text.SetFocus
    'clsIncremental�̃C�x���g���ĊJ����
    clsIncrementalfrmBIN.StopEvent = False
    Exit Sub
End Sub
''''�e�R���g���[���̒l��RS�ɃZ�b�g����
'''args
'''Optional rsargOnlyParts          AddNewMode�̎��͕K�{�APartsMaster�I�����[��Select���ɑΉ�����RS�A�ʏ��UpdateMode�ł͎g�p���Ȃ��E�E�E�͂�
'''Optional rsargOnlyTana           �I�v�V�����B���̂����I�Ԃ��ꏏ�ɐV�K�o�^����悤�ɂȂ�����I�ԃI�����[��RS���K�v�ɂȂ邩��?�\��g
Private Sub UpdateRSFromContrl(argCtrl As Control, Optional ByRef rsargOnlyParts As ADODB.Recordset, Optional ByRef rsargOnlyTana As ADODB.Recordset)
    On Error GoTo ErrorCatch
    If AddnewMode Then
        'AddNewMode�̎�,rsOnlyParts��rsOnlyTana�̏�������Ԃ��`�F�b�N�A�V�K���R�[�h�`�F�b�N�t���OON
        rsOnlyPartsInitialize True
        Set rsargOnlyParts = rsOnlyPartsMaster
    End If
    If Not dicObjNameToFieldName.Exists(argCtrl.Name) Then
        'dicobjToField�ɑ��݂��Ȃ��R���g���[�����̏ꍇ�͔�����
        Exit Sub
    End If
    If AddnewMode And (rsargOnlyParts Is Nothing) And (rsargOnlyTana Is Nothing) Then
        '�V�K�ǉ����[�h�ŁA��RS���ǂ����Nothing�������甲����
        MsgBox "RecordSet�����������ł����B�����𒆒f���܂�"
        Exit Sub
    End If
    '�Q�ƗpRS��`
    Dim rsRefLocal As ADODB.Recordset
    '�ȉ��A�e�����ɉ�����RS�̎Q�ƌ�������
    Select Case True
    Case UpdateMode And Not AddnewMode
        'UpdateMode�̎�
        '�Ώۂɂ���RS��clsADO�̂���
        Set rsRefLocal = clsADOfrmBIN.RS
    Case AddnewMode
        'AddNewMode
        Select Case True
        Case clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).Properties("BASETABLENAME") = INV_CONST.T_INV_M_Parts
            'AddnewMode�Ńx�[�X�e�[�u������Patrs������
            Set rsRefLocal = rsargOnlyParts
        Case clsADOfrmBIN.RS.Fields(dicObjNameToFieldName(argCtrl.Name)).Properties("BASETABLENAME") = INV_CONST.T_INV_M_Tana
            'AddnewMode�Ńx�[�X�e�[�u����Tana������
            Set rsRefLocal = rsargOnlyTana
        End Select
    End Select          'ModeSelector
    If rsRefLocal Is Nothing Then
        DebugMsgWithTime "UpdateRSRromContrl : refRS is nothing"
        GoTo CloseAndExit
    End If
    '�擾����RS�Q�Ƃɑ΂��ď������s��
    Select Case True
    '�ŏ��ɕ������`�F�b�N���s���A�I�[�o�[���Ă�����ݒ�l�܂Ő؂艺����
    Case Len(argCtrl.Text) > rsRefLocal.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize
        '���������t�B�[���h�ݒ�l�I�[�o�[
        MsgBox "���͂��ꂽ���������ݒ�� " & rsRefLocal.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize & " �����𒴂��Ă��܂��B"
        argCtrl.Text = Mid(argCtrl.Text, 1, rsRefLocal.Fields(dicObjNameToFieldName(argCtrl.Name)).DefinedSize)
        '�؂艺�����f�[�^��RS�ɓo�^����
        rsRefLocal.Fields(dicObjNameToFieldName(argCtrl.Name)).Value = _
        argCtrl.Text
        rsRefLocal.Update
    Case IsNull(rsRefLocal.Fields(dicObjNameToFieldName(argCtrl.Name)).Value), rsRefLocal.Fields(dicObjNameToFieldName(argCtrl.Name)).Value <> argCtrl.Text
        'RS�̒l��Null���A�����̃R���g���[����text�ƈ���Ă���ꍇ
        'rs�ɒl���Z�b�g���āAUpdate�܂ł���iDB�ɔ��f����ɂ�UpdateBatch���Ȃ��ƃ_���j
        rsRefLocal.Fields(dicObjNameToFieldName(argCtrl.Name)).Value = _
        argCtrl.Text
        rsRefLocal.Update
    End Select          'CheckDigit
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "UpdateRSFromContrl code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'Update��RS�ɃR�~�b�g���ꂽ�ύX��DB�Ƀv�b�V������
Private Sub DoUpdateBatch()
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    If AddnewMode Then
        'AddNewMode�̎��͕ʃv���V�[�W����(�A���Ă��Ȃ�)
        AddnewUpdateDB
        Exit Sub
    End If
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
        '�ʏ탂�[�h(�ҏW�s���[�h)�ɖ߂�
        SwitchtBoxEditmode False
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
            'Filter��None�ɂ���
            clsADOfrmBIN.RS.Filter = adFilterNone
            '�ҏW�s���[�h��
            SwitchtBoxEditmode False
'            'RS���f�[�^���擾����
'            GetValuFromRS
            'BookMark��߂�
            clsADOfrmBIN.RS.Bookmark = varBookMark
            GoTo CloseAndExit
        Else
            MsgBox "�X�V�Ɏ��s�����\��������܂� RSStasus: " & clsADOfrmBIN.RS.Status
            GoTo CloseAndExit
        End If
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "DoUpdateBatch code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'''AddNewMode��DB��Update����
Private Sub AddnewUpdateDB()
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    '��z�R�[�h�ƒI�Ԃ̑g�ݍ��킹�œ���̂��̂��Ȃ����`�F�b�N����
    'SQL����U�W���̂��̂�
    If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
        '�ڑ�����Ă������U�ؒf����
        clsADOfrmBIN.RS.Close
    End If
    clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_DEFAULT_DATA
    clsADOfrmBIN.RS.Open , , , , CommandTypeEnum.adCmdText
    Select Case True
    End Select
    'RS�̏������AAddNewStatus�̊m�F
    Select Case True
    Case rsOnlyPartsMaster Is Nothing, Not CBool(rsOnlyPartsMaster.Status And ADODB.RecordStatusEnum.adRecNew)
        'rsOnly�������������ANewRecord�̃t���O�������Ă��Ȃ������甲����
        MsgBox "�o�^�prs�����������A�܂��͐V�K���R�[�h��������܂���"
        GoTo CloseAndExit
    End Select
    'Filter���Z�b�g���Ă��
    clsADOfrmBIN.RS.Filter = dicObjNameToFieldName(txtBox_F_INV_Tana_Local_Text.Name) & " = '" & txtBox_F_INV_Tana_Local_Text.Text & "' AND " & _
                            dicObjNameToFieldName(txtBox_F_INV_Tehai_Code.Name) & " = '" & txtBox_F_INV_Tehai_Code.Text & "'"
    If clsADOfrmBIN.RS.RecordCount >= 1 Then
        DebugMsgWithTime "AddnewUpdateDB : Already exist Tehaicode and LocalTana pair"
        MsgBox "�w��̎�z�R�[�h�ƒI�Ԃ̑g�ݍ��킹�͊��ɑ��݂��܂�" & vbCrLf & _
            "��z�R�[�h: " & txtBox_F_INV_Tehai_Code.Text & vbCrLf & _
            "�I�ԁF " & txtBox_F_INV_Tana_Local_Text.Text
        GoTo CloseAndExit
    End If
    'SQL��AddNewMode��
    If clsADOfrmBIN.RS.State And ObjectStateEnum.adStateOpen Then
        clsADOfrmBIN.RS.Close
    End If
    clsADOfrmBIN.RS.Source = SQL_BIN_LABEL_ADDNEW_TEHAI_CODE
    clsADOfrmBIN.RS.Open , , , , CommandTypeEnum.adCmdText
    '�t�B���^�[�ɒI�Ԃ̃e�L�X�g��ݒ�
    clsADOfrmBIN.RS.Filter = dicObjNameToFieldName(txtBox_F_INV_Tana_Local_Text.Name) & " = '" & txtBox_F_INV_Tana_Local_Text.Text & "'"
    If clsADOfrmBIN.RecordCount < 1 Then
        MsgBox "�w��̒I�Ԃ�������܂���ł����B�I�ԐV�K�o�^��ʂœo�^���Ȃ����Ă݂ĉ������B"
        GoTo CloseAndExit
    ElseIf clsADOfrmBIN.RecordCount > 1 Then
        MsgBox "�w��̒I�Ԃŕ����̃��R�[�h������܂����BDB�̃����e�i���X���K�v�ł��B"
        GoTo CloseAndExit
    End If
    '�o�^��Ƃɓ���
    'tana_ID��ޔ�
    Dim longTanaID As Long
    longTanaID = clsADOfrmBIN.RS.Fields(clsEnumfrmBIN.INVMasterTana(F_INV_TANA_ID_IMT)).Value
    'rsOnlyParts�̏������m�F
    rsOnlyPartsInitialize
    'PartsOnly�ɑޔ�����TanaID��ݒ�
    rsOnlyPartsMaster.Fields(clsEnumfrmBIN.INVMasterParts(F_Tana_ID_IMPrt)).Value = longTanaID
    'InputDate����
    rsOnlyPartsMaster.Fields(PublicConst.INPUT_DATE).Value = GetLocalTimeWithMilliSec
    'RS���m��
    rsOnlyPartsMaster.Update
    'RS�̃t�B���^���Đݒ�A�萔�̂��̂�
    rsOnlyPartsMaster.Filter = adFilterNone
    rsOnlyPartsMaster.Filter = adFilterPendingRecords
    If Not CBool(rsOnlyPartsMaster.BOF And rsOnlyPartsMaster.EOF) And CBool(rsOnlyPartsMaster.Status And ADODB.RecordStatusEnum.adRecNew) Then
        '���R�[�h�����݂��A�Ȃ�����RS�̏�Ԃ��V�K���R�[�h�L�̏ꍇ
        rsOnlyPartsMaster.UpdateBatch adAffectGroup
    End If
    If rsOnlyPartsMaster.Status And ADODB.RecordStatusEnum.adRecUnmodified Then
        MsgBox "����ɒǉ�����܂���"
        '���߂ăC�x���g��~����
        StopEvents = True
        '�ʏ탂�[�h�֖߂�
        SwitchAddNewMode False
        '�C�x���g�ĊJ����
        StopEvents = False
    Else
        MsgBox "�ǉ��Ɏ��s���܂���"
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "AddnewUpdateDB code: " & Err.Number & " Description: " & Err.Description
    MsgBox "�o�^���ɃG���[���������܂��� " & vbCrLf & Err.Description
    rsOnlyPartsMaster.CancelUpdate
    rsOnlyPartsMaster.CancelBatch
    GoTo CloseAndExit
CloseAndExit:
    '�ꎞ�I�Ɏg�p����RSonly�̐ڑ���ؒf����
    If rsOnlyPartsMaster.State And ObjectStateEnum.adStateOpen Then
        rsOnlyPartsMaster.Close
        Set rsOnlyPartsMaster = Nothing
    End If
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'''rsOnlyParts�̏��������s��
'''args
'''Optional CheckNewRecord      True���Z�b�g����ƐV�K���R�[�h�ǉ�����Ă��Ȃ�����AddNew�܂ł���Ă��܂�
Private Sub rsOnlyPartsInitialize(Optional CheckNewRecord As Boolean)
    On Error GoTo ErrorCatch
    If rsOnlyPartsMaster Is Nothing Then
        '����������ĂȂ�������
        Set rsOnlyPartsMaster = New ADODB.Recordset
    End If
    If Not CBool(rsOnlyPartsMaster.State And ObjectStateEnum.adStateOpen) Then
        '�ڑ�����Ă��Ȃ������珉��ڑ����s��
        '�o�^�p��PartsMaster�݂̂�Select��RecordSet��V���ɐݒ�
        'Connection�̓N���X���L�ϐ��̕���ݒ�
        Set rsOnlyPartsMaster.ActiveConnection = clsADOfrmBIN.RS.ActiveConnection
        'PartsMaster�I�����[��SQL���Z�b�g
        rsOnlyPartsMaster.Source = SQL_BIN_LABEL_ONLY_PARTS
        rsOnlyPartsMaster.LockType = adLockBatchOptimistic
        rsOnlyPartsMaster.CursorType = adOpenStatic
        rsOnlyPartsMaster.CursorLocation = adUseClient
        'RS�I�[�v��
        rsOnlyPartsMaster.Open , , , , CommandTypeEnum.adCmdText
    End If
    If CheckNewRecord Then
        '�V�K���R�[�h�`�F�b�N�t���O�������Ă�����
        Select Case True
        Case Not CBool(rsOnlyPartsMaster.Status And ADODB.RecordStatusEnum.adRecNew)
            'rs�ɐV�K���R�[�h�t���O�������Ă��Ȃ������ꍇ
            'AddNew����
            rsOnlyPartsMaster.AddNew
        End Select
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "rsOnlyPartsInitialize code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
''''�ύX���ꂽ���e��j�����Č��ɖ߂�
'''args
'''Optional NoConfirm           True���Z�b�g����Ɗm�F�����ŃL�����Z������A�f�t�H���g��False
Private Sub CancelUpdateBatch(Optional NoConfirm As Boolean = False)
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
        If Not NoConfirm Then
            MsgBox "�ύX�_�͂���܂���ł���"
        End If
        '�t�B���^��߂��H
        clsADOfrmBIN.RS.Filter = varOldFilter
        If clsADOfrmBIN.RS.Supports(adBookmark) Then
            'BookMark�L���Ȃ�BookMark��߂�
            clsADOfrmBIN.RS.Bookmark = varBookMark
        End If
        '�ҏW�s���[�h��
        SwitchtBoxEditmode False
        If AddnewMode Then
            'AddNewMode�̎��͂��������������Ă��
            SwitchAddNewMode False
        End If
        GoTo CloseAndExit
    Case clsADOfrmBIN.RS.Status And adRecModified
        'Status���ύX�L�ɂȂ��Ă���
        '�L�����Z�����Ă������₢���킹
        Dim longMsgBoxRet As Long
        If Not NoConfirm Then
            longMsgBoxRet = MsgBox("���e���ύX����Ă��܂��A�ύX��j�����Ă��ǂ��ł���?", vbYesNo)
        End If
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
            If Not NoConfirm Then
                MsgBox "�ύX�_�𖳎��ɔj�����܂����B"
            End If
            '�t�B���^��߂��H
            clsADOfrmBIN.RS.Filter = varOldFilter
            If clsADOfrmBIN.RS.Supports(adBookmark) Then
                'BookMark�L���Ȃ�BookMark��߂�
                clsADOfrmBIN.RS.Bookmark = varBookMark
            End If
            '�ҏW�s���[�h��
            SwitchtBoxEditmode False
            If AddnewMode Then
                'AddNewMode�̎��͂��������������Ă��
                SwitchAddNewMode False
            End If
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
    DebugMsgWithTime "CancelUpdateBatch code: " & Err.Number & " Description: " & Err.Description
    If Err.Number = -2147217906 Then
        '�u�b�N�}�[�N�������ł��̃G���[�̎���(�ύX�㓙�Ńu�b�N�}�[�N���ړ�)�ҏW�s���[�h�֖߂��Ă��
        SwitchtBoxEditmode False
    End If
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
'    'SavePoint�����ɂ��A�e�[�u���폜�͕ʃv���V�[�W���Ŕ��f����
    '�e�[�u�����݃`�F�b�N���A����������쐬����
    If Not clsADOLabelTemp.IsTableExists(INV_CONST.T_INV_LABEL_TEMP) Then
        '���x���ꎞ�e�[�u�������݂��Ȃ�����
        '���x���ꎞ�e�[�u�����쐬����
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
        dicReplaceLabelTemp.Add 8, INV_CONST.F_INV_LABEL_TEMP_TEHAICODE_LENGTH
        dicReplaceLabelTemp.Add 9, INV_CONST.F_INV_LABEL_TEMP_ORDERNUM
        dicReplaceLabelTemp.Add 10, INV_CONST.F_INV_LABEL_TEMP_SAVEPOINT
        dicReplaceLabelTemp.Add 11, INV_CONST.F_INV_LABEL_TEMP_FORMSTARTTIME
        dicReplaceLabelTemp.Add 12, clsEnumfrmBIN.INVMasterParts(F_Store_Code_IMPrt)
        'Replace���s�ASQL�ݒ�
        clsADOLabelTemp.SQL = clsSQLBc.ReplaceParm(INV_CONST.SQL_INV_CREATE_LABEL_TEMP_TABLE, dicReplaceLabelTemp)
        'Write�t���O���Ă�
        clsADOLabelTemp.ConnectMode = clsADOLabelTemp.ConnectMode Or adModeWrite
        'SQL���s
        Dim isCollect As Boolean
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
    '�I�[�_�[No�e�L�X�g�{�b�N�X��Maxlength��RS��DefinedSize���Z�b�g���Ă��
    txtBox_OrderNumber.MaxLength = rsLabelTemp.Fields(INV_CONST.F_INV_LABEL_TEMP_ORDERNUM).DefinedSize
    DebugMsgWithTime "RecreateLabelTempTable: Recreate Label Temp Table Success"
    RecreateLabelTempTable = True
    GoTo CloseAndExit
    Exit Function
ErrorCatch:
    DebugMsgWithTime "RecreateLabelTempTable code: " & Err.Number & " Description: " & Err.Description
    RecreateLabelTempTable = False
    GoTo CloseAndExit
CloseAndExit:
    If Not clsADOLabelTemp Is Nothing Then
        clsADOLabelTemp.CloseClassConnection
        Set clsADOLabelTemp = Nothing
    End If
    Exit Function
End Function
'''���݂�RS�̃f�[�^�����x���e�[�u���ɒǉ�����
Private Sub AddNewRStoLabelTemp()
    On Error GoTo ErrorCatch
    If Not rsLabelTemp.State And ObjectStateEnum.adStateOpen Then
        '�ڑ����Ă��Ȃ�������ڑ�����
        rsLabelTemp.Open
    End If
    '�����I������ĂȂ������甲����
    If cmbBox_AddLabelCount.ListIndex = -1 Then
        MsgBox "�ǉ����閇����I�����ĉ�����"
        cmbBox_AddLabelCount.SetFocus
        Exit Sub
    End If
    '�����R���{�{�b�N�X���ǉ�����
    Dim longAddCount As Long
    For longAddCount = 1 To cmbBox_AddLabelCount.List(cmbBox_AddLabelCount.ListIndex)
        '�V�K���R�[�h��ǉ�����
        rsLabelTemp.AddNew
        Dim varKeyobjDic As Variant
        'dicObjtoField�����[�v���ArsLabelTemp�Ƀf�[�^��ݒ肷��
        If dicObjNameToFieldName.Exists(Empty) Then
            dicObjNameToFieldName.Remove Empty
        End If
        For Each varKeyobjDic In dicObjNameToFieldName
            Select Case True
            '�b��Ή��A���x��Table�ɒǉ����Ȃ����ڂ��t�H�[���ɕ\������悤�ɂȂ�������
            'Label�R���g���[���̏ꍇ�͉������Ȃ��Ŕ�����
            Case TypeName(Me.Controls(varKeyobjDic)) = "Label"
                '���x���R���g���[���̎��͉������Ȃ�
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
        '����̃t�H�[���X�^�[�g���Ԃ�FormStartTime�Ƃ��ē���
        rsLabelTemp.Fields(INV_CONST.F_INV_LABEL_TEMP_FORMSTARTTIME).Value = strStartTime
        'InputDate�͌��ݎ���
        rsLabelTemp.Fields(PublicConst.INPUT_DATE).Value = GetLocalTimeWithMilliSec
        '��z�R�[�h�̕����񐔂��Z�b�g
        rsLabelTemp.Fields(INV_CONST.F_INV_LABEL_TEMP_TEHAICODE_LENGTH).Value = Len(Trim(rsLabelTemp.Fields(clsEnumfrmBIN.INVMasterParts(F_Tehai_Code_IMPrt)).Value))
        '�I�[�_�[No���Z�b�g�A�擪����t�B�[���h�T�C�Y���܂�
        rsLabelTemp.Fields(INV_CONST.F_INV_LABEL_TEMP_ORDERNUM).Value = Mid(txtBox_OrderNumber.Text, 1, rsLabelTemp.Fields(INV_CONST.F_INV_LABEL_TEMP_ORDERNUM).DefinedSize)
        'SavePoint���Z�b�g�A�擪����t�B�[���h�T�C�Y���܂�
        rsLabelTemp.Fields(INV_CONST.F_INV_LABEL_TEMP_SAVEPOINT).Value = Mid(strSavePoint, 1, rsLabelTemp.Fields(INV_CONST.F_INV_LABEL_TEMP_SAVEPOINT).DefinedSize)
        'Update�Ń��[�J����RS���m�肷��
        rsLabelTemp.Update
        'InputDate�����炷����Sleep 1 (0.001)
        Sleep 1
    Next longAddCount
    'rsLabel��Filter��PendingRecords�A�ύX�𖢑��M�ɐݒ肵�AUpdateBatch�������ADB�ɔ��f����
    rsLabelTemp.Filter = adFilterNone
    rsLabelTemp.Filter = adFilterPendingRecords
    rsLabelTemp.UpdateBatch adAffectGroup
    rsLabelTemp.Filter = adFilterNone
    If rsLabelTemp.Status And ADODB.RecordStatusEnum.adRecUnmodified Then
        MsgBox "����� " & cmbBox_AddLabelCount.List(cmbBox_AddLabelCount.ListIndex) & " ���ꎞ�e�[�u���ɒǉ�����܂���"
        '���̘A���w��̂��߂ɒI�ԃe�L�X�g�{�b�N�X��SetFocus
        txtBox_F_INV_Tana_Local_Text.SetFocus
    End If
    GoTo CloseAndExit
    Exit Sub
ErrorCatch:
    DebugMsgWithTime "AddNewRStoLabelTemp code: " & Err.Number & " Description: " & Err.Description
    MsgBox "���x������p�ꎞ�e�[�u���o�^���ɃG���[�������������߁A����̓o�^�̓L�����Z������܂���"
    rsLabelTemp.CancelUpdate
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''Label Temp�e�[�u�����獷�����݈�������s����
'''args
'''strargTemplateWordFile               �������݈���t�B�[���h�ݒ�ς݃e���v���[�g����
'''Optional strargPlaneDocTemplete      �v�����^�ύX���K�v�ȃe���v���[�g���AApplicaion�C�x���g���g�p�������ꍇ�Ɏw�肷��A��̃t�@�C��
'''                                     ��t�@�C���̗v���ͤ�C�x���g�ɕK�v��modLabel_BIN��clsWordAppEvents�N���X���������Ă��邱��
Private Sub MailMergeDocCreate(strargMailMergeTemplateFile As String, Optional strargPlaneDocTemplete As String)
    On Error GoTo ErrorCatch
    '�e���v���[�g�����̑��݊m�F
    Dim fsoMailMerge As FileSystemObject
    Set fsoMailMerge = New FileSystemObject
    'clsADO�̓f�t�H���g��DB�f�B���N�g�����擾����ʂɂ����g��Ȃ��̂ŒP�Ƃō쐬
    Dim clsADOMailMerge As clsADOHandle
    Set clsADOMailMerge = CreateclsADOHandleInstance
    'DBPath���f�t�H���g��
    clsADOMailMerge.SetDBPathandFilenameDefault
    'DBFileName��TempDB��
    clsADOMailMerge.DBFileName = PublicConst.TEMP_DB_FILENAME
    If Not fsoMailMerge.FileExists(strargMailMergeTemplateFile) Then
        '�t�@�C�������݂��Ȃ�����
        MsgBox "�������݈���p�̃e���v���[�g�t�@�C����������܂���ł���"
        GoTo CloseAndExit
    End If
    'PlaneDoc���w�肳��Ă���ꍇ�͂�����̃t�@�C���̑��݊m�F��
    If strargPlaneDocTemplete <> "" Then
        If Not fsoMailMerge.FileExists(strargPlaneDocTemplete) Then
            MsgBox "�������݈���p�̃C�x���g��`�t�@�C����������܂���ł����B"
            GoTo CloseAndExit
        End If
    End If
    'T_LABEL_TEMP�̑��݊m�F
    If Not clsADOMailMerge.IsTableExists(INV_CONST.T_INV_LABEL_TEMP) Then
        DebugMsgWithTime "MailMergeDocCreate : T_LABEL_TEMP not exists"
        MsgBox "����p�̃f�[�^���o�^����Ă��܂���ł���"
        GoTo CloseAndExit
    End If
    'SavePoint�̊m�F�A�I�����s��
    Dim isCollect As Boolean
    isCollect = CheckandSelectSavePoint
    If Not isCollect Then
        DebugMsgWithTime "MailMergeDocCreate : select save point fail"
'        MsgBox "������X�g�̑I���ŃG���[���������܂���"
        GoTo CloseAndExit
    End If
    'SQL��ݒ�
    Dim strSQL As String
    Dim dicReplace As Dictionary
    Set dicReplace = New Dictionary
    dicReplace.RemoveAll
'    'BinLabel MailMerge�p��b�f�[�^�擾�A�I�����ʂ�Where�����œK�p
    dicReplace.Add 0, INV_CONST.T_INV_LABEL_TEMP
    dicReplace.Add 1, clsSQLBc.ReturnMailMergeWhere(frmBinLabel.varstrarrSelectedSavepoint)
    dicReplace.Add 2, INV_CONST.T_INV_SELECT_TEMP
    '255�����𒴂��Ă��MailMerge��SQL�Ƃ��Ă͂��߂炵���̂ŁA��U��Ɨp�e�[�u���ɏ����o��
    'Write�t���O�グ��
    clsADOMailMerge.ConnectMode = clsADOMailMerge.ConnectMode Or adModeWrite
    'SelectTemp�e�[�u���폜
    isCollect = clsADOMailMerge.DropTable(INV_CONST.T_INV_SELECT_TEMP)
    If Not isCollect Then
        MsgBox "���Ԏ��Ɨp�e�[�u���̍폜�Ɏ��s���܂���"
        GoTo CloseAndExit
    End If
    clsADOMailMerge.SQL = clsSQLBc.ReplaceParm(INV_CONST.SQL_LABEL_MAILMERGE_DEFAULT, dicReplace)
    '�����\�[�g�I�v�V�������w�肳��Ă�����SQL�ɒǋL���Ă��
    If chkBox_SortByLocationASC.Value Then
        '�I�ԏ����\�[�g�w�肪�Ȃ���Ă���
        clsADOMailMerge.SQL = clsADOMailMerge.SQL & vbCrLf & " ORDER BY [" & clsEnumfrmBIN.INVMasterTana(F_INV_Tana_Local_Text_IMT) & "] ASC" & _
        ",[" & INV_CONST.F_INV_LABEL_TEMP_ORDERNUM & "] ASC"
    End If
    'Seletc INTO ���s
    isCollect = clsADOMailMerge.Do_SQL_with_NO_Transaction
    'write�t���O������
    clsADOMailMerge.ConnectMode = clsADOMailMerge.ConnectMode And Not adModeWrite
    If Not isCollect Then
        MsgBox "���o���ʂ𒆊ԍ�Ɨp�e�[�u���ɓo�^����ۂɃG���[���������܂���"
        GoTo CloseAndExit
    End If
    'MailMerge��SelectedTable�̑S�I���I�����[��
    strSQL = "SELECT * FROM [" & INV_CONST.T_INV_SELECT_TEMP & "]"
    'wordDocuments�𓾂�
#If RefWord Then
    'word�̎Q�Ɛݒ肪����Ă���ꍇ
    Dim objWord As Word.Application
    Set objWord = New Word.Application
#Else
    Dim objWord As Object
    Set objWord = CreateObject("Word.Application")
#End If
'    Dim docTemplateMailMerge As Word.Document
    Dim docTemplateMailMerge As Object
    '���x���v�����g�p�e���v���[�g���J��
    Set docTemplateMailMerge = objWord.Documents.Open(Filename:=strargMailMergeTemplateFile)
    With docTemplateMailMerge.MailMerge
        '�f�[�^�\�[�X���J��
        .OpenDataSource Name:=fsoMailMerge.BuildPath(clsADOMailMerge.DBPath, PublicConst.TEMP_DB_FILENAME), ReadOnly:=True, sqlstatement:=strSQL
        '���ʂ͐V�K�h�L�������g��
        .Destination = 0                'wdSendToNewDocument
        '�������݈�����s
        .Execute
    End With
    '�������݈���̌��ʂ�Document���擾
#If RefWord Then
    'Word���Q�Ɛݒ肳��Ă���ꍇ
    Dim docNewMailMerge As Word.Document
#Else
    'word���Q�Ɛݒ肳��Ă��Ȃ��ꍇ
    Dim docNewMailMerge As Object
#End If
    Set docNewMailMerge = objWord.ActiveDocument
    '�I���W�i����Document�͕ۑ������ɕ���
    docTemplateMailMerge.Close savechanges:=False
    '���������̏�����Application�C�x���g����������K�v�̂���t�@�C���̂�
    If Not strargPlaneDocTemplete = "" Then
        '�������݌��ʂ��ꎞ�ۑ����邽�߂̃t�@�C�������擾
        Dim strTempMailmergeFullPath As String
        strTempMailmergeFullPath = fsoMailMerge.BuildPath(clsADOMailMerge.DBPath, GetTimeForFileNameWithMilliSec & "_Local.docx")
        '�������݌��ʂ��ꎞ�t�@�C���ɕۑ��A�ۑ��`����doc Xml�t�H�[�}�b�g(�f�t�H���g�𖾎��I�Ɏw��)
        docNewMailMerge.SaveAs2 Filename:=strTempMailmergeFullPath, FileFormat:=16              'wdFormatDocumentDefault 16
        '�ۑ����I�������Document�����
        docNewMailMerge.Close savechanges:=False
        '���x������pPlane�������J���ADocument�I�u�W�F�N�g�𓾂�
#If RefWord Then
        'Word�Q�Ɛݒ肪����Ă���ꍇ
        Dim docLabelPlane As Word.Document
#Else
        '�Q�Ɛݒ�Ȃ��̏ꍇ
        Dim docLabelPlane As Object
#End If
        'Label�pPlane�������e���v���[�g���ĐV�K�������J��
        objWord.Documents.Add Template:=strargPlaneDocTemplete
        '�V�K������Dobument�I�u�W�F�N�g�𓾂�
        Set docLabelPlane = objWord.ActiveDocument
        'Applicatoin�C�x���g�n���h���p�ɁAobjWord��Application�Q�Ƃ��Z�b�g���Ă��
        objWord.Run "modLabel_BIN.SetAppRefForEvent", objWord
        '�J����Plane�����̐擪�ɍ������݌��ʂ��C���|�[�g����
        docLabelPlane.Range(0, 0).InsertFile Filename:=strTempMailmergeFullPath, link:=False, attachment:=False
        '�C���|�[�g����������ꎞ�ۑ������������݌��ʃt�@�C�����폜����
        Kill strTempMailmergeFullPath
    End If
    '�������狤�ʏ���
    objWord.Visible = True
    '�e�[�u���폜�̓v���V�[�W����������
    DeleteCompDataFromLabelTemp
    '����I�������SavePointo��������
    strSavePoint = ""
    lbl_SavePointName.Caption = ""
    FormCommon.strSavePointName = ""
    ForceForeground objWord.Windows(1).hwnd
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "btnCreateMailmergeDoc_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsADOMailMerge Is Nothing Then
        clsADOMailMerge.CloseClassConnection
        Set clsADOMailMerge = Nothing
    End If
    If Not objWord Is Nothing Then
'        objWord.Quit
'        Set objWord = Nothing
    End If
    Set fsoMailMerge = Nothing
    Exit Sub
End Sub
'''�������ۂ̎��ʖ���I������
'''Return bool  ����������True�A����ȊO��False
Private Function CheckandSelectSavePoint() As Boolean
    On Error GoTo ErrorCatch
    '�����݂̂Ŏg�p����Ado�Ȃ̂Ōʐ錾����
    Dim clsadoSavePoint As clsADOHandle
    Set clsadoSavePoint = CreateclsADOHandleInstance
    '�f�t�H���g�f�B���N�g����
    clsadoSavePoint.SetDBPathandFilenameDefault
    'DB�t�@�C�����݈̂ꎞDB�̕���
    clsadoSavePoint.DBFileName = PublicConst.TEMP_DB_FILENAME
    'LabelTemp�e�[�u���̑��݂��`�F�b�N���A������΍쐬����
    Dim isCollect As Boolean
    If Not clsadoSavePoint.IsTableExists(INV_CONST.T_INV_LABEL_TEMP) Then
        'LabelTempTable�����݂��Ȃ�����
        isCollect = RecreateLabelTempTable
        If Not isCollect Then
            DebugMsgWithTime "CheckandSelectSavePoint : Create LabelTempTable Fail"
            MsgBox "������i�[�ꎞ�e�[�u���̍쐬�Ɏ��s���܂���"
            GoTo CloseAndExit
        End If
    End If
    'SQL�ݒ�AGroup By SavePoint,InputDate Oeder by inputdate desc,SavePoint asc
    Dim dicReplace As Dictionary
    Set dicReplace = New Dictionary
    dicReplace.RemoveAll
    dicReplace.Add 0, INV_CONST.F_INV_LABEL_TEMP_SAVEPOINT
    dicReplace.Add 1, INV_CONST.F_INV_LABEL_TEMP_FORMSTARTTIME
    dicReplace.Add 2, INV_CONST.T_INV_LABEL_TEMP
    dicReplace.Add 3, INV_CONST.F_INV_LABEL_TEMP_SAVE_FRENDLYNAME
    dicReplace.Add 4, INV_CONST.F_INV_LABEL_TEMP_FRMSTART_FRENDLYNAME
    clsadoSavePoint.SQL = clsSQLBc.ReplaceParm(INV_CONST.SQL_SELECT_SAVEPOINT, dicReplace)
    'SQL���s
    isCollect = clsadoSavePoint.Do_SQL_with_NO_Transaction
    If Not isCollect Then
        'SQL���s���s
        MsgBox "CheckandSetSavePoint : ���x���ꎞ�e�[�u���̎��ʔԍ��ꗗ�ǂݎ��Ɏ��s���܂���"
        CheckandSelectSavePoint = False
        GoTo CloseAndExit
    End If
    'RecordCount�ɂ�菈���𕪊�
    Select Case clsadoSavePoint.RecordCount
    Case 0
        '���R�[�h�����̏ꍇ
        MsgBox "���x���ꎞ�e�[�u���Ƀf�[�^��������܂���ł���"
        CheckandSelectSavePoint = False
        GoTo CloseAndExit
    Case 1
        '1�̏ꍇ�͑I����ʂ��o�����Ɍ��݂̍��ڂ��Z�b�g���Ă��
        ReDim varstrarrSelectedSavepoint(0, 1)
        'rs.MoveFirst����
        clsadoSavePoint.RS.MoveFirst
        varstrarrSelectedSavepoint(0, 0) = CStr(clsadoSavePoint.RS.Fields(INV_CONST.F_INV_LABEL_TEMP_SAVE_FRENDLYNAME).Value)
        varstrarrSelectedSavepoint(0, 1) = CStr(clsadoSavePoint.RS.Fields(INV_CONST.F_INV_LABEL_TEMP_FRMSTART_FRENDLYNAME).Value)
        CheckandSelectSavePoint = True
        GoTo CloseAndExit
    Case Is >= 2
        '������SavePoint�����������ꍇ�͑I����ʂ�ݒ�A�\������
        Load frmSelectSavePoint
        frmSelectSavePoint.lstBoxSavePoint.List = clsadoSavePoint.RS_Array
        frmSelectSavePoint.lstBoxSavePoint.ColumnCount = 2
        'Modal�őI����ʂ�\������(����������\����̃t�H�[���Ŏ��gUnload���ď������߂��Ă���͂�)
        frmSelectSavePoint.Show vbModal
        If IsEmpty(varstrarrSelectedSavepoint) Then
            '����Variant��Empty���Z�b�g����Ă����A�I����ʂŉ������s�������ۂ�
'            MsgBox "���X�g���ʖ��I����ʂŃG���[���������܂���"
            CheckandSelectSavePoint = False
            GoTo CloseAndExit
        End If
        '�����܂Ŕ����Ă�����Ƃ肠�����I���͏�肭�������ƔF��
        CheckandSelectSavePoint = True
        GoTo CloseAndExit
    End Select
ErrorCatch:
    CheckandSelectSavePoint = False
    DebugMsgWithTime "CheckandSelectSavePoint code: " & Err.Number & " Description " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsadoSavePoint Is Nothing Then
        '�ڑ��ؒf�ƃC���X�^���X�j��
        clsadoSavePoint.CloseClassConnection
        Set clsadoSavePoint = Nothing
    End If
    Exit Function
End Function
'''SavePoint���Z�b�g����
Private Sub SetSavePoint()
    Select Case True
    Case strSavePoint = ""
        'strSavePoint���󕶎��������Ƃ������Ƃ͍��񏉎��s�Ȃ̂ŁA���ʖ�����͂��Ă��炤
        'frmSetSavePoint �\���A�I������珟��Ɍ�������Unload���ď������߂��Ă���͂�
        frmSetSavePoint.Show vbModal
        If FormCommon.strSavePointName = "" Then
            '�󕶎����Ԃ��Ă����A�L�����Z�����ꂽ���󕶎��ɂ��ꂽ���ǂ�����
            'GetLocalTime�ŗǂ��Ǝv��
            FormCommon.strSavePointName = GetLocalTimeWithMilliSec
        End If
        '���ʂ����[�J���ϐ��ɔ��f
        strSavePoint = FormCommon.strSavePointName
        '23���������Ă���؂艺����
        If Len(strSavePoint) > 23 Then
            strSavePoint = Mid(strSavePoint, 1, 23)
        End If
        'SavePoint���x���ɒl���Z�b�g
        lbl_SavePointName.Caption = strSavePoint
        'strStartTime�Ɏ��Ԃ��Z�b�g
        strStartTime = GetLocalTimeWithMilliSec
        Exit Sub
    End Select
End Sub
'''�������������LabelTemp�̃f�[�^���폜����
'''���R�[�h�J�E���g��0�ɂȂ�����e�[�u������������
Private Sub DeleteCompDataFromLabelTemp()
    On Error GoTo ErrorCatch
    '�ʂ�Connection���肽���̂ŁA�Ɨ�����clsADO���`
    Dim clsAdoDeleteComp As clsADOHandle
    Set clsAdoDeleteComp = CreateclsADOHandleInstance
    'DBPath,DBFilename���ꎞDB�̕���
    clsAdoDeleteComp.SetDBPathandFilenameDefault
    clsAdoDeleteComp.DBFileName = PublicConst.TEMP_DB_FILENAME
    Dim dicRepladeDelete As Dictionary
    Set dicRepladeDelete = New Dictionary
    dicRepladeDelete.RemoveAll
    dicRepladeDelete.Add 0, INV_CONST.T_INV_LABEL_TEMP
    dicRepladeDelete.Add 1, clsSQLBc.ReturnMailMergeWhere(varstrarrSelectedSavepoint)
    'SQL�ݒ�
    clsAdoDeleteComp.SQL = clsSQLBc.ReplaceParm(SQL_DELET_COMP_DATA_FROM_LABEL_TEMP, dicRepladeDelete)
    'Write�t���O�グ��
    clsAdoDeleteComp.ConnectMode = clsAdoDeleteComp.ConnectMode Or adModeWrite
    'SQL���s
    Dim isCollect As Boolean
    isCollect = clsAdoDeleteComp.Do_SQL_with_NO_Transaction
    If Not isCollect Then
        MsgBox "��������f�[�^�̍폜�Ɏ��s���܂���"
        GoTo CloseAndExit
    End If
    '�c��f�[�^0��������e�[�u���폜
    '��ULabelTemp�̑S�f�[�^�擾
    clsAdoDeleteComp.SQL = "SELECT * FROM " & INV_CONST.T_INV_LABEL_TEMP
    'SQL���s
    isCollect = clsAdoDeleteComp.Do_SQL_with_NO_Transaction
    If clsAdoDeleteComp.RecordCount = 0 Then
        'RecordCount0��������e�[�u���폜
        isCollect = clsAdoDeleteComp.DropTable(INV_CONST.T_INV_LABEL_TEMP)
    End If
    If Not isCollect Then
        MsgBox "�ꎞ�e�[�u���̍폜�Ɏ��s���܂���"
        GoTo CloseAndExit
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "DeleteCompDataFromLabelTemp code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    If Not clsAdoDeleteComp Is Nothing Then
        'Write�t���O������
        clsAdoDeleteComp.ConnectMode = clsAdoDeleteComp.ConnectMode And Not adModeWrite
        '�R�l�N�V�����ؒf
        clsAdoDeleteComp.CloseClassConnection
        Set clsAdoDeleteComp = Nothing
    End If
    Exit Sub
End Sub
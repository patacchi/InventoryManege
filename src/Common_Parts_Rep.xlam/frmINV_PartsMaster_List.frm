VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmINV_PartsMaster_List 
   Caption         =   "�݌ɏ��}�X�^�[�\�����"
   ClientHeight    =   3765
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   15120
   OleObjectBlob   =   "frmINV_PartsMaster_List.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmINV_PartsMaster_List"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'�t�H�[�������ʂ̃����o�ϐ����`
'�C���X�^���X���L�ϐ�
Private clsADOfrmPMList As clsADOHandle
Private clsINVDBfrmPMList As clsINVDB
Private clsEnumPMList As clsEnum
Private clsSQLBc As clsSQLStringBuilder
Private clsIncrementalParts As clsIncrementalSerch
Private clsGetIEfrmPMList As clsGetIE
Private objExxelfrmPMList As Excel.Application
'key���I�u�W�F�N�g���ŁA�l���e�[�u���G�C���A�X�t���̃t�B�[���h��
Private dicObjNameToFieldName As Dictionary
'�萔��`
Private Const TEXT_BOX_NAME_PREFIX As String = "txtBox_"
Private Const LABEL_NAME_PREFIX As String = "lbl_"
'''Tana�}�X�^�[��Local_Text���ꊇ�ݒ肷��
'''Null�ɂȂ��Ă���ꏊ��System_Text�̕��Őݒ肵�Ă��
Private Sub btnTehai_Text_Local_Set_All_Click()
    On Error GoTo ErrorCatch
    '�N���X�ϐ��̊m�F
    If clsADOfrmPMList Is Nothing Then
        Set clsADOfrmPMList = CreateclsADOHandleInstance
    End If
    If clsEnumPMList Is Nothing Then
        Set clsEnumPMList = CreateclsEnum
    End If
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
    End If
'{0}    T_INV_M_Tana
'{1}    TDBTana
'{2}    (SET condition) TDBTana.F_INV_LOCAL_TEXT = TDBTana.F_INV_SYSTEM_Text
'{3}    (WHERE condition) AND TDBTana.LOCAL_TExt IS NULL
'Public Const SQL_INV_TANA_SET_LOCAL_TEXT_BY_SYSTEM As String = "UPDATE {0} AS {1} " & vbCrLf
    'Set
    Dim strSetCondition As String
    Dim strarrSetCondition(2) As String
    strarrSetCondition(0) = clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_Local_Text_IMT), clsEnumPMList)
    strarrSetCondition(1) = " = "
    strarrSetCondition(2) = clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_System_Text_IMT), clsEnumPMList)
    strSetCondition = Join(strarrSetCondition, "")
    'WHERE
    Dim strWHEREcondition As String
    Dim strarrWhere(2) As String
    strarrWhere(0) = "AND "
    strarrWhere(1) = clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_Local_Text_IMT), clsEnumPMList)
    strarrWhere(2) = " IS NULL"
    strWHEREcondition = Join(strarrWhere, "")
    '�u���pdictionary�\�z
    Dim dicReplaceWHERE As Dictionary
    Set dicReplaceWHERE = New Dictionary
    dicReplaceWHERE.Add 0, INV_CONST.T_INV_M_Tana
    dicReplaceWHERE.Add 1, clsEnumPMList.SQL_INV_Alias(INVDB_Tana_Alias_sia)
    dicReplaceWHERE.Add 2, strSetCondition
    dicReplaceWHERE.Add 3, strWHEREcondition
    '�v���p�e�B��SQL�ݒ�
    clsADOfrmPMList.SQL = clsSQLBc.ReplaceParm(INV_CONST.SQL_INV_TANA_SET_LOCAL_TEXT_BY_SYSTEM, dicReplaceWHERE)
    '���s�O��ConnectMode��Write�t���O���Ă�
    clsADOfrmPMList.ConnectMode = clsADOfrmPMList.ConnectMode Or adModeWrite
    'SQL���s
    Dim isCollect As Boolean
    isCollect = clsADOfrmPMList.Do_SQL_with_NO_Transaction
    'Write�t���O��������
    clsADOfrmPMList.ConnectMode = clsADOfrmPMList.ConnectMode And Not adModeWrite
    If Not isCollect Then
        'SQL���s���s
        DebugMsgWithTime "btnTehai_Text_Local_Set_All_Click : SQL Execute fail..."
        GoTo CloseAndExit
    End If
    '����
    DebugMsgWithTime "btnTehai_Text_Local_Set_All_Click : Update Success"
    MsgBox "�X�V�����B����̍X�V����: " & clsADOfrmPMList.Affected
    GoTo CloseAndExit
ErrorCatch:
CloseAndExit:
End Sub
'''��z�R�[�h�e�L�X�g�{�b�N�X�ɓ����Ă��镨���f�[�^DL���A�X�V����
Private Sub btnUpdateOriginData_Click()
    '�C�x���g��~����
    clsIncrementalParts.StopEvent = True
    '���݂̎�z�R�[�h�{�b�N�X�̒l��ޔ�����
    Dim strOldTehaiCode As String
    strOldTehaiCode = txtBox_F_INV_Tehai_Code.Text
    '�S���ڏ���
    ClearAllTextBoxAndLabel
    '��z�R�[�h���w�肵�A�݌ɏ��V�[�g��DL���t���p�X���擾����
    Dim strZaikoSHFullPath As String
#If NoIEConnect Then
    '���[�J���e�X�g�t�@�C�����̎�
    '�t�@�C���I�����Ă��炤�A�f�B���N�g���̓f�[�^�x�[�X�f�B���N�g��
    Call ChCurrentDirW(clsADOfrmPMList.DBPath)
    strZaikoSHFullPath = Application.GetOpenFilename
#Else
    'Web������擾�ł�����̎�
    strZaikoSHFullPath = modZaikoSerch.ZaikoSerchbyTehaiCode(strOldTehaiCode, clsGetIEfrmPMList)
#End If
    '�w��̍݌ɏ��t�@�C����DB PartsMaster��UPdate���A�������R�[�h�����󂯎��
    Dim longAffected As Long
    If objExxelfrmPMList Is Nothing Then
        '�N���X�ϐ�������������Ă��Ȃ������珉��������
        Set objExxelfrmPMList = New Excel.Application
    End If
#If NoIEConnect Then
    '�t�@�C���c���Ƃ�
    longAffected = clsINVDBfrmPMList.UpsertINVPartsMasterfromZaikoSH(strZaikoSHFullPath, objExxelfrmPMList, clsINVDBfrmPMList, clsADOfrmPMList, clsEnumPMList, clsSQLBc, True)
#Else
    '�t�@�C���폜����Ƃ�
    longAffected = clsINVDBfrmPMList.UpsertINVPartsMasterfromZaikoSH(strZaikoSHFullPath, objExxelfrmPMList, clsINVDBfrmPMList, clsADOfrmPMList, clsEnumPMList, clsSQLBc, False)
#End If
    MsgBox longAffected & " ���̃f�[�^���X�V���܂����B"
    '�C�x���g�ĊJ
    clsIncrementalParts.StopEvent = False
    '��z�R�[�h��߂��Ă��
    txtBox_F_INV_Tehai_Code.Text = strOldTehaiCode
End Sub
Private Sub lstBox_Incremental_Click()
    '�C���N�������^�����X�g���I�����ꂽ
    'SQL���[��������Ă����Ǝv��
    On Error GoTo ErrorCatch
    If clsIncrementalParts.Incremental_LstBox_Click Then
        '�C�x���g�̎��s��}�~����
        clsIncrementalParts.StopEvent = True
        '�m�肵���l�ɑ΂���SQL�̎��s�܂Ŋ�������
        'dicObjNameToFieldName�S�Ăɑ΂��ă��[�v
        '���R�[�h�Z�b�g�̃J�[�\�����ŏ��ɂ����Ă���
        If clsADOfrmPMList.RS.EOF And clsADOfrmPMList.RS.BOF Then
            '������ɗ����Ă�Ƃ������Ƃ̓��R�[�h�Ȃ�
            DebugMsgWithTime "IncrementalList_Click: No record found"
            Exit Sub
        End If
        clsADOfrmPMList.RS.MoveFirst
        Dim varCtrlKey As Control
        '�S�ẴR���g���[�������[�v���AdicObjtoFieldName�Ɋ܂܂����̂̂ݒl���Z�b�g���Ă���
        For Each varCtrlKey In Me.Controls
            If dicObjNameToFieldName.Exists(varCtrlKey.Name) Then
                'Dictionary�ɂ�����
                '�ʖ���.��_�ɒu���������O�ɂȂ��Ă���̂ŁA�t�B�[���h�����炻�̕�����𐶐�����
                Dim strFieldName As String
                strFieldName = REPLACE(dicObjNameToFieldName(varCtrlKey.Name), ".", "_")
                '�l���擾
                Dim strResultValue As String
                If (IsNull(clsADOfrmPMList.RS.Fields(strFieldName))) Then
                    strResultValue = ""
                Else
                    strResultValue = CStr(clsADOfrmPMList.RS.Fields(strFieldName))
                End If
                '�I�u�W�F�N�g�̎�ނɂ�菈���𕪊�
                Select Case TypeName(varCtrlKey)
                Case "TextBox"
                    '�e�L�X�g�{�b�N�X�̎�
                    varCtrlKey.Text = strResultValue
                Case "Label"
                    '���x���̎�
                    varCtrlKey.Caption = strResultValue
                End Select
            Else
                'Dictionary�Ɋ܂܂�Ă��Ȃ��̂ō���̃R���g���[���͑ΏۊO
            End If
        Next varCtrlKey
        '�l��S���Z�b�g���I����Ă���C�x���g��t�ĊJ����
        clsIncrementalParts.StopEvent = False
    Else
        'Click�C�x���g�ŉ������炠����
        Exit Sub
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "IncremantalList_Click code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
Private Sub lstBox_Incremental_Enter()
    clsIncrementalParts.Incremental_LstBox_Enter
End Sub
Private Sub lstBox_Incremental_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    '�L�[�{�[�h�̏ꍇ�͂�����
    clsIncrementalParts.Incremental_LstBox_Key_UP KeyCode, Shift
End Sub
Private Sub lstBox_Incremental_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    '���̃C�x���g�����X�g�I�𒼌�ɔ�������̂ł悳����
End Sub
Private Sub txtBox_F_INV_Tana_Local_Text_Change()
    If Me.txtBox_F_INV_Tana_Local_Text.Text = "" Then
        '�e�L�X�g���󔒂������牽�����Ȃ�
'        Exit Sub
    End If
    '�S�đ啶���ɕϊ�����
    Me.txtBox_F_INV_Tana_Local_Text.Text = UCase(Me.txtBox_F_INV_Tana_Local_Text.Text)
    '���g�ȊO�̍��ڂ���������
'    ClearAllTextBoxAndLabel Me.txtBox_F_INV_Tana_Local_Text.Name
    '�C���N�������^���T�[�`���s
    clsIncrementalParts.Incremental_TextBox_Change
End Sub
Private Sub txtBox_F_INV_Tana_Local_Text_Enter()
    '�I�ԕ\���p Enter�C�x���g
    clsIncrementalParts.Incremental_TextBox_Enter Me.txtBox_F_INV_Tana_Local_Text, lstBox_Incremental, Me, dicObjNameToFieldName, clsADOfrmPMList, clsEnumPMList, clsSQLBc
End Sub
Private Sub txtBox_F_INV_Tehai_Code_Change()
    If Me.txtBox_F_INV_Tehai_Code.Text = "" Then
        '�e�L�X�g���󔒂������牽�����Ȃ�
    End If
    '�S�đ啶���ɕϊ�����
    Me.txtBox_F_INV_Tehai_Code.Text = UCase(Me.txtBox_F_INV_Tehai_Code.Text)
'    ClearAllTextBoxAndLabel Me.txtBox_F_INV_Tehai_Code.Name
    '�C���N�������^���T�[�`���s
    clsIncrementalParts.Incremental_TextBox_Change
End Sub
Private Sub txtBox_F_INV_Tehai_Code_Enter()
    '�C���N�������^���T�[�` Enter�C�x���g
    clsIncrementalParts.Incremental_TextBox_Enter Me.txtBox_F_INV_Tehai_Code, lstBox_Incremental, Me, dicObjNameToFieldName, clsADOfrmPMList, clsEnumPMList, clsSQLBc
End Sub
'-----------------------------------------------------------------------------------------
'���\�b�h��`
Private Sub UserForm_Initialize()
    '�t�H�[������������
    '�����o�̃N���X�ϐ��̏��������s��
    'clsADO
    If clsADOfrmPMList Is Nothing Then
        Set clsADOfrmPMList = CreateclsADOHandleInstance
    End If
    'clsINVDB
    If clsINVDBfrmPMList Is Nothing Then
        Set clsINVDBfrmPMList = CreateclsINVDB
    End If
    'clsEnum
    If clsEnumPMList Is Nothing Then
        Set clsEnumPMList = CreateclsEnum
    End If
    'clsStringBuilderSQL
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
    End If
    'clsIncrementalSerch
    If clsIncrementalParts Is Nothing Then
        Set clsIncrementalParts = CreateclsIncrementalSerch
    End If
    'DBPath��DBFilename��ݒ肷��
    txtBox_DB_Path.Text = clsADOfrmPMList.DBPath
    txtBox_DB_Filename.Text = clsADOfrmPMList.DBFileName
    '�I�u�W�F�N�g�����t�B�[���h����Dictionary�̐ݒ���s��
    InitializeFieldNameDic
    '�I�Ńe�L�X�g�{�b�N�X�Ƀt�H�[�J�X���ړ�
    txtBox_F_INV_Tana_Local_Text.SetFocus
    '���������I���O�ɑS�������悤�Ƃ���ƁADictionary���̏������ł��ĂȂ��̂�TxtBox_Change�C�x���g����ɔ������Ă��܂��̂ŏ����͍Ō��
    '�e�L�X�g�{�b�N�X�A���x���S����
    ClearAllTextBoxAndLabel
    '���ۂ̒l�̓��ꍞ�݂̓C���N�������^���T�[�`�̒��ōs��
End Sub
'''�e�L�X�g�{�b�N�X�A���x����S��������
'''args
'''strExceptContrlName      ���̖��O�Ɉ�v����R���g���[���̂͏������Ȃ�
Private Sub ClearAllTextBoxAndLabel(Optional strExceptContrlName As String)
    '�R���g���[����Name�v���p�e�B�Œ萔�ɒ�`���Ă���e�L�X�g�{�b�N�X�ƃ��x���ɂ��āA���e�����ꂼ��������Ă��
    Dim controlKey As Control
    For Each controlKey In Me.Controls
        If dicObjNameToFieldName.Exists(controlKey.Name) And controlKey.Name <> strExceptContrlName Then
            'dicObjctToField�Œ�`���ꂽ��������������悤�ɂ���
            Select Case TypeName(controlKey)
            Case "TextBox"
                '�e�L�X�g�{�b�N�X�̏ꍇ
                controlKey.Text = ""
            Case "Label"
                '���x���̏ꍇ
                controlKey.Caption = ""
            End Select
        End If
    Next controlKey
End Sub
'''�I�u�W�F�N�g���A�t�B�[���h��Dictionary�̏�����
Private Sub InitializeFieldNameDic()
    If dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = New Dictionary
    End If
    dicObjNameToFieldName.Add txtBox_F_INV_Tehai_Code.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Tehai_Code_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Manege_Section.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Manege_Section_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add lbl_F_INV_Tana_System_Text.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_System_Text_IMT), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Kishu.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Kishu_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Store_Code.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Store_Code_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Deliver_Lot.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Deliver_Lot_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Fill_Lot.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Fill_Lot_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Lead_Time.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Lead_Time_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Order_Amount.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Order_Amount_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Order_Remain.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Order_Remain_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Stock_Amount.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Stock_Amount_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add lbl_F_INV_Tana_ID.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Tana_ID_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_System_Name.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_System_Name_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_System_Spec.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_System_Spec_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Sotre_Unit.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Store_Unit_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_System_Description.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_System_Description_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Manege_Section_Sub.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Manege_Section_Sub_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Tana_Local_Text.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_Local_Text_IMT), clsEnumPMList)
    dicObjNameToFieldName.Add lbl_F_INV_Tehai_ID.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Tehai_ID_IMPrt), clsEnumPMList)
    Exit Sub
End Sub
Private Sub UserForm_Terminate()
    '�f�X�g���N�^
End Sub
'�N���X�̃f�X�g���N�^
Private Sub Fainalizer()
    If Not clsADOfrmPMList Is Nothing Then
        'ADO�������c���Ă���
        clsADOfrmPMList.CloseClassConnection
        Set clsADOfrmPMList = Nothing
    End If
    If Not clsINVDBfrmPMList Is Nothing Then
        Set clsINVDBfrmPMList = Nothing
    End If
    If Not clsSQLBc Is Nothing Then
        Set clsSQLBc = Nothing
    End If
    If Not clsEnumPMList Is Nothing Then
        Set clsEnumPMList = Nothing
    End If
    If Not clsIncrementalParts Is Nothing Then
        Set clsIncrementalParts = Nothing
    End If
End Sub
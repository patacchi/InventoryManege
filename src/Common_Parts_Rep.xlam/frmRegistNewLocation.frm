VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmRegistNewLocation 
   Caption         =   "�V�K�I�ԓo�^���"
   ClientHeight    =   3435
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8100
   OleObjectBlob   =   "frmRegistNewLocation.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmRegistNewLocation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'�V�K�I�Ԃ�o�^����t�H�[��
Option Explicit
'�N���X���L�C���X�^���X�ϐ�
Private clsADONewLocation As clsADOHandle
Private clsEnumNewLocation As clsEnum
Private clsSqlBCNewLocation As clsSQLStringBuilder
Private clsIncrementalNewLocation As clsIncrementalSerch
Private dicObjToFieldName As Dictionary
'�����o�ϐ�
Private StopEvents As Boolean
Private conADONewLocation As ADODB.Connection
'''------------------------------------------------------------------------------------------------------
'SQL��`
'�f�t�H���g�f�[�^�擾SQL
'{0}    Tana_ID
'{1}    Tana_System
'{2}    Tana_Local
'{3}    T_M_Tana
'{4}    InputDate
Private Const SQL_DEFAULT_NEW_LOCATION_DATA As String = "SELECT DISTINCT {0},{1},{2},{4} FROM {3} " & vbCrLf & _
                                                        "WHERE {1} IS NOT NULL"
'''------------------------------------------------------------------------------------------------------
'�C�x���g
'Initialize
Private Sub UserForm_Initialize()
    ConstRuctor
End Sub
'Teminate
Private Sub UserForm_Terminate()
    DestRuctor
End Sub
'TextBoxEnter
Private Sub txtBox_F_INV_Tana_Local_Text_Enter()
    If StopEvents Then
        '�C�x���g��~��Ԃ������甲����
        Exit Sub
    End If
    '�C�x���g��~����
    StopEvents = True
    'Incremental TextBoxEnter
    clsIncrementalNewLocation.Incremental_TextBox_Enter txtBox_F_INV_Tana_Local_Text, lstBoxIncremantal
    '�C�x���g�ĊJ����
    StopEvents = False
End Sub
'TextBoxChange
'tana_System
Private Sub txtBox_F_INV_Tana_System_Text_Change()
    'tana_System��Change������\���p�̃��x����Caption�ɓ������ڂ�ݒ肵�Ă��
    lblSystemTextView.Width = txtBox_F_INV_Tana_System_Text.Width
    lblSystemTextView.Caption = txtBox_F_INV_Tana_System_Text.Text
End Sub
Private Sub txtBox_F_INV_Tana_Local_Text_Change()
    On Error GoTo ErrorCatch
    If StopEvents Then
        '�C�x���g��~��ԂȂ甲����
        Exit Sub
    End If
    '�C�x���g��~����
    'UCASE�|����
    txtBox_F_INV_Tana_Local_Text.Text = UCase(txtBox_F_INV_Tana_Local_Text.Text)
    'Incremental Textbox Change
    clsIncrementalNewLocation.Incremental_TextBox_Change True
    'LocalText����X�y�[�X���������ASystemText�𓾂�
    Dim strSystemText As String
    'RegExp�I�u�W�F�N�g���`
    Dim objRegExp As Object
    Set objRegExp = CreateObject("VBScript.RegExp")
    '�p�^�[���Ƃ��ċ󔒕�����ݒ�
    '\s [\t\r\n\v\f]�Ɠ���
    objRegExp.Pattern = "\s"
    '������S�̂�����
    objRegExp.Global = True
    strSystemText = objRegExp.REPLACE(txtBox_F_INV_Tana_Local_Text.Text, "")
    '��U���݂�RS��Filter��ޔ�
    Dim varOldFilter As Variant
    varOldFilter = clsADONewLocation.RS.Filter
    'RS��Filter�Ɏ擾����SystemText���Z�b�g����
    clsADONewLocation.RS.Filter = dicObjToFieldName(txtBox_F_INV_Tana_System_Text.Name) & " = '" & strSystemText & "'"
    'Filter�|������RecordCount��1������������V�K���R�[�h
    If clsADONewLocation.RS.RecordCount < 1 Then
        'tana_system�Ƃ��ăX�y�[�X���󕶎��Œu���������̂��Z�b�g
        txtBox_F_INV_Tana_System_Text.Text = strSystemText
        '�V�K�o�^�{�^����Enable��True��
        btnAdNewLocation.Enabled = True
    Else
        '�����̒I�Ԃ����݂���ꍇ
        txtBox_F_INV_Tana_System_Text.Text = "(�����̒I�Ԃ����݂��܂�)"
        '�V�K�o�^�{�^����Enable��False��
        btnAdNewLocation.Enabled = False
    End If
    '�t�B���^��߂�
    clsADONewLocation.RS.Filter = varOldFilter
    '�C�x���g�ĊJ����
    StopEvents = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "txtBox_F_INV_Tana_Local_Text_Change code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Set objRegExp = Nothing
    Exit Sub
End Sub
'Click
'�V�K�I�o�^
Private Sub btnAdNewLocation_Click()
    AddNewLocation
End Sub
'''------------------------------------------------------------------------------------------------------
'�v���V�[�W��
'''�t�H�[���R���X�g���N�^
Private Sub ConstRuctor()
    If clsADONewLocation Is Nothing Then
        Set clsADONewLocation = CreateclsADOHandleInstance
        '�ŏ��ɖ����I��DBPath���f�t�H���g��
        clsADONewLocation.SetDBPathandFilenameDefault
    End If
    If clsADONewLocation.RS Is Nothing Then
        Set clsADONewLocation.RS = New ADODB.Recordset
    End If
    If clsEnumNewLocation Is Nothing Then
        Set clsEnumNewLocation = CreateclsEnum
    End If
    If clsSqlBCNewLocation Is Nothing Then
        Set clsSqlBCNewLocation = CreateclsSQLStringBuilder
    End If
    If conADONewLocation Is Nothing Then
        Set conADONewLocation = New ADODB.Connection
    End If
    'dicObjeToFieldName �� clsIncremental�͕ʃv���V�[�W����
    'dicObjToFieldName�̐ݒ�
    setdicObjToFieldName
    '�f�t�H���g�f�[�^�擾
    setDefaultDatatoRS
    If clsIncrementalNewLocation Is Nothing Then
        Set clsIncrementalNewLocation = CreateclsIncrementalSerch
        'clsIncremental�̃R���X�g���N�^
        clsIncrementalNewLocation.ConstRuctor frmRegistNewLocation, dicObjToFieldName, clsADONewLocation, clsEnumNewLocation, clsSqlBCNewLocation
    End If
End Sub
'�f�X�g���N�^
Private Sub DestRuctor()
    '�N���XRS
    If Not clsADONewLocation.RS Is Nothing Then
        If clsADONewLocation.RS.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����Ă�����ؒf���Ă��
            clsADONewLocation.RS.Close
        End If
        Set clsADONewLocation.RS = Nothing
    End If
    'Connection
    If Not conADONewLocation Is Nothing Then
        If conADONewLocation.State And ObjectStateEnum.adStateOpen Then
            conADONewLocation.Close
        End If
        Set conADONewLocation = Nothing
    End If
    If Not clsADONewLocation Is Nothing Then
        clsADONewLocation.CloseClassConnection
        Set clsADONewLocation = Nothing
    End If
    Unload frmRegistNewLocation
End Sub
'''dicObjToField�̐ݒ�
Private Sub setdicObjToFieldName()
    If dicObjToFieldName Is Nothing Then
        Set dicObjToFieldName = New Dictionary
    End If
    '�ŏ��ɑS����
    dicObjToFieldName.RemoveAll
    '�R���g���[���ƃt�B�[���h���Ή��t��
    dicObjToFieldName.Add lbl_F_INV_Tana_ID.Name, clsEnumNewLocation.INVMasterTana(F_INV_TANA_ID_IMT)
    dicObjToFieldName.Add txtBox_F_INV_Tana_System_Text.Name, clsEnumNewLocation.INVMasterTana(F_INV_Tana_System_Text_IMT)
    dicObjToFieldName.Add txtBox_F_INV_Tana_Local_Text.Name, clsEnumNewLocation.INVMasterTana(F_INV_Tana_Local_Text_IMT)
End Sub
'''DB���f�[�^�擾���ARS�ɃZ�b�g����
Private Sub setDefaultDatatoRS()
    On Error GoTo ErrorCatch
    '�u���pdic��`�A�ݒ�
    Dim dicReplaceDefault As Dictionary
    Set dicReplaceDefault = New Dictionary
    dicReplaceDefault.RemoveAll
    dicReplaceDefault.Add 0, clsEnumNewLocation.INVMasterTana(F_INV_TANA_ID_IMT)
    dicReplaceDefault.Add 1, clsEnumNewLocation.INVMasterTana(F_INV_Tana_System_Text_IMT)
    dicReplaceDefault.Add 2, clsEnumNewLocation.INVMasterTana(F_INV_Tana_Local_Text_IMT)
    dicReplaceDefault.Add 3, INV_CONST.T_INV_M_Tana
    dicReplaceDefault.Add 4, PublicConst.INPUT_DATE
    '�C�x���g��~����
    StopEvents = True
    'RS�����������̎��͐V���ɐݒ肵�Ă��
    If clsADONewLocation.RS Is Nothing Then
        Set clsADONewLocation.RS = New ADODB.Recordset
    End If
    'RS���N���X�ϐ���Connetcion�I�u�W�F�N�g���ڑ��ς݂��������U�ؒf����
    If clsADONewLocation.RS.State And ObjectStateEnum.adStateOpen Then
        clsADONewLocation.RS.Close
    End If
    If conADONewLocation.State And ObjectStateEnum.adStateOpen Then
        conADONewLocation.Close
    End If
    'Connection�̐ݒ�
    conADONewLocation.ConnectionString = clsADONewLocation.CreateConnectionString(clsADONewLocation.DBPath, clsADONewLocation.DBFileName)
    conADONewLocation.CursorLocation = adUseClient
    conADONewLocation.Mode = adModeRead Or adModeShareDenyNone
    '�ڑ��I�[�v��
    conADONewLocation.Open
    'RA�̃v���p�e�B�ݒ�
    clsADONewLocation.RS.LockType = adLockBatchOptimistic
    clsADONewLocation.RS.CursorType = adOpenStatic
    'Replace���s���ARS��Source��SQL�ݒ�
    clsADONewLocation.RS.Source = clsSqlBCNewLocation.ReplaceParm(SQL_DEFAULT_NEW_LOCATION_DATA, dicReplaceDefault)
    'RS��Connection�ɋ��LConnection��ݒ�
    Set clsADONewLocation.RS.ActiveConnection = conADONewLocation
    'rs Open
    clsADONewLocation.RS.Open , , , , CommandTypeEnum.adCmdText
    DebugMsgWithTime "setDefaultDatatoRS Default Data Count: " & clsADONewLocation.RS.RecordCount
    '�C�x���g�ĊJ����
    StopEvents = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "getDefaultData code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Set dicReplaceDefault = Nothing
    Exit Sub
End Sub
'�V�K�I�Ԃ�o�^����
Private Sub AddNewLocation()
    On Error GoTo ErrorCatch
    '�C�x���g��~����
    StopEvents = True
    '���݂̃t�B���^�[��ޔ�
    Dim varOldFilter As Variant
    varOldFilter = clsADONewLocation.RS.Filter
    'SystemText��Filter��ݒ�
    clsADONewLocation.RS.Filter = dicObjToFieldName(txtBox_F_INV_Tana_System_Text.Name) & " = '" & txtBox_F_INV_Tana_System_Text.Text & "'"
    If clsADONewLocation.RS.RecordCount >= 1 Then
        'RecordCount��1�ȏ�̏ꍇ�͊����̃f�[�^������̂ŏ����𒆒f
        MsgBox "���ɓ����̒I�Ԃ����݂��܂��B�����𒆒f���܂�"
        '�t�B���^��߂�
        clsADONewLocation.RS.Filter = varOldFilter
        'TanaLocal��SetFocus
        txtBox_F_INV_Tana_Local_Text.SetFocus
        GoTo CloseAndExit
        Exit Sub
    End If
    'RS�ɐV�K���R�[�h��ǉ�
    clsADONewLocation.RS.AddNew
    '�V�K���R�[�h�ɒl���Z�b�g���Ă���
    Dim varKeydicObjt As Variant
    'dicObjToField�����[�v
    '��f�[�^�폜
    If dicObjToFieldName.Exists(Empty) Then
        dicObjToFieldName.Remove (Empty)
    End If
    For Each varKeydicObjt In dicObjToFieldName
        '�I�u�W�F�N�g�̎�ނŏ����𕪊�
        Select Case True
        Case TypeName(frmRegistNewLocation.Controls(varKeydicObjt)) = "TextBox"
            '�e�L�X�g�{�b�N�X�̏ꍇ
            '���ʃe�L�X�g�{�b�N�X�̂ݒl���Z�b�g����
            clsADONewLocation.RS.Fields(dicObjToFieldName(varKeydicObjt)).Value = frmRegistNewLocation.Controls(varKeydicObjt).Text
        End Select
    Next varKeydicObjt
    'InputDate����
    clsADONewLocation.RS.Fields(PublicConst.INPUT_DATE).Value = GetLocalTimeWithMilliSec
    '���[�J����RS���m�肳����
    clsADONewLocation.RS.Update
    '��U�t�B���^����
    clsADONewLocation.RS.Filter = adFilterNone
    'PendingRecords�ŕύX�̂��郌�R�[�h�݂̂Ńt�B���^
    clsADONewLocation.RS.Filter = adFilterPendingRecords
    'PendingRecords�݂̂�UpdateBatch�����āARS�̌��ʂ�DB�ɔ��f������
    Select Case True
    Case clsADONewLocation.RS.Status And (ADODB.RecordStatusEnum.adRecModified Or ADODB.RecordStatusEnum.adRecNew)
        '�t�B���^��������ύX�_����A�������͐V�K���R�[�h�������ꍇ
        '�t�B���^�����Ɉ�v�������̂̂�Update
        clsADONewLocation.RS.UpdateBatch adAffectGroup
        If clsADONewLocation.RS.Status And ADODB.RecordStatusEnum.adRecUnmodified Then
            MsgBox "����ɍX�V����܂���"
            '���݂̃��R�[�h�̒l���t�H�[���ɔ��f������
            GetValuFromRS
            '�A�����͂ɑΉ����邽�߁ATanaLocal��SetFocus
            txtBox_F_INV_Tana_Local_Text.SetFocus
        Else
            DebugMsgWithTime "AddNewLocation : fail update batch Location_Local: " & txtBox_F_INV_Tana_Local_Text.Text
            MsgBox "����ɍX�V����Ȃ������\��������܂� �I��: " & txtBox_F_INV_Tana_Local_Text.Text
        End If
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "AddNewLocation code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
'''RS���l���擾����
Private Sub GetValuFromRS()
    On Error GoTo CloseAndExit
    '�C�x���g��~����
    StopEvents = True
    Dim varKeyDicObjtoField As Variant
    'cidObjToField�̑S�v�f�����[�v
    For Each varKeyDicObjtoField In dicObjToFieldName
        '�R���g���[���̎�ނɂ�菈���𕪊�
        Select Case True
        Case TypeName(frmRegistNewLocation.Controls(varKeyDicObjtoField)) = "Label"
            '���x���������ꍇ
            frmRegistNewLocation.Controls(varKeyDicObjtoField).Caption = _
            clsADONewLocation.RS.Fields(dicObjToFieldName(varKeyDicObjtoField)).Value
        Case TypeName(frmRegistNewLocation.Controls(varKeyDicObjtoField)) = "TextBox"
            '�e�L�X�g�{�b�N�X�������ꍇ
            frmRegistNewLocation.Controls(varKeyDicObjtoField).Text = _
            clsADONewLocation.RS.Fields(dicObjToFieldName(varKeyDicObjtoField)).Value
        End Select
    Next varKeyDicObjtoField
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "GetValuFromRS code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ����
    StopEvents = False
    Exit Sub
End Sub
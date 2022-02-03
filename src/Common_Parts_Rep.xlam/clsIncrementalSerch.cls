VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsIncrementalSerch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'''�t�H�[���́i��Ɂj�e�L�X�g�{�b�N�X�ŃC���N�������^���T�[�`���������邽�߂̃N���X
Option Explicit
'�����o�ϐ�
Private boolStopEvents As Boolean
Private varSourceArray As Variant                       'ListBox�Ɋ��蓖�Ă�匳�̔z��i�t�B���^�O�A���ۂ͂���Ƀt�B���^��������ListBox.List�Ɋ��蓖�Ă�j
Private dicReplaceSELECTParam As Dictionary             'SQL SELECT�p��ReplaseParam
Private txtBoxTarget As MSForms.TextBox                 '�^�[�Q�b�g�ƂȂ�e�L�X�g�{�b�N�X�̎Q��
Private lstBox_Incremental As MSForms.ListBox           '�C���N�������^���T�[�`�p�̃��X�g�{�b�N�X�̎Q��
Private frmParent As UserForm                           'Parent�ƂȂ�t�H�[�����̂���
Private dicObjectToFieldName As Dictionary              '�I�u�W�F�N�g����key�A�e�[�u���G�C���A�X���t���̃t�B�[���h����value�Ƃ���Dictionary
Private clsADOIncremental As clsADOHandle               'AdoHandle�̃C���X�^���X�Q��
Private clsEnumIncremental As clsEnum
Private clsSQLBIncremental As clsSQLStringBuilder
'�����o�萔
Private Const LISTBOX_FONT_SIZE As Single = 9           '���X�g�{�b�N�X�̃t�H���g�T�C�Y
Private Const LISTBOX_BASE_HEIGHT As Single = 10.5      '���X�g�{�b�N�X��1�s������̍���
'�v���p�e�B
'StopEvents
Property Get StopEvent() As Boolean
    StopEvent = boolStopEvents
    Exit Property
End Property
Property Let StopEvent(argBoolStopEvent As Boolean)
    boolStopEvents = argBoolStopEvent
    Exit Property
End Property
'txtBox
Property Get txtBoxRef() As MSForms.TextBox
    Set txtBoxRef = txtBoxTarget
End Property
Property Set txtBoxRef(ByRef argTxtBox As MSForms.TextBox)
    Set txtBoxTarget = argTxtBox
End Property
'lstBox
Property Get LstBoxRef() As MSForms.ListBox
    Set LstBoxRef = lstBox_Incremental
End Property
Property Set LstBoxRef(ByRef arglstBox As MSForms.ListBox)
    Set lstBox_Incremental = arglstBox
End Property
'me.frmref
Property Get frmRef() As UserForm
    Set frmRef = frmParent
End Property
Property Set frmRef(ByRef argFrm As UserForm)
    Set frmParent = argFrm
End Property
'me.dicobjectfield
Property Get dicObjectField() As Dictionary
    Set dicObjectField = dicObjectToFieldName
End Property
Property Set dicObjectField(ByRef argDicObject As Dictionary)
    Set dicObjectToFieldName = argDicObject
End Property
'clsADo
Property Get clsADOhandleRef() As clsADOHandle
    Set clsADOhandleRef = clsADOIncremental
End Property
Property Set clsADOhandleRef(ByRef argclsADO As clsADOHandle)
    Set clsADOIncremental = argclsADO
End Property
'clsEnum
Property Get clsEnumRef() As clsEnum
    Set clsEnumRef = clsEnumIncremental
End Property
Property Set clsEnumRef(ByRef argclsEnum As clsEnum)
    Set clsEnumIncremental = argclsEnum
End Property
'clsSqlBC
Property Get clsSQLBRef() As clsSQLStringBuilder
    Set clsSQLBRef = clsSQLBIncremental
End Property
Property Set clsSQLBRef(ByRef argclsSQLB As clsSQLStringBuilder)
    Set clsSQLBIncremental = argclsSQLB
End Property
'--------------------------------------------------------------------------------------------------------------
'���\�b�h
'''�C���N�������^���T�[�`�Ńe�L�X�g�{�b�N�X��Change�C�x���g�̋��ʃC�x���g�n���h��
'''Change�C�x���g
'''���������͂��ꂽ��A���X�g�̍i�荞�݂��s���A���ʂ�1���݂̂ɂȂ����烊�X�g����������
'''args
Public Sub Incremental_TextBox_Change()
    On Error GoTo ErrorCatch
    'StopEvent���Z�b�g����Ă����牽�����Ȃ��Ŕ�����
    If Me.StopEvent Then
        'StopEvent
        Exit Sub
    End If
    '�e�����̃`�F�b�N
    Dim IsInitialize As Boolean
    IsInitialize = CheckInctance
    If Not IsInitialize Then
        '�ǂꂩ�̃C���X�^���X�Q�ƕϐ���Nothing������
        GoTo CloseAndExit
        Exit Sub
    End If
    If Not Me.dicObjectField.Exists(Me.txtBoxRef.Name) Then
        '�t�B�[���h��Dic�Ƀe�L�X�g�{�b�N�X�̖��O��������Ȃ�������I��
        DebugMsgWithTime "Incremental_Textbox_Change: object name not found in Dictionary.  ObjectName: " & Me.txtBoxRef.Name
        GoTo CloseAndExit
        Exit Sub
    End If
    If Not IsRedim(varSourceArray) Then
        '�܂��z�񂪏���������ĂȂ������ꍇ
        GoTo CloseAndExit
    End If
    '�C�x���g��t���~����
    Me.StopEvent = True
    '���X�g�{�b�N�X�̑I����Ԃ���������
    Me.LstBoxRef.ListIndex = -1
    '�e�L�X�g�{�b�N�X�ɓ��͂���Ă��镶����Ńt�B���^�����Ă݂�
    Dim varArrayFilterd As Variant
    varArrayFilterd = Filter(varSourceArray, Me.txtBoxRef.Text, True, vbTextCompare)
    'filter�֐��͌�����Ȃ��� 0 to -1 �̔z���Ԃ��炵���̂ŁAUbound < Lbound�ɂȂ�炵��
    If Not IsRedim(varArrayFilterd) Or UBound(varArrayFilterd) < LBound(varArrayFilterd) Then
        '������Ȃ������ꍇ�H
        DebugMsgWithTime "Incremental_TextBox_Change: No result found"
        '���X�g�{�b�N�X���N���A���Ă��AVisible��False�ɂ���
        Me.LstBoxRef.Clear
        Me.LstBoxRef.Visible = False
        GoTo CloseAndExit
        Exit Sub
    End If
    If UBound(varArrayFilterd) - LBound(varArrayFilterd) = 0 Then
        '�t�B���^�|������̌�₪�c��1�ɂȂ����ꍇ
'        '���X�g�{�b�N�X���\���ɂ��āA���X�g�{�b�N�X��Index 0��I�����AClick�C�x���g�𔭉΂�����
''        '�����Ŕ�\���ɂ��Ă��܂��ƌ�����������폜�������Ƀ��X�g�������Ȃ�
''        Me.LstBoxRef.Visible = False
'        Me.LstBoxRef.List = varArrayFilterd
'        Me.LstBoxRef.ListIndex = 0
'        '�܂��͕\������������
''        SetListBoxStyle varArrayFilterd
        '�m��Ȃ̂ŁA���X�g�{�b�N�X�͕\�����Ȃ����ǂ����悤?
        '���1�ɂȂ������_�Ŋm�肷��ƁA���ɘA�����͂��������ɕs��
        '�e�L�X�g�{�b�N�X�̒l�����X�g�{�b�N�X�̒l�ɃZ�b�g���Ă��
'        me.txtBoxRef.Text = me.lstboxref.List(0)
        '���X�g�{�b�N�X��Click�C�x���g�𔭐������邽�߂ɑI�������Ă��
'        me.lstboxref.ListIndex = 0
'        me.lstboxref.Visible = False
'        GoTo CloseAndExit
    End If
    '���X�g�{�b�N�X��\������
    SetListBoxStyle varArrayFilterd
    '�C�x���g��t���ĊJ����
    Me.StopEvent = False
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "Incremental_TextBox_Change code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Me.StopEvent = False
    Exit Sub
End Sub
'''�C���N�������^���T�[�`�A�e�L�X�g�{�b�N�X�C�x���g�n���h��
'''Enter
'''��ԍŏ��ɂ��̃C�x���g����n�܂�͂��Ȃ̂ŁA�N���X�̃R���X�g���N�^����
'''�t�H�[�J�X�����������_�ŁA���X�g�̏��������s��
'''args
'''me.txtBoxRef                 �^�[�Q�b�g�ƂȂ�e�L�X�g�{�b�N�X�̎Q��
'''me.lstboxref           �C���N�������^���T�[�`�p�̃��X�g�{�b�N�X�̎Q��
'''me.frmref                    Parent�̃t�H�[���̎Q��
'''me.dicobjectfield         �I�u�W�F�N�g����key�A�e�[�u���G�C���A�X���t���̃t�B�[���h����value�Ƃ���Dictionary
'''me.clsadohandleref            AdoHandle�̃C���X�^���X�Q��
'''me.clsenumref
'''clsSQLStringBuilder
Public Sub Incremental_TextBox_Enter(ByRef txtBoxargTarget As MSForms.TextBox, ByRef lstBoxarg_Incremental As MSForms.ListBox, ByRef argFrmParent As UserForm, dicargObjectToFieldName As Dictionary, _
clsADOargIncremental As clsADOHandle, clsEnumargIncremental As clsEnum, clsSQLBargIncremental As clsSQLStringBuilder)
    On Error GoTo ErrorCatch
    '�e�����̃`�F�b�N�ANothing����Ȃ�������N���X�̃v���p�e�B�ɃZ�b�g����
    If txtBoxargTarget Is Nothing Or lstBoxarg_Incremental Is Nothing Or dicargObjectToFieldName Is Nothing Or clsADOargIncremental Is Nothing _
     Or clsEnumargIncremental Is Nothing Or clsSQLBargIncremental Is Nothing Then
        '�ǂꂩ�̃C���X�^���X�Q�Ƃ�Nothing������
        DebugMsgWithTime "Incremental_Textbox_Enter: some instance Nothing"
        GoTo CloseAndExit
        Exit Sub
    Else
        '���ꂼ��v���p�e�B�ɃZ�b�g���Ă��
        Set Me.txtBoxRef = txtBoxargTarget
        Set Me.LstBoxRef = lstBoxarg_Incremental
        Set Me.frmRef = argFrmParent
        Set Me.dicObjectField = dicargObjectToFieldName
        Set Me.clsADOhandleRef = clsADOargIncremental
        Set Me.clsEnumRef = clsEnumargIncremental
        Set Me.clsSQLBRef = clsSQLBargIncremental
    End If
    If Not Me.dicObjectField.Exists(Me.txtBoxRef.Name) Then
        '�t�B�[���h��Dic�Ƀe�L�X�g�{�b�N�X�̖��O��������Ȃ�������I��
        DebugMsgWithTime "Incremental_Textbox_Enter: object name not found in Dictionary.  ObjectName: " & Me.txtBoxRef.Name
        GoTo CloseAndExit
        Exit Sub
    End If
    '���X�g�̍X�V���I���܂ŃC�x���g��~����
    Me.StopEvent = True
    '��U���X�g���\���ɂ��A�I�����������Ă��
    Me.LstBoxRef.Visible = False
    Me.LstBoxRef.ListIndex = -1
    Me.LstBoxRef.Font.Size = LISTBOX_FONT_SIZE
    'ReplaceDic��ݒ肷��
    '�����Where�����͂Ȃ���X
    'Null��r�����Ȃ��Ƃ߂�ǂ��ɂȂ�
    Dim strWHEREcondition As String
    Dim strarrWhere(2) As String
    strarrWhere(0) = "AND NOT "
    strarrWhere(1) = Me.dicObjectField(Me.txtBoxRef.Name)
    strarrWhere(2) = " IS NULL"
    strWHEREcondition = Join(strarrWhere, "")
    'ReplaceDic�̐ݒ���s��
    SetReplaceParmDic Me.dicObjectField(Me.txtBoxRef.Name), strWHEREcondition
    'SQL�g�ݗ���
    Me.clsADOhandleRef.SQL = Me.clsSQLBRef.ReplaceParm(INV_CONST.SQL_INV_JOIN_TANA_PARTS, dicReplaceSELECTParam)
    Dim isCollect As Boolean
    'SQL���s
    isCollect = Me.clsADOhandleRef.Do_SQL_with_NO_Transaction
    If Not isCollect Then
        DebugMsgWithTime "Incremental_TextBox_Enter: Do Get List sql fail..."
        MsgBox "Incremantal_TextBox_Enter�Ń��X�g�擾SQL���s���ɃG���[���������܂���"
        GoTo CloseAndExit
    End If
    '�^�C�g�������̔z��������o�ϐ��Ɋ��蓖�Ă�
    'Filter�֐��ł�1�����z�񂵂������ɂƂ�Ȃ��̂ŁA�����o�ϐ��Ɋi�[����O��1�����z��ɕϊ����Ă��
    '��U2�����z��Ƃ��Ď󂯎��
    Dim vararr2Dimention As Variant
    vararr2Dimention = Me.clsADOhandleRef.RS_Array(NoTitle:=True)
    If Not IsRedim(vararr2Dimention) Then
        '����������ĂȂ��z�񂪋A���Ă�����
        MsgBox "�f�[�^��������܂���ł���"
        GoTo CloseAndExit
        Exit Sub
    End If
    '1�����z��ɕϊ����A�����o�ϐ��ɃZ�b�g
    varSourceArray = clsSQLBRef.SQLResutArrayto1Dimmention(vararr2Dimention)
    '��₪��̏ꍇ�͒��ڃe�L�X�g�{�b�N�X�ɒl��ݒ肵�Ă��A���X�g�{�b�N�X���͔̂�\���̂܂܂ɂ���
    If UBound(varSourceArray) - LBound(varSourceArray) = 0 Then
        Me.LstBoxRef.Visible = False
        Me.LstBoxRef.List = varSourceArray
        '1�s�ڂ�I�����A�{�̂̃t�H�[����Select�C�x���g�𑖂点��
        '���̌�̏����͊e�t�H�[���ōs�����̂Ƃ���
        Me.LstBoxRef.ListIndex = 0
        '���X�g�{�b�N�X���\���ɂ���
        Me.LstBoxRef.Height = 0
        Me.LstBoxRef.Visible = False
'        Me.txtBoxRef.Text = varSourceArray(0)
        GoTo CloseAndExit
        Exit Sub
    End If
    '�e�L�X�g�{�b�N�X�ɓr���܂œ��͂��Ă܂��߂��Ă��Ă������ɗ���̂ŁA�e�L�X�g�{�b�N�X�ɕ����������Ă��邩�`�F�b�N���A��������Change�n���h���Ɉړ�����
    If Me.txtBoxRef.TextLength >= 1 Then
        '�C�x���g��t�ĊJ
        Me.StopEvent = False
        'Change�C�x���g�n���h���N��
        Incremental_TextBox_Change
        GoTo CloseAndExit
        Exit Sub
    End If
    'Enter�̒i�K�Ŋ��Ƀe�L�X�g�{�b�N�X�ɕ��������͂���Ă�����
    '�����܂łő匳�̃��X�g�͎擾�ł��Ă���̂ŁA��U���X�g�\���ł���悤�ɐݒ肵�Ă��
    SetListBoxStyle varSourceArray
    '�i�荞�݂�Change�C�x���g�ɂčs��
    '�C�x���g��t�ĊJ
    Me.StopEvent = False
    Exit Sub
ErrorCatch:
    DebugMsgWithTime "Incremental_TextBox_Enter Code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Me.StopEvent = False
    Exit Sub
End Sub
'''���X�g�{�b�N�X(�C���N�������^�����X�g) Enter�C�x���g
'''Enter�������̏����B�c��1�������炭�肱�m�肵���Ⴄ�ʁH
'''
Public Sub Incremental_LstBox_Enter()
    On Error GoTo ErrorCatch
    '�C���X�^���X�m�F
    Dim isInitialized As Boolean
    isInitialized = CheckInctance
    If Not isInitialized Then
        '���������������H
        DebugMsgWithTime "Incremental_LstBox_Enter : some instance Nothing..."
        GoTo CloseAndExit
        Exit Sub
    End If
    If Me.LstBoxRef.ListCount = 1 Then
        'Enter�������_�Ń��X�g�̎c����1������
        '�I�����Ă��܂��̂ł�
        '�����I�ɃC�x���g�ĊJ
        Me.StopEvent = False
        Me.LstBoxRef.ListIndex = 0
        '�����ɗ��鎞�_��Click�C�x���g�̏����͊�����������Ă�̂ŁA�e�L�X�g�{�b�N�X�ւ̃Z�b�g�ƃ��X�g�{�b�N�X���\���ɂ�������Ă����v
        '��U�C�x���g��~
        Me.StopEvent = True
        '�e�L�X�g�{�b�N�X�Ƀe�L�X�g�Z�b�g
        Me.txtBoxRef.Text = Me.LstBoxRef.List(Me.LstBoxRef.ListIndex)
        '���X�g�{�b�N�X���̂��\���ɁA���łɃ��X�g�{�b�N�X�̑I����Ԃ���������i���ɑI�����ꂽ�܂܂ɂȂ��Ă邽�߁j
        Me.LstBoxRef.ListIndex = -1
        Me.LstBoxRef.Clear
        Me.LstBoxRef.Height = 0
        '�C�x���g�ĊJ
        Me.StopEvent = False
        GoTo CloseAndExit
        Exit Sub
    End If
ErrorCatch:
CloseAndExit:
End Sub
'''�C���N�������^�����X�g�N���b�N�i�I���m��j�C�x���g Click
'''�w�肳�ꂽDic����������SQL���s����B���s������̒l�̐ݒ�͂��ꂼ��̌Ăяo�����ōs���B
'''�߂�l   Bool    ��Ɗ���������True�A����ȊO��False
'''�Ăяo�����ł�True��҂��Ēl���Z�b�g���Ă����̂��ȁH
Public Function Incremental_LstBox_Click() As Boolean
    On Error GoTo ErrorCatch
    '�����`�F�b�N������
    Dim isInitialized As Boolean
    isInitialized = CheckInctance
    If Not isInitialized Then
        DebugMsgWithTime "Incremental_LstBox_Click : some inctance not initialized"
        Incremental_LstBox_Click = False
        GoTo CloseAndExit
    End If
    Dim strResultText As String
    '��U�C�x���g���~����
    Me.StopEvent = True
    '���ʂ��擾
    strResultText = Me.LstBoxRef.List(Me.LstBoxRef.ListIndex)
    'WHERE�������쐬
    Dim strWHEREcondition As String
    Dim strarrCondition(3) As String
    strarrCondition(0) = "AND "
    strarrCondition(1) = Me.dicObjectField(Me.txtBoxRef.Name)
    strarrCondition(2) = " = "
    strarrCondition(3) = Me.clsSQLBRef.addQuote(strResultText)
    strWHEREcondition = Join(strarrCondition, "")
    'ReplaceDic��ݒ肷��
    '�����SELECT��DicObjctToField�ɂ���S�Ă̍��ڂ����������Ă��Ȃ��ƃ_��
    SetReplaceParmDic GetSELECTfieldListFromDicObjctToFieldName, strWHEREcondition
    'clsADO�̃v���p�e�B��SQL���Z�b�g
    Me.clsADOhandleRef.SQL = Me.clsSQLBRef.ReplaceParm(INV_CONST.SQL_INV_JOIN_TANA_PARTS, dicReplaceSELECTParam)
    'SQL���s
    Dim isCollect As Boolean
    isCollect = Me.clsADOhandleRef.Do_SQL_with_NO_Transaction
    If Not isCollect Then
        DebugMsgWithTime "Incremental_LstBox_Click : SQL executing fali...."
        Incremental_LstBox_Click = False
        GoTo CloseAndExit
    End If
    '���X�g�̑I����ԉ����A�e�L�X�g�{�b�N�X�ւ̌��ʃe�L�X�g�̔��f����KeyUP�����MouseUp�C�x���g���ōs��
    Incremental_LstBox_Click = True
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "Incremantal_LstBox_Click code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    '�C�x���g�ĊJ
    Me.StopEvent = False
    Exit Function
End Function
'''�C���N�������^�����X�g��KeyUP�C�x���g�̃C�x���g�n���h��
'''KeyUp�C�x���g�Ȃ̂ŁAClick�C�x���g�̌�Ŕ������邽�ߎ��g���\���ɂ���̂���ړI
'''args
'''argKeyCode       �����ꂽ�L�[�̃L�[�R�[�h������
'''argShift         �V�t�g�L�[�̉������?
Public Sub Incremental_LstBox_Key_UP(argKeyCode As MSForms.ReturnInteger, argShift As Integer)
    On Error GoTo ErrorCatch
    '�����o�ϐ��`�F�b�N
    Dim isInitialized As Boolean
    isInitialized = CheckInctance
    If Not isInitialized Then
        DebugMsgWithTime "Incremental_LstBox_Key_UP : Instance check fail"
        GoTo CloseAndExit
        Exit Sub
    End If
    '�C�x���g��t��~����
    Me.StopEvent = True
    '�L�[�R�[�h�ɂ�菈���𕪊�
    Select Case argKeyCode
    Case vbKeyEscape
        'ESC�L�[
        '���X�g���\���ɂ���
        Me.LstBoxRef.Visible = False
        GoTo CloseAndExit
    Case vbKeyReturn
    Case vbKeyUp
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "Incremental_LstBox_Key_UP code: " & err.Number & " Description: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''T_INV_M_Tana �� T_M_INV_Parts�� F_INV_Tana_ID�Ō��������ėpSQL��RepleceDictionary��ݒ肷�郁�\�b�h
'''args
'''strargSelectField        SELECT �̈���
'''strargWhereCondition     WHERE �̈���
Private Sub SetReplaceParmDic(strargSELECTField As String, strargWHERECondition As String)
    If dicReplaceSELECTParam Is Nothing Then
        Set dicReplaceSELECTParam = New Dictionary
''T_INV_M_Tana��T_INV_M_Parts���������ėpSELECT SQL�A�O��DB�t�@�C���Q�Ƃ͖������̂Ƃ���
''{0}    (SELECT Field)
''{1}    T_INV_M_Parts
''{2}    TDBPrts
''{3}    T_INV_M_Tana
''{4}    TDBTana
''{5}    F_INV_Tana_ID
''{6}    (WHERE condition)�����̏ꍇ�͋󕶎� "" ��OK
''INV_CONST.SQL_INV_JOIN_TANA_PARTS
        '����͑S�Ă̏�����V���ɓ���Ă��
        '0��SELECT �t�B�[���h
        dicReplaceSELECTParam.Add 0, strargSELECTField
        dicReplaceSELECTParam.Add 1, INV_CONST.T_INV_M_Parts
        dicReplaceSELECTParam.Add 2, Me.clsEnumRef.SQL_INV_Alias(INVDB_Parts_Alias_sia)
        dicReplaceSELECTParam.Add 3, INV_CONST.T_INV_M_Tana
        dicReplaceSELECTParam.Add 4, Me.clsEnumRef.SQL_INV_Alias(INVDB_Tana_Alias_sia)
        dicReplaceSELECTParam.Add 5, Me.clsEnumRef.INVMasterTana(F_INV_TANA_ID_IMT)
        '6�ԁAWHERE����
        dicReplaceSELECTParam.Add 6, strargWHERECondition
    Else
        '���ɏ������ς݂̏ꍇ�́ASELECT������WHERE�����̂ݕύX�ɂȂ�̂ŁA���������������čĊ��蓖��
        '0 SELECT
        dicReplaceSELECTParam.Remove (0)
        dicReplaceSELECTParam.Add 0, strargSELECTField
        '6 WHERE
        dicReplaceSELECTParam.Remove (6)
        dicReplaceSELECTParam.Add 6, strargWHERECondition
    End If
End Sub
'''�v���p�e�B��dicObjToFieldName���S�t�B�[���h�I����SELECT �������쐬����
'''�߂�l   string      SELECT�̌�ɂ������Ďg�p����
Private Function GetSELECTfieldListFromDicObjctToFieldName() As String
    On Error GoTo ErrorCatch
    '�����`�F�b�N
    Dim isInitialized As Boolean
    isInitialized = CheckInctance
    If Not isInitialized Then
        DebugMsgWithTime "GetSELECTfieldListFromDicObjctToFieldName : not initialized instance var..."
        GetSELECTfieldListFromDicObjctToFieldName = ""
        GoTo CloseAndExit
    End If
    'dicobj.count���̔z����`
    Dim strarrSELECTfield() As String
    ReDim strarrSELECTfield(Me.dicObjectField.Count - 1)
    Dim varKeyDicObj As Variant
    Dim longArrRowCounter As Long
    longArrRowCounter = 0
    For Each varKeyDicObj In Me.dicObjectField
        '�z��Ƀt�B�[���h�����i�[���Ă���
        '�t�B�[���h���𖾎��I�Ɏw�肵�Ȃ���SELECT�������ʂ��G�C���A�X�O���ꂿ�Ⴄ
        '���łɃh�b�g�͓��ꕶ�����������̂�Relace���Ȃ��Ⴞ��
        Dim strarrPlusAlias(2) As String
        strarrPlusAlias(0) = Me.dicObjectField(varKeyDicObj)
        strarrPlusAlias(1) = " AS "
        strarrPlusAlias(2) = REPLACE(strarrPlusAlias(0), ".", "_")
        strarrSELECTfield(longArrRowCounter) = Join(strarrPlusAlias, "")
        '�z��̍s�J�E���^�[���C���N�������g
        longArrRowCounter = longArrRowCounter + 1
    Next varKeyDicObj
    '���ʂ�Ԃ�
    GetSELECTfieldListFromDicObjctToFieldName = Join(strarrSELECTfield, ",")
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "GetSELECTfieldListFromDicObjctToFieldName code: " & err.Number & " Descriptoin: " & err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''ListBox�Ɋe��v���p�e�B���Z�b�g���A�\������
'''args
'''varArrayList                 ���X�g�{�b�N�X�ɕ\������z��
'''me.txtBoxRef                 �^�[�Q�b�g�ƂȂ�e�L�X�g�{�b�N�X�̎Q��
'''me.lstboxref           �C���N�������^���T�[�`�p�̃��X�g�{�b�N�X�̎Q��
'''me.frmref                    Parent�̃t�H�[���̎Q��
Private Sub SetListBoxStyle(varArrayList As Variant)
    On Error GoTo ErrorCatch
    If Not IsRedim(varArrayList) Or getArryDimmensions(varArrayList) <> 1 Then
        '���ʂ̔z�񂶂�Ȃ����ۂ��̂�����
        DebugMsgWithTime "SetListBoxstyle: parhaps not list array "
        Exit Sub
    End If
    Me.LstBoxRef.List = varArrayList
    With Me.LstBoxRef
        .ListStyle = fmListStylePlain
        .BorderStyle = fmBorderStyleSingle
        .Font.Size = LISTBOX_FONT_SIZE
        '�T�C�Y�������A�e�L�X�g�{�b�N�X�̂������ɕ\������悤�ɂ���
        .Top = Me.txtBoxRef.Top + Me.txtBoxRef.Height
        .Width = Me.txtBoxRef.Width
        .Left = Me.txtBoxRef.Left
        .Height = LISTBOX_BASE_HEIGHT * .ListCount
        '�����̍ő�l�̐ݒ肪�K�v�����H
        '�t�H�[���̍����𒴂��Ă�����Height�𒲐�
        If .Height > Me.frmRef.InsideHeight Then
            .Height = Me.frmRef.InsideHeight - .Top
        End If
        .Visible = True
    End With
    GoTo CloseAndExit
    Exit Sub
ErrorCatch:
    DebugMsgWithTime "SetListStyle code: " & err.Number & " Description : " & err.Description
    Exit Sub
CloseAndExit:
End Sub
'''�N���X���̃C���X�^���X�Q�ƕϐ��̏�������Ԃ𒲂ׂ�֐�
'''��ł�Nothing�������False��Ԃ��A�S������������Ă�����True
Private Function CheckInctance() As Boolean
    If Me.txtBoxRef Is Nothing Or Me.LstBoxRef Is Nothing Or Me.dicObjectField Is Nothing Or Me.clsADOhandleRef Is Nothing _
    Or Me.clsEnumRef Is Nothing Or Me.clsSQLBRef Is Nothing Or Me.frmRef Is Nothing Then
        '�ǂꂩ�̃C���X�^���X�Q�Ƃ�Nothing������
        DebugMsgWithTime "CheckInstance : some instance Nothing"
        CheckInctance = False
        GoTo CloseAndExit
        Exit Function
    Else
        '�S��Nothing����Ȃ�����
        CheckInctance = True
        GoTo CloseAndExit
        Exit Function
    End If
CloseAndExit:
    Exit Function
End Function
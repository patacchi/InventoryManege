VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmSelectSavePoint 
   Caption         =   "������X�g�I�����"
   ClientHeight    =   4920
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   6210
   OleObjectBlob   =   "frmSelectSavePoint.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmSelectSavePoint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'''Label_Temp��Savepoint��I������t�H�[��
Option Explicit
Private StopEvents As Boolean
Private Enum Enum_SortField
    SavePoint = 0
    InputDate = 1
End Enum
'List��Initialize�͌Ăяo�����ōs��
'''�L�����Z���{�^��
Private Sub btnCancel_Click()
    '''frmBinLabel��varstrarrSelectedSavePoint��Empty���Z�b�g���āA���g��Unload
    frmBinLabel.varstrarrSelectedSavepoint = Empty
    Unload Me
    Exit Sub
End Sub
Private Sub btnCompSelect_Click()
    '�I�����ꂽ������
    Dim strarrSelectedSavepoint() As String 'SavePoint�i�[�p�z��
    Dim strarrInputDate() As String         'InputDate�i�[�p�z��
    Dim longListRow As Long                 'List�̃J�����g�s���i�[
    Dim longSelectedRows As Long            '�I�����ꂽ���ڂ̐����i�[
    longSelectedRows = 0
    'lstBoxSavePoint.List�̑S���ڂ����[�v
    For longListRow = LBound(lstBoxSavePoint.List) To UBound(lstBoxSavePoint.List)
        Select Case True
        Case longListRow = LBound(lstBoxSavePoint.List)
            '�ŏ��̍s�̏ꍇ
            '�ŏ��̍s�̓^�C�g���s�Ȃ̂ŉ������Ȃ�
        Case lstBoxSavePoint.Selected(longListRow)
            '�I������Ă��鍀�ڂ̏ꍇ
            'longSelectedRows���C���N�������g
            longSelectedRows = longSelectedRows + 1
            '���ʔz��Redim Preserve
            ReDim Preserve strarrSelectedSavepoint(longSelectedRows - 1)
            ReDim Preserve strarrInputDate(longSelectedRows - 1)
            'List�̍��ڂ��Z�b�g
            'SavePoint
            strarrSelectedSavepoint(longSelectedRows - 1) = CStr(lstBoxSavePoint.List(longListRow, 0))
            'InputDate
            strarrInputDate(longSelectedRows - 1) = CStr(lstBoxSavePoint.List(longListRow, 1))
        End Select
    Next longListRow
    If longSelectedRows < 1 Then
        MsgBox "�I�����ꂽ���ڂ��L��܂���ł����B�Œ�ł�1���ڑI�����ĉ�����"
        Exit Sub
    End If
    'frmBinLabel�Ɏ擾�������ʂ��Z�b�g���A���g��Unload
    Dim longArrayRowCounter As Long
    '���ʊi�[�p�z����`
    Dim arrstrResult() As String
    ReDim arrstrResult(UBound(strarrSelectedSavepoint), 1)
    '���ʂ�SavePoint�v�f�����[�v���ASavePoint��InputDate���Z�b�g
    For longArrayRowCounter = LBound(strarrSelectedSavepoint) To UBound(strarrSelectedSavepoint)
        'SavePoint�Z�b�g
        arrstrResult(longArrayRowCounter, 0) = strarrSelectedSavepoint(longArrayRowCounter)
        'InputDate�Z�b�g
        arrstrResult(longArrayRowCounter, 1) = strarrInputDate(longArrayRowCounter)
    Next longArrayRowCounter
    'frmBinLabel�Ɍ��ʂ̔z����Z�b�g
    frmBinLabel.varstrarrSelectedSavepoint = arrstrResult
    Unload Me
    Exit Sub
End Sub
'InputDate���ɕ��ёւ�
Private Sub btnOrderByInputDate_Click()
    SortList Enum_SortField.InputDate
End Sub
'SavePoint���ɕ��ёւ�
Private Sub btnOrderBySavePoint_Click()
    SortList Enum_SortField.SavePoint
End Sub
'''lstbox_Change
'''�擪�s��������S�I���A�S�����̓���������
Private Sub lstBoxSavePoint_Change()
    If StopEvents Then
        '�C�x���g��~�t���O�����Ă��甲����
        Exit Sub
    End If
    If lstBoxSavePoint.ListCount < 2 Then
        '���X�g��2�s����(�^�C�g������?)�̏ꍇ�͔�����
        MsgBox "�L���ȃf�[�^������܂���ł���"
        Exit Sub
    End If
    '�ŏ��̍s���I�����ꂽ��A����True�ɂ��邩False�ɂ��邩���߂�
    Select Case True
    Case lstBoxSavePoint.ListIndex = 0
        '�ŏ��̍s���I�����ꂽ
        '���X�g�S�Ă̍s�����[�v�A�������ŏ��̍s�ȊO
        '�S�Ă̍s��Selected���ŏ��̍s�Ɠ����ɂ���
        '�C�x���g��~����
        StopEvents = True
        Dim longArrayCount As Long
        For longArrayCount = (LBound(lstBoxSavePoint.List) + 1) To UBound(lstBoxSavePoint.List)
            lstBoxSavePoint.Selected(longArrayCount) = lstBoxSavePoint.Selected(0)
        Next longArrayCount
        '�C�x���g�ĊJ����
        StopEvents = False
    End Select
End Sub
Private Sub SortList(argEnumField As Enum_SortField)
    '���X�g����ѕς���
    '���݂̏������R�[�h�Z�b�g�Ɋi�[
    Dim rsSavePoint As ADODB.Recordset
    Set rsSavePoint = New ADODB.Recordset
    '�t�B�[���h����`��1�s�ڂ̕����t�B�[���h���A�^��String�Ƃ���
    'SavePoint�t�B�[���h�ǉ�
    rsSavePoint.Fields.Append Name:=CStr(lstBoxSavePoint.List(0, 0)), Type:=adWChar, DefinedSize:=23
    'InptDate�t�B�[���h�ǉ�
    rsSavePoint.Fields.Append Name:=CStr(lstBoxSavePoint.List(0, 1)), Type:=adWChar, DefinedSize:=23
    'rs��Open����
    If rsSavePoint.State = ObjectStateEnum.adStateClosed Then
        rsSavePoint.Open
    End If
    '�f�[�^��ǉ�����A���ۂ̃f�[�^��List��2�s�ڂ���
    Dim longListRowCount As Long
    For longListRowCount = 1 To UBound(lstBoxSavePoint.List)
        rsSavePoint.AddNew
        'SavePoint
        rsSavePoint.Fields(CStr(lstBoxSavePoint.List(0, 0))).Value = lstBoxSavePoint.List(longListRowCount, 0)
        'InputDate
        rsSavePoint.Fields(CStr(lstBoxSavePoint.List(0, 1))).Value = lstBoxSavePoint.List(longListRowCount, 1)
        '���̃��[�v��RS�m��
        rsSavePoint.Update
    Next longListRowCount
    'Sort���s
    rsSavePoint.Sort = CStr(lstBoxSavePoint.List(0, CLng(argEnumField))) & " DESC"
    '���ʊi�[�p�z���`
    Dim varArr As Variant
    ReDim varArr(UBound(lstBoxSavePoint.List), 1)
    '1�s�ڂ̓^�C�g���s�Œ�
    varArr(0, 0) = CStr(lstBoxSavePoint.List(0, 0))
    varArr(0, 1) = CStr(lstBoxSavePoint.List(0, 1))
    '�s�J�E���^�[�������A2�s�ڂ���
    longListRowCount = 1
    'rsMoveFirst
    'rs�����[�v���āAEOF�ɂȂ�܂Ńf�[�^�ǉ�
    rsSavePoint.MoveFirst
    Do
        'SavePoint
        varArr(longListRowCount, 0) = rsSavePoint.Fields(0).Value
        'InputDate
        varArr(longListRowCount, 1) = rsSavePoint.Fields(1).Value
        'longListRowCount�C���N�������g
        longListRowCount = longListRowCount + 1
        'MoveNext
        rsSavePoint.MoveNext
    Loop While Not rsSavePoint.EOF
    '���ʂ�ListBox�ɓK�p
    lstBoxSavePoint.Clear
    lstBoxSavePoint.List = varArr
    'rs�����
    Set rsSavePoint = Nothing
    Exit Sub
End Sub
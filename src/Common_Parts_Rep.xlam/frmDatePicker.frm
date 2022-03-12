VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmDatePicker 
   Caption         =   "���t�I���t�H�[��"
   ClientHeight    =   4410
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   5310
   OleObjectBlob   =   "frmDatePicker.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmDatePicker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'''�C�x���g���ʉ��֌W�ϐ���`
'''Date�̏����l�� cdbl(date)�� 0�ɂȂ�
'���ʃC�x���g�N���X�i�[�R���N�V����
Private colcommonEvents As Collection
'''�����o�ϐ���`
Private dateCurrentMonth As Date                            '�t�H�[�������݈����Ă���N����(����1���w�肵������)���i�[����ϐ�
Private StopEvents As Boolean                               '�C�x���g����t���O
'���ʃC�x���g�n���h���Ō��ʂ��������ނ��߂̕ϐ�
Public vardateDayArray_CurrentYearMonth As Variant              '���݂̔N�������Ɏ擾�������x��������Date�z��
'''-------------------------------------------------------------------------------------------------------------
'''�C�x���g
'Userform
'Initialize
Private Sub UserForm_Initialize()
    ConstRuctor
End Sub
'''�O�̌��� Click
Private Sub btnPreviousMonth_Click()
    '���݂̔N�����擾
    Dim dateCurent As Date
    dateCurent = DateSerial(CInt(cmbBox_Year.Text), CInt(cmdBox_Month.Text), 1)
    '�N����Month-1�������̂�ݒ�
    cmbBox_Year.Text = Year(DateSerial(Year(dateCurent), Month(dateCurent) - 1, 1))
    cmdBox_Month.Text = Month(DateSerial(Year(dateCurent), Month(dateCurent) - 1, 1))
End Sub
'''���̌��� Click
Private Sub btnNextMonth_Click()
    '���݂̔N�����擾
    Dim dateCurent As Date
    dateCurent = DateSerial(CInt(cmbBox_Year.Text), CInt(cmdBox_Month.Text), 1)
    '�N����Month+1�������̂�ݒ�
    cmbBox_Year.Text = Year(DateSerial(Year(dateCurent), Month(dateCurent) + 1, 1))
    cmdBox_Month.Text = Month(DateSerial(Year(dateCurent), Month(dateCurent) + 1, 1))
End Sub
'''-------------------------------------------------------------------------------------------------------------
'''���\�b�h
'''�R���X�g���N�^
Private Sub ConstRuctor()
    '�C�x���g��~����
    StopEvents = True
    '�ŏ���FormCommon�̌���Date������������
    FormCommon.datePickerResult = Empty
    '���������Ƃ��ē���1����ݒ�
    dateCurrentMonth = DateSerial(Year(Now()), Month(Now()), 1)
    '�N�����̃{�b�N�X��ݒ�
    '�N �O��2�N��
    Dim intYear(4) As Integer
    Dim longArrayCounter As Long
    For longArrayCounter = 0 To UBound(intYear)
        intYear(longArrayCounter) = Year(dateCurrentMonth) - 2 + longArrayCounter
    Next longArrayCounter
    cmbBox_Year.List = intYear
    '�� 1-12
    Dim intMonth(11) As Integer
    For longArrayCounter = 0 To UBound(intMonth)
        intMonth(longArrayCounter) = longArrayCounter + 1
    Next longArrayCounter
    cmdBox_Month.List = intMonth
    '�����̂��̂ɂ���
    cmdBox_Month.Text = Month(dateCurrentMonth)
    '���t�{�b�N�X�̓C�x���g���ʉ��C�x���g�n���h���Ō��ʂ��m�肵���炻����Őݒ肳���
    '�C�x���g���ʉ��n���h���̏���
    '���ʃC�x���g�n���h�� �C�x���g�N���X�i�[�p�R���N�V�����̏�����
    If colcommonEvents Is Nothing Then
        Set colcommonEvents = New Collection
    End If
    setCommonEventsContrl
    '�����ݒ�̂��߁A�N�𓖔N�̂��̂ɂ��AChange�C�x���g�𔭐�������
    '�e�L�X�g�𓖔N�̂��̂ɂ���
    cmbBox_Year.Text = Year(dateCurrentMonth)
End Sub
''�f�R���{�{�b�N�X�ɓ��͂��ꂽ�N��������t�{�b�N�X�ɐݒ肷��z��𓾂�
'''-------------------------------------------------------------------------------------------------------
'''Return   Integer() �z��
Private Function GetDayArrayFromCurrentMonth() As Integer()
    '�N���ɐ����ȊO�������Ă��Ȃ����`�F�b�N
    If Not IsNumeric(cmbBox_Year.Text) Or Not IsNumeric(cmdBox_Month.Text) Then
        '�N�������ꂩ�̃R���{�{�b�N�X�ɓ��͂��ꂽ���t�������Ƃ��ĔF���ł��Ȃ��ꍇ
        MsgBox "�N���{�b�N�X�����ꂩ�ɐ����ȊO�����͂���܂���"
        GetDayArrayFromCurrentMonth = Empty
        GoTo CloseAndExit
    End If
    '���t�Ƃ��ĕϊ��ł��邩�`�F�b�N
    If Not IsDate(DateSerial(cmbBox_Year.Text, cmdBox_Month.Text, 1)) Then
        '�R���{�{�b�N�X�̔N���̐��������t�ɕϊ��ł��Ȃ��Ƃ�
        MsgBox "���͂��ꂽ���l�����t�Ƃ��ĔF���ł��܂���ł���"
        GetDayArrayFromCurrentMonth = Empty
        GoTo CloseAndExit
    End If
    Dim intDay() As Integer
    '������(Month + 1)�O��(day 0)(=�����̖���) -1 ���z��̃T�C�Y�ƂȂ�
    ReDim intDay(Day(DateSerial(CInt(cmbBox_Year.Text), CInt(cmdBox_Month.Text) + 1, 0)) - 1)
    Dim longArrayRowCounter As Long
    For longArrayRowCounter = 0 To UBound(intDay)
        intDay(longArrayRowCounter) = longArrayRowCounter + 1
    Next longArrayRowCounter
    '���ʂ�Ԃ�
    GetDayArrayFromCurrentMonth = intDay
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "GetDayArrayFromCurrentMonth code: " & Err.Number & " Description: " & Err.Description
    GetDayArrayFromCurrentMonth = Empty
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''-------------------------------------------------------------------------------------------------------
'''�C�x���g�n���h�����ʉ��N���X�ɓo�^����
Private Sub setCommonEventsContrl()
    Dim Ctrleach As MSForms.Control
    '���K�\���I�u�W�F�N�g�̃C���X�^���X�擾
#If refRegExp Then
    'RegExp���Q�Ɛݒ肳��Ă���Ƃ�
    Dim objRegExp As RegExp
    Set objRegExp = New RegExp
#Else
    '�Q�Ɛݒ肳��Ă��Ȃ��Ƃ�(�x���o�C���f�B���O)
    Dim objRegExp As Object
    Set objRegExp = CreateObject("VBScript.RegExp")
#End If
    'lbl_Day?? ����2��
    objRegExp.Pattern = FormCommon.LABEL_DAY_PRIFIX & "[0-9]{2}"
    '�C�x���g���ʉ��N���X�̃C���X�^���X�𓾂�
    Dim clsCommonEventsDatePicker As clsCommonEvents
    'DatePicker�̑S�R���g���[�������[�v
    For Each Ctrleach In frmDatePicker.Controls
        Select Case True
        Case objRegExp.Test(Ctrleach.Name), Ctrleach.Name = cmbBox_Year.Name, Ctrleach.Name = cmdBox_Month.Name
            '���t�̃��x���R���g���[��������(���O�̐��K�\����v�ɂ��)
            '�܂��͔N���R���{�{�b�N�X������
            Set clsCommonEventsDatePicker = New clsCommonEvents
            '�C�x���g�����N���X��WithEvents�ϐ��Ɍ��݂̃R���g���[�����Z�b�g
            Set clsCommonEventsDatePicker.commonControl = Ctrleach
            '�C�x���g���ʉ��N���X�R���N�V�����ɒǉ�
            colcommonEvents.Add clsCommonEventsDatePicker
            Set clsCommonEventsDatePicker = Nothing
        End Select
    Next Ctrleach
End Sub
Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CDbl(FormCommon.datePickerResult) = 0 Then
        '����Ƃ��Ɍ��ʂ������l�������炻�̂܂ܕ��Ă���������
        Dim longMsgBoxResult As Long
        longMsgBoxResult = MsgBox("���t���I������Ă��܂��񂪁A���̂܂ܕ��܂����H", vbYesNo)
        If longMsgBoxResult = vbYes Then
            '���̂܂ܕ��Ă�����
            Cancel = 0
        Else
            '������_��
            Cancel = 1
        End If
    End If
End Sub
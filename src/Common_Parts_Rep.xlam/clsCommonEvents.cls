VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsCommonEvents"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'''�C�x���g�v���V�[�W�����ʉ��̂��߂̃N���X
'''�t�H�[�����A�R���g���[����ʂ��Ƃɕʂ̕ϐ���p�ӂ���
Option Explicit
'''---------------------------------------------------------------------------
'frmDatePicker��Label�̋��ʃC�x���g�n���h���⑫�p�̕ϐ�
Private WithEvents common_DatePicker_Label As MSForms.Label
Attribute common_DatePicker_Label.VB_VarHelpID = -1
Private WithEvents common_DatePicker_cmbBox As MSForms.ComboBox
Attribute common_DatePicker_cmbBox.VB_VarHelpID = -1
'''---------------------------------------------------------------------------
'�O�����J�p(�v���p�e�B)�̔ėpControl�ϐ�
Private pControl As MSForms.Control
'''---------------------------------------------------------------------------
'�v���p�e�B
Property Get commonControl() As MSForms.Control
    Set commonControl = pControl
End Property
Property Set commonControl(argCtrl As MSForms.Control)
    On Error GoTo ErrorCatch
    '�R���g���[���̎�ނɂ�菈���𕪊�
    If argCtrl Is Nothing Then
        '������Nothing�������甲����
        GoTo CloseAndExit
        Exit Property
    End If
    Select Case TypeName(argCtrl)
    Case "Label"
        '���x���̏ꍇ
        '�X�Ƀt�H�[�����ŏ����𕪊�
        Select Case argCtrl.Parent.Name
        Case frmDatePicker.Name
            'DatePicker�̃��x��������
            Set pControl = argCtrl
            '�C�x���g�⑫�p�ϐ��ɃZ�b�g(�Ȍ�C�x���g�L���b�`�ł���悤�ɂȂ�͂�)
            Set common_DatePicker_Label = Me.commonControl
            GoTo CloseAndExit
        End Select
    Case "ComboBox"
        '�R���{�{�b�N�X�̏ꍇ
        '�X�Ƀt�H�[�����ŏ����𕪊�
        Select Case argCtrl.Parent.Name
        Case frmDatePicker.Name
            'DatePicker�̃R���{�{�b�N�X������
            Set pControl = argCtrl
            Set common_DatePicker_cmbBox = Me.commonControl
            GoTo CloseAndExit
        End Select
    End Select
    '�����܂Ŕ����Ă����Ƃ������͖��Ή��̑g�ݍ��킹������
    MsgBox "���̃R���g���[���͋��ʉ���`����Ă��܂���" & vbCrLf & _
    "�R���g���[����: " & TypeName(argCtrl) & " " & argCtrl.Name & vbCrLf & _
    "�e�t�H�[�����F " & argCtrl.Parent.Name
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "set commonControl code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Property
End Property
'''---------------------------------------------------------------------------
'''���ʃC�x���g�n���h���L�q
'''DatePicker Label Click
'''�e�t�H�[���̔N���{�b�N�X��萔�l���擾���A���g�̃��x���̔ԍ�
Private Sub common_DatePicker_Label_Click()
#If refRegExp Then
    'RegExp�Q�ƍς�
    Dim objRegExp As RegExp
    Set objRegExp = New RegExp
#Else
    'RegExp�Q�ƂȂ�
    Dim objRegExp As Object
    Set objRegExp = CreateObject("VBScript.RegExp")
#End If
    '���K�\���p�^�[���ݒ�
    '�v���t�B�b�N�X�Ɛ�������2�O���[�v�ɕ�����
    objRegExp.Pattern = "(" & FormCommon.LABEL_DAY_PRIFIX & ")([0-9]{2})"
    If Not objRegExp.Test(Me.commonControl.Name) Then
        MsgBox "���t���x���ȊO�̃��x���ł��B�����𒆒f���܂�"
        GoTo CloseAndExit
    End If
    '���l�������擾
#If refRegExp Then
    'regexp�Q�Ƃ���Ă���ꍇ
    Dim MatchCollection As MatchCollection
#Else
    '�Q�Ɩ����̏ꍇ
    Dim MatchCollection As Object
#End If
    Set MatchCollection = objRegExp.Execute(Me.commonControl.Name)
    If Not MatchCollection.Count = 1 Then
        '�������ʂ�1������Ȃ��ꍇ
        MsgBox "�R���g���[�����̌����Ɏ��s���܂��� Day Label Click"
        GoTo CloseAndExit
    End If
    Dim dateTarget As Date
    '�t�H�[���̓��t�z����N���b�N���ꂽ���t����肵�A�擾
    dateTarget = frmDatePicker.vardateDayArray_CurrentYearMonth(CLng(MatchCollection(0).SubMatches(1)))
    '�擾����Date��FormCommon�̃O���[�o���ϐ��ɃZ�b�g
    FormCommon.datePickerResult = dateTarget
    'DatePicker�t�H�[����Unload
    Unload frmDatePicker
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "common_DatePicker_Label_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''DatePicker cmbBox
'''�N���A1���Ƃ��āADate�^�ɂȂ邩�ǂ����`�F�b�N���A���t���x���̐ݒ�܂ōs��
Private Sub common_DatePicker_cmbBox_Change()
    On Error GoTo ErrorCatch
    If Not IsNumeric(frmDatePicker.cmbBox_Year.Text) Or Not IsNumeric(frmDatePicker.cmdBox_Month.Text) Then
        MsgBox "�N���ǂ��炩�̒l�����l�ƂƂ��ĔF���ł��܂���ł���"
        GoTo CloseAndExit
        Exit Sub
    End If
    If Not IsDate(DateSerial(CInt(frmDatePicker.cmbBox_Year.Text), CInt(frmDatePicker.cmdBox_Month.Text), 1)) Then
        '�N��1���̑g�ݍ��킹��Date�Ƃ��ĔF���ł��Ȃ�����
        MsgBox "�ݒ肳�ꂽ�N���̑g�ݍ��킹�����t�Ƃ��ĔF���ł��܂���ł���"
        GoTo CloseAndExit
    End If
    '���t���x���̐�����Date�z���p��
    Dim datearrDay(41) As Date
    Dim date1dayCurYM As Date           '�N��1����Date
    date1dayCurYM = DateSerial(CInt(frmDatePicker.cmbBox_Year.Text), CInt(frmDatePicker.cmdBox_Month.Text), 1)
    '�܂��͓����̕��̓��t���Z�b�g���Ă��
    Dim longArrayRowCounter As Long
    'WeekDay��1(���j)����n�܂邱�Ƃ𗘗p���AWeekDay() -2�𓾂āA��ɔz��̓Y�������炱�̐����������Γ��t�̃I�t�Z�b�g��������
    '�z��̓Y�����̃G���h�͗���0��(�������̓��ɂ�)
    '��L2�����ꂼ��Z�o����
    Dim longStartDayWeekday As Long
    longStartDayWeekday = Weekday(date1dayCurYM) - 2
    Dim longEndRow As Long
    longEndRow = Day(DateSerial(Year(date1dayCurYM), Month(date1dayCurYM) + 1, 0))
    For longArrayRowCounter = LBound(datearrDay) To UBound(datearrDay)
        datearrDay(longArrayRowCounter) = DateSerial(Year(date1dayCurYM), Month(date1dayCurYM), longArrayRowCounter - longStartDayWeekday)
    Next longArrayRowCounter
    frmDatePicker.vardateDayArray_CurrentYearMonth = datearrDay
    '���t���x���ɃZ�b�g���Ă���
    'DatePicker�̂��ׂẴR���g���[�������[�v���A���t���x���̖����K���ɉ������R���g���[���̂ݑ��삷��
#If refRegExp Then
    'RegExp�Q�ƍς�
    Dim objRegExp As RegExp
    Set objRegExp = New RegExp
#Else
    'RegExp�Q�ƂȂ�
    Dim objRegExp As Object
    Set objRegExp = CreateObject("VBScript.RegExp")
#End If
    '���K�\���p�^�[���ݒ�
    '�v���t�B�b�N�X�Ɛ�������2�O���[�v�ɕ�����
    objRegExp.Pattern = "(" & FormCommon.LABEL_DAY_PRIFIX & ")([0-9]{2})"
    Dim ContrlEach As MSForms.Control
    For Each ContrlEach In frmDatePicker.Controls
        If objRegExp.Test(ContrlEach.Name) Then
#If refRegExp Then
            'regexp�Q�Ƃ���Ă���ꍇ
            Dim MatchCollection As MatchCollection
#Else
            '�Q�Ɩ����̏ꍇ
            Dim MatchCollection As Object
#End If
            Set MatchCollection = objRegExp.Execute(ContrlEach.Name)
            If Not MatchCollection.Count = 1 Then
                MsgBox "�R���g���[���̖��O�p�^�[���̌����Ɏ��s���܂���"
                GoTo CloseAndExit
            End If
            'MatchCollection(0).submatches(1)�Ō�������1�Ԗڂ�2�v�f��(�����O���[�v)�̌��ʂ��Ԃ�
            ContrlEach.Caption = Day(datearrDay(CLng(MatchCollection(0).SubMatches(1))))
            '���t�̏����ɂ��w�i�̐F�╶���F��ς���
            Select Case True
            Case datearrDay(CLng(MatchCollection(0).SubMatches(1))) = DateSerial(Year(Now()), Month(Now()), Day(Now()))
                '�����ɂ҂����肾������
                '�����F��W����
                ContrlEach.ForeColor = FormCommon.TEXT_NORMAL_BLACK
                '�w�i�F�𔖗ΐF��
                ContrlEach.BackColor = FormCommon.TXTBOX_BACKCOLORE_EDITABLE
            Case Month(datearrDay(CLng(MatchCollection(0).SubMatches(1)))) = Month(date1dayCurYM)
                '�����̓��ɂ��������ꍇ�A�����F���m�[�}����
                ContrlEach.ForeColor = FormCommon.TEXT_NORMAL_BLACK
                '�y�������͐F��ς���A����ȊO�̓s���N
                Select Case Weekday(datearrDay(CLng(MatchCollection(0).SubMatches(1))))
                Case vbSaturday
                    '�y�j�A�w�i���ۂ��̂�
                    ContrlEach.BackColor = FormCommon.BACK_COLOR_SATURDAY_BLUE
                Case vbSunday
                    '���j�A�w�i��F���ۂ��̂�
                    ContrlEach.BackColor = FormCommon.BACK_COLOR_SUNDAY_RED
                Case Else
                    '����ȊO
                    '�w�i�F�͑I���\�s���N��
                    ContrlEach.BackColor = FormCommon.BACK_COLOR_SELECTABLE_PINK
                End Select
            Case Month(datearrDay(CLng(MatchCollection(0).SubMatches(1)))) <> Month(date1dayCurYM)
                '�����̓��ɂ�����Ȃ������甖���D�F��
                ContrlEach.ForeColor = FormCommon.TEXT_NOT_ENABLE_GRAY
                '�j���ɂ���Ĕw�i�F�ύX
                Select Case Weekday(datearrDay(CLng(MatchCollection(0).SubMatches(1))))
                Case vbSaturday
                    '�y�j�A�w�i���ۂ��̂�
                    ContrlEach.BackColor = FormCommon.BACK_COLOR_SATURDAY_BLUE
                Case vbSunday
                    '���j�A�w�i��F���ۂ��̂�
                    ContrlEach.BackColor = FormCommon.BACK_COLOR_SUNDAY_RED
                Case Else
                    '����ȊO
                    '�w�i�F�͑I���\�s���N��
                    ContrlEach.BackColor = FormCommon.BACK_COLOR_SELECTABLE_PINK
                End Select
            End Select
        End If
        Set MatchCollection = Nothing
    Next ContrlEach
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "common_DatePicker_cmbBox_Change code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
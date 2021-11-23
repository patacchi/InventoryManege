VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsSQLStringBuilder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'SQL��������i��Ɍ����j�̂��߂̃N���X
'�J�n�����A�I��������ݒ肵�āA������A���͔z���Join�ōs������
Private strSQLBuilder As String         '�Ō�̌��ʂ�SQL��
Private longStringLength As Long        '������̒���
Private dblTimer As Double              '�������Ԍv���p�^�C�}�[�A�[�A�[�A
'Private longRecordCount As Long         '���݂̏������f�[�^�̏ꏊ�i�o���N�̎��Ɏg���j
Private Sub Class_Initialize()
    '�N���X����������
    strSQLBuilder = Empty
    longStringLength = 0
End Sub
Private Sub Class_Terminate()
    '�N���X�j�����Ɏ��s
    strSQLBuilder = Empty
    longStringLength = 0
End Sub
'''Author Daiske_Oota 2021_10_18
'''Printf�̂悤�Ȋ֐�
'''.NET��StringBuilder��AppendFormat�̃I�[�o�[���[�h4���g�p��
'''{index number 0start}�`���̃v���[�X�z���_�Ɍ����߂ł���i�ق��ɂ��F�X�����ݒ肵�悤�Ǝv���΂ł���j
'''------------------------------------------------------------------------------------------------------
'''Parms
'''strargOriginString       �v���[�X�z���_���݂̃I���W�i��������
'''dicargParm               �L�[�ɃC���f�b�N�X�ԍ��AItem�Ƀv���[�X�z���_�ɓ����ׂ������������B�v���[�X�z���_��萔�����Ȃ��ꍇ�͗�O���X���[�����
Public Function ReplaceParm(strargOriginString As String, dicargParm As Dictionary) As String
    If strargOriginString = "" Then
        DebugMsgWithTime "ReplaceParm Orrigin String is empty"
        ReplaceParm = ""
        Exit Function
    End If
    If dicargParm.Count <= 0 Then
        '�u��������̃I�u�W�F�N�g�����[���������甲����
        DebugMsgWithTime "ReplaceParm Parm list empty"
        ReplaceParm = ""
        Exit Function
    End If
    On Error GoTo ErrorCatch
    '������Dictionary�����Ƀv���[�X�z���_�ɑΉ�����I�u�W�F�N�g�̔z����쐬����
    Dim arrParm() As Variant
    ReDim arrParm(dicargParm.Count - 1)
    Dim longParmCount As Long
    For longParmCount = 0 To dicargParm.Count - 1
        arrParm(longParmCount) = dicargParm(longParmCount)
    Next longParmCount
    Dim objBuilder As Object
    Set objBuilder = CreateObject("System.Text.StringBuilder")
    ' System.Text.StringBuilder AppendFormat_4(string format, Params System.Object[] args)
    ReplaceParm = objBuilder.AppendFormat_4(strargOriginString, arrParm).ToString
'    objBuilder.Clear
    Set objBuilder = Nothing
    Exit Function
ErrorCatch:
    Set objBuilder = Nothing
    DebugMsgWithTime "ReplaceParm code: " & Err.Number & vbCrLf & " Description: " & Err.Description
    Exit Function
End Function
'''------------------------------------------------------------------------------------------------------
Private Function Append(ByVal strargOrignString As String, ByRef varAryString As Variant, Optional strDelimiter As String = ",") As String
    Dim strarrBuf() As String
    Dim longElementCount As Long
    Dim longCounter As Long
    On Error GoTo ErrorCatch
    Select Case Len(strargOrignString)
    Case 0
        '����String������0�̎��́A�ǉ��̕����ŏ�
        longElementCount = UBound(varAryString) - LBound(varAryString)
    Case Else
        '���̂��������肾�����ꍇ
        '�����Ɏw�肳��Ă���v�f�� + �I���W�i���̃v���X���
        longElementCount = UBound(varAryString) - LBound(varAryString) + 1
    End Select
    ReDim strarrBuf(longElementCount)
    Select Case Len(strargOrignString)
    Case 0
        '���̒�����0�̏ꍇ�͒ǉ��̔z��Ɠ����ł����E�E�E
        strarrBuf = varAryString
    Case Else
        '�I���W�i�����������肾�����ꍇ
        '�܂��擪�ɃI���W�i����String���������Ă��
        longCounter = 0
        strarrBuf(longCounter) = strargOrignString
        '�ǉ����̔z������Ԃɂ�������
        For longCounter = 1 To longElementCount
            strarrBuf(longCounter) = varAryString(longCounter - (1 - LBound(varAryString)))
        Next longCounter
    End Select
    '�z��Ɋi�[���I�������Join��String�ɂ���
    Append = Join(strarrBuf, strDelimiter)
    Exit Function
ErrorCatch:
    DebugMsgWithTime "Append Error code: " & Err.Number & "Description: " & Err.Description
End Function
Public Function addQuote(ByVal strargOriginalString As String, Optional ByVal strQuote As String = """") As String
    '�^����ꂽ������ɁA�G�X�P�[�v����������
    Dim strBuf(2) As String
    On Error GoTo ErrorCatch
    strBuf(0) = strQuote
    strBuf(1) = Replace(strargOriginalString, """", """""")
    strBuf(2) = strQuote
    addQuote = Append("", strBuf, "")
    Exit Function
ErrorCatch:
    DebugMsgWithTime "addQuote Error code: " & Err.Number & "Description: " & Err.Description
End Function
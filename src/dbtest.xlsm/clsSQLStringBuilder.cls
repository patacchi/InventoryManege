VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsSQLStringBuilder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'SQL��������i��Ɍ����j�̂��߂̃N���X
'�J�n�����A�I��������ݒ肵�āA������A���͔z���Join�ōs������
Private strSQLBuilder As String         '�Ō�̌��ʂ�SQL��
Private arrstrField As Variant          '�t�B�[���h�̕�����z��
Private intFieldCount As Integer        '�t�B�[���h�̐�
Private longBulkCount As Long            '�o���N��
Private strStartRireki As String        '�X�^�[�g�̗���
Private longMaisuu As Long              '����
Private byteRenbanketa As Byte          '�A�ԁi���������j�̌���
Private strEndRireki As String          '�G���h�̗���
Private longStringLength As Long        '������̒���
Private strTableName As String          '�e�[�u����
Private strJobNumber As String          '�W���u�ԍ�
Private dicFieldType As Dictionary      '�t�B�[���h�̃^�C�v��
Private strRirekiHeader As String       '�����w�b�_
Private longRirekiNumber As Long        '����A�ԕ���
Private dblTimer As Double              '�������Ԍv���p�^�C�}�[�A�[�A�[�A
'Private longRecordCount As Long         '���݂̏������f�[�^�̏ꏊ�i�o���N�̎��Ɏg���j
Private Sub Class_Initialize()
    '�N���X����������
    '�Ȃ��������Ńt�B�[���h���X�g�̐ݒ���s��
    arrFieldList_JobData = Split(Job_Number & "," & Job_RirekiHeader & "," & Job_RirekiNumber & "," & Job_Rireki & "," & Field_Initialdate, ",")
    arrFieldList_Barcode = Split(BarcordNumber & "," & Laser_Rireki & "," & Field_Initialdate, ",")
    arrFieldList_Retry = Split(BarcordNumber & "," & Retry_Rireki & "," & Retry_Reason & "," & Field_Initialdate, ",")
    strSQLBuilder = Empty
    intFieldCount = 0
'    longRecordCount = 0
    longBulkCount = 1000000                  '�o���N�������ݒ�
    strStartRireki = Empty
    strEndRireki = Empty
    longStringLength = 0
End Sub
Private Sub Class_Terminate()
    '�N���X�j�����Ɏ��s
    strSQLBuilder = Empty
    intFieldCount = 0
    strStartRireki = Empty
    strEndRireki = Empty
    longStringLength = 0
End Sub
'�v���p�e�B�ݒ�
Property Let FieldArray(varargField As Variant)
    '�t�B�[���h����z��̌`�Ŏw��
    arrstrField = varargField
End Property
Property Get FieldArray() As Variant
    '�t�B�[���h�̔z���Ԃ�
    FieldArray = arrstrField
End Property
Property Let BulkCount(longargBulkCount As Long)
    '�o���N���ݒ�
    longBulkCount = longargBulkCount
End Property
Property Get BulkCount() As Long
    '�o���N���擾
    BulkCount = longBulkCount
End Property
Property Let StartRireki(strargStartRireki As String)
    '�X�^�[�g����ݒ�
    strStartRireki = strargStartRireki
End Property
Property Get StartRireki() As String
    '�X�^�[�g�����擾
    StartRireki = strStartRireki
End Property
Property Let EndRireki(strargEndRireki As String)
    '�G���h����ݒ�
    strEndRireki = strargEndRireki
End Property
Property Get EndRireki() As String
    '�G���h�����擾
    EndRireki = strEndRireki
End Property
Property Let TableName(strargTableName As String)
    '�e�[�u�����ݒ�
    strTableName = strargTableName
End Property
Property Get TableName() As String
    '�e�[�u�����擾
    TableName = strTableName
End Property
Property Let Maisu(longargMaisuu As Long)
    '�����ݒ�
    longMaisuu = longargMaisuu
End Property
Property Get Maisu() As Long
    '�����擾
    Maisu = longMaisuu
End Property
Property Let RenbanKeta(byteargKetasuu As Byte)
    '�A�Ԍ����ݒ�
    byteRenbanketa = byteargKetasuu
End Property
Property Get RenbanKeta() As Byte
    '�A�Ԍ����擾
    RenbanKeta = byteRenbanketa
End Property
Property Let JobNumber(strargJobNumber As String)
    '�W���u�ԍ��ݒ�
    strJobNumber = strargJobNumber
End Property
Property Get JobNumber() As String
    '�W���u�ԍ��擾
    JobNumber = strJobNumber
End Property
Property Set FieldType(ByRef dicargFieldType As Dictionary)
    '�t�B�[���h�^�C�v�ݒ�
    Set dicFieldType = dicargFieldType
End Property
Property Get FieldType() As Dictionary
    '�t�B�[���h�^�C�v�擾
    Set FieldType = dicFieldType
End Property
Property Let RirekiHeader(strargRirekiHeader As String)
    '�����w�b�_�ݒ�
    strRirekiHeader = strargRirekiHeader
End Property
Property Get RirekiHeader() As String
    '�����w�b�_�擾
    RirekiHeader = strRirekiHeader
End Property
Property Let RirekiNumber(longargRirekiNumber As Long)
    '�����̘A�Ԑݒ�
    longRirekiNumber = longargRirekiNumber
End Property
Property Get RirekiNumber() As Long
    '�����̘A�Ԏ擾
    RirekiNumber = longRirekiNumber
End Property
Property Get Rireki() As String
'    '�����i���������́j
    Rireki = Me.RirekiHeader & Right(String$(Me.RenbanKeta, "0") & Me.RirekiNumber, Me.RenbanKeta)
End Property
'���\�����b�h
Public Function CreateInsertSQL(Optional ByVal boolCheckLastRireki As Boolean, _
                                Optional ByVal strargStartRireki As String, _
                                Optional ByVal longargMaisuu As Long, _
                                Optional ByVal strargTableName As String, _
                                Optional ByVal strargJobNumber As String) As Boolean
    Dim KishuInfo As typKishuInfo
    Dim longRirekiCount As Long
    Dim strField As String          '�t�B�[���h�����܂ł�SQL
    Dim intReturnCode               'msgbox�֐��̃��^�[���R�[�h
    On Error GoTo ErrorCatch
    '�t�B�[���h���͐�Ƀv���p�e�B�ŃZ�b�g���Ăق����́E�E�E
    If Not strargStartRireki = "" Then
        Me.StartRireki = strargStartRireki
    End If
    If Not longargMaisuu = 0 Then
        Me.Maisu = longargMaisuu
    End If
    If Not strargTableName = "" Then
        Me.TableName = strargTableName
    End If
    If Not strargJobNumber = "" Then
        Me.JobNumber = strargJobNumber
    End If
    If Me.StartRireki = "" Or _
        Me.Maisu <= 0 Or _
        Me.TableName = "" Or _
        Me.JobNumber = "" Then
        MsgBox "CreateInsertSQL �G���[�F�K�{���ڂœ��͂���Ă��Ȃ��ꏊ������܂�"
        CreateInsertSQL = False
        Exit Function
    End If
    'DB���痚���̌����Ƃ��E���Ă���
    KishuInfo = getKishuInfoByRireki(Me.StartRireki)
    If Me.RenbanKeta = 0 Then
        Me.RenbanKeta = KishuInfo.RenbanKetasuu
    End If
    Me.RirekiHeader = Left(Me.StartRireki, KishuInfo.TotalRirekiketa - KishuInfo.RenbanKetasuu)
    'FieldType��`���Ȃ���Ă��邩�`�F�b�N
    If dicFieldType Is Nothing Then
        Set dicFieldType = GetFieldTypeNameByTableName(Me.TableName)
    End If
    '���X�g�����`�F�b�N�̗L���ɂ�菈������
    If boolCheckLastRireki Then
        Me.EndRireki = Me.RirekiHeader & Right(String$(Me.RenbanKeta, "0") & _
                        CLng(Right(Me.StartRireki, KishuInfo.RenbanKetasuu)) + Me.Maisu - 1, Me.RenbanKeta)
        intReturnCode = MsgBox(prompt:="�ŏI������ " & Me.EndRireki & " �ō����Ă��܂����H", Buttons:=vbYesNo)
        If intReturnCode = vbNo Then
            Debug.Print "Last Rireki Check Abort"
            CreateInsertSQL = False
            Exit Function
        End If
    End If
    dblTimer = timer()
    Debug.Print "CreateInsertSQL �o���N�Ή��C���T�[�gSQL�쐬�E�����J�n"
    Call BuildFieldList
    Call BuildJobDataValuesList
    CreateInsertSQL = True
    Exit Function
ErrorCatch:
    Debug.Print "CreateInsertSQL: " & Err.Number & "Description: " & Err.Description
End Function
Private Function BuildFieldList() As Boolean
    Dim intValueCount As Integer
    Dim strarrBuf() As String
    Dim intCounter As Integer
    On Error GoTo ErrorCatch
    If Not strSQLBuilder = "" Then
        Debug.Print "Already string here"
        Exit Function
    End If
    '�ŏ���1���ڂ͍��ړ��ꂿ�Ⴄ�̂ŁA�ŁA�Ō������ς�J�b�R�����̂ŁA�����ς��Ȃ��E�E�E
    intValueCount = UBound(Me.FieldArray) - LBound(Me.FieldArray)
    ReDim strarrBuf(intValueCount)
    For intCounter = 0 To intValueCount
        Select Case intCounter
        Case 0
            '�ŏ�
            strarrBuf(intCounter) = "INSERT INTO " & Me.TableName & " (" & Me.FieldArray(intCounter)
        Case intValueCount
            '�Ō�
            strarrBuf(intCounter) = Me.FieldArray(intCounter) & ") VALUES "
        Case Else
            '�r��
            strarrBuf(intCounter) = Me.addQuote(Me.FieldArray(intCounter))
        End Select
    Next intCounter
    '�����������s
    strSQLBuilder = Append(strSQLBuilder, strarrBuf)
    BuildFieldList = True
    Exit Function
ErrorCatch:
    Debug.Print "BuildFiedList code: " & Err.Number & "Description: " & Err.Description
End Function
Private Function BuildJobDataValuesList() As Boolean
    'INSERT ��VALUES �ȍ~�̑������\�z����
    Dim longCounterBulk As Long           '������me.BulkCount�Ŋ���؂ꂽ��A�������񂻂���SQL���s����
    Dim intFieldCounter As Integer
    Dim longMaisuuCounter As Long
    Dim longRirekiNumber As Long
    Dim strarrBuf() As String
    Dim strValues(0) As String
    Dim longCurrentElement As Long          '�o�b�t�@�̌��݂́i�ʎZ�j�v�f���A�t�B�[���h�~���R�[�h���ɂȂ邩��
    Dim isCollect As Boolean
    Dim dbJobData As clsSQLiteHandle
    Dim strLocalTimeWithMSec As String      '�~���b�t���̌��ݓ���
    On Error GoTo ErrorCatch
'    Set dbJobData = New clsSQLiteHandle
    longCurrentElement = 0
    strValues(0) = ""
    '���ݓ������擾
    strLocalTimeWithMSec = GetLocalTimeWithMilliSec()
    '�Ȃ���������x���s����Ă��܂���������̂ŁA�擪�ő��s�ۂ𔻒f
'    If Me.Maisu <= longRecordCount Then
'        '�����K�v�����͏I����Ă�̂ŁA�����𒆒f���Ĕ�����
'        BuildJobDataValuesList = False
'        GoTo CloseAndExit
'        Exit Function
'    End If
    '�o���N���������̏��Ȃ��ق� �~ �t�B�[���h�����̃o�b�t�@���m��
    ReDim strarrBuf(Application.WorksheetFunction.Min _
    (Me.BulkCount, Me.Maisu) * (UBound(Me.FieldArray) - LBound(Me.FieldArray) + 1) - 1)
    longMaisuuCounter = 1
    longCounterBulk = 1
    '���ꂪ��ԊO���̃��[�v�BFor�͂��߁B�w�肳�ꂽ�������I���܂ŌJ��Ԃ�
    Do While longMaisuuCounter <= Me.Maisu
        '���̃��[�v�𔲂�����SQL���s���ASQL�N���A���Ă܂����Ȃ���
        '�o���N�J�E���g�����ǁA�����For�͂��߁A���Ő����ς��̂�
        Do While longCounterBulk <= Me.BulkCount
            '�����ŗ����̘A�Ԃ𓱏o����
            Me.RirekiNumber = CLng(Right(Me.StartRireki, Me.RenbanKeta)) + longMaisuuCounter - 1
            '��ԓ����̃��[�v�B�����Ńt�B�[���h�̐������[�v����i���@�̂ЂƂ܂Ƃ܂�j
            For intFieldCount = LBound(Me.FieldArray) To UBound(Me.FieldArray)
                '���ꂼ��t�B�[���h���ɂ���ē��o���@���قȂ�
                Select Case Me.FieldArray(intFieldCount)
                Case Job_Number
                    strarrBuf(longCurrentElement) = Me.JobNumber
                Case Job_RirekiHeader
                    strarrBuf(longCurrentElement) = Me.RirekiHeader
                Case Job_RirekiNumber
                    strarrBuf(longCurrentElement) = Me.RirekiNumber
                Case Job_Rireki
                    strarrBuf(longCurrentElement) = Me.Rireki
                Case Field_Initialdate
                    strarrBuf(longCurrentElement) = strLocalTimeWithMSec
                Case Else
                    MsgBox Me.FieldArray(intFieldCount) & "�͒m��Ȃ��q�ł�"
                End Select
                '�f�[�^�^�ɂ���āA�N�I�[�g�̕K�v���̗L���𔻒f����
                Select Case Me.FieldType.Item(Me.FieldArray(intFieldCount))
                Case "TEXT", "BLOB"
                    '�N�I�[�g���K�v
                    strarrBuf(longCurrentElement) = addQuote(strarrBuf(longCurrentElement))
                Case "NUMERIC", "INTEGER", "FLOAT"
                    '�Ƃ肠�������̂܂܂�
                End Select
                '�t�B�[���h���[�v�̍Ō�Ȃ̂ŁA�J�b�R���̂̏��������Ă�����
                If intFieldCount = LBound(Me.FieldArray) Then
                    'Value�̍ŏ��Ȃ̂�(��擪�ɂ��Ă�����
                    strarrBuf(longCurrentElement) = "(" & strarrBuf(longCurrentElement)
                ElseIf intFieldCount = UBound(Me.FieldArray) Then
                    '�Ō�Ȃ̂ŁA�J�b�R���Ă����� )
                    strarrBuf(longCurrentElement) = strarrBuf(longCurrentElement) & ")"
                End If
                longCurrentElement = longCurrentElement + 1
            Next intFieldCount
            '�I������疇���ƃo���N�J�E���^�[�C���N�������g
            longMaisuuCounter = longMaisuuCounter + 1
            longCounterBulk = longCounterBulk + 1
            '�o���N�J�E���g�Ƃ͕ʂɁA���񖇐����Ď����邱�ƁA����ɒB�����炷���ɔ�����
            If longCounterBulk - 1 Mod Me.BulkCount = 0 Or _
                longMaisuuCounter > Me.Maisu Then
                Exit Do
            End If
        Loop
        '�K�萔�ɒB�����̂ŁA���������̏�ASQL���s���ASQL���N���A�A�t�B�[���h�č\�z������
        '���̂Ƃ���Ƃ肠�������@���Ȃ��̂ŁAUnique�ᔽ���������s�͋󂢂Ă�UpdateDate�̃t�B�[���h�Ɍ��ݎ�����˂�����
        '���[�v�������當���A��
        strarrBuf(longCurrentElement - 1) = strarrBuf(longCurrentElement - 1) & vbCrLf & " on CONFLICT(RirekiNumber) do UPDATE set UpdateDate = CURRENT_TIMESTAMP"
        Debug.Print "�z��i�[�����B�o���N�� " & Me.BulkCount & " �A�v�f�� " & longCurrentElement & " �� " & timer - dblTimer & " �b�|����܂����B"
        Set dbJobData = New clsSQLiteHandle
        '�܂���Values�̒���A�����Ă��
        strValues(0) = Append("", strarrBuf)
        '���ɁAFields�̕����ƘA��
        strSQLBuilder = Append(strSQLBuilder, strValues, " ")
        dbJobData.SQL = strSQLBuilder
        Debug.Print "�����A�������B�o���N�� " & Me.BulkCount & " �� " & timer - dblTimer & " �b�|����܂����B"
        'SQL���s
        isCollect = dbJobData.Do_SQL_With_Transaction()
        If Not isCollect Then
            Debug.Print "�o���N�C���T�[�g���ɉ����������悤�ł��ɂ�"
        End If
        strSQLBuilder = ""
        strValues(0) = ""
        longCurrentElement = 0
        longCounterBulk = 1
        '����ڑ���j�����Ă݂�
        Set dbJobData = Nothing
        If Me.Maisu <= longMaisuuCounter Then
            '�����K�v�����͏I����Ă�̂ŁA�����𒆒f���Ĕ�����
            BuildJobDataValuesList = True
            GoTo CloseAndExit
            Exit Function
        End If
        '�o���N���������̎c��̏��Ȃ��ق� �~ �t�B�[���h�����̃o�b�t�@���m��
        ReDim strarrBuf(Application.WorksheetFunction.Min _
        (Me.BulkCount, (Me.Maisu - longMaisuuCounter + 1)) * (UBound(Me.FieldArray) - LBound(Me.FieldArray) + 1) - 1)
        '���̎����SQL�\�z����������
        Call BuildFieldList
    Loop
    BuildJobDataValuesList = True
    GoTo CloseAndExit
    Exit Function
CloseAndExit:
    Debug.Print "������������ " & "�o���N��:" & Me.BulkCount & "�A����:" & Me.Maisu & "���� " & timer() - dblTimer & " �b�|�������悤�ł�"
    Set dbJobData = Nothing
    Exit Function
ErrorCatch:
    Debug.Print "BuildJobDataValues code: " & Err.Number & "Description: " & Err.Description
End Function
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
    Debug.Print "Append Error code: " & Err.Number & "Description: " & Err.Description
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
    Debug.Print "addQuote Error code: " & Err.Number & "Description: " & Err.Description
End Function
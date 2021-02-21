Attribute VB_Name = "SQL_View_To"
Option Explicit
'�����I��View�e�[�u���ɂ�����SQL���W�߂܂�
Public Function ReturnJobNumber_For_KanbanDivide(ByVal strargTableName As String) As Variant
    Dim strSQL As String
    Dim vararrKanbanJobNumber As Variant
    Dim dbKanbanJobNumber As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Set dbKanbanJobNumber = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    strSQL = strSQL & "SELECT " & sqlbC.addQuote(Job_Number) & " as ""Job�ԍ�"", " & sqlbC.addQuote(Field_Initialdate) & " as ""�o�^����"",count(*) - count("
    strSQL = strSQL & sqlbC.addQuote(Job_KanbanChr) & ") as ""�c�薇��"" FROM " & sqlbC.addQuote(strargTableName)
'    strSQL = strSQL & " WHERE " & sqlbC.addQuote(Job_KanbanChr) & " IS NULL GROUP BY " & sqlbC.addQuote(Job_Number) & "," & sqlbC.addQuote(Field_Initialdate)
    strSQL = strSQL & " GROUP BY " & sqlbC.addQuote(Job_Number) & "," & sqlbC.addQuote(Field_Initialdate)
    strSQL = strSQL & " ORDER BY " & sqlbC.addQuote(Job_RirekiNumber) & " ASC;"
    dbKanbanJobNumber.SQL = strSQL
    dbKanbanJobNumber.DoSQL_No_Transaction
    vararrKanbanJobNumber = dbKanbanJobNumber.RS_Array(boolPlusTytle:=False)
    Set dbKanbanJobNumber = Nothing
    Set sqlbC = Nothing
    ReturnJobNumber_For_KanbanDivide = vararrKanbanJobNumber
    Exit Function
ErrorCatch:
    Set dbKanbanJobNumber = Nothing
    Set sqlbC = Nothing
    Debug.Print "ReturnJobNumber code: " & Err.Number & " Description: " & Err.Description
    Exit Function
End Function
Public Function ReturnDivideChrByJobNumber(ByVal strargTableName As String, ByVal strargJobNumber As String, ByVal strargInputDate As String) As Variant
    Dim strSQL As String
    Dim vararrDivideChr As Variant
    Dim dbDivideChr As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Set dbDivideChr = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    strSQL = strSQL & "SELECT " & sqlbC.addQuote(Job_KanbanChr) & " AS ""����������"",0 AS ""�V�[�g��"",COUNT("
    strSQL = strSQL & sqlbC.addQuote(Job_Rireki) & ") AS ""����"", 0 as ""���b�N��"",MIN(" & sqlbC.addQuote(Job_Rireki) & ") AS ""�X�^�[�g����"",MAX("
    strSQL = strSQL & sqlbC.addQuote(Job_Rireki) & ") as ""�G���h����"" FROM " & sqlbC.addQuote(strargTableName)
    strSQL = strSQL & " WHERE " & sqlbC.addQuote(Job_Number) & " = " & sqlbC.addQuote(strargJobNumber) & " AND "
    strSQL = strSQL & sqlbC.addQuote(Field_Initialdate) & " = " & sqlbC.addQuote(strargInputDate) & " AND "
    strSQL = strSQL & sqlbC.addQuote(Job_KanbanChr) & " IS NOT NULL GROUP BY "
    strSQL = strSQL & sqlbC.addQuote(Job_KanbanChr) & "," & sqlbC.addQuote(Job_Number) & "," & sqlbC.addQuote(Field_Initialdate)
    strSQL = strSQL & " ORDER BY " & sqlbC.addQuote(Job_RirekiNumber) & " ASC;"
    dbDivideChr.SQL = strSQL
    dbDivideChr.DoSQL_No_Transaction
    vararrDivideChr = dbDivideChr.RS_Array(boolPlusTytle:=True)
    ReturnDivideChrByJobNumber = vararrDivideChr
    Set dbDivideChr = Nothing
    Set sqlbC = Nothing
    Exit Function
ErrorCatch:
    Set dbDivideChr = Nothing
    Set sqlbC = Nothing
    Debug.Print "ReturnDivideChrByJobNumber code: " & Err.Number & " Description: " & Err.Description
    Exit Function
End Function
Public Function GetNextKanbanChrByTableName(ByVal strargTableName As String) As String
    'JOB�֌W�Ȃ��A�ő嗚���̕���������́u���́v�g�p���𕶎���^�ŕԂ�
    Dim strLastKanbanChr As String
    Dim dbNextKanbanChr As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Dim strSQL As String
    Dim vararrNextKanban As Variant
    Set dbNextKanbanChr = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    '�Ō�̕�������擾����SQL
    strSQL = strSQL & "SELECT " & sqlbC.addQuote(Job_KanbanChr) & " FROM " & sqlbC.addQuote(strargTableName) & " WHERE " & sqlbC.addQuote(Job_RirekiNumber)
    strSQL = strSQL & " = (SELECT MAX(" & sqlbC.addQuote(Job_RirekiNumber) & ") FROM " & sqlbC.addQuote(strargTableName)
    strSQL = strSQL & " WHERE " & sqlbC.addQuote(Job_KanbanChr) & " IS NOT NULL);"
    dbNextKanbanChr.SQL = strSQL
    dbNextKanbanChr.DoSQL_No_Transaction
    If dbNextKanbanChr.RecordCount = 0 Then
        '���R�[�h�J�E���g0�̏ꍇ��A��Ԃ��ďI���
        GetNextKanbanChrByTableName = Chr(MIN_Kanban_ChrCode)
        Exit Function
    End If
    vararrNextKanban = dbNextKanbanChr.RS_Array(boolPlusTytle:=False)
    Set dbNextKanbanChr = Nothing
    Set sqlbC = Nothing
    strLastKanbanChr = UCase(vararrNextKanban(0, 0))
    '��`���Ă���ő啶���R�[�h�𒴂��邩�ǂ����ŏ����𕪊򂷂�
    If Asc(strLastKanbanChr) + 1 > MAX_Kanban_ChrCode Then
        '������ꍇ�́A�ŏ��l�iA�j��Ԃ��Ă��
        GetNextKanbanChrByTableName = Chr(MIN_Kanban_ChrCode)
        Exit Function
    Else
        '�����Ȃ��ꍇ�́A�����R�[�h+1�̕�����Ԃ��Ă��
        GetNextKanbanChrByTableName = Chr(Asc(strLastKanbanChr) + 1)
        Exit Function
    End If
ErrorCatch:
    Set dbNextKanbanChr = Nothing
    Set sqlbC = Nothing
    Debug.Print "GetNextKanbanChrByTableName code: " & Err.Number & " Description: " & Err.Description
    Exit Function
End Function
Public Function GetNextKanbanRirekiByJobNumber(ByVal strargTableName As String, ByVal strargJobNumber As String, ByVal strargInitialDate As String) As String
    'Job���ŁAKanbanChr��Null�̂�̍ŏ������i= �Ŕ̎��̗����j���擾����
    Dim dbNextKanbanRireki As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Dim strSQL As String
    Dim vararrNextKanbanRireki As Variant
    Set dbNextKanbanRireki = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    'SQL�g�ݗ���
    strSQL = strSQL & "SELECT MIN(" & sqlbC.addQuote(Job_Rireki) & ") FROM " & sqlbC.addQuote(strargTableName)
    strSQL = strSQL & " WHERE " & sqlbC.addQuote(Job_Number) & " = " & sqlbC.addQuote(strargJobNumber) & " AND "
    strSQL = strSQL & sqlbC.addQuote(Field_Initialdate) & " = " & sqlbC.addQuote(strargInitialDate)
    strSQL = strSQL & " AND " & sqlbC.addQuote(Job_KanbanChr) & " IS NULL;"
    dbNextKanbanRireki.SQL = strSQL
    dbNextKanbanRireki.DoSQL_No_Transaction
    If dbNextKanbanRireki.RecordCount = 0 Then
        '�����ɍ������̂���������
        GetNextKanbanRirekiByJobNumber = ""
        Exit Function
    End If
    vararrNextKanbanRireki = dbNextKanbanRireki.RS_Array
    Set dbNextKanbanRireki = Nothing
    Set sqlbC = Nothing
    If IsNull(vararrNextKanbanRireki(0, 0)) Then
        GetNextKanbanRirekiByJobNumber = "�c�薇��0�Ȃ̂ŐV�KJob�����͂ł��܂���" & vbCrLf & "����Job��I�����ĉ�����"
        Exit Function
    End If
    GetNextKanbanRirekiByJobNumber = CStr(vararrNextKanbanRireki(0, 0))
    Exit Function
ErrorCatch:
    Set dbNextKanbanRireki = Nothing
    Set sqlbC = Nothing
    Debug.Print "GetNextKanbanRireki code: " & Err.Number & " Description: " & Err.Description
End Function
Public Function UpdateKanbanChrByJobNumberMaisuu(strargTableName As String, strargKanbanChr As String, strargStartRireki As String, longargMaisuu As Long, argKishuInfo As typKishuInfo) As Boolean
    '�^����ꂽ���������ɊŔf�[�^��Update���s��
    Dim intRackTotal As Integer
    Dim intCurrentRack As Integer
    Dim longCurrentMaisuuStart As Long
    Dim longCurrentMaisuuEnd As Long
    Dim longStartRirekiNumber As Long
    Dim longEndRirekiNumber As Long
    Dim longMaiPerRack As Long
    Dim strSQL As String
    Dim dbUpdateKanban As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Dim isCollect As Boolean
    On Error GoTo ErrorCatch
    If longargMaisuu <= 0 Then
        MsgBox "������0�ȉ����w�肳��܂����B�����𒆎~���܂�"
        UpdateKanbanChrByJobNumberMaisuu = False
        Exit Function
    End If
    '���b�N������̖��������߂�
    longMaiPerRack = CLng(argKishuInfo.MaiPerSheet) * CLng(argKishuInfo.SheetPerRack)
    '�g�[�^���̃��b�N�������߂�
    intRackTotal = Application.WorksheetFunction.RoundUp(CDbl(longargMaisuu) / CDbl(longMaiPerRack), 0)
    '�X�^�[�g�����ƏI�����������߂�
    longStartRirekiNumber = CLng(Right(strargStartRireki, argKishuInfo.RenbanKetasuu))
    longEndRirekiNumber = longStartRirekiNumber + longargMaisuu - 1
    intCurrentRack = 1
    Do While intCurrentRack <= intRackTotal
    '�ŏI���b�N���ǂ����ŏ����𕪊򂷂�
        Select Case intCurrentRack = intRackTotal
        Case True
            '�ŏI���b�N�̏ꍇ
            longCurrentMaisuuStart = longStartRirekiNumber + ((intCurrentRack - 1) * longMaiPerRack)
            longCurrentMaisuuEnd = longEndRirekiNumber
        Case False
            '�r���̃��b�N�̏ꍇ
            longCurrentMaisuuStart = longStartRirekiNumber + ((intCurrentRack - 1) * longMaiPerRack)
            longCurrentMaisuuEnd = longCurrentMaisuuStart + longMaiPerRack - 1
        End Select
        'SQL�����A�����A�g�����U�N�V�������������
        '������DB��SQLBulider�̃C���X�^���X����
        Set dbUpdateKanban = New clsSQLiteHandle
        Set sqlbC = New clsSQLStringBuilder
        strSQL = ""
        strSQL = strSQL & "UPDATE " & sqlbC.addQuote(strargTableName) & " SET " & sqlbC.addQuote(Job_KanbanChr) & " = " & sqlbC.addQuote(strargKanbanChr)
        strSQL = strSQL & "," & sqlbC.addQuote(Job_KanbanNumber) & " = " & intCurrentRack
        strSQL = strSQL & " WHERE " & sqlbC.addQuote(Job_RirekiNumber) & " BETWEEN " & longCurrentMaisuuStart & " AND " & longCurrentMaisuuEnd & ";"
        dbUpdateKanban.SQL = strSQL
        isCollect = dbUpdateKanban.Do_SQL_With_Transaction
        Set dbUpdateKanban = Nothing
        Set sqlbC = Nothing
        If Not isCollect Then
            MsgBox "�Ŕ��A�b�v�f�[�g���ɃG���[����"
            Debug.Print "UpdateKanbanChrByJobMaisuu Table:" & strargTableName & " StarNumber: " & longCurrentMaisuuStart & " EndNumber: " & longCurrentMaisuuEnd
            Exit Function
        End If
        '1���b�N�ڂ̏�������
        '���b�N�J�E���g�C���N�������g
        intCurrentRack = intCurrentRack + 1
     Loop
     UpdateKanbanChrByJobNumberMaisuu = True
     Exit Function
ErrorCatch:
     Debug.Print "UpdateKanbanChrByJobNumberMaisuu code: " & Err.Number & " Description: " & Err.Description
End Function
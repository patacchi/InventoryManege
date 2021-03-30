Attribute VB_Name = "SQL_View_To"
Option Explicit
'�����I��View�e�[�u���ɂ�����SQL���W�߂܂�
Public Function ReturnJobNumber_For_KanbanDivide(ByVal strargTableName As String, ByRef argKishuInfo As typKishuInfo) As Variant
    Dim strSQL As String
    Dim strRirekiNumber As String
    Dim strFromTable As String
    Dim strJobNumber As String
    Dim strInitialDate As String
    Dim strKanbanChr As String
    Dim longStartNumber_Temp As Long                '����A�Ԃ̎b��X�^�[�g
    Dim jobStart As typJobInfo                      '�X�^�[�g�A�Ԃ�JobInfo
    Dim longStartRirekiNumber As Long               '����A�Ԃ̃X�^�[�g
    Dim longEndNumber_Temp As Long                  '����A�Ԃ̎b��G���h
    Dim jobEnd As typJobInfo                        '�G���h�A�Ԃ�JobInfo
    Dim longEndRirekiNumber As Long                 '����A�Ԃ̃G���h
    Dim longKanbanCurrent As Long                   '�Ŕ����̌��݂̍ŏI�A��
    Dim longJobCurrent As Long                      'Job�o�^�̍ŏI�A��
    Dim vararrKanbanJobNumber As Variant
    Dim dbKanbanJobNumber As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Set dbKanbanJobNumber = New clsSQLiteHandle
    #If READLOCAL Then
        dbKanbanJobNumber.LocalMode = True
    #Else
        dbKanbanJobNumber.LocalMode = False
    #End If
    Set sqlbC = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    '�ȉ����p�����[�^�o�C���h�A����With��Ŏ擾������������
    '�p�����[�^�o�C���h�ɂ���ϐ���addquote������_����GroupBy�Ƀp�����[�^�����Ȃ������E�E�E
    strRirekiNumber = sqlbC.addQuote(Job_RirekiNumber)
'    strRirekiNumber = Job_RirekiNumber
    strFromTable = sqlbC.addQuote(strargTableName)
'    strFromTable = strargTableName
    strJobNumber = sqlbC.addQuote(Job_Number)
'    strJobNumber = Job_Number
    strInitialDate = sqlbC.addQuote(Field_Initialdate)
'    strInitialDate = Field_Initialdate
    strKanbanChr = sqlbC.addQuote(Job_KanbanChr)
'    strKanbanChr = Job_KanbanChr
    '�Ŕ�Job�o�^�A���ꂼ��̘A�Ԃ̃G���h���擾
    longKanbanCurrent = GetLastRirekiNumber_byKishuTable(argKishuInfo.KishuName, KanbanChrField, boolRenumberIfZero:=True)
    longJobCurrent = GetLastRirekiNumber_byKishuTable(argKishuInfo.KishuName, JobNumberField, True)
    '�A�Ԃ̃X�^�[�g�E�G���h�����߂�
    Select Case frmKanban.chkBoxLastArea
    Case True
        '�͈͐������ݒ肳��Ă���ꍇ�i���������f�t�H���g�j
        '�b��̃X�^�[�g�E�G���h�����߂�
        longStartNumber_Temp = Application.WorksheetFunction.Max(1, longKanbanCurrent - CLng(frmKanban.txtBoxBeforeArea.Text))
        longEndNumber_Temp = Application.WorksheetFunction.Min(longJobCurrent, longKanbanCurrent + CLng(frmKanban.txtBoxAfterArea.Text))
    Case False
        '�͈͐����Ȃ��̏ꍇ
        longStartNumber_Temp = 1
        longEndNumber_Temp = longJobCurrent
    End Select
    '���߂�ꂽ�A�Ԃ���AJob�P�ʂ�RoudUp,RoundDown���s��
    jobStart = GetRoundJobInfo_byRirekiNumber(longStartNumber_Temp, Floor_to_Ceil, argKishuInfo)
    jobEnd = GetRoundJobInfo_byRirekiNumber(longEndNumber_Temp, Ceil_to_Floor, argKishuInfo)
    longStartRirekiNumber = jobStart.StartNumber
    longEndRirekiNumber = jobEnd.EndNumber
    '�o�C���h�p���X�g�ݒ�
    Set dbKanbanJobNumber.NamedParm = dbKanbanJobNumber.GetNamedList("@RirekiStart", Int32, longStartRirekiNumber)
    Set dbKanbanJobNumber.NamedParm = dbKanbanJobNumber.GetNamedList("@RirekiEnd", Int32, longEndRirekiNumber)
'    Set dbKanbanJobNumber.NamedParm = dbKanbanJobNumber.GetNamedList("@GroupBy1", Text, strJobNumber)
'    Set dbKanbanJobNumber.NamedParm = dbKanbanJobNumber.GetNamedList("@GroupBy2", Text, strInitialDate)
'    Set dbKanbanJobNumber.NamedParm = dbKanbanJobNumber.GetNamedList("@GroupBy3", Text, strKanbanChr)
'    With_Local
'    With_Remote
'    strSQL = strSQL & "SELECT " & sqlbC.addQuote(Job_Number) & " as ""Job�ԍ�"", " & sqlbC.addQuote(Field_Initialdate) & " as ""�o�^����"",count(*) - count("
'    strSQL = strSQL & sqlbC.addQuote(Job_KanbanChr) & ") as ""�c�薇��"" FROM " & sqlbC.addQuote(strargTableName)
''    strSQL = strSQL & " WHERE " & sqlbC.addQuote(Job_KanbanChr) & " IS NULL GROUP BY " & sqlbC.addQuote(Job_Number) & "," & sqlbC.addQuote(Field_Initialdate)
'    strSQL = strSQL & " GROUP BY " & sqlbC.addQuote(Job_Number) & "," & sqlbC.addQuote(Field_Initialdate)
'    strSQL = strSQL & " ORDER BY " & sqlbC.addQuote(Job_RirekiNumber) & " ASC;"
    strSQL = "WITH " & With_Remote & " AS (SELECT * FROM " & strFromTable & " WHERE " & strRirekiNumber & " BETWEEN @RirekiStart AND @RirekiEnd)"
    strSQL = strSQL & "SELECT " & strJobNumber & " as ""Job�ԍ�""," & strInitialDate & " as ""�o�^����"",count(*) - count("
    strSQL = strSQL & strKanbanChr & ") as ""�c�薇��"" FROM " & With_Remote
    'strSql = strSql & " GROUP BY @GroupBy1,@GroupBy2,@GroupBy3 ORDER BY " & sqlbC.addQuote(strRirekiNumber) & " ASC;"
    strSQL = strSQL & " GROUP BY " & strJobNumber & "," & strInitialDate & " ORDER BY " & strRirekiNumber & " ASC;"
    dbKanbanJobNumber.SQL = strSQL
'    dbKanbanJobNumber.DoSQL_No_Transaction
    dbKanbanJobNumber.Do_SQL_Use_NamedParm_NO_Transaction
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
Public Function ReturnJobInfo_by_JobNumber(ByRef argKishuInfo As typKishuInfo, ByVal strargJobNumber As String, ByVal strargInitialDate As String) As typJobInfo
    'Job�ԍ���InitialInputDate��^���Ă�����āATypJobInfo�^�ŕԂ�
    '���̂Ƃ���̓X�^�[�g�ƃG���h�̘A�ԁE�����̂�
    Dim localJobInfo As typJobInfo
    Dim strSQL As String
    Dim strTableName As String
    Dim strFieldJobNumber As String
    Dim strFieldRireki As String
    Dim strFieldInitialDate As String
    Dim varReturn As Variant
    Dim dbJobInfo As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    On Error GoTo ErrorCatch
    Set sqlbC = New clsSQLStringBuilder
    Set dbJobInfo = New clsSQLiteHandle
    strTableName = sqlbC.addQuote(Table_JobDataPri & argKishuInfo.KishuName)
    strFieldJobNumber = sqlbC.addQuote(Job_Number)
    strFieldRireki = sqlbC.addQuote(Job_Rireki)
    strFieldInitialDate = sqlbC.addQuote(Field_Initialdate)
    Set dbJobInfo.NamedParm = dbJobInfo.GetNamedList("@JobNumber", Text, strargJobNumber)
    Set dbJobInfo.NamedParm = dbJobInfo.GetNamedList("@InitialDate", Text, strargInitialDate)
'    WITH Remote_Limit as (select * FROM remote.T_JobData_Test15 WHERE JobNumber = "TT00122" AND InitialInputDate = "2021-03-19T23:09:33.175")
'    SELECT MIN(rireki),MAX(rireki)  FROM Remote_Limit;
    strSQL = "WITH " & With_Remote & " AS (SELECT * FROM " & strTableName & " WHERE " & strFieldJobNumber & " = @JobNumber AND "
    strSQL = strSQL & strFieldInitialDate & " = @InitialDate) "
    strSQL = strSQL & " SELECT MIN(" & strFieldRireki & "),MAX(" & strFieldRireki & ")  FROM " & With_Remote & ";"
    dbJobInfo.SQL = strSQL
    Call dbJobInfo.Do_SQL_Use_NamedParm_NO_Transaction
    varReturn = dbJobInfo.RS_Array
    Set dbJobInfo = Nothing
    Set sqlbC = Nothing
    If UBound(varReturn, 2) < 1 Then
        '���ʎ擾�Ɏ��s���Ă�ۂ�
        ReturnJobInfo_by_JobNumber = localJobInfo
        Exit Function
    End If
    localJobInfo.startRireki = varReturn(0, 0)
    localJobInfo.EndRireki = varReturn(0, 1)
    localJobInfo.StartNumber = CLng(Right(localJobInfo.startRireki, argKishuInfo.RenbanKetasuu))
    localJobInfo.EndNumber = CLng(Right(localJobInfo.EndRireki, argKishuInfo.RenbanKetasuu))
    localJobInfo.JobNumber = strargJobNumber
    localJobInfo.InitialDate = strargInitialDate
    ReturnJobInfo_by_JobNumber = localJobInfo
    Exit Function
ErrorCatch:
    Debug.Print "ReturnJobInfo_by_JobNumber code: " & Err.Number & " Description: " & Err.Description
    Exit Function
End Function
Public Function GetRoundJobInfo_byRirekiNumber(ByVal longargRirekiNumber As Long, ByVal longFindDir As RirekiFindDir, ByRef argKishuInfo As typKishuInfo) As typJobInfo
    Dim strTableName As String
    Dim longCurrentNumber As Long
    Dim longMinNumber As Long
    Dim longMaxNumber As Long
    Dim longFindNumber As Long      '���T���̔ԍ��͂���ł���
    Dim JobInfoLocal As typJobInfo
    On Error GoTo ErrorCatch
    strTableName = Table_JobDataPri & argKishuInfo.KishuName
    '���ꂼ��̘A�Ԃ����߂Ă���
    longCurrentNumber = longargRirekiNumber
    longMinNumber = GetMinimumRirekiNumber_byTableName(strTableName)
    longMaxNumber = GetLastRirekiNumber_byKishuTable(argKishuInfo.KishuName, JobNumberField, True)
    '�ԍ������肷��
    Select Case longFindDir
    Case RirekiFindDir.Ceil_to_Floor
        If longCurrentNumber > longMaxNumber Then
            'max���傫���̂͂��߂��E�E�E
            longFindNumber = longMaxNumber
        Else
            'max�ȉ��Ȃ炻�̂܂܎g��
            longFindNumber = longCurrentNumber
        End If
    Case RirekiFindDir.Floor_to_Ceil
        If longCurrentNumber < longMinNumber Then
            'min�����͂���
            longFindNumber = longMinNumber
        Else
            'min�ȏ�Ȃ炻�̂܂܎g��
            longFindNumber = longCurrentNumber
        End If
    End Select
    JobInfoLocal = GetJobInfo_By_RirekiNumberandKishuInfo(longFindNumber, argKishuInfo)
    GetRoundJobInfo_byRirekiNumber = JobInfoLocal
    Exit Function
ErrorCatch:
    Debug.Print "GetRoundJobInfo_ByRirekiNumber code: " & Err.Number & " Description: " & Err.Description
    GetRoundJobInfo_byRirekiNumber = JobInfoLocal
    Exit Function
End Function
Public Function GetJobInfo_By_RirekiNumberandKishuInfo(longargRirekiNumber As Long, ByRef argKishuInfo As typKishuInfo) As typJobInfo
    '�����̘A�ԕ�����KishuInfo�����āAJobInfo��Ԃ�
    Dim strTableName As String
    Dim strFieldRirekiNumber As String
    Dim strFieldJobNumber As String
    Dim strFieldInitialDate As String
    Dim strJobNumber As String
    Dim strInitialDate As String
    Dim dicReturn As Dictionary
    Dim JobInfoLocal As typJobInfo
    Dim dbJobinfoByNumber As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Set dbJobinfoByNumber = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    '�e�t�B�[���h�ݒ�
    strTableName = sqlbC.addQuote(Table_JobDataPri & argKishuInfo.KishuName)
    strFieldRirekiNumber = sqlbC.addQuote(Job_RirekiNumber)
    strFieldJobNumber = sqlbC.addQuote(Job_Number)
    strFieldInitialDate = sqlbC.addQuote(Field_Initialdate)
    dbJobinfoByNumber.SQL = "SELECT " & strFieldJobNumber & "," & strFieldInitialDate & " FROM " & strTableName
    dbJobinfoByNumber.SQL = dbJobinfoByNumber.SQL & " WHERE " & strFieldRirekiNumber & " = @RirekiNumber ;"
    Set dbJobinfoByNumber.NamedParm = dbJobinfoByNumber.GetNamedList("@RirekiNumber", Int32, longargRirekiNumber)
    '�p�����[�^�o�C���h�����SQL���s
    dbJobinfoByNumber.Do_SQL_Use_NamedParm_NO_Transaction
    Set dicReturn = dbJobinfoByNumber.RS_Array_Dictionary
    If dbJobinfoByNumber.RecordCount = 0 Then
        '�������s���Ă��
        Debug.Print "GetJobInfo_By_Rrirekinumber DB Serch result 0"
        GetJobInfo_By_RirekiNumberandKishuInfo = JobInfoLocal
        Set dbJobinfoByNumber = Nothing
        Set sqlbC = Nothing
        Exit Function
    End If
    Set dbJobinfoByNumber = Nothing
    Set sqlbC = Nothing
    strJobNumber = dicReturn("1")(Job_Number)
    strInitialDate = dicReturn("1")(Field_Initialdate)
    '�擾����Job�ԍ���InitialDate�����ɁAJobInfo���擾����
    JobInfoLocal = ReturnJobInfo_by_JobNumber(argKishuInfo, strJobNumber, strInitialDate)
    GetJobInfo_By_RirekiNumberandKishuInfo = JobInfoLocal
    Exit Function
ErrorCatch:
    Debug.Print "GetJobInfo_ByNumber code: " & Err.Number & " Description: " & Err.Description
    GetJobInfo_By_RirekiNumberandKishuInfo = JobInfoLocal
    Exit Function
End Function
Public Function ReturnDivideChrByJobNumber(ByVal strargTableName As String, ByVal strargJobNumber As String, ByVal strargInputDate As String) As Variant
    Dim strSQL As String
    Dim vararrDivideChr As Variant
    Dim dbDivideChr As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Set dbDivideChr = New clsSQLiteHandle
    #If READLOCAL Then
        dbDivideChr.LocalMode = True
    #Else
        dbDivideChr.LocalMode = False
    #End If
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
    #If READLOCAL Then
        dbNextKanbanChr.LocalMode = True
    #Else
        dbNextKanbanChr.LocalMode = False
    #End If
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
    #If READLOCAL Then
        dbNextKanbanRireki.LocalMode = True
    #Else
        dbNextKanbanRireki.LocalMode = False
    #End If
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
        #If READLOCAL Then
            dbUpdateKanban.LocalMode = True
        #Else
            dbUpdateKanban.LocalMode = False
        #End If
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
Public Function GetOriginalDBSchemaByKishuName(ByVal strargKishuName As String) As Dictionary
    '�^����ꂽ�@�햼(Job_Kishuname)���A�e�[�u���ƃC���f�b�N�X�̃X�L�[�}(sql�j��Dictionary�ŕԂ�
    Dim dbOrigin As clsSQLiteHandle
    Dim dicLocalSchema As Dictionary
    On Error GoTo ErrorCatch
    Set dbOrigin = New clsSQLiteHandle
    Set dicLocalSchema = New Dictionary
    dbOrigin.SQL = "SELECT type,name,sql FROM sqlite_schema WHERE sql IS NOT NULL AND "
    dbOrigin.SQL = dbOrigin.SQL & "name LIKE ""%" & Table_JobDataPri & strargKishuName & "%"";"
    dbOrigin.DoSQL_No_Transaction
    Set dicLocalSchema = dbOrigin.RS_Array_Dictionary
    Set GetOriginalDBSchemaByKishuName = dicLocalSchema
    Set dbOrigin = Nothing
    Set dicLocalSchema = Nothing
    Exit Function
ErrorCatch:
    Debug.Print "GetOriginalDBSchemaByKishuName code: " & Err.Number & " Description: " & Err.Description
    Set dbOrigin = Nothing
    Set dicLocalSchema = Nothing
    Exit Function
End Function
Public Function CopyDBTableRemote_To_Local(ByVal strargTableName As String, ByVal strargLocalDBFilePath As String, Optional ByVal strargRemoteDbFilePath As String, _
                                            Optional ByVal longargLastNumberArea As Long) As Boolean
    '�����[�g���I���W�i���Ƃ��āA���[�J���ɑI���R�s�[����
    'longargLastNunmberArea�ŁA�ŐV�Z���ɍi���Ē��o����悤�ɂ���A���Ă��Ȃ��ꍇ�͍ŏ�����Ō�܂Łi���Ԃ������E�E�E)
    Dim strRemoteDBPath As String
    Dim dbCopyTable As clsSQLiteHandle
    Dim strRmoteTableName As String
    Dim strLocalTableName As String
    Dim strSrcWhereField As String
    Dim sqlbC As clsSQLStringBuilder
    Dim strSQL As String
    Dim isCollect As Boolean
    Dim longSrcStartRirekiNumber As Long            '�R�s�[���e�[�u���̍ŏ�����ԍ��i�A�ԕ����̂݁j
    Dim longSrcEndRirekiNumber As Long              '�R�s�[���e�[�u���̍ő嗚��ԍ�
    Set dbCopyTable = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    '�܂��̓����[�gDB�t�@�C���p�X�����肷��
    If strargRemoteDbFilePath = "" Then
        strRemoteDBPath = constDatabasePath & "\" & constJobNumberDBname
    Else
        strRemoteDBPath = strargRemoteDbFilePath
    End If
    '���Ƀ����[�g�ƃ��[�J���̃e�[�u����
    strRmoteTableName = """remote""." & sqlbC.addQuote(strargTableName)
    strLocalTableName = sqlbC.addQuote(strargTableName)
    '���Ƀ����[�gDB���A�^�b�`����
    strSQL = "ATTACH " & sqlbC.addQuote(strRemoteDBPath) & " AS ""remote"";"
    dbCopyTable.SQL = strSQL
    dbCopyTable.DBPath = strargLocalDBFilePath
    isCollect = dbCopyTable.DoSQL_No_Transaction()
    If Not isCollect Then
        MsgBox "�����[�gDB�A�^�b�`���ɃG���[����"
        GoTo ErrorCatch
        Exit Function
    End If
    '���ɁA�����[�g���烍�[�J���ւ̃R�s�[�������s�i�������d���I�j
    '�g�����U�N�V�����L��SQL���s
    '�p�����[�^�o�C���h���g�p����
    MsgBox "�܂��쐬�r������_CopyDBTableRemote_TO_Local"
    isCollect = dbCopyTable.DoSQL_No_Transaction("BEGIN TRANSACTION")
    If Not isCollect Then
        MsgBox "�g�����U�N�V���������J�n���s�A�����𒆒f���܂�"
        CopyDBTableRemote_To_Local = False
        dbCopyTable.RollBackTransaction
        GoTo ErrorCatch
        Exit Function
    End If
    'INSERT INTO T_JobData_Test15 SELECT * FROM (SELECT * FROM remote.T_JobData_Test15
    'WHERE RirekiNumber BETWEEN 1210001 and 2400000) srcT WHERE NOT EXISTS
    ' (SELECT * FROM T_JobData_Test15 dstT WHERE srcT.Rireki = dstT.Rireki);
    strSrcWhereField = sqlbC.addQuote(Job_RirekiNumber)
    strSQL = "INSERT INTO " & strLocalTableName & " SELECT * FROM (SELECT * FROM " & strRemoteDBPath
    strSQL = strSQL & " WHERE " & strSrcWhereField & " BETWEEN @SrcRirekiNumberStart and @SrcRirekiNumberEnd) SrcT WHERE NOT EXISTS"
    strSQL = strSQL & " (SELECT * FROM " & strLocalTableName & " DstT WHERE @SrcRireki = @DstRireki);"
    dbCopyTable.SQL = strSQL
    Set dbCopyTable.NamedParm = dbCopyTable.GetNamedList("@SrcRirekiNumberStart", Int32, Job_RirekiNumber)
    If Not isCollect Then
        MsgBox "�����[�gDB����̃R�s�[���ɃG���[����"
        GoTo ErrorCatch
        Exit Function
    End If
    isCollect = dbCopyTable.DoSQL_No_Transaction("COMMIT TRANSACTION")
    Set dbCopyTable = Nothing
    Set sqlbC = Nothing
    CopyDBTableRemote_To_Local = True
    Exit Function
ErrorCatch:
    Debug.Print "CopyDBTableRemote_To_Local code: " & Err.Number & " Description: " & Err.Description
    Set dbCopyTable = Nothing
    Set sqlbC = Nothing
    CopyDBTableRemote_To_Local = False
    Exit Function
End Function
Public Function CountKanbanChr(ByVal strargJobNumber As String, ByVal strargInitialInputDate As String) As Integer
    'Job�ԍ���ŁA����������̐���Ԃ��܂�
End Function
Public Function UpdateLastRirekNumber_atKishuTable(ByVal strargKishuName, ByVal longargLastRirekiNumber As Long, ByVal longargLastNumberField As LastRirekiNumber, _
                                                    Optional ByVal boolUseNewNumberOnly As Boolean = False) As Boolean
    '�@��e�[�u���̍ŏI�������X�V�܂ł����Ⴄ
    '�Ō��UserNewNumberOnly��True���Z�b�g����ƁA��ɗ^����ꂽ�ԍ��ŏ㏑������i��Ƀ����e�i���X�p�j
    Dim strSQL As String
    Dim strTargetTable As String
    Dim strUpdateField As String
    Dim strWhereField As String
    Dim dbUpdateLastRirekiNumber As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Dim isCollect As Boolean
    Set dbUpdateLastRirekiNumber = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    strTargetTable = sqlbC.addQuote(Table_Kishu)
    strWhereField = sqlbC.addQuote(Kishu_KishuName)
    '�p�����[�^�o�C���h�p���X�g�ݒ�
    Set dbUpdateLastRirekiNumber.NamedParm = dbUpdateLastRirekiNumber.GetNamedList("@NewLastNumber", Int32, longargLastRirekiNumber)
    Set dbUpdateLastRirekiNumber.NamedParm = dbUpdateLastRirekiNumber.GetNamedList("@WhereCondition", Text, strargKishuName)
    'Job�ԍ����Ŕԍ����Ńt�B�[���h�����肷��
    Select Case longargLastNumberField
    Case LastRirekiNumber.JobNumberField
        'Job�ԍ��̃��X�g���X�V������
        strUpdateField = sqlbC.addQuote(Kishu_Jobnumber_Lastnumber)
    Case LastRirekiNumber.KanbanChrField
        '�Ŕ̃��X�g���X�V������
        strUpdateField = sqlbC.addQuote(Kishu_Kanbanchr_Lastnumber)
    Case Else
        MsgBox "�w��O�̗��`���I������܂���"
        UpdateLastRirekNumber_atKishuTable = False
        Exit Function
    End Select
    strSQL = "UPDATE " & strTargetTable & " SET " & strUpdateField
    If boolUseNewNumberOnly Then
        '�����e�i���X���[�h�A��Ɉ����ŗ^����ꂽ���ōX�V�����Ⴄ
        strSQL = strSQL & " = @NewLastNumber WHERE "
    Else
        '�ʏ탂�[�h�A�@��e�[�u���ƍŐV���l�ŁA�l�̑傫���ق����c��
        strSQL = strSQL & " = CASE WHEN @NewLastNumber <= " & strUpdateField & " THEN " & strUpdateField & " ELSE @NewLastNumber END WHERE "
    End If
    strSQL = strSQL & strWhereField & " = @WhereCondition;"
    dbUpdateLastRirekiNumber.SQL = strSQL
    isCollect = dbUpdateLastRirekiNumber.Do_SQL_Use_NamedParm_NO_Transaction
    If Not isCollect Then
        Debug.Print "UpdateLastRirekiNumber_asKishuTable fail"
        UpdateLastRirekNumber_atKishuTable = False
        Exit Function
    End If
    UpdateLastRirekNumber_atKishuTable = True
    Exit Function
End Function
Private Function GetMinimumRirekiNumber_byTableName(ByVal strargTableName As String) As Long
    '�^����ꂽ�e�[�u���̘A�ԍŏ��l��Ԃ�
    Dim strFieldNumber
    Dim varReturn As Variant
    Dim dbMinNumber As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Set dbMinNumber = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    strFieldNumber = sqlbC.addQuote(Job_RirekiNumber)
    dbMinNumber.SQL = "SELECT MIN(" & strFieldNumber & ") FROM " & strargTableName & " ;"
    dbMinNumber.DoSQL_No_Transaction
    varReturn = dbMinNumber.RS_Array
    Set dbMinNumber = Nothing
    Set sqlbC = Nothing
    If Not IsNumeric(varReturn(0, 0)) Then
        '�擾���s���Ă��ˁE�E
        Debug.Print "GetMinNumber fail"
        GetMinimumRirekiNumber_byTableName = 0
        Exit Function
    Else
        GetMinimumRirekiNumber_byTableName = CLng(varReturn(0, 0))
        Exit Function
    End If
End Function
Public Function GetLastRirekiNumber_byKishuTable(ByVal strargKishuName, ByVal longargLastNumberField As LastRirekiNumber, Optional ByVal boolRenumberIfZero) As Long
    '�@��e�[�u���̍ŏI�������擾����
    '�����Ŏw�肳�ꂽLastRirekiNumber Enum�̒l�ɂ�菈���𕪊�i�Ŕ�Job�ԍ����j
    'RenumberIfZero��True�̏ꍇ�A���ʂ�0�������ꍇ�ɁAPublicModule.RenumberKishuTableLastNumber���Ă�
    Dim varResult As Variant
    Dim strSelectField As String                'select�̃t�B�[���h���A�����LastRirekiNumber�̒l�ɂ�蕪��
    Dim strWherField As String                  'where�̌����t�B�[���h��
    Dim isCollect As Boolean
    Dim dbLastNumber As clsSQLiteHandle
    Dim sqlbC As clsSQLStringBuilder
    Set dbLastNumber = New clsSQLiteHandle
    Set sqlbC = New clsSQLStringBuilder
    '�p�����[�^�o�C���h�g�p
    '                   SELECT JobNumber_LastNumber FROM T_Kishu WHERE KishuName = "Test15";
    strWherField = sqlbC.addQuote(Kishu_KishuName)
    Set dbLastNumber.NamedParm = dbLastNumber.GetNamedList("@WhereCondition", Text, strargKishuName)
    Select Case longargLastNumberField
    Case LastRirekiNumber.JobNumberField
        'JobNumber�̃��X�g���~����
        strSelectField = sqlbC.addQuote(Kishu_Jobnumber_Lastnumber)
    Case LastRirekiNumber.KanbanChrField
        '�Ŕ̃��X�g���~����
        strSelectField = sqlbC.addQuote(Kishu_Kanbanchr_Lastnumber)
    Case Else
        MsgBox "�w��O�̐��l���Z�b�g����܂����B�����𒆒f���܂�"
        Debug.Print "GetLastRIrekiNumber_byKishuTable Unknown Field Nuber"
        GetLastRirekiNumber_byKishuTable = -1
        Exit Function
    End Select
    dbLastNumber.SQL = "SELECT " & strSelectField & " FROM T_Kishu WHERE " & strWherField & " = @WhereCondition;"
    isCollect = dbLastNumber.Do_SQL_Use_NamedParm_NO_Transaction
    If Not isCollect Then
        Debug.Print "GetLastRIrekiNumber_byKishuTable fail"
        GetLastRirekiNumber_byKishuTable = 0
        Set dbLastNumber = Nothing
        Set sqlbC = Nothing
        Exit Function
    End If
    varResult = dbLastNumber.RS_Array
    If dbLastNumber.RecordCount = 0 Then
        Debug.Print "GetLastRirekiNumber_BykishuTable �����Ɉ�v����f�[�^�Ȃ��iNull�̉\���j"
        GetLastRirekiNumber_byKishuTable = 0
        Set dbLastNumber = Nothing
        Exit Function
    End If
    Set dbLastNumber = Nothing
    Set sqlbC = Nothing
    If IsNull(varResult(0, 0)) Or (varResult(0, 0)) = 0 Then
        Debug.Print "GetLastRirekiNumber Result is Null or zero"
        If boolRenumberIfZero Then
            '�[���ōĎ擾�w��������ꍇ
            Call RenumberKishuTableLastNumber
            '�ċA�ł�����x�ĂԁA�������Ď擾�Ȃ���
            GetLastRirekiNumber_byKishuTable = GetLastRirekiNumber_byKishuTable(strargKishuName, longargLastNumberField, boolRenumberIfZero:=False)
        Else
            '�ʏ�i�������Ȃ��j
            GetLastRirekiNumber_byKishuTable = 0
        End If
        Exit Function
    Else
        GetLastRirekiNumber_byKishuTable = CLng(varResult(0, 0))
    End If
    Exit Function
End Function
VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsSQLiteHandle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private myDbHandle As LongPtr           'DB�n���h��
Private RetVal As Long                  '���SQLite3�p�̋A��l
Private myStmtHandle As LongPtr         'SQL�X�e�[�g�����g�n���h��
Private strDBPath As String             'DB�t�@�C���p�X��
Private longDBRowIndex As Long          '���݂̃f�[�^�x�[���J�[�\���s�C���f�b�N�X
Private strSQL As String                'SQL������
Private myRecord As Variant             '���ʂƂ��ċA���z��i�o���A���g�jmyRecord(Array(),....)�A�擪1�s�ڂɃt�B�[���h������鎖�ɂ���
Private isInitialize As Boolean         '�C�j�V�����C�Y�ς݂��ǂ���
Private isDBOpen As Boolean             'DB���I�[�v���ς݂��ǂ���
Private isStatement As Boolean          'Statement�̃n���h�����L���iTrue�j���ǂ���
Private longRecordCount As Long         'Select���� �iSQLITE_ROW�́j�� = �q�b�g�������R�[�h�̐����L�^
Private Sub Class_Initialize()
    '�R���X�g���N�^�i�N���X�C���X�^���X�������ɍŏ��Ɏ��s�����j
    isInitialize = False
    isDBOpen = False
    longDBRowIndex = 0
    longRecordCount = 0
    myRecord = Array(0)
End Sub
Private Sub Class_Terminate()
    '�f�X�g���N�^�i�N���X�j�����鎞�Ɏ��s�����j
    Set myRecord = Nothing
    strSQL = Empty
    '��{�I�ɂ��|���͊e���ł��̂ŁA�܂��f�[�^�x�[�X�ڑ�����Ă鎞�����ɂ��
    If isStatement Then
        '�X�e�[�g�����g�n���h�����|��
        RetVal = SQLite3Finalize(myStmtHandle)
        If RetVal <> SQLITE_OK Then
            Debug.Print "SQLiteFinalize returned:" & RetVal, SQLite3ErrMsg(myStmtHandle)
        End If
        isStatement = False
    End If
    If isDBOpen Then
        'DB�ڑ��N���[�Y
        RetVal = SQLite3Close(myDbHandle)
        If RetVal <> SQLITE_OK Then
            Debug.Print "SQLite3Close returned:" & RetVal, SQLite3ErrMsg(myStmtHandle)
        End If
        isDBOpen = False
    End If
    Exit Sub
End Sub
Property Get RS() As Variant
    '���R�[�h�Z�b�g�擾�i��s�j
    If longDBRowIndex > Me.RecordCount Then
        MsgBox "���R�[�h�Z�b�g�擾���ɃG���[�����B���R�[�h�����ȏ�̃C���f�b�N�X���w�肳��܂���"
        RS = Nothing
        Exit Property
    End If
    RS = myRecord(longDBRowIndex)
End Property
Property Get RS_Array(Optional ByRef boolPlusTytle As Boolean) As Variant
    'RecoredSet�����̂܂ܔz��ŕԂ��Ȃ�����
    '�����₷���悤�ɓ񎟌��z��ɓ���Ȃ����Ă���Ԃ�
    Dim varArray As Variant
    Dim longRowCounter As Long
    Dim longColumnCount As Long
    On Error GoTo ErrorCatch
    varArray = Array()
    '1�����ڂ̗v�f�������[�v
    If boolPlusTytle = True Then
        ReDim varArray(UBound(myRecord, 1), UBound(myRecord(0), 1))
        For longRowCounter = LBound(myRecord, 1) To UBound(myRecord, 1)
            For longColumnCount = LBound(myRecord(longRowCounter), 1) To UBound(myRecord(longRowCounter), 1)
                varArray(longRowCounter, longColumnCount) = myRecord(longRowCounter)(longColumnCount)
            Next longColumnCount
        Next longRowCounter
    Else
        '�^�C�g���s���擾���Ȃ��ꍇ�͂�����
        ReDim varArray(UBound(myRecord, 1) - 1, UBound(myRecord(0), 1))
        For longRowCounter = LBound(myRecord, 1) + 1 To UBound(myRecord, 1)
            For longColumnCount = LBound(myRecord(longRowCounter), 1) To UBound(myRecord(longRowCounter), 1)
                varArray(longRowCounter - 1, longColumnCount) = myRecord(longRowCounter)(longColumnCount)
            Next longColumnCount
        Next longRowCounter
    End If
    RS_Array = varArray
    Exit Property
ErrorCatch:
    Debug.Print "RS_Array code: " & Err.Number & "Desctiption: " & Err.Description
End Property
Property Get RecordCount() As Long
    '���R�[�h�����擾
    On Error GoTo ErrorCatch
'    RecordCount = UBound(myRecord) - LBound(myRecord) + 1
    '�擪�s�Ƀ^�C�g�������鎖�ɂ����̂ōs������
'    RecordCount = UBound(myRecord) - LBound(myRecord)
    RecordCount = longRecordCount
    Exit Property
ErrorCatch:
    RecordCount = 0
    Debug.Print "Error Ocure SQLiteHande Class. code:" & Err.Number & " Description:" & Err.Description
End Property
Property Get EOF() As Boolean
    '�f�[�^�x�[�X��EOF���ǂ������ׂĕԂ�
    If longDBRowIndex = Me.RecordCount() Then
        '���R�[�h�J�E���g��DB�J�[�\���C���f�b�N�X�������Ȃ̂ōŌ�
        EOF = True
    Else
        EOF = False
    End If
End Property
Property Let SQL(ByVal strargSQL As String)
    'SQL���ݒ�
    strSQL = strargSQL
End Property
Property Get SQL() As String
    'SQL���擾
    SQL = strSQL
End Property
Public Sub MoveNext(Optional ByVal longDBRow As Long)
    'DB���R�[�h�Z�b�g�̃X�e�[�g�����g�J�[�\�������̍s�ցA�C���f�b�N�X�ԍ����w�肳��Ă���ꍇ�͂�������
    If longDBRow > 0 Then
        longDBRowIndex = longDBRow - 1
    End If
    longDBRowIndex = longDBRowIndex + 1
End Sub
Public Sub MoveFirst()
    'DB�X�e�[�g�����g�J�[�\�����ŏ��ɖ߂�
    longDBRowIndex = 0
End Sub
Public Function Initialize(Optional ByRef strLibDirarg As String) As Boolean
    Dim isCollect As Boolean
    '�C�j�V�����C�Y����A�܂�DB�ɐڑ��͂��Ȃ�
    On Error GoTo ErrorCatch
    '���Ɏw�肳��Ă��Ȃ���ΕW����DB�t�@�C���ƃf�B���N�g�����w�肷��
    If strLibDirarg = "" Then
        'DB�C�j�V�����C�Y
        isCollect = DBInishialize()
    Else
        'DB�C�j�V�����C�Y�i���C�u�����f�B���N�g���w��j
        isCollect = DBInishialize(strLibDirarg)
    End If
    If isCollect Then
        Initialize = True
        isInitialize = True
        Exit Function
    Else
        '���������s
        MsgBox "DB���������s"
        Initialize = False
        Exit Function
    End If
ErrorCatch:
    Initialize = False
    Debug.Print "Error in Initialize. code:" & Err.Number & " Description:" & Err.Description
    Class_Terminate
End Function
Public Function DoSQL_No_Transaction(Optional ByVal strSQLarg As String, Optional strDBPath As String) As Boolean
    'SQL�������DB�p�X���i�I�v�V�����j����A�g�����U�N�V�����Ȃ��̏������s���܂��i�y���̐�p�j
    Dim stepMsg As String
    Dim isCollect As Boolean
    Dim strErrorMsg As String
    On Error GoTo ErrorCatch
    '�܂�DB�C�j�V�����C�Y���ĂȂ��悤�Ȃ炱���ł��
    If Not isInitialize Then
        'DB�C�j�V�����C�Y
        isCollect = DBInishialize()
    End If
    'DB�ڑ��̗L�����m�F���A�ڑ����ĂȂ������炱���Őڑ�����
    If Not isDBOpen Then
        'DB�t�@�C����
        If strDBPath = "" Then
            strDBPath = CurDir & "\" & constJobNumberDBname
        End If
        'Job���DB�t�@�C���I�[�v���i������΍��͂��j
        RetVal = SQLite3Open(strDBPath, myDbHandle)
        If RetVal <> SQLITE_OK Then
            strErrorMsg = "SQLite3Open returned" & RetVal & vbTab & SQLite3ErrMsg(myDbHandle)
            'Debug.Print "SQLite3Open returned" & RetVal, SQLite3ErrMsg(myDbHandle)
'            Debug.Print strErrorMsg
'            myRecord = Array()
'            ReDim myRecord(0)
'            myRecord(0) = Array(strErrorMsg)
            DoSQL_No_Transaction = False
            GoTo NoTitleExit
            Exit Function
        End If
        'DB�ڑ��t���OTrue
        isDBOpen = True
    End If
    'SQL������R���p�C��
    'SQL�w�肳��Ă���΂��̓��e�Ŏ��s����
    '���O�Ƀv���p�e�B�Őݒ肵�Ă������Ǝv��
    If Not strSQLarg = "" Then
        Me.SQL = strSQLarg
    End If
    RetVal = SQLite3PrepareV2(myDbHandle, Me.SQL, myStmtHandle)
    isStatement = True
    If RetVal <> SQLITE_OK Then
        strErrorMsg = "SQLite3PrepareV2 returned" & RetVal & vbTab & SQLite3ErrMsg(myDbHandle)
        'Debug.Print "SQLite3PrepareV2 returned" & RetVal, SQLite3ErrMsg(myDbHandle)
        DoSQL_No_Transaction = False
        GoTo NoTitleExit
    End If
    RetVal = SQLite3Step(myStmtHandle)
    If RetVal = SQLITE_OK Or RetVal = SQLITE_DONE Then
        '�����Ő���I��
        'Insert�Ƃ����ʂ���̂͂������ɂȂ�͂�
        'Sqlite3Changes�Ō��ʍs���擾���Ă���ŏI���
        strErrorMsg = "���O�̑���� " & SQLite3Changes(myDbHandle) & " �̕ύX������܂����i����I���j"
'        Debug.Print strErrorMsg
'        myRecord = Array()
'        ReDim myRecord(0)
'        myRecord(0) = Array(strErrorMsg)
        DoSQL_No_Transaction = True
'        GoTo CloseAndExit
        GoTo NoTitleExit
        Exit Function
    ElseIf RetVal = SQLITE_ROW Then
        'SQL���s�ƃf�[�^�z��i�[������������
        isCollect = Get_Data_and_Put_Arry
    Else
        '�����͂����ُ�I���ł����Ǝv��
        DoSQL_No_Transaction = False
        GoTo CloseAndExit
    End If
    If isCollect Then
        '����I�����������
        DoSQL_No_Transaction = True
        GoTo CloseAndExit
        Exit Function
    Else
        '�������������ۂ�
        DoSQL_No_Transaction = False
        GoTo CloseAndExit
    End If
    '����I��
    DoSQL_No_Transaction = True
    GoTo CloseAndExit
    Exit Function
NoTitleExit:
        Debug.Print strErrorMsg
        myRecord = Array()
        ReDim myRecord(1)
        myRecord(0) = Array("No Title")
        myRecord(1) = Array(strErrorMsg)
        GoTo CloseAndExit
ErrorCatch:
    If Err.Number <> 0 Then
'        MsgBox Err.Number & vbCrLf & Err.Description
    End If
    Debug.Print "DoSQL_No_Transaction code: " & Err.Number & "description: " & Err.Description
    DoSQL_No_Transaction = False
    Exit Function
CloseAndExit:
    'StatamentHandle ���|��
    If isStatement Then
        RetVal = SQLite3Finalize(myStmtHandle)
        If RetVal <> SQLITE_OK Then
            strErrorMsg = "SQLite3Finalize returned" & RetVal & vbTab & SQLite3ErrMsg(myDbHandle)
            'Debug.Print "SQLite3Finalize returned" & RetVal, SQLite3ErrMsg(myDbHandle)
            Debug.Print strErrorMsg
            myRecord = Array()
            ReDim myRecord(0)
            myRecord(0) = Array(strErrorMsg)
            DoSQL_No_Transaction = False
        End If
        isStatement = False
    End If
    'DB�ڑ��N���[�Y
    'DB�ڑ�����̂̓N���X�j�������܂ő҂��ĂĂ��������ȁH
'    RetVal = SQLite3Close(myDbHandle)
'    If RetVal <> SQLITE_OK Then
'        Debug.Print "SQLite3Close returned" & RetVal, SQLite3ErrMsg(myDbHandle)
'        Exit Function
'    End If
'    'DB�ڑ��t���OFalse��
'    isDBOpen = False
    Exit Function
End Function
Public Function Do_SQL_With_Transaction(Optional ByVal strSQLarg As String, Optional strDBPath As String) As Boolean
    '�g�����U�N�V�������������SQL���s
    Dim sqlite3WithTrunsaction As clsSQLiteHandle
    Set sqlite3WithTrunsaction = New clsSQLiteHandle
    Dim isCollect As Boolean
    Dim strOrigSQL As String
    On Error GoTo RollBackAndExit
    strOrigSQL = Me.SQL
    '�g�����U�N�V�����J�n
    isCollect = DoSQL_No_Transaction("BEGIN TRANSACTION")
    If Not isCollect Then
        GoTo RollBackAndExit
    End If
    Me.SQL = strOrigSQL
    isCollect = DoSQL_No_Transaction()
    If Not isCollect Then
        GoTo RollBackAndExit
    End If
    Do_SQL_With_Transaction = True
    '���������̂ŃR�~�b�g��
    isCollect = DoSQL_No_Transaction("COMMIT TRANSACTION")
    If Not isCollect Then
        GoTo RollBackAndExit
    End If
    Exit Function
RollBackAndExit:
    '�g�����U�N�V���������[���o�b�N���������ŁA�I������
    DoSQL_No_Transaction ("ROLLBACK TRANSACTION")
    MsgBox "���[���o�b�N����"
    Do_SQL_With_Transaction = False
    Debug.Print "Do_SQL_With_Transaction code: " & Err.Number & "Description: " & Err.Description
    Set sqlite3WithTrunsaction = Nothing
    Exit Function
End Function
Private Function Get_Data_and_Put_Arry() As Boolean
    'SQLite�X�e�[�g�����g�ɑ΂��ASQLITE_DONE���o�Ă���܂Ŕz��Ƀf�[�^��˂�����
    '���̃f�[�^������ꍇ��SQLITE_ROW���A���Ă��Ă�͂�
    'SQLITE_DONE�ASQL_OK�ȊO�ŏI������ꍇ��False��Ԃ�
    Dim longColCount As Long            '�t�B�[���h����
    Dim longCounterRow As Long
    Dim longCounterColumn As Long
    Dim longColType As Long             'Column�̌^�iColumnValue�̎��Ɏg���j
    Dim strColName As String            '�t�B�[���h��
    Dim varColumnData As Variant        'DB�̊e�t�B�[���h�̒l���i�[����Array()�A�ŏ��̍s�̓t�B�[���h�������Ă��
    Dim dblStartTime As Double
    'SQL���s
    On Error GoTo ErrorCatch
    If (RetVal <> SQLITE_OK) And (RetVal <> SQLITE_DONE) And (RetVal <> SQLITE_ROW) Then
        '�ُ�l�Ȃ̂ő��I��
        Debug.Print "SQLite3Step returned" & RetVal, SQLite3ErrMsg(myDbHandle)
        Get_Data_and_Put_Arry = False
        Exit Function
    End If
    '�Ƃ肠�������s�����m�F������@��������Ȃ������̂ŁA�Œ�l�Ŕz��m��(ToDo)
    myRecord = Array()
    ReDim myRecord(constDefaultArraySize)
    varColumnData = Array()
    longCounterRow = 0
    '�t�B�[���h�����擾
    longColCount = SQLite3ColumnCount(myStmtHandle)
    '��f�[�^�̔z��T�C�Y����
    ReDim varColumnData(longColCount - 1)
    dblStartTime = timer()
    '�f�[�^��1�s�ڂɃt�B�[���h�^�C�g����������
    'RetValue�̌��ʂɂ���ď����𕪊�i��������̂��A1�s�����Ȃ̂�
    Select Case RetVal
    Case SQLITE_OK Or SQLITE_DONE
        '��������1�s�݂̂�������
        myRecord(longCounterRow) = "No Field Title"
        longCounterRow = longCounterRow + 1
    Case SQLITE_ROW
        '�t�B�[���h�������[�v
        For longCounterColumn = 0 To longColCount - 1
            longColType = SQLite3ColumnType(myStmtHandle, longCounterColumn)
            varColumnData(longCounterColumn) = SQLite3ColumnName(myStmtHandle, longCounterColumn)
        Next longCounterColumn
        myRecord(longCounterRow) = varColumnData
'        varColumnData = Array()
        longCounterRow = longCounterRow + 1
'        longRecordCount = longRecordCount + 1
    Case Else
        '����ȊO�H����͂͂��́E�E�E
        Debug.Print "�O���If�̘R��ł��A���Ƃ����āE�E�E"
        longCounterRow = longCounterRow + 1
    End Select
    Do While RetVal = SQLITE_ROW
        '�z��ɓ˂����ޏ����J�n
        '�t�B�[���h�̐������[�v����
        For longCounterColumn = 0 To longColCount - 1
            '�f�[�^�^�C�v�擾���A�l���擾����
            longColType = SQLite3ColumnType(myStmtHandle, longCounterColumn)
            varColumnData(longCounterColumn) = ColumnValue_InClass(myStmtHandle, longCounterColumn, longColType)
        Next longCounterColumn
        myRecord(longCounterRow) = varColumnData
'        varColumnData = Array()
        ' Row�J�E���^�[�C���N�������g
        '���R�[�h�J�E���^�[���C���N�������g���Ă����āE�E�E
        longCounterRow = longCounterRow + 1
        longRecordCount = longRecordCount + 1
        If UBound(myRecord) - longCounterRow <= 50 Then
            '�����m�ۏ���܂�50�؂����瑝�ʕ��������₵�Ă��i�d����E�E�E
            ReDim Preserve myRecord(UBound(myRecord) + constAddArraySize)
        End If
        RetVal = SQLite3Step(myStmtHandle)
    Loop
    '�_�E���T�C�Y
    ReDim Preserve myRecord(CLng(longCounterRow - 1))
    Debug.Print "SQL���z��i�[���v����:" & timer() - dblStartTime
    '����I��
    Get_Data_and_Put_Arry = True
    Exit Function
ErrorCatch:
    Get_Data_and_Put_Arry = False
    MsgBox "SQL���ʔz�񏑂��o�����ɃG���["
    Debug.Print "Get_Data_and_Put_Array code:" & Err.Number & " Description:" & Err.Description
    Exit Function
End Function
#If Win64 Then
Private Function ColumnValue_InClass(ByVal stmtHandle As LongPtr, ByVal ZeroBasedColIndex As Long, ByVal SQLiteType As Long) As Variant
#Else
Private Function ColumnValue_InClass(ByVal stmtHandle As Long, ByVal ZeroBasedColIndex As Long, ByVal SQLiteType As Long) As Variant
#End If
    Select Case SQLiteType
        Case SQLITE_INTEGER:
            ColumnValue_InClass = SQLite3ColumnInt32(stmtHandle, ZeroBasedColIndex)
        Case SQLITE_FLOAT:
            ColumnValue_InClass = SQLite3ColumnDouble(stmtHandle, ZeroBasedColIndex)
        Case SQLITE_TEXT:
            ColumnValue_InClass = SQLite3ColumnText(stmtHandle, ZeroBasedColIndex)
        Case SQLITE_BLOB:
            ColumnValue_InClass = SQLite3ColumnText(stmtHandle, ZeroBasedColIndex)
        Case SQLITE_NULL:
            ColumnValue_InClass = Null
    End Select
End Function
Private Function DBInishialize(Optional ByRef strLibDir As String) As Boolean
    If strLibDir = "" Then
        'Lib�f�B���N�g���w�肳��Ȃ������ꍇ�́ADB�f�B���N�g���Ɠ���Ƃ���i�����z���y������E�E�E�j
        'strLibDir = ThisWorkbook.Path + "\x64"
        strLibDir = ThisWorkbook.Path & "\" & constDatabasePath
    End If
    '�C�j�V�����C�Y
    Dim InitReturn As Long
    Dim isCollect
    #If Win64 Then
        ' I put the 64-bit version of SQLite.dll under a subdirectory called x64
        InitReturn = SQLite3Initialize(strLibDir)
    #Else
        InitReturn = SQLite3Initialize ' Default path is ThisWorkbook.Path but can specify other path where the .dlls reside.
    #End If
    If InitReturn <> SQLITE_INIT_OK Then
        Debug.Print "Error Initializing SQLite. Error: " & Err.LastDllError
        DBInishialize = False
        Exit Function
    End If
    'DB�f�B���N�g���Ɉړ�
    isCollect = ChcurrentforDB()
    If Not isCollect Then
        MsgBox "DB�f�B���N�g�����݊m�F���ɃG���[����"
        DBInishialize = False
        Exit Function
    End If
    DBInishialize = True
    isInitialize = True
End Function
Private Function ChcurrentforDB() As Boolean
    'DB�t�@�C��������f�B���N�g���ɃJ�����g��ύX����
    Dim strCurrentDir As String
    Dim fso As New scripting.FileSystemObject
    On Error GoTo ErrorCatch
    '�J�����g�f�B���N�g�����u�b�N�̃f�B���N�g���ɕύX
    ChCurrentDirW (ThisWorkbook.Path)
    strCurrentDir = CurDir
    'DataBase�f�B���N�g���̑��ݗL���m�F"
    If fso.FolderExists(constDatabasePath) <> True Then
        '�f�B���N�g�����݂��Ȃ��ꍇ�쐬����H
        MsgBox "�f�[�^�x�[�X�t�H���_���������ߍ쐬���܂��B"
        MkDir constDatabasePath
    End If
    '�f�[�^�x�[�X�f�B���N�g���Ɉړ�
    strCurrentDir = CurDir & "\" & constDatabasePath
    ChCurrentDirW (strCurrentDir)
    '����I�������ꍇ��True��Ԃ�
    ChcurrentforDB = True
    Set fso = Nothing
    Exit Function
    '�G���[����
ErrorCatch:
    ChcurrentforDB = False
    MsgBox ("DB�f�B���N�g���Ɉړ����ɃG���[���������܂���")
    Set fso = Nothing
    Exit Function
End Function
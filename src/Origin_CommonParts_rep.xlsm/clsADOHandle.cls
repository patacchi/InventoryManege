VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsADOHandle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'''ADODB�ɂ��DB�𑀍삷��N���X
'2021_10_10 IE�A�g�̂��߂ɐV�K�쐬 Patacchi
'DB�ڑ��֌W�̒萔�ݒ�
Const constDatabasePath             As String = "C:\Users\q3005sbe\AppData\Local\Rep\Inventory_Manege\bin\Inventory_DB"      '�f�[�^�x�[�X�f�B���N�g��
Const constDBFILENAME               As String = "CAT_Find.accdb"           'IE���i�[�pDB�t�@�C����
Const constDBPROVIDER_Pri           As String = "Provider = Microsoft.ACE.OLEDB.12.0;Data Source="
Const Field_Initialdate             As String = "InitialInputDate"      '�e�e�[�u�����ʁA������͎���
Const Field_Update                  As String = "UpdateDate"            '�e�e�[�u�����ʁA�ŏI�X�V����
Const constLONGDEFAULTARRAYSIZE     As Long = 15000                     '���ʊi�[�p�z��̏����T�C�Y�i�b��j
Const constLONGEXPANDARRAYSIZE      As Long = 3000                      '�i�[�z�񂪑���Ȃ��ꍇ��1��̊g����
'�����o�ϐ�
Private strDBPath As String
Private strDBFileName As String
Private strConnection As String
Private isConnected As Boolean
Private strSql As String
Private adoConnection As ADODB.Connection
Private adoCommand As ADODB.Command
Private adoParameters As ADODB.Parameters
Private rsMyRecord As ADODB.Recordset
Private varMyArray As Variant
Private longAffected As Long                                            '�e�����󂯂��s�����i�[����iUpdate�Ƃ�Insert�Ƃ��j
'�v���p�e�B
'DBPath
Property Get DBPath() As String
    If strDBPath = "" Then
        '�����o�ϐ���������ԂȂ�萔���Z�b�g���Ă��
        strDBPath = constDatabasePath
    End If
    DBPath = strDBPath
End Property
Property Let DBPath(ByVal strargDBPath As String)
    '���ɐڑ��ς݂̏ꍇ�͕ύX�����Ȃ�
    If isConnected Then
        Exit Property
    End If
    If strargDBPath <> "" Then
        strDBPath = strargDBPath
    End If
End Property
'DBFileName
Property Get DBFileName() As String
    If strDBFileName = "" Then
        '�t�@�C�����̃����o�ϐ���������ԂȂ�萔���Z�b�g���Ă��
        strDBFileName = constDBFILENAME
    End If
    DBFileName = strDBFileName
End Property
Property Let DBFileName(ByVal strargDBFileName As String)
    '���ɐڑ��ς݂̏ꍇ�͕ύX�����Ȃ�
    If isConnected Then
        Exit Property
    End If
    If strargDBFileName <> "" Then
        strDBFileName = strargDBFileName
    End If
End Property
'ConnectionString
Property Get ConnectionString() As String
    If strConnection = "" Then
        '����`�Ȃ�DBPath��DBFilename��菉���l��Ԃ�
        strConnection = CreateConnectionString(Me.DBPath, Me.DBFileName)
    End If
    ConnectionString = strConnection
End Property
Property Let ConnectionString(ByVal strargConnection As String)
    '���ɐڑ��ς݂̏ꍇ�͕ύX�����Ȃ�
    If isConnected Then
        Exit Property
    End If
    If strargConnection <> "" Then
        strConnection = strargConnection
    End If
End Property
'isConnected
'�ǂݎ���p
Property Get Connected() As Boolean
    Connected = isConnected
End Property
'SQL
Property Get SQL() As String
    SQL = strSql
End Property
Property Let SQL(ByVal strargSQL As String)
    If Not strargSQL = "" Then
        strSql = strargSQL
    End If
End Property
'RecordSet
'�ǂݎ���p�H
Property Get RS() As ADODB.Recordset
    Set RS = rsMyRecord
End Property
'RA_Array
'�ǂݎ���p
Property Get RS_Array() As Variant
    RS_Array = varMyArray
End Property
'RecordCount
'�ǂݎ���p
Property Get RecordCount() As Long
    If rsMyRecord.State = 1 And rsMyRecord.RecordCount > 0 Then
        'RS���J���Ă��āA����RecordCount��1�ȏ�̏ꍇ�ɐ���Ԃ�
        RecordCount = CLng(rsMyRecord.RecordCount)
        Exit Property
    Else
        If rsMyRecord.State = 0 Then
            'State=0 RS�����Ă���
            RecordCount = -1
            Exit Property
        End If
    End If
End Property
'Affected
'�ǂݎ���p
Property Get Affected() As Long
    If longAffected >= 0 Then
        Affected = longAffected
    End If
End Property
'''�R���X�g���N�^
'''�N���X�������ɍŏ��ɍs��
Private Sub Class_Initialize()
    Call Initialize
End Sub
'''�f�X�g���N�^
'''�N���X�j�����Ō�ɍs��
Private Sub Class_Terminate()
    Call Finalize
End Sub
Private Sub Initialize()
    isConnected = False
    strSql = ""
End Sub
Private Sub Finalize()
        'Connection�̌�n��
    If Not adoConnection Is Nothing Then
        'Nothing����Ȃ�������ڑ������
        '�ڑ�����Ă��Ȃ���Ε���
        If isConnected Then
            Call adoConnection.Close
        End If
        Set adoConnection = Nothing
    End If
    'Command
    Set adoCommand = Nothing
    'Patrameters
    Set adoParameters = Nothing
End Sub
'''SQL���g�����U�N�V�����Ȃ��Ŏ��s����
'''
Public Function Do_SQL_with_NO_Transaction(Optional ByVal strargSQL As String, Optional ByVal strargDBPath As String, Optional ByVal strargDBFileName As String) As Boolean
    Dim strlocalSQL As String
    If strargSQL = "" Then
        'SQL�̈������󔒂�������v���p�e�B�����������
        strargSQL = Me.SQL
        If strargSQL = "" Then
            '�v���p�e�B������������Ă��󂾂����珈�����Ȃ��Ŕ�����
            DebugMsgWithTime "Do_SQL_With_NO_Transattion SQL String Empty"
            Do_SQL_with_NO_Transaction = False
            Exit Function
        End If
    End If
    'DB�̐ڑ��܂ōs���i��^�����j
    '���ꂪ�I����SQL����t�\�ȏ�ԂɂȂ��Ă�͂�
    Dim isCollect As Boolean
    isCollect = DBReady(strargDBPath, strargDBFileName)
    If Not isCollect Then
        'DB�J���Ă�Œ��ɉ������s����
        DebugMsgWithTime "Do_DQL_with_NO_Transaction fail try open DB..."
        Do_SQL_with_NO_Transaction = False
        Exit Function
    End If
    'SQL���Z�b�g���A���s����
    On Error GoTo ErrorCatch
    If adoCommand Is Nothing Then
        'Command������������ĂȂ������炱���ōs��
        Set adoCommand = New ADODB.Command
    End If
    adoCommand.CommandText = strargSQL
    adoCommand.ActiveConnection = adoConnection
    If rsMyRecord Is Nothing Then
        '���ʊi�[�pRecordset�̏�����
        Set rsMyRecord = New ADODB.Recordset
    End If
    Set rsMyRecord = adoCommand.Execute(longAffected)
    'rsMyRecord��EOF��BOF������Ă����璆�g������̂ŁA�z��Ɋi�[����
    If Not (rsMyRecord.BOF And rsMyRecord.EOF) Then
        '�z�񏑂��o���J�n
        isCollect = RecordSet_to_2DArray(rsMyRecord)
    End If
    Set adoCommand = Nothing
    Do_SQL_with_NO_Transaction = True
    Exit Function
ErrorCatch:
    MsgBox "Do_SQL_with_NO_Transaction code: " & Err.Number & vbCrLf & "Description: " & Err.Description
    DebugMsgWithTime "Do_SQL_with_NO_Transaction code: " & Err.Number & " Description: " & Err.Description
    Exit Function
End Function
'''Write Daisuke_Oota
'''RecordSet��񎟌��z��ɏ����o��
'''���ʂ�Variant�^�̔z��Ƃ��ď����o��
'''1�s�ځi�C���f�b�N�X0�j�̓^�C�g����i�������̓G���[���b�Z�[�W�H�j�Ƃ���
Private Function RecordSet_to_2DArray(ByRef argRS As ADODB.Recordset) As Boolean
    If Me.RecordCount < 0 And Me.Affected < 0 Then
        'RecordCount��Affected��0�����̎��͉�������̃G���[�����������Ȃ̂ŃG���[������܂������b�Z�[�W��Ԃ�
        ReDim varMyArray(0, 0)
        varMyArray(0, 0) = "�G���[�����������悤�ł�"
        RecordSet_to_2DArray = False
        Exit Function
    End If
    If Me.RecordCount < 0 Then
        'RecordCount�����ĂȂ�����Affected�Ɍ����������Ă遨Update�Ƃ�����Ȃ�����
        ReDim varMyArray(0, 0)
        varMyArray(0, 0) = Me.Affected & " ���̃��R�[�h���������܂����B"
        RecordSet_to_2DArray = True
        Exit Function
    End If
    '���������RecordSet�ɒ��g�������Ă���
    If argRS.Fields.Count >= 1 Then
        '�t�B�[���h������ꍇ�̓t�B�[���h���X�g��z���1�s�ڂɒǉ�����
        '���ʊi�[�p�z��������T�C�Y��Redim����
        '���ʊi�[�z��̃T�C�Y�����s���̓^�C�g����������̂ŁARecoreCount�����̂܂܃Z�b�g
        ReDim varMyArray(Me.RecordCount, argRS.Fields.Count - 1)
        Dim longFieldCount As Long
        For longFieldCount = 0 To argRS.Fields.Count - 1
            varMyArray(0, longFieldCount) = argRS(longFieldCount).Name
        Next longFieldCount
    Else
        RecordSet_to_2DArray = False
        Exit Function
    End If
    '���Ɍ��ʃf�[�^��z��Ɋi�[���Ă���
    Dim longRowCount As Long
    longRowCount = 1
    argRS.MoveFirst
    Do
        For longFieldCount = 0 To argRS.Fields.Count - 1
'            argRS(longFieldCount).Type
            'adUnsighnedTinyInt �o�C�g�^ �̂܂܂��ƕ\���o���Ȃ��E�E�H
            If argRS(longFieldCount).Type = adUnsignedTinyInt Then
                varMyArray(longRowCount, longFieldCount) = CInt(argRS(longFieldCount).Value)
            Else
                varMyArray(longRowCount, longFieldCount) = argRS(longFieldCount).Value
            End If
        Next longFieldCount
        '���̃��R�[�h��
        argRS.MoveNext
        If argRS.EOF Then
            'EOF�������炻���Ń��[�v�𔲂���
            Exit Do
        End If
        '�s�J�E���^�C���N�������g
        longRowCount = longRowCount + 1
    Loop
'    '���ʏ����o���z��̃_�E���T�C�Y
'    ReDim varMyArray(longRowCount, argRS.Fields.Count - 1)
    RecordSet_to_2DArray = True
    Exit Function
End Function
'''DB�̃f�B���N�g���E�t�@�C�����݊m�F�A�ڑ��I�[�v���܂ōs���iSQL���s���钼�O�܂Ŏ����Ă����j
'''
Private Function DBReady(Optional strargDBPath As String, Optional strargDBFileName As String) As Boolean
    If strargDBPath = "" Then
        'DB�t�@�C���f�B���N�g�����������炾������v���p�e�B�����������
        strargDBPath = Me.DBPath
    End If
    '�J�����g�f�B���N�g����DB�f�B���N�g���ɂ���
    Dim isCollect As Boolean
    isCollect = ChCurrentToDBDirectory(strargDBPath)
    If Not isCollect Then
        '�f�B���N�g���ړ����Ɏ��s�������ۂ�
        DebugMsgWithTime "DBReady fail to move DB Directory"
        DBReady = False
        Exit Function
    End If
    If strargDBFileName = "" Then
        'DB�t�@�C�����������󂾂�����v���p�e�B�����������
        strargDBFileName = Me.DBFileName
    End If
    '�ڑ��������ݒ肷��
    Me.ConnectionString = CreateConnectionString(strargDBPath, strargDBFileName)
    'DB�t�@�C���̑��ݗL�����m�F���A������ΐV�K�쐬����
    isCollect = False
    isCollect = IsDBFileExist(strargDBFileName)
    'DB�֐ڑ�����
    isCollect = OpenConnection(Me.ConnectionString)
    If Not isCollect Then
        '�ڑ��Ɏ��s�������ۂ��̂ł��̂܂܏�������������
        DebugMsgWithTime "DBReady: fail to open DB File"
        DBReady = False
        Exit Function
    End If
    DBReady = True
    Exit Function
End Function
''�ڑ���������쐬����
Private Function CreateConnectionString(Optional ByVal strargDBPath As String, Optional ByVal strargDBFileName As String) As String
    If strargDBPath = "" Then
        '������DB�p�X���w�肳��Ă��Ȃ�������v���p�e�B�����������
        strargDBPath = Me.DBPath
    End If
    If strargDBFileName = "" Then
        '������DB�t�@�C�������w�肳��Ă��Ȃ�������v���p�e�B�����������
        strargDBFileName = Me.DBFileName
    End If
    Dim strlocalConnection As String
    Dim sqlBc As clsSQLStringBuilder
    Set sqlBc = New clsSQLStringBuilder
    strlocalConnection = constDBPROVIDER_Pri
    strlocalConnection = strlocalConnection & sqlBc.addQuote(strargDBPath & "\" & strargDBFileName)
    CreateConnectionString = strlocalConnection
    Set sqlBc = Nothing
    Exit Function
End Function
'''DB�ւ̐ڑ����J�n����
'''strargConnection �ڑ��������String�œn��
Private Function OpenConnection(strargConnection As String) As Boolean
    If strargConnection = "" Then
        '�ڑ������񂪎w�肳��Ă��Ȃ������瑦������
        DebugMsgWithTime "OpenConnection Connection String Empty"
        OpenConnection = False
        Exit Function
    End If
    If Connected Then
        '���ɐڑ��ς݂Ȃ牽�����Ȃ��Ŕ�����i�ł�True��j
        DebugMsgWithTime "OpenConnection already conected"
        OpenConnection = True
        Exit Function
    End If
    On Error GoTo ErrorCatch
    If adoConnection Is Nothing Then
        '�N���X�̃����o�ϐ�������������ĂȂ������珉��������
       Set adoConnection = New ADODB.Connection
    End If
    adoConnection.ConnectionString = Me.ConnectionString
    'Connection��CursorLocation��Cliant�ɂ���B��������Ȃ��ƁARecorCount�Ƃ������Ȃ������肷��
    adoConnection.CursorLocation = adUseClient
    adoConnection.Open
    If adoConnection.Errors.Count >= 1 Then
        GoTo ErrorCatch
        Exit Function
    End If
    isConnected = True
    OpenConnection = True
    Exit Function
ErrorCatch:
    If adoConnection.Errors.Count >= 1 Then
        '���炩�̃G���[���N����
        Dim longErrorCount As Long
        For longErrorCount = 0 To adoConnection.Errors.Count - 1
            DebugMsgWithTime "OpenConnection code: " & adoConnection.Errors(longErrorCount).Number & " Description: " & adoConnection.Errors(longErrorCount).Description
        Next longErrorCount
        OpenConnection = False
        Exit Function
    End If
    DebugMsgWithTime "OpenConnection code: " & Err.Number & " Description: " & Err.Description
    OpenConnection = False
    Exit Function
End Function
'DB�t�@�C���̑��ݗL�����m�F���A�Ȃ���Ώ����e�[�u���쐬���s��
Private Function IsDBFileExist(Optional strargDBFileName As String) As Boolean
    'DB�t�@�C���̗L�����m�F����
    Dim isCurrendDbDir As Boolean
    '�f�B���N�g���͌ʎw�肷��\��������̂ŁA�����ł͈ړ����Ȃ�
'    isCurrendDbDir = ChCurrentToDBDirectory
'    If Not isCurrendDbDir Then
'        'DB�f�B���N�g�������݂��Ȃ��i������mkdir���������Ă���͂��j�Ȃ̂ŁA�l�b�g���[�N���_��
'        MsgBox "�l�b�g���[�N�ڑ��̖��ɂ��A�����𒆎~���܂��B"
'        IsDBFileExist = False
'        Exit Function
'    End If
    Dim fsoObj As FileSystemObject
    Set fsoObj = New FileSystemObject
    Dim strlocalDBFileName As String
    If strargDBFileName <> "" Then
        '������DB�t�@�C�������w�肳��Ă����炻������Z�b�g���Ă��
        strlocalDBFileName = strargDBFileName
    Else
        '�w�肳��Ă��Ȃ���Β萔���Z�b�g���Ă��
        strlocalDBFileName = constDBFILENAME
    End If
    If Not fsoObj.FileExists(strlocalDBFileName) Then
        MsgBox "DB�t�@�C����������Ȃ��悤�Ȃ̂ŐV�K�쐬���܂�"
        InitialDBCreate (strlocalDBFileName)
        IsDBFileExist = True
    End If
    '����I��
    IsDBFileExist = True
End Function
'''DB�f�B���N�g���ɃJ�����g�f�B���N�g�����ړ�������
'''�f�B���N�g�������݂��Ȃ���΍쐬����
Private Function ChCurrentToDBDirectory(Optional strargDBPath As String = "") As Boolean
    On Error GoTo ErrorCatch
    '�J�����g�f�B���N�g����DB�f�B���N�g���Ɉړ�����
    '�J�����g�f�B���N�g���̎擾�iUNC�p�X�Ή��j
    'DataBase�f�B���N�g���̑��ݗL���m�F"
    Dim strCurrentDir As String
    If strargDBPath <> "" Then
        '�����Ŏw�肳��Ă����炻�̃f�B���N�g����DB�f�B���N�g���Ƃ���
        strCurrentDir = strargDBPath
    Else
        '�w�肳��Ă��Ȃ��ꍇ��Const�Ŏw�肳��Ă���f�B���N�g���ɂ���
        strCurrentDir = constDatabasePath
    End If
'    If fso.FolderExists(constDatabasePath) <> True Then
    Dim fso As New scripting.FileSystemObject
    If fso.FolderExists(strCurrentDir) <> True Then
        '�f�B���N�g�����݂��Ȃ��ꍇ�쐬����H
        MsgBox "�f�[�^�x�[�X�t�H���_���������ߍ쐬���܂��B"
        MkDir strCurrentDir
    End If
    '�f�[�^�x�[�X�f�B���N�g���Ɉړ�
    ChCurrentDirW (strCurrentDir)
    ChCurrentToDBDirectory = True
    Exit Function
ErrorCatch:
    DebugMsgWithTime "ChCurrenttoDB code: " & Err.Number & " Description: " & Err.Description
    If Err.Number = 76 Then
        '�p�X��������܂���Amkdir�ŃG���[���o�� = �l�b�g���[�N�_���Ȃ񂾂�
        MsgBox "DB�f�B���N�g���쐬���s�i�����l�b�g���[�N���j�����𒆒f���܂�"
    End If
    ChCurrentToDBDirectory = False
    Exit Function
End Function
Private Function InitialDBCreate(Optional strargDBFileName As String) As Boolean
    Dim isCollect As Boolean
    Dim strSql  As String
    On Error GoTo ErrorCatch
    '�f�B���N�g���ړ��͑匳�ł��̂ŁA�ʂɂ͍s��Ȃ�
'    'DB�f�B���N�g���ֈړ�
'    Dim isDBDir As Boolean
'    isDBDir = ChCurrentToDBDirectory(Me.DBPath)
'    If Not isDBDir Then
'        MsgBox "DB�f�B���N�g���쐬���s�i�l�b�g���[�N�����������j�����𒆒f���܂��B"
'        InitialDBCreate = False
'        Exit Function
'    End If
'    If Me.DBFileName = "" Or Me.DBPath = "" Then
'        '�ڑ������񂩃f�B���N�g�����ǂ��炩���󔒂Ȃ甲����i���s�j
'        DebugMsgWithTime "InitialDBCreate: DB File or Directory not found"
'        InitialDBCreate = False
'        Exit Function
'    End If
    If strargDBFileName = "" Then
        'DB�t�@�C�����������Ŏw�肳��Ă��Ȃ�������v���p�e�B�����������
        strargDBFileName = Me.DBFileName
        If strargDBFileName = "" Then
            '����ł��󔒂������璆�~����
            DebugMsgWithTime "InitilaDBCreate File name empty"
            InitialDBCreate = False
            Exit Function
        End If
    End If
    '�Ƃ肠�������DB�t�@�C�����쐬����
    Dim adoxCat As adox.Catalog
    Set adoxCat = New adox.Catalog
    '�ڑ�������쐬
    Call adoxCat.Create(Me.ConnectionString)
    Set adoxCat = Nothing
'    '�����e�[�u���쐬�pSQL���쐬(T_Kishu)
'    strSQL = ""
'    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_Kishu & """ (" & vbCrLf & """"
'    strSQL = strSQL & Kishu_Header & """ TEXT NOT NULL UNIQUE," & vbCrLf & """"
'    strSQL = strSQL & Kishu_KishuName & """ TEXT NOT NULL UNIQUE," & vbCrLf & """"
'    strSQL = strSQL & Kishu_KishuNickname & """ TEXT NOT NULL UNIQUE," & vbCrLf & """"
'    strSQL = strSQL & Kishu_TotalKeta & """ NUMERIC NOT NULL," & vbCrLf & """"
'    strSQL = strSQL & Kishu_RenbanKetasuu & """ NUMERIC NOT NULL," & vbCrLf & """"
'    strSQL = strSQL & Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP," & vbCrLf & """"
'    strSQL = strSQL & Field_Update & """ TEXT)"
'    isCollect = dbSQLite3.DoSQL_No_Transaction(strSQL)
'
'    '�G�C���A�X�e�[�u���쐬
'    Call CreateAliasTable
'    Set dbSQLite3 = Nothing
''    '�e�X�g����_SQL�쐬�e�X�g
''    isCollect = CreateTable_by_KishuName("Test15")
''    If Not isCollect Then
''        InitialDBCreate = False
''    End If
'    '����I��
    InitialDBCreate = True
    Exit Function
ErrorCatch:
    If Err.Number <> 0 Then
        MsgBox Err.Number & vbCrLf & Err.Description
    End If
    Exit Function
End Function
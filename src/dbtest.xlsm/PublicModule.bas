Attribute VB_Name = "PublicModule"
Option Explicit
'Option Base 1
'�Q�Ɛݒ�
'Microsoft AciteX Data Objects 2.8 Library      %ProgramFiles(x86)%\Common Files\System\msado28.tlb
'Microsoft ADO Ext. 6.0 for DDL and Security    %ProgramFiles(x86)%\Common Files\System\msadox.dll
'Microsoft Scripting Runtime                    %SystemRoot%\SysWOW64\scrrun.dll
'Microsoft DAO 3.6 Object Library               %ProgramFiles(x86)%\Common Files\Microfost Shared\DAO\dao360.dll
'UNC�Ή��̂��߁AWin32API�g�p
Public Declare PtrSafe Function SetCurrentDirectoryW Lib "kernel32" (ByVal lpPathName As LongPtr) As LongPtr
'���t���~���b�P�ʂŎ擾����̂�Win32API���g�p
'SYSTEMTIME�\���̒�`
Type SYSTEMTIME
        wYear As Integer
        wMonth As Integer
        wDayOfWeek As Integer
        wDay As Integer
        wHour As Integer
        wMinute As Integer
        wSecond As Integer
        wMilliseconds As Integer
End Type
'�֐���`
Public Declare PtrSafe Sub GetLocalTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)
Public Function isUnicodePath(ByVal strCurrentPath As String) As Boolean
    '�p�X����Unicode���܂܂�Ă����True��Ԃ��A�C�x���g�����ɂ���i�}�N�����s�����炢��ˁj
    Dim strSJIS As String           '�p�X������USJIS�ɕϊ���������
    Dim strReUnicode As String      'SJIS�ɕϊ������p�X�����ēxUnicode�ɂ�������
    strSJIS = StrConv(strCurrentPath, vbFromUnicode)
    strReUnicode = StrConv(strSJIS, vbUnicode)
    If strReUnicode <> strCurrentPath Then
        '���ɂ��[�ǂ�SJIS�ϊ����Ė߂��Ă����̂��Ⴄ��Unicode����
        isUnicodePath = True
        Exit Function
    Else
        '�����Ȃ̂ł��ɂ��[�ǂȂ�
        isUnicodePath = False
        Exit Function
    End If
End Function
Public Function IsDBFileExist() As Boolean
    Dim fsoObj As FileSystemObject
    Set fsoObj = New FileSystemObject
    'DB�t�@�C���̗L�����m�F����
    ChCurrentToDBDirectory
    If Not fsoObj.FileExists(constJobNumberDBname) Then
        MsgBox "DB�t�@�C����������Ȃ��悤�Ȃ̂ŐV�K�쐬���܂�"
        InitialDBCreate
    End If
End Function
Public Function ChCurrentDirW(ByVal DirName As String)
    'UNICODE�Ή�ChCurrentDir
    'SetCurrentDirectoryW�iUNICODE�j�Ȃ̂�
    'StrPtr����K�v������E�E�H
    SetCurrentDirectoryW StrPtr(DirName)
End Function
Public Sub CheckInitialTableJSON()
    '�����e�[�u���쐬�p��JSON�����邩�m�F����
    Dim fsoJSON As FileSystemObject
    Set fsoJSON = New FileSystemObject
    Call ChCurrentToDBDirectory
    If Not fsoJSON.FileExists(JSON_File_InitialDB) Then
        MsgBox "�����e�[�u���쐬�pJSON��������Ȃ����ߍ쐬���܂�"
        Debug.Print "���̂������e�[�u���쐬�pJSON��������Ȃ��A�쐬"
        Call CreateInitialTableJSON
    End If
End Sub
Public Sub CreateInitialTableJSON()
    '�����e�[�u���쐬�pJSON�쐬
    Dim dicJSONObject As Dictionary
    Dim strJSON As String
    Dim streamInitialJSON As ADODB.Stream
    Dim sqlbInitial As clsSQLStringBuilder
    Dim strSQLJsonTable As String
    Dim strSQLKishu As String
    Dim strSQLLog As String
    Set dicJSONObject = New Dictionary
    Set streamInitialJSON = New ADODB.Stream
    Set sqlbInitial = New clsSQLStringBuilder
    On Error GoTo ErrorCatch
    '�J�����g��DB�f�B���N�g���Ɉړ�
    Call ChCurrentToDBDirectory
    'JSON�e�[�u��SQL
    strSQLJsonTable = strSQLJsonTable & strTable1_NextTable & sqlbInitial.addQuote(Table_JSON) & strTable2_Next1stField
    strSQLJsonTable = strSQLJsonTable & sqlbInitial.addQuote(JSON_Field_Name) & strTable3_TEXT & strTable_NotNull & strTable_Unique & strTable4_EndRow
    strSQLJsonTable = strSQLJsonTable & sqlbInitial.addQuote(JSON_Field_string) & strTable3_JSON & strTable_NotNull & strTable4_EndRow
    strSQLJsonTable = strSQLJsonTable & sqlbInitial.addQuote(Field_Initialdate) & strTable3_TEXT & strTable_Default & "CURRENT_TIMESTAMP" & strTable4_EndRow
    strSQLJsonTable = strSQLJsonTable & sqlbInitial.addQuote(Field_Update) & strTable3_TEXT & strTable5_EndSQL
    '�@��e�[�u��SQL
    strSQLKishu = strSQLKishu & strTable1_NextTable & sqlbInitial.addQuote(Table_Kishu) & strTable2_Next1stField
    strSQLKishu = strSQLKishu & sqlbInitial.addQuote(Kishu_Header) & strTable3_TEXT & strTable_NotNull & strTable_Unique & strTable4_EndRow
    strSQLKishu = strSQLKishu & sqlbInitial.addQuote(Kishu_KishuName) & strTable3_TEXT & strTable_NotNull & strTable_Unique & strTable4_EndRow
    strSQLKishu = strSQLKishu & sqlbInitial.addQuote(Kishu_KishuNickname) & strTable3_TEXT & strTable_NotNull & strTable_Unique & strTable4_EndRow
    strSQLKishu = strSQLKishu & sqlbInitial.addQuote(Kishu_TotalKeta) & strTable3_NUMERIC & strTable_NotNull & strTable4_EndRow
    strSQLKishu = strSQLKishu & sqlbInitial.addQuote(Kishu_RenbanKetasuu) & strTable3_NUMERIC & strTable_NotNull & strTable4_EndRow
    strSQLKishu = strSQLKishu & sqlbInitial.addQuote(Field_Initialdate) & strTable3_TEXT & strTable_Default & "CURRENT_TIMESTAMP" & strTable4_EndRow
    strSQLKishu = strSQLKishu & sqlbInitial.addQuote(Field_Update) & strTable3_TEXT & strTable5_EndSQL
    'JSON�e�[�u��
    dicJSONObject.Add Table_JSON, New Dictionary
    dicJSONObject(Table_JSON).Add JSON_Table_SQL, strSQLJsonTable       'JSON�e�[�u���쐬�pSQL
    dicJSONObject(Table_JSON).Add JSON_Table_Description, "JSON���i�[�e�[�u��"
    '�@��e�[�u��
    dicJSONObject.Add Table_Kishu, New Dictionary
    dicJSONObject(Table_Kishu).Add JSON_Table_SQL, strSQLKishu              '�e�[�u���쐬�pSQL�i�[
    dicJSONObject(Table_Kishu).Add JSON_Table_Description, "�@��ʏ��i�[�e�[�u���A�@��w�b�_�A���������E�� per �V�[�g�̏��"
    dicJSONObject(Table_Kishu).Add JSON_AppendField, New Dictionary
    dicJSONObject(Table_Kishu)(JSON_AppendField).Add Kishu_Header, New Dictionary
'    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_Header).Add JSON_Table_SQL           '�@��w�b�_�쐬�pSQL�i�[
    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_Header).Add JSON_Table_Description, "�@�픻�ʃw�b�_�t�B�[���h UNIQUE�ANOT NULL����"
    dicJSONObject(Table_Kishu)(JSON_AppendField).Add Kishu_KishuName, New Dictionary
'    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_KishuName).Add JSON_Table_SQL             '�@�햼SQL
    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_KishuName).Add JSON_Table_Description, "�@�햼�t�B�[���h�A��������w�����̐}�� UNIQUE"
    dicJSONObject(Table_Kishu)(JSON_AppendField).Add Kishu_KishuNickname, New Dictionary
'    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_KishuNickname).Add JSON_Table_SQL    '�@��ʏ̖�SQL
    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_KishuNickname).Add JSON_Table_Description, "�@��ʏ̖��A�V�[�g����R���{�{�b�N�X�̍��ڂɎg���A���{��OK UNIQUE"
    dicJSONObject(Table_Kishu)(JSON_AppendField).Add Kishu_TotalKeta, New Dictionary
'    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_TotalKeta).Add JSON_Table_SQL        '�@��g�[�^��SQL
    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_TotalKeta).Add JSON_Table_Description, "�@��̗����̃g�[�^������ NUMERIC"
    dicJSONObject(Table_Kishu)(JSON_AppendField).Add Kishu_RenbanKetasuu, New Dictionary
'    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_RenbanKetasuu).Add JSON_Table_SQL    '�@��A�Ԍ���SQL
    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_RenbanKetasuu).Add JSON_Table_Description, "�@��̘A�ԕ����̌��� NUMERIC"
    dicJSONObject(Table_Kishu)(JSON_AppendField).Add Kishu_Mai_Per_Sheet, New Dictionary
'    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_Mai_Per_Sheet).Add JSON_Table_SQL    '�@��Amai per sheetSQL
    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_Mai_Per_Sheet).Add JSON_Table_Description, "1�V�[�g������̖��� NUMERIC"
    dicJSONObject(Table_Kishu)(JSON_AppendField).Add Kishu_Barcord_Read_Number, New Dictionary
'    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_Barcord_Read_Number).Add JSON_Table_SQL  '�@��A�o�[�R�[�h�ǂݎ�萔SQL
    dicJSONObject(Table_Kishu)(JSON_AppendField)(Kishu_Barcord_Read_Number).Add JSON_Table_Description, "1�V�[�g������o�[�R�[�h�̐� NUMERIC"
    strJSON = JsonConverter.ConvertToJson(dicJSONObject)
    GoTo CloseAndExit
    Exit Sub
CloseAndExit:
    Set dicJSONObject = Nothing
    Set streamInitialJSON = Nothing
    Set sqlbInitial = Nothing
    Exit Sub
ErrorCatch:
    Debug.Print "CreateInitialJSON code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
    Exit Sub
End Sub
Public Function InitialDBCreate() As Boolean
    Dim isCollect As Boolean
    Dim strSQL  As String
    Dim dbSQLite3 As clsSQLiteHandle
    Set dbSQLite3 = New clsSQLiteHandle
    On Error GoTo ErrorCatch
    'DB�f�B���N�g���ֈړ�
    Call ChCurrentToDBDirectory
    '�����e�[�u���쐬�pSQL���쐬(T_Kishu)
    strSQL = ""
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_Kishu & """ (" & vbCrLf & """"
    strSQL = strSQL & Kishu_Header & """ TEXT NOT NULL UNIQUE," & vbCrLf & """"
    strSQL = strSQL & Kishu_KishuName & """ TEXT NOT NULL UNIQUE," & vbCrLf & """"
    strSQL = strSQL & Kishu_KishuNickname & """ TEXT NOT NULL UNIQUE," & vbCrLf & """"
    strSQL = strSQL & Kishu_TotalKeta & """ NUMERIC NOT NULL," & vbCrLf & """"
    strSQL = strSQL & Kishu_RenbanKetasuu & """ NUMERIC NOT NULL," & vbCrLf & """"
    strSQL = strSQL & Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP," & vbCrLf & """"
    strSQL = strSQL & Field_Update & """ TEXT)"
    isCollect = dbSQLite3.DoSQL_No_Transaction(strSQL)
    Set dbSQLite3 = Nothing
'    '�e�X�g����_SQL�쐬�e�X�g
'    isCollect = CreateTable_by_KishuName("Test15")
'    If Not isCollect Then
'        InitialDBCreate = False
'    End If
    '����I��
    InitialDBCreate = True
    Exit Function
ErrorCatch:
    If Err.Number <> 0 Then
        MsgBox Err.Number & vbCrLf & Err.Description
    End If
    Exit Function
End Function
Public Function registNewKishu_to_KishuTable(ByVal strKishuheader As String, ByVal strKishuname As String, ByVal strKishuNickname As String, _
                                ByVal byteTotalKetasu As Byte, ByVal byteRenbanKetasu As Byte) As Boolean
    '�V�@��o�^����
    Dim dbSQLite3 As clsSQLiteHandle
    Set dbSQLite3 = New clsSQLiteHandle
    Dim strSQLlocal As String
    Dim isCollect As Boolean
    '�e�[�u���̗L���m�F
    If Not IsTableExist(Table_Kishu) Then
        MsgBox "�@��e�[�u�������������̂Œǉ����܂�"
        InitialDBCreate
    End If
    'SQL�g�ݗ���
    strSQLlocal = "INSERT INTO " & Table_Kishu & _
                    " (" & Kishu_Header & "," & Kishu_KishuName & "," & Kishu_KishuNickname & _
                    "," & Kishu_TotalKeta & "," & Kishu_RenbanKetasuu & _
                    ") VALUES (""" & strKishuheader & """,""" & strKishuname & """,""" & strKishuNickname & """," & _
                    byteTotalKetasu & "," & byteRenbanKetasu & ")"
    dbSQLite3.SQL = strSQLlocal
    isCollect = dbSQLite3.DoSQL_No_Transaction()
    Set dbSQLite3 = Nothing
    If Not isCollect Then
        MsgBox "�@��e�[�u���ǉ����ɃG���[����"
        Debug.Print Err.Description
        registNewKishu_to_KishuTable = False
        Exit Function
    End If
    '�����ċ@�햼���@�햼�ˑ��̃e�[�u�����쐬���Ă���
    isCollect = CreateTable_by_KishuName(strKishuname)
    If Not isCollect Then
        MsgBox "�@��ʃe�[�u���ǉ����ɃG���["
        registNewKishu_to_KishuTable = False
        Exit Function
    End If
    MsgBox "�@��ǉ�����"
    registNewKishu_to_KishuTable = True
End Function
Public Sub ChCurrentToDBDirectory()
    '�J�����g�f�B���N�g����DB�f�B���N�g���Ɉړ�����
    '�J�����g�f�B���N�g���̎擾�iUNC�p�X�Ή��j
    Dim strCurrentDir As String
    Dim fso As New scripting.FileSystemObject
'    '�J�����g�f�B���N�g�����u�b�N�̃f�B���N�g���ɕύX
'    ChCurrentDirW (ThisWorkbook.Path)
'    strCurrentDir = CurDir
    'DataBase�f�B���N�g���̑��ݗL���m�F"
    If fso.FolderExists(constDatabasePath) <> True Then
        '�f�B���N�g�����݂��Ȃ��ꍇ�쐬����H
        MsgBox "�f�[�^�x�[�X�t�H���_���������ߍ쐬���܂��B"
        MkDir constDatabasePath
    End If
    '�f�[�^�x�[�X�f�B���N�g���Ɉړ�
    strCurrentDir = constDatabasePath
    ChCurrentDirW (strCurrentDir)
End Sub
Public Function GetNameRange(ByVal strSerchName As String, Optional ByRef shTarget As Worksheet)
    '���O��`�Ɏw�肳�ꂽ���̂����݂��邩���ׂāA���݂����疼�O��`���̂��̂�Ԃ�
    Dim rngNameLocal As Name
    Dim strSerchParentName As String
    '�ʏ��ActiveSheet��Parent�����A�Ώۂ��w�肳��Ă����ꍇ�͂��̖��O���g�p
    If shTarget Is Nothing Then
        '�w�肳��Ȃ��ꍇ��Activesheet
        strSerchParentName = ActiveSheet.Name
    Else
        '�w�肳��Ă���ꍇ�͂��̖��O��
        strSerchParentName = shTarget.Name
    End If
    For Each rngNameLocal In ActiveWorkbook.Names
        If rngNameLocal.RefersToRange.Parent.Name = strSerchParentName And rngNameLocal.Name = strSerchName Then
            '�V�[�g��(����)�y�і��O����v
            '��v�������O�����̂܂ܕԂ��Ă����āE�E�E
            Set GetNameRange = rngNameLocal
            Set rngNameLocal = Nothing
            Exit Function
        End If
    Next rngNameLocal
    '�����܂ŏo�Ă������Ď��͖����̂�E�E�E
    Set rngNameLocal = Nothing
    GetNameRange = errcxlNameNotFound
End Function
Public Function CreateTable_by_KishuName(ByRef strKishuname As String) As String
    '�@�햼�������Ƃ��Ď��A��������ɋ@�햼�ˑ��̃e�[�u�����쐬����SQL����Ԃ�
    Dim strSQL As String
    Dim adstreamReader As ADODB.Stream
    Dim isCollect As Boolean
    Dim dbSQLite3 As clsSQLiteHandle
    Set dbSQLite3 = New clsSQLiteHandle
    'T_Jobdata �W���u�̗�����Job�ԍ�
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_JobDataPri & strKishuname & """ (" & vbCrLf
    strSQL = strSQL & """" & Job_Number & """ TEXT NOT NULL," & vbCrLf
    strSQL = strSQL & """" & Job_RirekiHeader & """ TEXT NOT NULL," & vbCrLf
    strSQL = strSQL & """" & Job_RirekiNumber & """ NUMERIC NOT NULL UNIQUE," & vbCrLf
    strSQL = strSQL & """" & Job_Rireki & """ TEXT NOT NULL UNIQUE," & vbCrLf
    strSQL = strSQL & """" & Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP," & vbCrLf
    strSQL = strSQL & """" & Field_Update & """ TEXT," & vbCrLf
    strSQL = strSQL & "Primary Key(""" & Job_Rireki & """)" & vbCrLf
    strSQL = strSQL & ");"
    isCollect = dbSQLite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    strSQL = ""
    '������T_Barcorde �o�[�R�[�h�e�[�u���i�s�b�Ă����j
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_Barcodepri & strKishuname & """ (" & vbCrLf
    strSQL = strSQL & """" & Field_BarcordeNumber & """ TEXT NOT NULL," & vbCrLf
    strSQL = strSQL & """" & Laser_Rireki & """ TEXT NOT NULL UNIQUE," & vbCrLf
    strSQL = strSQL & """" & Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP," & vbCrLf
    strSQL = strSQL & """" & Field_Update & """ TEXT," & vbCrLf
    strSQL = strSQL & "Primary Key(""" & Laser_Rireki & """)" & vbCrLf
    strSQL = strSQL & ");"
    isCollect = dbSQLite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    strSQL = ""
    '�Ō�Ƀ��g���C�����i����́H����j
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_Retrypri & strKishuname & """ (" & vbCrLf
    strSQL = strSQL & """" & Field_BarcordeNumber & """ TEXT NOT NULL," & vbCrLf
    strSQL = strSQL & """" & Laser_Rireki & """ TEXT NOT NULL," & vbCrLf
    strSQL = strSQL & """" & Retry_Reason & """ TEXT," & vbCrLf
    strSQL = strSQL & """" & Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP," & vbCrLf
    strSQL = strSQL & """" & Field_Update & """ TEXT" & vbCrLf
    strSQL = strSQL & ");"
    isCollect = dbSQLite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    '�e�[�u���ǉ��͑S���I�����
    '�C���f�b�N�X�쐬
    '�o�[�R�[�h�e�[�u��
    strSQL = ""
    strSQL = "CREATE UNIQUE INDEX IF NOT EXISTS ""ix" & Table_Barcodepri & strKishuname & """ ON """ & _
    Table_Barcodepri & strKishuname & """ (""" & Laser_Rireki & """ ASC);"
    isCollect = dbSQLite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    '�W���u�����e�[�u��
    strSQL = ""
    strSQL = "CREATE UNIQUE INDEX IF NOT EXISTS ""ix" & Table_JobDataPri & strKishuname & """ ON """ & _
    Table_JobDataPri & strKishuname & """ (""" & Job_Rireki & """ ASC);"
    isCollect = dbSQLite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    '�C���f�b�N�X�쐬�I��
    Set dbSQLite3 = Nothing
    '�ǉ��t�B�[���h�X�V��
    Call CheckNewField
    CreateTable_by_KishuName = True
    Exit Function
End Function
Public Sub CheckNewField()
    Dim dbTableAdd As clsSQLiteHandle
    Dim strSQL As String
    Dim varTableList As Variant
    Dim intTableCounter As Integer
    Dim arrStr_Kishu_AppendField() As String
    Dim arrStr_Kishu_Type() As String
    Dim arrStr_Job_AppendField() As String
    Dim arrStr_Job_Type() As String
    Dim arrStr_BarCorde_AppendField() As String
    Dim arrStr_BarCorde_Type() As String
    Dim arrStr_Retry_AppendField() As String
    Dim arrStr_Retry_Type() As String
    Dim arrStr_Index_AppendField() As String
    On Error GoTo ErrorCatch
    '�ǉ��t�B�[���h��`
    arrStr_Kishu_AppendField = Split(Kishu_Mai_Per_Sheet & "," & Kishu_Barcord_Read_Number, ",")
    arrStr_Kishu_Type = Split("NUMERIC" & "," & "NUMERIC", ",")
    arrStr_Job_AppendField = Split(Job_KanbanChr & "," & Job_ProductDate & "," & Field_LocalInput & "," & Field_RemoteInput & "," & Job_KanbanNumber, ",")
    arrStr_Job_Type = Split("TEXT" & "," & "TEXT" & "," & "NUMERIC" & "," & "NUMERIC" & "," & "NUMERIC", ",")
    arrStr_BarCorde_AppendField = Split(Field_LocalInput & "," & Field_RemoteInput, ",")
    arrStr_BarCorde_Type = Split("NUMERIC" & "," & "NUMERIC", ",")
    arrStr_Retry_AppendField = Split(Field_LocalInput & "," & Field_RemoteInput, ",")
    arrStr_Retry_Type = Split("NUMERIC" & "," & "NUMERIC", ",")
    arrStr_Index_AppendField = Split(Job_Number & "," & Field_Initialdate, ",")
    Set dbTableAdd = New clsSQLiteHandle
    '�e�[�u���Ƃ��t�B�[���h�Ƃ����񂪂�ǉ�������
    If Not IsTableExist(Table_Kishu) Then
        Call InitialDBCreate
    End If
    '���O�e�[�u����ǉ����Ă��
    strSQL = ""
    strSQL = strSQL & strOLDAddTable1_NextTable & Table_Log & strOLDAddTable2_Field1_Next_Field & Log_ActionType
    strSQL = strSQL & strOLDAddTable_TEXT_Next_Field & Log_Table
    strSQL = strSQL & strOLDAddTable_TEXT_Next_Field & Log_StartRireki
    strSQL = strSQL & strOLDAddTable_TEXT_Next_Field & Log_Maisuu
    strSQL = strSQL & strOLDAddTable_NUMELIC_Next_Field & Log_JobNumber
    strSQL = strSQL & strOLDAddTable_TEXT_Next_Field & Log_RirekiHeader
    strSQL = strSQL & strOLDAddTable_TEXT_Next_Field & Log_BarcordNumber
    strSQL = strSQL & strOLDAddTable_TEXT_Next_Field & Log_SQL
    strSQL = strSQL & strOLDAddTable_TEXT_Next_Field & Field_LocalInput
    strSQL = strSQL & strOLDAddTable_NUMELIC_Next_Field & Field_RemoteInput & strOLDAddTable_Numeric_Last
    dbTableAdd.SQL = strSQL
    Call dbTableAdd.DoSQL_No_Transaction
    Set dbTableAdd = Nothing
    '�e�[�u���ꗗ���󂯎��
    Set dbTableAdd = New clsSQLiteHandle
    dbTableAdd.SQL = "select name from sqlite_master where type = ""table"";"
    Call dbTableAdd.DoSQL_No_Transaction
    varTableList = dbTableAdd.RS_Array
    Set dbTableAdd = Nothing
    '�e�[�u���������[�v
    For intTableCounter = LBound(varTableList, 1) To UBound(varTableList, 1)
        If Mid(varTableList(intTableCounter, 0), 1, Len(Table_Kishu)) = Table_Kishu Then
            '�@��e�[�u��
            '�t�B�[���h�ǉ�
            Call AppendFieldbyTableName(varTableList(intTableCounter, 0), arrStr_Kishu_AppendField, arrStr_Kishu_Type)
        ElseIf Mid(varTableList(intTableCounter, 0), 1, Len(Table_JobDataPri)) = Table_JobDataPri Then
            'Job�e�[�u��
            '�t�B�[���h�ǉ�
            Call AppendFieldbyTableName(varTableList(intTableCounter, 0), arrStr_Job_AppendField, arrStr_Job_Type)
            'Index�ǉ�
            Call AppendIndexbyTableName(varTableList(intTableCounter, 0), arrStr_Index_AppendField)
        ElseIf Mid(varTableList(intTableCounter, 0), 1, Len(Table_Barcodepri)) = Table_Barcodepri Then
            '�o�[�R�[�h�e�[�u��
            '�t�B�[���h�ǉ�
            Call AppendFieldbyTableName(varTableList(intTableCounter, 0), arrStr_BarCorde_AppendField, arrStr_BarCorde_Type)
        ElseIf Mid(varTableList(intTableCounter, 0), 1, Len(Table_Retrypri)) = Table_Retrypri Then
            '���g���C�e�[�u��
            '�t�B�[���h�ǉ�
            Call AppendFieldbyTableName(varTableList(intTableCounter, 0), arrStr_Retry_AppendField, arrStr_Retry_Type)
        Else
            Debug.Print "�悭�킩��Ȃ��e�[�u��������"
        End If
    Next intTableCounter
ErrorCatch:
    Set dbTableAdd = Nothing
    Debug.Print "AppendField code: " & Err.Number & "Description " & Err.Description
    Exit Sub
CloseAndExit:
    Set dbTableAdd = Nothing
    Exit Sub
End Sub
Public Sub AppendFieldbyTableName(ByVal strargTableName As String, ByRef arrargstrField() As String, ByRef arrargstrType() As String)
    Dim dbAppendField As clsSQLiteHandle
    Dim byteFieldCounter As Byte
    Dim strSQL As String
    For byteFieldCounter = LBound(arrargstrField) To UBound(arrargstrField)
        If Not IsFieldExist(strargTableName, arrargstrField(byteFieldCounter)) Then
            '�t�B�[���h�������悤�Ȃ̂ŁA�ǉ��ɓ���
            Set dbAppendField = New clsSQLiteHandle
            strSQL = ""
            strSQL = strSQL & strOLDAddField1_NextTableName & strargTableName
            strSQL = strSQL & strOLDAddField2_NextFieldName & arrargstrField(byteFieldCounter)
            If arrargstrType(byteFieldCounter) = "NUMERIC" Then
                'NUMERIC�̏ꍇ
                strSQL = strSQL & strOLDAddField3_Numeric_Last
            ElseIf arrargstrType(byteFieldCounter) = "TEXT" Then
                'TEXT�̏ꍇ
                strSQL = strSQL & strOLDAddField3_Text_Last
            ElseIf arrargstrType(byteFieldCounter) = "JSON" Then
                'JSON�̏ꍇ
            End If
            dbAppendField.SQL = strSQL
            Call dbAppendField.DoSQL_No_Transaction
            Set dbAppendField = Nothing
        End If
    Next byteFieldCounter
End Sub
Public Function IsFieldExist(ByVal strargTableName As String, ByVal strargFieldName As String) As Boolean
    '����̃e�[�u���Ɏw�肳�ꂽ�t�B�[���h�����邩�ǂ���
    Dim dbIsField As clsSQLiteHandle
    Dim varReturnValue As Variant
    Dim bytFieldCounter As Byte
    '�e�[�u���̃t�B�[���h���ꗗ���擾
    Set dbIsField = New clsSQLiteHandle
    dbIsField.SQL = "select name from pragma_table_info(""" & strargTableName & """);"
    Call dbIsField.DoSQL_No_Transaction
    varReturnValue = dbIsField.RS_Array
    Set dbIsField = Nothing
    '�t�B�[���h�������[�v
    For bytFieldCounter = LBound(varReturnValue, 1) To UBound(varReturnValue, 1)
        If varReturnValue(bytFieldCounter, 0) = strargFieldName Then
            IsFieldExist = True
            Exit Function
        End If
    Next bytFieldCounter
    IsFieldExist = False
    Exit Function
End Function
Public Sub AppendIndexbyTableName(ByVal strargTableName As String, arrstrargField() As String)
    Dim dbIndexAdd As clsSQLiteHandle
    Dim byteFieldCounter As Byte
    Dim strSQL As String
    byteFieldCounter = LBound(arrstrargField)
    Do While byteFieldCounter <= UBound(arrstrargField)
        If byteFieldCounter = LBound(arrstrargField) Then
            '����̂�
            strSQL = ""
            strSQL = strSQL & strOLDIndex1_NextTable & strargTableName
            strSQL = strSQL & strOLDIndex2_NextTable & strargTableName
            strSQL = strSQL & strOLDIndex3_Field1 & arrstrargField(byteFieldCounter)
        End If
        byteFieldCounter = byteFieldCounter + 1
        If byteFieldCounter > UBound(arrstrargField) Then
            '�����͍Ō�ɗ���Ƃ���
            strSQL = strSQL & strOLDIndex5_Last
        Else
            '�r��
            strSQL = strSQL & strOLDIndex4_FieldNext & arrstrargField(byteFieldCounter)
        End If
    Loop
    Set dbIndexAdd = New clsSQLiteHandle
    dbIndexAdd.SQL = strSQL
    Call dbIndexAdd.DoSQL_No_Transaction
    Set dbIndexAdd = Nothing
End Sub
Public Function getArryDimmensions(ByRef varArry As Variant) As Byte
    '�z��̎�������Ԃ��iByte�܂ł����Ή����Ȃ���j
    Dim byteLocalCounter As Byte
    Dim longRows As Long
    If Not IsArray(varArry) Then
        MsgBox ("�z�񂶂�Ȃ����ۂ��̂������̂Œ��~�ł�")
        getArryDimmensions = False
        Exit Function
    End If
    byteLocalCounter = 0
    On Error Resume Next
    Do While Err.Number = 0
        byteLocalCounter = byteLocalCounter + 1
        longRows = UBound(varArry, byteLocalCounter)
    Loop
    byteLocalCounter = byteLocalCounter - 1
    Err.Clear
    getArryDimmensions = byteLocalCounter
    Exit Function
 End Function
Public Function getKishuInfoByRireki(strargRireki As String) As typKishuInfo
    '���������ɋ@�����Ԃ�
    '�Ԃ�l��KishuInfo�^�i���[�U�[��`�\���́j
    '����΂��ϐ��ɂ���̂��g���悤�ɂȂ�܂���
    Dim Kishu As typKishuInfo
    Dim longKishuCounter As Long
    On Error GoTo ErrorCatch
    If strargRireki = "" Then
        MsgBox "�@���񌟍��ɂ͗������K�{�ł�"
        getKishuInfoByRireki = Kishu
        GoTo CloseAndExit
    End If
    '����΂��̂�����������Ă��邩�`�F�b�N
    If (Not arrKishuInfoGlobal) = -1 Then
        '�����ɗ���Ɩ��������炵���E�E�E
        Call GetAllKishuInfo_Array
    End If
    If boolNoTableKishuRecord = True Then
        '�@��e�[�u������̏ꍇ�͋@��o�^��ʂ�\��
        strRegistRireki = strargRireki
        frmRegistNewKishu.Show
    End If
Serch_From_GlobalKishuList:
    For longKishuCounter = LBound(arrKishuInfoGlobal, 1) To UBound(arrKishuInfoGlobal, 1)
        If Mid(strargRireki, 1, Len(arrKishuInfoGlobal(longKishuCounter).KishuHeader)) = _
            arrKishuInfoGlobal(longKishuCounter).KishuHeader Then
            '�@��w�b�_����v�����̂ŁAKishuInfo��Ԃ��ďI��
            '�@��o�^OK�t���O�𗧂Ă�
            boolRegistOK = True
            Kishu.KishuHeader = arrKishuInfoGlobal(longKishuCounter).KishuHeader
            Kishu.KishuName = arrKishuInfoGlobal(longKishuCounter).KishuName
            Kishu.KishuNickName = arrKishuInfoGlobal(longKishuCounter).KishuNickName
            Kishu.TotalRirekiketa = arrKishuInfoGlobal(longKishuCounter).TotalRirekiketa
            Kishu.RenbanKetasuu = arrKishuInfoGlobal(longKishuCounter).RenbanKetasuu
            getKishuInfoByRireki = Kishu
            GoTo CloseAndExit
        End If
    Next longKishuCounter
    '�����܂ŗ����Ƃ������͋@��o�^����ĂȂ��Ƃ�����
    boolRegistOK = False
'    MsgBox "�@��o�^����Ă��Ȃ��悤�Ȃ̂ŁA�o�^��ʂɈڂ�܂�"
    strRegistRireki = strargRireki
    Call frmRegistNewKishu.Show
    '�o�^�����̂ŁA����1�񃊃X�g�擾���ɍs��
    If boolRegistOK Then
        GoTo Serch_From_GlobalKishuList
    Else
        '�@��o�^OK�t���O�������ĂȂ�������I������
        Debug.Print "�@��o�^�t���ONG�ɂ��I��"
        Exit Function
    End If
    Exit Function
CloseAndExit:
    Exit Function
ErrorCatch:
'    MsgBox "�@����擾���ɃG���[�����������悤�ł�"
    Debug.Print "getKishuInfoByRireki code: " & Err.Number & " Description: " & Err.Description
End Function
Public Function GetAllKishuInfo_Array() As typKishuInfo()
    '�S�@�����KishuInfo�^�̔z��ɂ��ĕԂ�
    '����΂��ϐ��ŋ��L�����Ⴈ���H
    Dim arrKishuInfo() As typKishuInfo
    Dim isCollect As Boolean
    Dim dbKishuAll As clsSQLiteHandle
    Set dbKishuAll = New clsSQLiteHandle
    Dim intCounterKishu As Integer
    Dim varKishuTable As Variant
    Dim strSQLlocal As String
    On Error GoTo ErrorCatch
    '�@��e�[�u���̗L�����m�F����
    If Not IsTableExist(Table_Kishu) Then
        MsgBox "�@��e�[�u���i�����e�[�u���j��������Ȃ������̂ŐV�K�쐬���܂��B"
        isCollect = InitialDBCreate
        If Not isCollect Then
            MsgBox "�@��e�[�u���̍쐬�Ɏ��s�����悤�ł�"
            GetAllKishuInfo_Array = arrKishuInfo
            GoTo CloseAndExit
            Exit Function
        End If
    End If
    'SQL�쐬
    strSQLlocal = "SELECT " & Kishu_Header & "," & Kishu_KishuName & "," & Kishu_KishuNickname & "," & _
                    Kishu_TotalKeta & "," & Kishu_RenbanKetasuu & _
                    " FROM " & Table_Kishu
    '�@��e�[�u���̓��e��z��Ŏ󂯎��
    dbKishuAll.SQL = strSQLlocal
    isCollect = dbKishuAll.DoSQL_No_Transaction()
    If Not isCollect Then
'        MsgBox "SQL���s���Ɏ��s�������悤"
        GoTo CloseAndExit
    End If
    If dbKishuAll.RecordCount = 0 Then
        Debug.Print "NoDataAvilable in T_Kishu"
        boolNoTableKishuRecord = True
        Exit Function
    End If
    '���ʂ�z��Ŏ󂯎��
    ReDim varKishuTable(dbKishuAll.RecordCount - 1)
    ReDim arrKishuInfo(dbKishuAll.RecordCount - 1)
    ReDim arrKishuInfoGlobal(UBound(arrKishuInfo))
    varKishuTable = dbKishuAll.RS_Array(boolPlusTytle:=False)
    Set dbKishuAll = Nothing
    'KishuInfo�^�ɓ˂�����ł��
    For intCounterKishu = LBound(varKishuTable, 1) To UBound(varKishuTable, 1)
        arrKishuInfo(intCounterKishu).KishuHeader = varKishuTable(intCounterKishu, 0)
        arrKishuInfo(intCounterKishu).KishuName = varKishuTable(intCounterKishu, 1)
        arrKishuInfo(intCounterKishu).KishuNickName = varKishuTable(intCounterKishu, 2)
        arrKishuInfo(intCounterKishu).TotalRirekiketa = varKishuTable(intCounterKishu, 3)
        arrKishuInfo(intCounterKishu).RenbanKetasuu = varKishuTable(intCounterKishu, 4)
    Next intCounterKishu
    arrKishuInfoGlobal = arrKishuInfo
    GetAllKishuInfo_Array = arrKishuInfo
    GoTo CloseAndExit
    Exit Function
CloseAndExit:
    Set dbKishuAll = Nothing
    GetAllKishuInfo_Array = arrKishuInfo
    Exit Function
ErrorCatch:
    Debug.Print "GetAllKishu_Array code: " & Err.Number & "Description: " & Err.Description
End Function
Public Function GetFieldTypeNameByTableName(ByVal strargTableName As String) As Dictionary
    '�e�[�u��������t�B�[���h���ƃf�[�^�^�C�v�̈ꗗ���擾����
    Dim dbFieldName As clsSQLiteHandle
    Set dbFieldName = New clsSQLiteHandle
    Dim isCollect As Boolean
    Dim dicFieldType As Dictionary
    Set dicFieldType = New Dictionary
    Dim varFieldType As Variant
    Dim intFieldCounter As Integer
    If Not IsTableExist(strargTableName) Then
        MsgBox strargTableName & " �e�[�u����������܂���ł����B�^�C�v�擾�𒆎~���܂��B"
        Set GetFieldTypeNameByTableName = dicFieldType
        GoTo CloseAndExit
    End If
    '�}�X�^�[�e�[�u�����t�B�[���h���ƃ^�C�v�����擾
    isCollect = dbFieldName.DoSQL_No_Transaction("SELECT name,type FROM pragma_table_info(""" & strargTableName & """)")
    varFieldType = dbFieldName.RS_Array(boolPlusTytle:=False)
    For intFieldCounter = LBound(varFieldType, 1) To UBound(varFieldType, 1)
        dicFieldType.Add varFieldType(intFieldCounter, 0), varFieldType(intFieldCounter, 1)
    Next intFieldCounter
    Set GetFieldTypeNameByTableName = dicFieldType
    GoTo CloseAndExit
    Exit Function
CloseAndExit:
    Set dbFieldName = Nothing
    Set dicFieldType = Nothing
    Exit Function
End Function
 Public Function IsTableExist(ByVal strargTableName As String) As Boolean
    Dim dbExist As clsSQLiteHandle
    Set dbExist = New clsSQLiteHandle
    Dim isCollect As Boolean
    Dim strSQLlocal As String
    strSQLlocal = "SELECT tbl_name FROM sqlite_master WHERE type=""table"" AND name=""" & strargTableName & """"
    isCollect = dbExist.DoSQL_No_Transaction(strSQLlocal)
    If dbExist.RecordCount = 0 Then
        '�������ʂɂȂ��̂ő��݂��Ȃ�
        IsTableExist = False
    Else
        '�e�[�u������
        IsTableExist = True
    End If
    Set dbExist = Nothing
    Exit Function
 End Function
Public Function GetRecordCountSimple(ByVal strargTableName As String, ByVal strargFieldName As String, Optional ByVal strargFindStr) As Long
    '�e�[�u�����ƃt�B�[���h���i�����j�A���������i�ȗ��j��^���āA���R�[�h���݂̂�Ԃ��V���v���ȃ��\�b�h
    '�����������^���Ȃ��ꍇ��count()�̊ȈՔłƂ��Ďg���邩��
    '������ WHERE (Field) (����������)�Ƃ��čs���Ă��܂�
    Dim dbSimple As clsSQLiteHandle
    Dim varReturnValue As Variant
    On Error GoTo ErrorCatch
    If Not IsTableExist(strargTableName) Then
        MsgBox strargTableName & "�e�[�u����������܂���"
        GetRecordCountSimple = 0
        Exit Function
    End If
    Set dbSimple = New clsSQLiteHandle
    If strargFindStr = "" Then
        '���������񂪂Ȃ��ꍇ�͑f���Ƀt�B�[���h���S����Ώۂ�
        dbSimple.SQL = "SELECT COUNT(" & strargFieldName & ") FROM " & strargTableName
    Else
        '���������񂪂���ꍇ�́AWhere�̏����Ɏg���Ă��
        dbSimple.SQL = "SELECT COUNT(" & strargFieldName & ") FROM " & strargTableName & _
        " WHERE " & strargFieldName & " " & strargFindStr
    End If
    dbSimple.DoSQL_No_Transaction
'    GetRecordCountSimple = dbSimple.RecordCount
    varReturnValue = dbSimple.RS_Array
    GetRecordCountSimple = varReturnValue(0, 0)
    Set dbSimple = Nothing
    Exit Function
ErrorCatch:
    GetRecordCountSimple = 0
    GetRecordCountSimple = errcOthers
    Set dbSimple = Nothing
    Debug.Print "SimpleRecorde code: " & Err.Number & "Description: " & Err.Description
    Exit Function
End Function
Public Function GetKishuinfoByZuban(strargZuban As String) As typKishuInfo
    '�}�Ԃ����Ƃ�KishuInfo�����������Ă���
    Dim Kishu As typKishuInfo
    Dim longKishuCounter As Long
    On Error GoTo ErrorCatch
    If strargZuban = "" Then
        Debug.Print "GetKishuInfoByZXuban No arg"
        GoTo CloseAndExit
    End If
    '����΂��̂�����������Ă��邩�`�F�b�N
    If (Not arrKishuInfoGlobal) = -1 Then
        '�����ɗ���Ɩ��������炵���E�E�E
        Call GetAllKishuInfo_Array
    End If
    If boolNoTableKishuRecord = True Then
        '�@��e�[�u������̏ꍇ�͏I������
        GoTo CloseAndExit
    End If
    '�@��e�[�u��arrya��S�����ׂ�
    For longKishuCounter = LBound(arrKishuInfoGlobal, 1) To UBound(arrKishuInfoGlobal, 1)
        If strargZuban = arrKishuInfoGlobal(longKishuCounter).KishuName Then
            '�}�Ԃ�KishuName����v������KishuInfo��Ԃ��Ă��
            Kishu.KishuHeader = arrKishuInfoGlobal(longKishuCounter).KishuHeader
            Kishu.KishuName = arrKishuInfoGlobal(longKishuCounter).KishuName
            Kishu.KishuNickName = arrKishuInfoGlobal(longKishuCounter).KishuNickName
            Kishu.TotalRirekiketa = arrKishuInfoGlobal(longKishuCounter).TotalRirekiketa
            Kishu.RenbanKetasuu = arrKishuInfoGlobal(longKishuCounter).RenbanKetasuu
            GoTo CloseAndExit
        End If
    Next longKishuCounter
    '�@�킪������Ȃ������̂ŁA���̂܂܏I��
    GoTo CloseAndExit
CloseAndExit:
    GetKishuinfoByZuban = Kishu
    Exit Function
ErrorCatch:
'    MsgBox "�@����擾���ɃG���[�����������悤�ł�"
    Debug.Print "getKishuInfoByRireki code: " & Err.Number & " Description: " & Err.Description
End Function
Public Function GetLocalTimeWithMilliSec() As String
    '���ݓ������~���b�܂ŕt���āA�t�H�[�}�b�g�ς�String�Ƃ��ĕԂ�
    'ISO1806�`��
    'yyyy-mm-ddTHH:MM:SS.fff
    Dim strDateWithMillisec As String
    Dim timeLocalTime As SYSTEMTIME
    Call GetLocalTime(timeLocalTime)
    strDateWithMillisec = ""
    strDateWithMillisec = strDateWithMillisec & Format(timeLocalTime.wYear, "0000")
    strDateWithMillisec = strDateWithMillisec & "-"
    strDateWithMillisec = strDateWithMillisec & Format(timeLocalTime.wMonth, "00")
    strDateWithMillisec = strDateWithMillisec & "-"
    strDateWithMillisec = strDateWithMillisec & Format(timeLocalTime.wDay, "00")
    strDateWithMillisec = strDateWithMillisec & "T"
    strDateWithMillisec = strDateWithMillisec & Format(timeLocalTime.wHour, "00")
    strDateWithMillisec = strDateWithMillisec & ":"
    strDateWithMillisec = strDateWithMillisec & Format(timeLocalTime.wMinute, "00")
    strDateWithMillisec = strDateWithMillisec & ":"
    strDateWithMillisec = strDateWithMillisec & Format(timeLocalTime.wSecond, "00")
    strDateWithMillisec = strDateWithMillisec & "."
    strDateWithMillisec = strDateWithMillisec & Format(timeLocalTime.wMilliseconds, "000")
    GetLocalTimeWithMilliSec = strDateWithMillisec
End Function
Public Function GetLastRireki(ByVal strargTableName As String) As String
    '�^����ꂽ�e�[�u�����̍Ō�̗������擾����
    Dim dbLastRireki As clsSQLiteHandle
    Dim varResult As Variant
    On Error GoTo ErrorCatch
    If Not IsTableExist(strargTableName) Then
        Debug.Print "GetLastRireki Table: " & strargTableName & " not found"
        GetLastRireki = ""
        Exit Function
    End If
    Set dbLastRireki = New clsSQLiteHandle
    dbLastRireki.SQL = "SELECT " & Job_Rireki & " FROM (SELECT " & _
                        Job_Rireki & ",MAX(" & Job_RirekiNumber & ") FROM " & _
                        strargTableName & ");"
    Call dbLastRireki.DoSQL_No_Transaction
    varResult = dbLastRireki.RS_Array(boolPlusTytle:=False)
    GetLastRireki = CStr(varResult(0, 0))
    GoTo CloseAndExit
ErrorCatch:
    Debug.Print "GetLastRireki code : " & Err.Number & "Description: " & Err.Description
    GetLastRireki = ""
    GoTo CloseAndExit
CloseAndExit:
   Set dbLastRireki = Nothing
   Exit Function
End Function
Public Function GetNextRireki(ByVal strargTableName As String) As String
    '�^����ꂽ�e�[�u���̎��̗������擾����
    Dim strLastRireki As String
    Dim strNewRireki As String
    Dim KishuLocal As typKishuInfo
    '�e�[�u�����Ȃ��ꍇ��A���X�g�������󔒂�������󔒕Ԃ��ďI��
    If Not IsTableExist(strargTableName) Then
        Debug.Print "GetNextRireki Table: " & strargTableName & " not found"
        GetNextRireki = ""
        Exit Function
    End If
    strLastRireki = GetLastRireki(strargTableName)
    If strLastRireki = "" Then
        Debug.Print "GetNextRireki : Last Rireki Empty"
        GetNextRireki = ""
        Exit Function
    End If
    KishuLocal = getKishuInfoByRireki(strLastRireki)
    If KishuLocal.RenbanKetasuu = 0 Then
        Debug.Print "GetNextRireki : KishuInfo Empty"
        GetNextRireki = ""
        Exit Function
    End If
    strNewRireki = Mid(strLastRireki, 1, KishuLocal.TotalRirekiketa - KishuLocal.RenbanKetasuu) & _
                    Right(String$(KishuLocal.RenbanKetasuu, "0") & CStr((CLng(Right(strLastRireki, KishuLocal.RenbanKetasuu)) + 1)), KishuLocal.RenbanKetasuu)
    GetNextRireki = strNewRireki
    Exit Function
End Function
Public Sub OutputArrayToCSV(ByRef vararg2DimentionsDataArray As Variant, ByVal strargFilePath As String, Optional ByVal strargFileEncoding As String = "UTF-8")
    '�񎟌��z���CSV�ɓf���o��
    Dim byteDimentions As Byte
    Dim objFileStream As ADODB.Stream
    Dim longRowCounter As Long
    Dim longFieldCounter As Long
    Dim strarrField() As String
    Dim strLineBuffer As String
    On Error GoTo ErrorCatch
    byteDimentions = getArryDimmensions(vararg2DimentionsDataArray)
    If Not byteDimentions = 2 Then
        MsgBox "�����ɓ񎟌��z��ȊO���^�����܂����B�����𒆎~���܂��B"
        Debug.Print "OutputArrayToCSV : Not 2 Dimension Array"
        Exit Sub
    End If
    Set objFileStream = New ADODB.Stream
    With objFileStream
        '�G���R�[�h�w��
        .Charset = strargFileEncoding
        '���s�R�[�h�w��
        .LineSeparator = adCRLF
        .Open
        '�s�����[�v
        For longRowCounter = LBound(vararg2DimentionsDataArray, 1) To UBound(vararg2DimentionsDataArray, 1)
            '�t�B�[���h�����[�v�A�����Ń��C���o�b�t�@��g�ݗ��Ă�
            '�܂���string�z��Ƀt�B�[���h�������āAJoin�ŘA������
            ReDim strarrField(UBound(vararg2DimentionsDataArray, 2))
            For longFieldCounter = LBound(vararg2DimentionsDataArray, 2) To UBound(vararg2DimentionsDataArray, 2)
                If IsNull(vararg2DimentionsDataArray(longRowCounter, longFieldCounter)) Then
                    'Null�̏ꍇ��NULL������͂��Ă��
                    strarrField(longFieldCounter) = "NULL"
                Else
                    '�ʏ�͂�����
                    strarrField(longFieldCounter) = CStr(vararg2DimentionsDataArray(longRowCounter, longFieldCounter))
                End If
            Next longFieldCounter
            strLineBuffer = Join(strarrField, ",")
            .WriteText strLineBuffer, adWriteLine
        Next longRowCounter
        '���[�v���I�������e�L�X�g�t�@�C�������o���i�㏑���ۑ��j
        .SaveToFile strargFilePath, adSaveCreateOverWrite
        .Close
    End With
    MsgBox "CSV�o�͊��� " & strargFilePath
    Exit Sub
ErrorCatch:
    Debug.Print "OutputArrayToCSV code: " & Err.Number & " Description: " & Err.Description
    Exit Sub
End Sub
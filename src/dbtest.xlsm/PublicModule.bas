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
Declare PtrSafe Sub GetLocalTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)

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
Public Function InitialDBCreate() As Boolean
    Dim isCollect As Boolean
    Dim strSQL  As String
    Dim dbSQLite3 As clsSQLiteHandle
    Set dbSQLite3 = New clsSQLiteHandle
    On Error GoTo ErrorCatch
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
    '�J�����g�f�B���N�g�����u�b�N�̃f�B���N�g���ɕύX
    ChCurrentDirW (ThisWorkbook.Path)
    strCurrentDir = CurDir
    '�f�[�^�x�[�X�f�B���N�g���͂���O��Ői�߂�̂ŕs�v
    '������SQLite��DLL���邩��I
'    'DataBase�f�B���N�g���̑��ݗL���m�F"
'    If fso.FolderExists(constDatabasePath) <> True Then
'        '�f�B���N�g�����݂��Ȃ��ꍇ�쐬����H
'        MsgBox "�f�[�^�x�[�X�t�H���_���������ߍ쐬���܂��B"
'        MkDir constDatabasePath
'    End If
    '�f�[�^�x�[�X�f�B���N�g���Ɉړ�
    strCurrentDir = CurDir & "\" & constDatabasePath
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
    strSQL = strSQL & """" & BarcordNumber & """ TEXT NOT NULL," & vbCrLf
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
    strSQL = strSQL & """" & BarcordNumber & """ TEXT NOT NULL," & vbCrLf
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
    CreateTable_by_KishuName = True
    Exit Function
End Function
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
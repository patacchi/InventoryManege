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


Public Function ChCurrentDirW(ByVal DirName As String)
    'UNICODE�Ή�ChCurrentDir
    'SetCurrentDirectoryW�iUNICODE�j�Ȃ̂�
    'StrPtr����K�v������E�E�H
    SetCurrentDirectoryW StrPtr(DirName)
End Function

Public Function IsDBFileExist() As Boolean
    'DB�t�@�C���̑��݂��m�F���A�����ꍇ��DB�t�@�C����쐬���i���g��j
    '���ɃJ�����g�f�B���N�g����DB�f�B���N�g���ɂ���O��œ����Ă܂�
    '�W���u���DB�ɂ̂݁A���T_Kishu�A�@����i�[�e�[�u����ݒ肷��
    On Error GoTo ErrorCatch
    Dim fso As New Scripting.FileSystemObject

    '�W���u���DB�L���`�F�b�N
    '�W���u���DB�����݂��Ȃ��ꍇ�́ADB���ݖ����Ƃ��Ĉ���
    If fso.FileExists(constJobNumberDBname) <> True Then
        MsgBox ("DB�t�@�C����������Ȃ��������ߐV�K�쐬���܂�")
        'DB�V�K�쐬����
        If Not InitialDBCreate Then
            MsgBox ("DB�t�@�C���`�F�b�N�i�V�KDB�쐬�j�ŃG���[")
            IsDBFileExist = False
            Set fso = Nothing
            Exit Function
        End If
    End If
    IsDBFileExist = True
    Set fso = Nothing
    Exit Function

ErrorCatch:
'    MsgBox ("DB�t�@�C�����݊m�F���ɃG���[����")
    Debug.Print "IsDBFileExist Error code:" & Err.Number & "Description: " & Err.Description
    Set fso = Nothing
    Exit Function
End Function

Public Function InitialDBCreate() As Boolean
    Dim isCollect As Boolean
    Dim strSQL  As String
    Dim dbSqlite3 As clsSQLiteHandle
    Set dbSqlite3 = New clsSQLiteHandle
    
    On Error GoTo ErrorCatch
    '�����e�[�u���쐬�pSQL���쐬(T_Kishu)
    strSQL = ""
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_Kishu & """("""
    strSQL = strSQL & Kishu_Header & """ TEXT NOT NULL UNIQUE,"""
    strSQL = strSQL & Kishu_KishuName & """ TEXT NOT NULL UNIQUE,"""
    strSQL = strSQL & Kishu_KishuNickname & """ TEXT NOT NULL ,"""
    strSQL = strSQL & Kishu_TotalKeta & """ NUMERIC NOT NULL,"""
    strSQL = strSQL & Kishu_RenbanKetasuu & """ NUMERIC NOT NULL,"""
    strSQL = strSQL & Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP,"""
    strSQL = strSQL & Field_Update & """ TEXT)"
    
    isCollect = dbSqlite3.DoSQL_No_Transaction(strSQL)
    Set dbSqlite3 = Nothing
    '�e�X�g����_SQL�쐬�e�X�g
    isCollect = CreateTable_by_KishuName("Test15")
    If Not isCollect Then
        InitialDBCreate = False
    End If
    '����I��
    InitialDBCreate = True
    Exit Function
ErrorCatch:
    If Err.Number <> 0 Then
        MsgBox Err.Number & vbCrLf & Err.Description
    End If
    Exit Function
End Function
Public Function registNewKishu(ByVal strKishuheader As String, ByVal strKishuname As String, ByVal strKishuNickname As String, _
                                ByVal byteTotalKetasu As Byte, ByVal byteRenbanKetasu As Byte) As Boolean
    '�V�@��o�^����
End Function
Public Function ChcurrentAndReturnDBName()
    'Activesheet�̐ݒ�ŁA�J�����g�f�B���N�g�����ړ���
    '�X�Ƀf�[�^�x�[�X����Ԃ�(String)
    '�J�����g�f�B���N�g���̎擾�iUNC�p�X�Ή��j
    Dim strCurrentDir As String
    Dim fso As New Scripting.FileSystemObject
    Dim rngName As Name
    Dim strDatabaseName As String
    
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
End Function

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
    Dim dbSqlite3 As clsSQLiteHandle
    Set dbSqlite3 = New clsSQLiteHandle
    
    'T_Jobdata �W���u�̗�����Job�ԍ�
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_JobDataPri & strKishuname & """ (""" & _
    Job_Number & """ TEXT NOT NULL,""" & _
    Job_RirekiHeader & """ TEXT NOT NULL,""" & _
    Job_RirekiNumber & """ NUMERIC NOT NULL UNIQUE,""" & _
    Job_Rireki & """ TEXT NOT NULL UNIQUE,""" & _
    Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP,""" & _
    Field_Update & """ TEXT," & _
    "Primary Key(""" & Job_Rireki & """)" & _
    ");"
    isCollect = dbSqlite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    strSQL = ""
    
    '������T_Barcorde �o�[�R�[�h�e�[�u���i�s�b�Ă����j
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_Barcodepri & strKishuname & """ (""" & _
    Job_Number & """ TEXT,""" & _
    BarcordNumber & """ TEXT NOT NULL,""" & _
    Laser_Rireki & """ TEXT NOT NULL UNIQUE,""" & _
    Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP,""" & _
    Field_Update & """ TEXT," & _
    "Primary Key(""" & Laser_Rireki & """)" & _
    ");"
    isCollect = dbSqlite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    strSQL = ""

    '�Ō�Ƀ��g���C�����i����́H����j
    strSQL = "CREATE TABLE IF NOT EXISTS """ & Table_Retrypri & strKishuname & """ (""" & _
    Job_Number & """ TEXT,""" & _
    BarcordNumber & """ TEXT NOT NULL,""" & _
    Laser_Rireki & """ TEXT NOT NULL,""" & _
    Retry_Reason & """ TEXT,""" & _
    Field_Initialdate & """ TEXT DEFAULT CURRENT_TIMESTAMP,""" & _
    Field_Update & """ TEXT" & _
    ");"
    isCollect = dbSqlite3.DoSQL_No_Transaction(strSQL)
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
    isCollect = dbSqlite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    '�W���u�����e�[�u��
    strSQL = ""
    strSQL = "CREATE UNIQUE INDEX IF NOT EXISTS ""ix" & Table_JobDataPri & strKishuname & """ ON """ & _
    Table_JobDataPri & strKishuname & """ (""" & Job_Rireki & """ ASC);"
    isCollect = dbSqlite3.DoSQL_No_Transaction(strSQL)
    If Not isCollect Then
        CreateTable_by_KishuName = False
        Exit Function
    End If
    '�C���f�b�N�X�쐬�I��
    Set dbSqlite3 = Nothing
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
    Dim Kishu As typKishuInfo
    Dim dbSqlite3 As clsSQLiteHandle
    dbSqlite3 = New clsSQLiteHandle
    Dim strSQLlocal As String
    Dim strarrKishuHeader() As String
    Dim longKishusuCounter As Long

    If strargRireki = "" Then
        MsgBox "�@���񌟍��ɂ͗������K�{�ł�"
        getKishuInfoByRireki = Kishu
        Exit Function
    End If

    '�@��w�b�_�݂̂̃��X�g���󂯎��
    strSQLlocal = "SELECT " & Kishu_Header & _
                    "FROM " & Table_Kishu
    
    
    
End Function

 

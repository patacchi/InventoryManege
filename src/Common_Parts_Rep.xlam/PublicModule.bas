Attribute VB_Name = "PublicModule"
Option Explicit
'�Q�Ɛݒ�
'Microsoft AciteX Data Objects 2.8 Library      %ProgramFiles(x86)%\Common Files\System\msado28.tlb
'Microsoft ADO Ext. 6.0 for DDL and Security    %ProgramFiles(x86)%\Common Files\System\msadox.dll
'Microsoft Scripting Runtime                    %SystemRoot%\SysWOW64\scrrun.dll
'Microsoft DAO 3.6 Object Library               %ProgramFiles(x86)%\Common Files\Microfost Shared\DAO\dao360.dll
'-----------------------------------------------------------------------------------------------------------------------
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
'-----------------------------------------------------------------------------------------------------------------------
Public Function ChCurrentDirW(ByVal DirName As String) As Boolean
    'UNICODE�Ή�ChCurrentDir
    'SetCurrentDirectoryW�iUNICODE�j�Ȃ̂�
    'StrPtr����K�v������E�E�H
    SetCurrentDirectoryW StrPtr(DirName)
End Function
'-----------------------------------------------------------------------------------------------------------
'Public Sub CreateAliasTable()
'    '�G�C���A�X�e�[�u���쐬
'    '2021_09_14 Patacchi �G�C���A�X�e�[�u������
'    'Header��KishuName���ꂼ��̃G�C���A�X�e�[�u���ɕ�������
'
'    Dim strSQL As String
'    Dim dbAlias As clsSQLiteHandle
'    Dim sqlbC As clsSQLStringBuilder
'    On Error GoTo ErrorCatch
'    Set dbAlias = New clsSQLiteHandle
'    Set sqlbC = New clsSQLStringBuilder
'    'Header
'    '�e�[�u�������݂��Ȃ��ꍇ�̂ݎ��s����
'    If Not IsTableExist(Table_AliasHeader) Then
'        strSQL = ""
'        strSQL = strSQL & strTable1_NextTable & Table_AliasHeader
'        strSQL = strSQL & strTable2_Next1stField & sqlbC.addQuote(Kishu_Header) & strTable3_TEXT & strTable_NotNull & strTable_Unique & strTable4_EndRow
'        strSQL = strSQL & sqlbC.addQuote(Kishu_Origin) & strTable3_TEXT & strTable_NotNull & strTable4_EndRow
'        strSQL = strSQL & strTable4_5_PrimaryKey & sqlbC.addQuote(Kishu_Header) & strTable4_6_EndPrimary & strTable5_EndSQL
'        dbAlias.SQL = strSQL
'        Call dbAlias.DoSQL_No_Transaction
'    End If
'    'KishuName
'    '�e�[�u�������݂��Ȃ��ꍇ�̂ݎ��s����
'    If Not IsTableExist(Table_AliasKishu) Then
'        strSQL = ""
'        strSQL = strSQL & strTable1_NextTable & Table_AliasKishu
'        strSQL = strSQL & strTable2_Next1stField & sqlbC.addQuote(Kishu_KishuName) & strTable3_TEXT & strTable_NotNull & strTable_Unique & strTable4_EndRow
'        strSQL = strSQL & sqlbC.addQuote(Kishu_Origin) & strTable3_TEXT & strTable_NotNull & strTable4_EndRow
'        strSQL = strSQL & strTable4_5_PrimaryKey & sqlbC.addQuote(Kishu_KishuName) & strTable4_6_EndPrimary & strTable5_EndSQL
'        dbAlias.SQL = strSQL
'        Call dbAlias.DoSQL_No_Transaction
'    End If
'    GoTo CloseAndExit
'ErrorCatch:
'    If Err.Number <> 0 Then
'        MsgBox Err.Number & vbCrLf & Err.Description
'    End If
'    DebugMsgWithTime "CreateAliasTable code: " & Err.Number & "Description: " & Err.Description
'    GoTo CloseAndExit
'CloseAndExit:
'    Set dbAlias = Nothing
'    Set sqlbC = Nothing
'    Exit Sub
'End Sub
'------------------------------------------------------------------------------------------------------
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
        DebugMsgWithTime "OutputArrayToCSV : Not 2 Dimension Array"
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
    DebugMsgWithTime "OutputArrayToCSV code: " & Err.Number & " Description: " & Err.Description
    Exit Sub
End Sub
'''Author Daisuke Oota 2021_10_18
'''�f�o�b�O�o�͎��ɓ������ꏏ�ɏo���Ă��֐�
'''---------------------------------------------------------------------------------------------------------------------------
Public Sub DebugMsgWithTime(strargDebugMsg As String)
    If strargDebugMsg = "" Then
        '�����񂪋󔒂������甲����
        Exit Sub
    End If
    '�������݂Œl���o��
    Debug.Print GetLocalTimeWithMilliSec & " " & strargDebugMsg
    Exit Sub
End Sub
'''---------------------------------------------------------------------------------------------------------------------------
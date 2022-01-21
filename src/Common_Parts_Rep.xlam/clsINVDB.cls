VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsINVDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'''Author Patacchi 2022_01_10
'''�݌ɏ��DB�������N���X
Option Explicit
'�萔��`
Private Const FILTER_NAME_RANGE_PART As String = "FilterDatabase"
'------------------------------------------------------------------------------------------------------
'�����o�ϐ���`
Private objExcel As Excel.Application
Private strINVDBFullPath As String                                  'INV_Manege.accdb�̃t���p�X�A��{�I�ɂ͖��w��Ńf�t�H���g�̏ꏊ��ǂ݂ɍs��
Private strBKZaikoInfoFullPath As String                            '�݌ɏ���Excel�t�@�C���̃t���p�X�A����t�@�C�������ϓ�����̂Ńf�t�H���g�l�͖���
'------------------------------------------------------------------------------------------------------
'�v���p�e�B
'INVDBFullPath
Property Get INVDBFullPath() As String
    If strINVDBFullPath <> "" Then
        '�����o�ϐ��Ɋ���INVDB�������Ă����炻�̂܂ܕԂ�
        INVDBFullPath = strINVDBFullPath
        Exit Property
    End If
    '�����o�ϐ����󂾂����ꍇ�A�����l��ݒ肵�Ă��
    Dim dbINVBDBFullpath As clsADOHandle
    Set dbINVBDBFullpath = New clsADOHandle
    Dim fsoINVDBFullPath As FileSystemObject
    Set fsoINVDBFullPath = New FileSystemObject
    'clsAdoHandle���DB�f�t�H���g�f�B���N�g�����AINV_CONST���f�t�H���gDB�t�@�C�������擾���A�t���p�X�ɑg�ݗ��ĕԂ�
    INVDBFullPath = fsoINVDBFullPath.BuildPath(dbINVBDBFullpath.DBPath, INV_CONST.INV_DB_FILENAME)
    Set dbINVBDBFullpath = Nothing
    Set fsoINVDBFullPath = Nothing
    Exit Property
End Property
Property Let INVDBFullPath(strargINVDBFullPath As String)
    If strargINVDBFullPath = "" Then
        '��������̎��͔�����
        DebugMsgWithTime "Property let INVDBFullPath:arg empty"
        Exit Property
    End If
    '�����o�ϐ��ɃZ�b�g���Ă��
    strINVDBFullPath = strargINVDBFullPath
    Exit Property
End Property
'BKZaikoInfoFullPath
Property Get BKZAikoInfoFullPath() As String
    '�݌ɏ��V�[�g��Book���ɏ����l�͖����ׁA�����o�ϐ������̂܂ܕԂ�
    BKZAikoInfoFullPath = strBKZaikoInfoFullPath
    Exit Property
End Property
Property Let BKZAikoInfoFullPath(strargBKZaikoInfoFullPath As String)
    If strargBKZaikoInfoFullPath = "" Then
        '�������󂾂����甲����
        DebugMsgWithTime "Property let BKZaikoInfoFullPath: arg empty"
        Exit Property
    End If
    '�����o�ϐ��ɃZ�b�g���Ă��
    strBKZaikoInfoFullPath = strargBKZaikoInfoFullPath
    Exit Property
End Property
'''Autor Daisuke_oota 2021_01_17
'''�N���X���������ɍs������
Private Sub ClassInitialize()
End Sub
'''Autor Daisuke_oota 2021_01_17
'''�N���X���j�����ɍs������
Private Sub ClassFinarize()
    If Not objExcel Is Nothing Then
        'ExcelObject��Nothing����Ȃ��ꍇ
        objExcel.Quit
        Set objExcel = Nothing
    End If
End Sub
'------------------------------------------------------------------------------------------------------
'�R���X�g���N�^�A�f�X�g���N�^
Private Sub Class_Initialize()
    Call ClassInitialize
End Sub
Private Sub Class_Terminate()
    Call ClassFinarize
End Sub
'------------------------------------------------------------------------------------------------------
'���\�b�h
'''Author Patacchi 2022_01_16
'''Excel�֘A�t�@�C���ɃI�[�g�t�B���^��ݒ肵�A�t�B���^�͈̖͂��O��Ԃ��iSelect �� From �̈����ɂȂ�j
'''�߂�l string�z�� 1�����ڂ̓t�@�C���̃t���p�X�A2�����ڂ�Table��
'''parms
'''optional strargExceFileFullpath          Excel�t�@�C���̃t���p�X���w�肷��A���w��̏ꍇ�̓N���X��BKZAikoInfoFullPath�v���p�e�B��ݒ�
'''optional strargSheetName                 �t�B���^�ݒ肷��V�[�g�����w�肷��A���w��̏ꍇ�͍ŏ��̃V�[�g��ΏۂƂ���
'''Optional strargKeyFieldName              �t�B���^�ݒ肷��ۂ̊�t�B�[���h���A���w��̏ꍇ��z�R�[�h�Ƃ���
Public Function GetFilterRangeNameFromExcel(Optional strargExcelFileFullpath As String, Optional strargSheetName As String, Optional strargKeyFieldName As String) As String()
    'Excel�t�@�C�����w�肳��Ȃ������ꍇ�̓N���X�̃v���p�e�B�����������
    If strargExcelFileFullpath = "" Then
        strargExcelFileFullpath = Me.BKZAikoInfoFullPath
    End If
    If strargExcelFileFullpath = "" Then
        '�v���p�e�B������������Ă�Book�����󂾂����ꍇ�͔�����
        DebugMsgWithTime "GetFilterRangeNameFromExcel: Book filename empty"
        GoTo CloseandExit
    End If
    On Error GoTo ErrorCatch
    '�����̃t�@�C���̑��݊m�F
    Dim fsoFilterRange As FileSystemObject
    Set fsoFilterRange = New FileSystemObject
    If Not fsoFilterRange.FileExists(strargExcelFileFullpath) Then
        '�t�@�C����������Ȃ�����
        DebugMsgWithTime "GetFilterRangeNameFromExcel: file not found: " & strargExcelFileFullpath
        GoTo CloseandExit
    End If
    Dim EnumValue As clsEnum
    Set EnumValue = CreateclsEnum
    Select Case LCase(fsoFilterRange.GetExtensionName(strargExcelFileFullpath))
    Case EnumValue.DBFileExetension(xlam_dext), EnumValue.DBFileExetension(xlsm_dext), _
    EnumValue.DBFileExetension(xls_dext), EnumValue.DBFileExetension(xlsb_dext), EnumValue.DBFileExetension(xlsx_dext)
        '�G�N�Z���֘A�t�@�C���̎�
        '��\���ŏ������邽�߂ɁAApplication�I�u�W�F�N�g��Workbook�I�u�W�F�N�g��ʂɒ�`����
        If objExcel Is Nothing Then
            '�N���X��objExcel������������Ă��Ȃ������炱���ōs��
            Set objExcel = New Excel.Application
        End If
        Dim wkbFilter As Workbook
        'workbook�I�u�W�F�N�g���擾
        Set wkbFilter = objExcel.Workbooks.Open(strargExcelFileFullpath)
        If wkbFilter.Worksheets.Count < 1 Then
            '�V�[�g����1�����������ꍇ�͔�����
            DebugMsgWithTime "GetFilterRangeNameFromExcel: Sheet count under 1"
            GoTo CloseandExit
        End If
        If strargSheetName = "" Then
            '�����ŃV�[�g����^�����Ȃ������ꍇ
            '�ŏ��̃V�[�g����ΏۂƂ���
            strargSheetName = wkbFilter.Worksheets(1).Name
        End If
        '���݂��Ȃ��V�[�g�����J�����ꍇ��Err.Number = 9 �A�C���f�b�N�X�O�G���[����������̂ŁA�G���[�g���b�v���s��
        Err.Clear
        Dim shtFilter As Worksheet
        '�݌ɏ��V�[�g�̃I�u�W�F�N�g���擾����A���̃^�C�~���O�ŃV�[�g�����݂��Ȃ��ꍇ�̓G���[����������
        On Error Resume Next
        Err.Clear
        Set shtFilter = wkbFilter.Worksheets(strargSheetName)
        'Err.Number��0�ȊO�̎��͏����𒆒f
        If Err.Number <> 0 Then
            DebugMsgWithTime "GetFilterRangeNameFromExcel: sheet not found: " & strargSheetName
            GoTo CloseandExit
            Exit Function
        End If
        On Error GoTo ErrorCatch
        Dim flgSave As Boolean
        flgSave = False
        If shtFilter.AutoFilterMode = False Then
            '�݌ɏ��V�[�g�Ƀt�B���^�[���ݒ肳��Ă��Ȃ��ꍇ
            Dim rngZaikoInfoColumn As Range
            '�L�[Field�������肷��
            If strargKeyFieldName = "" Then
                '�����ŃL�[�t�B�[���h�����w�肳��Ă��Ȃ��ꍇ�́A��z�R�[�h���f�t�H���g�Ƃ���
                strargKeyFieldName = EnumValue.shZaikoField(F_Tehai_Code_ShZ)
            End If
            '�݌ɏ��̗񖼂̂�������������ARange�I�u�W�F�N�g�𓾂�
            Set rngZaikoInfoColumn = shtFilter.Cells.Find(strargKeyFieldName)
            If Not rngZaikoInfoColumn Is Nothing Then
                '��z�R�[�h�̗񂪌��������ꍇ
                '��z�R�[�h�̗����ɂ��ăI�[�g�t�B���^��ݒ肷��
                rngZaikoInfoColumn.AutoFilter
                'SaveFlag�𗧂Ă�
                flgSave = True
            End If
        End If
        '���O��`���ׂĂɑ΂��ă��[�v���A��\���̖��O�͈͂�\������ݒ�ɂ�
        '�t�B���^�[���̖��O��`���֐��̖߂�l�Ƃ��Đݒ肵�Ă��
        Dim elmName As Name
        For Each elmName In shtFilter.Names
            If elmName.Visible = False Then
                '���O��`����\���Ȃ��Ă����ꍇ
                elmName.Visible = True
                '�ۑ��t���O�𗧂Ă�
                flgSave = True
            End If
        Next elmName
        '�ۑ��t���O�̏�Ԃ𒲂ׂ�
        If flgSave Then
            '�ۑ��t���O�������Ă�����u�b�N��ۑ�����
            wkbFilter.Save
        End If
        'Book�ւ̐ڑ�����Ă��
        wkbFilter.Close
        Set wkbFilter = Nothing
        '������������Excel�t�@�C���̃e�[�u���ꗗ���擾���A�t�B���^�[���ʕ�����̓����Ă���e�[�u���������������炻���Ԃ�
        Dim dbGetTableList As clsADOHandle
        Set dbGetTableList = CreateclsADOHandleInstance
        dbGetTableList.DBFileName = fsoFilterRange.GetFileName(strargExcelFileFullpath)
        dbGetTableList.DBPath = fsoFilterRange.GetParentFolderName(strargExcelFileFullpath)
        Dim arrstrFilterTables() As String
        arrstrFilterTables = dbGetTableList.GetTableList
        Dim arrstrResult() As String
        arrstrResult = Filter(arrstrFilterTables, FILTER_NAME_RANGE_PART)
        If UBound(arrstrResult) = 0 Then
            '���ʂ���݂̂ł������ꍇ�i��������ƍ���j
            Dim arrstrFilterRangeResult(0, 1) As String
            arrstrFilterRangeResult(0, 0) = strargExcelFileFullpath
            arrstrFilterRangeResult(0, 1) = "[" & arrstrResult(0) & "]"
            GetFilterRangeNameFromExcel = arrstrFilterRangeResult
           GoTo CloseandExit
           Exit Function
        End If
    Case EnumValue.DBFileExetension(csv_dext)
        'CSV�t�@�C���������ꍇ
        '��A�̏������s���Axlsx�t�@�C���ɂ�����A���̃t�@�C�����Ŏ��M���ċA�Ăяo������
        Dim strResultxlsxFileName As String
        strResultxlsxFileName = CSVFileSaveAsXlsxFileandPasteValues(strargExcelFileFullpath)
        '���g���ċN�Ăяo��
        Dim arrstrRangeTableName() As String
        arrstrRangeTableName = Me.GetFilterRangeNameFromExcel(strResultxlsxFileName)
        '�A���Ă����e�[�u���������ʂƂ��ĕԂ�
        GetFilterRangeNameFromExcel = arrstrRangeTableName
        GoTo CloseandExit
        Exit Function
    Case Else
        'Excel�t�@�C������Ȃ������ꍇ
        DebugMsgWithTime "SetExcelAutoFormat: not excel file"
        GoTo CloseandExit
    End Select
ErrorCatch:
    DebugMsgWithTime "GetFilterRangeNameFromExcel code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseandExit
    Exit Function
CloseandExit:
    Set shtFilter = Nothing
    If Not wkbFilter Is Nothing Then
        'Workbook�I�u�W�F�N�g��Nothing����Ȃ��ꍇ
        wkbFilter.Close
        Set wkbFilter = Nothing
    End If
    Set dbGetTableList = Nothing
    Set EnumValue = Nothing
    Set fsoFilterRange = Nothing
    Exit Function
End Function
'''Author Patacchi 2022_01_16
'''CSV�t�@�C����xlsx�t�@�C���ɕۑ����A���S�͈͒l�\��t����Ԃɂ��ۑ������t�@�C������Ԃ�
'''�߂�l string �ۑ����xlsx�t�@�C�����̃t���p�X��Ԃ�
Private Function CSVFileSaveAsXlsxFileandPasteValues(strargCSVFileFullPath As String) As String
    On Error GoTo ErrorCatch
    If strargCSVFileFullPath = "" Then
        DebugMsgWithTime "CSVFileSaveAsxlsx: arg csv file name empty"
        GoTo CloseandExit
    End If
    '�t�@�C�����݊m�F
    Dim fsoCSV As FileSystemObject
    Set fsoCSV = New FileSystemObject
    If Not fsoCSV.FileExists(strargCSVFileFullPath) Then
        DebugMsgWithTime "CSVFileSaveAsxlsx: file not found: " & strargCSVFileFullPath
        GoTo CloseandExit
        Exit Function
    End If
    '�g���q�m�F
    Dim EnumValue As clsEnum
    Set EnumValue = CreateclsEnum
    If Not LCase(fsoCSV.GetExtensionName(strargCSVFileFullPath)) = EnumValue.DBFileExetension(csv_dext) Then
        '�g���q��csv����Ȃ�����
        DebugMsgWithTime "CSVFileSaveAsxlsx: not csv files (extention)"
        GoTo CloseandExit
        Exit Function
    End If
    'CSV�t�@�C�����J���Axlsx�`���ŕۑ�����
    Dim objExcel As Excel.Application
    Set objExcel = New Excel.Application
    Dim wkbCSV As Workbook
    'workbook�I�u�W�F�N�g���擾
    Set wkbCSV = objExcel.Workbooks.Open(strargCSVFileFullPath)
    '�Ƃ肠�������̂܂�xlsx�Ƃ��ĕۑ�����
    Dim strxlsxFileName As String
    strxlsxFileName = strargCSVFileFullPath & "." & EnumValue.DBFileExetension(xlsx_dext)
    If fsoCSV.FileExists(strxlsxFileName) Then
        '�ۑ���̃t�@�C�������������ꍇ�͏�������
        fsoCSV.DeleteFile strxlsxFileName, True
    End If
    wkbCSV.SaveAs strxlsxFileName, xlOpenXMLWorkbook
    wkbCSV.Close
    Set wkbCSV = Nothing
    '���x�͕ۑ�����xlsx�t�@�C���ɑ΂��āA�S�f�[�^�l�\��t���̏������s��
    Dim wkbXlsx As Workbook
    Set wkbXlsx = objExcel.Workbooks.Open(strxlsxFileName)
    If wkbXlsx.Worksheets.Count < 1 Then
        '���[�N�V�[�g�̐���1�����������甲�����
        DebugMsgWithTime "CSVFileSaveAsXlsx: no contents"
        GoTo CloseandExit
        Exit Function
    End If
    Dim shXlsx As Worksheet
    'xlsx�̐擪�V�[�g���擾
    Set shXlsx = wkbXlsx.Worksheets(1)
    '�ŏI�Z���܂ł͈̔͂��擾���A�l�\��t��
    Dim lngMaxRow As Long
    Dim lngMaxColumn As Long
    shXlsx.Range(shXlsx.Cells(1, 1), shXlsx.Cells.SpecialCells(xlCellTypeLastCell)).Copy
    DoEvents
    shXlsx.Range(shXlsx.Cells(1, 1), shXlsx.Cells.SpecialCells(xlCellTypeLastCell)).PasteSpecial Paste:=xlPasteValues
    '�R�s�[���[�h����
    objExcel.CutCopyMode = False
    '���߂�xlsx�t�@�C����ۑ�
    wkbXlsx.Save
    wkbXlsx.Close
    Set wkbXlsx = Nothing
    CSVFileSaveAsXlsxFileandPasteValues = strxlsxFileName
    GoTo CloseandExit
ErrorCatch:
    CSVFileSaveAsXlsxFileandPasteValues = ""
    DebugMsgWithTime "CSVFileSaveAsXlsxFileandPasteValues code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseandExit
CloseandExit:
    Set shXlsx = Nothing
    If Not wkbXlsx Is Nothing Then
        wkbXlsx.Close
        Set wkbXlsx = Nothing
    End If
    If Not wkbCSV Is Nothing Then
        wkbCSV.Close
        Set wkbCSV = Nothing
    End If
    Set EnumValue = Nothing
    Set fsoCSV = Nothing
    Exit Function
End Function
'''Author Daisuke Oota 2022_01_20
'''�݌ɏ��V�[�g�̃t���p�X�������Ƃ��āAINV�p�[�c�}�X�^�[DB�ɓo�^����v���V�[�W��
'''args
'''strargZaikoSHFullPath    �݌ɏ��V�[�g�̃t���p�X
'''clsADOUpsert             ADOHandle�̃C���X�^���X�A�J��Ԃ����������邱�ƂɂȂ�Ǝv���̂ŁA���̃��\�b�h�ȑO�Ő錾���A���L����
'''                         DBPath,DBFilename�͈����œn�����N���X�̃C���X�^���X�̃v���p�e�B�Őݒ肷�邱�ƂƂ���
'''clsINVDBUpsert           INVDB�N���X�̃C���X�^���X���w�肷��B���̃��\�b�h�ȑO�ɍ쐬���Ă�����ė��p����i�R���X�g���N�^�̓��삪�d�����߁j
'''�߂�l long      �ύX�����������R�[�h����Ԃ��B0�ȉ����Ɖ������炪�������H
Public Function UpsertINVPartsMasterfromZaikoSH(strargZaikoSHFullPath As String, ByRef clsINVDBUpsert As clsINVDB, ByRef clsADOUpsert As clsADOHandle) As Long
    On Error GoTo ErrorCatch
    '�N���X�̑��݊m�F
    If clsINVDBUpsert Is Nothing Then
        '����������ĂȂ��N���X�C���X�^���X���n���ꂽ
        DebugMsgWithTime "UpsertINVPartsMasterfromZaikoSH: Class instance is nothing"
        UpsertINVPartsMasterfromZaikoSH = 0
        GoTo CloseandExit
        Exit Function
    End If
#If DebugDB = 1 Then
    'DebugDB���[�h�̎�
    strargZaikoSHFullPath = Application.GetOpenFilename()
#End If
    '�t�@�C���̑��݊m�F
    Dim fsoUpsertPartsMaster As FileSystemObject
    Set fsoUpsertPartsMaster = New FileSystemObject
    If Not fsoUpsertPartsMaster.FileExists(strargZaikoSHFullPath) Then
        '�����Ŏw�肵���t�@�C�������݂��Ȃ������ꍇ
        DebugMsgWithTime "UpsertINVPartsMaster file not found: " & strargZaikoSHFullPath
        UpsertINVPartsMasterfromZaikoSH = 0
        GoTo CloseandExit
    End If
    Dim strFilterdZaikoSh() As String
    '�t�B���^������̃t�@�C�������󂯎��B���̎��A�V�[�g���𖾎��I��INT_CONST�����������w�肵�Ă��
    strFilterdZaikoSh = clsINVDBUpsert.GetFilterRangeNameFromExcel(strargZaikoSHFullPath, INV_CONST.INV_SH_ZAIKO_NAME)
    '������ɏ���������Ă��Ȃ��z�񂪋A���Ă�����A�݌ɏ��V�[�g�����݂��Ȃ��\���������̂ŏ����𒆒f����
    If Not IsRedim(strFilterdZaikoSh) Then
        DebugMsgWithTime "UpserINVPartsMaster: not found zako_info sheets origin file: " & strargZaikoSHFullPath
        UpsertINVPartsMasterfromZaikoSH = 0
        GoTo CloseandExit
    End If
    '''�����܂łō݌ɏ��V�[�g���m�肵���̂ŁA�݌ɏ�񂩂�DB�ɓo�^���郁�\�b�h�ŏ������s��
    Dim longResultAffected As Long
    longResultAffected = DoUpsertbyZaikoSH(strFilterdZaikoSh(0, 0), strFilterdZaikoSh(0, 1), clsADOUpsert)
    GoTo CloseandExit
ErrorCatch:
    DebugMsgWithTime "UpsertINBPartMasterFromZaikoSH code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseandExit
CloseandExit:
    Set fsoUpsertPartsMaster = Nothing
    'INVDB�C���X�^���X��ByRef�ő��̕����ė��p���Ă���̂ŉ���֎~
'    If Not INVDBupsertINVPartMaster Is Nothing Then
'        'INVDB�ϐ���Nothing�������ꍇ
'        Set INVDBupsertINVPartMaster = Nothing
'    End If
    Exit Function
End Function
'''Author Daisuke oota 2022_01_21
'''�݌ɏ��V�[�g�̃t���p�X�������Ƃ��āADB�ɓo�^���郁�\�b�h
'''args
'''strargFilterdZaikoSHFullPath         �t�B���^�����ς݂̃u�b�N���̃t���p�X
'''strargTableName                      �݌ɏ��V�[�g��Select �� From�ɓ���e�[�u����
'''clsADOUpsert                         ADOHandle�̃C���X�^���X�A�J��Ԃ����������邱�ƂɂȂ�Ǝv���̂ŁA���̃��\�b�h�ȑO�Ő錾���A���L����
'''                                     DBPath,DBFilename�͈����œn�����N���X�̃C���X�^���X�̃v���p�e�B�Őݒ肷�邱�ƂƂ���
'''�߂�l long      �e���̂������s����Ԃ�
Private Function DoUpsertbyZaikoSH(strargFilterdZaikoSHFullPath As String, strargTableName As String, ByRef clsADOUpsert As clsADOHandle) As Long
    On Error GoTo ErrorCatch
    'AdoHandle�̃N���X�������󋵂��m�F
    If clsADOUpsert Is Nothing Then
        DebugMsgWithTime "DoUpsertbyZaikoSH: warning! clsADOHandle instance Nothing. will delay cause create new class"
        Set clsADOUpsert = CreateclsADOHandleInstance
        DoUpsertbyZaikoSH = 0
        GoTo CloseandExit
        Exit Function
    End If
    '�t�@�C���A�e�[�u���̋�f�[�^�`�F�b�N
    If strargFilterdZaikoSHFullPath = "" Or strargTableName = "" Then
        DebugMsgWithTime "DoUpsertbyZaikoSH: Zaiko sheet filename or table name is empty"
        DoUpsertbyZaikoSH = 0
        GoTo CloseandExit
        Exit Function
    End If
ErrorCatch:
    DebugMsgWithTime "DoUpsertbyZaikoSH code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseandExit
    Exit Function
CloseandExit:
    Exit Function
End Function
VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmKanban 
   Caption         =   "�Ŕ��������t�H�[��"
   ClientHeight    =   8475.001
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   15690
   OleObjectBlob   =   "frmKanban.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmKanban"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'#const ReadLocal =1 �Ƃ���ƁA�@�햼����ł������_�Ń��[�J���Ɉꎞ�e�[�u�����쐬���A�������猟������悤�ɂ���
'���ł��Q�Ƃ�����ۂ��̂ŁAVbaproject�̃v���p�e�B�ŃO���[�o���ϐ��Ƃ��Ē�`
#If READLOCAL = 1 Then
    Private dbLocal As clsSQLiteHandle
    Private strLocalPath
    Private strLocalDBFilePath
#End If
Private Sub btnDeleteLastKanban_Click()
    If listBoxExistingChr.ColumnCount <= 1 Then
        MsgBox "JOB�������������݂��Ȃ��悤�Ȃ̂ŁA�폜�����𒆎~���܂�"
        Exit Sub
    End If
End Sub
Private Sub btnDoDivide_Click()
    Dim KishuLocal As typKishuInfo
    Dim isCollect As Boolean
    Dim longOldJobNumberIndex As Long
    Dim longOldNicknameIndex As Long
    On Error GoTo ErrorCatch
    KishuLocal = GetKishuinfoByNickName(lblNowKishuNickName.Caption)
    If txtBoxNewMaisuu.Text = "" Or txtboxNewSheetQty.Text = "" Or cmbBoxKanbanChr.Text = "" Then
        MsgBox "�K�v�ȍ��ڂ����͂���Ă��Ȃ��悤�ł��B"
        Exit Sub
    End If
    If CLng(txtBoxNewMaisuu.Text) > CLng(lblRemainMaisuu.Caption) Then
        MsgBox "�c�薇���𒴂��Ă��܂��B"
        Exit Sub
    End If
    If CLng(txtBoxNewMaisuu.Text) <= 0 Then
        MsgBox "������0�ȉ����Z�b�g���ꂽ���߁A�I�����܂�"
        Exit Sub
    End If
    isCollect = UpdateKanbanChrByJobNumberMaisuu(Table_JobDataPri & KishuLocal.KishuName, cmbBoxKanbanChr.Text, lblNextRireki.Caption, txtBoxNewMaisuu, KishuLocal)
    If Not isCollect Then
        MsgBox "�Ŕf�[�^�̐ݒ莞�ɃG���[�����������悤�ł�"
        Exit Sub
    End If
    '�I�������̂ł��|��
'    strOldJobNumber = cmbBoxJobNumber.List(cmbBoxJobNumber.ListIndex, 0)
    longOldJobNumberIndex = cmbBoxJobNumber.ListIndex
    longOldNicknameIndex = cmbBoxKishuNickName.ListIndex
    Call Clear_Exclude_KishuNickName(boolExcludeJobNumber:=True)
    '���X�g�ĕ\��
    cmbBoxKishuNickName.ListIndex = -1
    Sleep 20
    cmbBoxJobNumber.ListIndex = -1
    Sleep 20
    cmbBoxKishuNickName.ListIndex = longOldNicknameIndex
    Sleep 20
    cmbBoxJobNumber.ListIndex = longOldJobNumberIndex
    Sleep 100
    listBoxExistingChr.Width = 520
    Sleep 50
    listBoxExistingChr.Width = 525.5
    Sleep 30
    MsgBox "Job��������"
    Exit Sub
ErrorCatch:
    Debug.Print "btnDoDivide code: " & Err.Number & " Descriptoin: " & Err.Description
    Exit Sub
End Sub
Private Sub btnPrintKanban_Click()
    If listBoxExistingChr.ListIndex = -1 Or listBoxExistingChr.ListIndex = 0 Then
        MsgBox "�Ŕ��쐬�����������ԍ���I��ł���N���b�N���ĉ������B"
        Exit Sub
    End If
    '�Ŕ쐬�J�n
End Sub
Private Sub btnQRRead_Click()
    Dim KishuLocal As typKishuInfo
    Dim qrLocal As typQRDataField
    On Error GoTo ErrorCatch
    QRField = qrLocal
    frmQRAnalyze.Show
    If QRField.Zuban = "" Then
        Exit Sub
    End If
    KishuLocal = GetKishuinfoByKishuName(QRField.Zuban)
    If KishuLocal.KishuNickName = "" Then
        MsgBox "�ǂݍ��܂ꂽQR�R�[�h�̋@���񂪌�����܂���ł����BJob�o�^��ʂ���o�^���ĉ������B"
        Exit Sub
    End If
    '�@�햼�R���{�{�b�N�X�ɃZ�b�g���Ă��
    cmbBoxKishuNickName.Text = KishuLocal.KishuNickName
    cmbBoxJobNumber.Text = QRField.JobNumber
ErrorCatch:
    Debug.Print "btnQRRead code:" & Err.Number & " Descriptoin: "; Err.Description
End Sub
Private Sub cmbBoxKishuNickName_Change()
    Dim KishuNickName As typKishuInfo
    Dim vararrJobData As Variant
    Dim strListColumnWidth As String
    '�Ⴄ�̂�I�������p�^�[���̂��߂ɁA���͕ω�������A���̍��ڂ����������Ă��
    Call Clear_Exclude_KishuNickName
    '�@��ʏ̖�����KishuInfo�����������Ă���
    KishuNickName = GetKishuinfoByNickName(cmbBoxKishuNickName.Text)
    '�Ŕꗗ�\�擾SQL�啝���P�ɂ��A���[�J���R�s�[�͕s�v�ɂȂ�܂���
    #If READLOCAL = 1 Then
        '���[�J���R�s�[���́A�����ŋ@��֘A�e�[�u�������[�J���Ɏ�荞��
        Dim dicOriginTableSchema As Dictionary
        Dim varKeyLocal As Variant
        Dim isCollect As Boolean
        Set dbLocal = New clsSQLiteHandle
        Set dicOriginTableSchema = GetOriginalDBSchemaByKishuName(KishuNickName.KishuName)
        '�܂��̓e�[�u����`�݂̂��ς܂���
        For Each varKeyLocal In dicOriginTableSchema
            '�e�[�u�������݂��Ȃ��ꍇ�̂ݍ쐬
            If Not IsTableExist(dicOriginTableSchema(varKeyLocal)("name"), strLocalDBFilePath) Then
                dbLocal.SQL = dicOriginTableSchema(varKeyLocal)("sql")
                dbLocal.DBPath = strLocalDBFilePath
                dbLocal.DoSQL_No_Transaction
            End If
        Next
        '���ɁA���g�̃R�s�[�ɐi�ށi�����͏d���͂��j
        If chkBoxLastArea.Value Then
            '�擾�s���w�肪����ꍇ�i���������f�t�H���g����ɂ������j
            isCollect = CopyDBTableRemote_To_Local(Table_JobDataPri & KishuNickName.KishuName, strLocalDBFilePath, longargLastNumberArea:=CLng(txtBoxAfterArea.Text))
        Else
            isCollect = CopyDBTableRemote_To_Local(Table_JobDataPri & KishuNickName.KishuName, strLocalDBFilePath)
        End If
    #End If
    vararrJobData = ReturnJobNumber_For_KanbanDivide(Table_JobDataPri & KishuNickName.KishuName, KishuNickName)
    cmbBoxJobNumber.ColumnCount = UBound(vararrJobData, 2) - LBound(vararrJobData, 2) + 1
    strListColumnWidth = GetColumnWidthString(vararrJobData, boolMaxLengthFind:=True)
    cmbBoxJobNumber.List = vararrJobData
    lblNowKishuNickName.Caption = cmbBoxKishuNickName.Text
End Sub
Private Sub cmbBoxJobNumber_Change()
    Dim vararrDivideChr As Variant
    Dim KishuLocal As typKishuInfo
    Dim strTableName As String
    Dim strJobNumber As String
    Dim strInputDate As String
    Dim intCounterRow As Integer
    Dim strDivideListColumnWidts As String
    On Error GoTo ErrorCatch
    'Job�ԍ��܂Ō��܂�����A�w��̃W���u�ԍ���2�L�邩�ǂ����m�F����
    'Job�ԍ��{�b�N�X�ɂ� Job�ԍ� InputDate �c�薇���̏��œ����Ă�͂�
    '�����X�g����I��ł��炦�΂������E�E�E
    '1���Job�ԍ��A2���InputInitialDate�ɂȂ��Ă�͂�
    '�ߋ��̕��������擾����
    '�ŏ��Ƀ^�C�g���s����ŋA���Ă���
    '���������� �V�[�g���i�_�~�[�j ���� ���b�N���i�_�~�[�j �X�^�[�g���� �G���h���� �̏��ɋA���Ă���
    If cmbBoxJobNumber.Text = "" Then
        Exit Sub
    End If
    '�ŏ��ɉߋ����ʃ��X�g�{�b�N�X�̂��|��
    listBoxExistingChr.Clear
    KishuLocal = GetKishuinfoByNickName(lblNowKishuNickName.Caption)
    strTableName = Table_JobDataPri & KishuLocal.KishuName
    strJobNumber = cmbBoxJobNumber.List(cmbBoxJobNumber.ListIndex, 0)
    strInputDate = cmbBoxJobNumber.List(cmbBoxJobNumber.ListIndex, 1)
    '�E���̎c��V�[�g��/�������x�����X�V���Ă��
    lblRemainMaisuu.Caption = CStr(cmbBoxJobNumber.List(cmbBoxJobNumber.ListIndex, 2))
    lblRemainSheetQty.Caption = CStr(CLng(lblRemainMaisuu.Caption) / KishuLocal.MaiPerSheet)
    '�����܂ŗ����番��������ȍ~��Enable�ɂ��Ă��
    cmbBoxKanbanChr.Enabled = True
    txtBoxNewMaisuu.Enabled = True
    txtboxNewSheetQty.Enabled = True
    '���̊Ŕ�����̌����Z�b�g���Ă��iJob�����j
    cmbBoxKanbanChr.Value = GetNextKanbanChrByTableName(strTableName)
    '���̊J�n�������Z�b�g���Ă��
    lblNextRireki.Caption = GetNextKanbanRirekiByJobNumber(strTableName, strJobNumber, strInputDate)
    '�t�H�[�J�X�ړ�
    txtboxNewSheetQty.SetFocus
    vararrDivideChr = ReturnDivideChrByJobNumber(strTableName, strJobNumber, strInputDate)
    '�Ȃ��������ς��̂ŁA�蓮�ݒ�
    listBoxExistingChr.Width = 524.24
    Sleep 2
    listBoxExistingChr.Width = 524.25
    '�����ŉߋ��̗����Ȃ��̏ꍇ�́A�Ȍ�̏����𒆎~���ĉߋ����ʃ��X�g�{�b�N�X�ɂ����\�����Ă��
    '�f�[�^�Ȃ��̏ꍇ�́A�V�i��Job�̉\��������̂Œ���
'    If vararrDivideChr(0, 0) = "No Title" Then
    If UBound(vararrDivideChr, 2) < 2 Then
        '�����_�Ńf�[�^�Ȃ�
        listBoxExistingChr.ColumnWidths = ""
        listBoxExistingChr.ColumnCount = 1
        listBoxExistingChr.AddItem "JOB���������Ȃ�"
        Exit Sub
    End If
    '�V�[�g���ƃ��b�N���̓_�~�[�̐��������Ă�̂ŁA����Ă��Ȃ��ƃ_��
    For intCounterRow = LBound(vararrDivideChr, 1) + 1 To UBound(vararrDivideChr, 1)
        vararrDivideChr(intCounterRow, 1) = CLng(vararrDivideChr(intCounterRow, 2) / KishuLocal.MaiPerSheet)
        vararrDivideChr(intCounterRow, 3) = CLng(Application.WorksheetFunction.RoundUp( _
                                            CSng(vararrDivideChr(intCounterRow, 1)) / CSng(KishuLocal.SheetPerRack), 0))
    Next intCounterRow
    strDivideListColumnWidts = GetColumnWidthString(vararrDivideChr, boolMaxLengthFind:=True)
    listBoxExistingChr.ColumnCount = UBound(vararrDivideChr, 2) - LBound(vararrDivideChr, 2) + 1
    listBoxExistingChr.ColumnWidths = strDivideListColumnWidts
    listBoxExistingChr.List = vararrDivideChr
    Exit Sub
ErrorCatch:
    Debug.Print "cmbBoxJobNumber_Change code: " & Err.Number & " Description: " & Err.Description
End Sub
Private Sub Clear_Exclude_KishuNickName(Optional ByVal boolExcludeJobNumber As Boolean)
    '�@��ʏ̖����I�΂ꂽ�ۂɁA���̂��̂�����������
    If Not boolExcludeJobNumber Then
        cmbBoxJobNumber.Clear
    End If
    listBoxExistingChr.Clear
    listBoxExistingChr.ColumnCount = 1
'    lblNowKishuNickName.Caption = ""
    lblRemainMaisuu.Caption = ""
    lblRemainSheetQty.Caption = ""
    txtBoxNewMaisuu.Text = ""
    txtboxNewSheetQty.Text = ""
    listBoxExistingChr.Width = 524.5
End Sub
Private Sub txtBoxNewMaisuu_Change()
    Dim KishuLocal As typKishuInfo
    On Error GoTo ErrorCatch
    '�����̃g�R����Ȃ������疳������
    If Not ActiveControl.Name = txtBoxNewMaisuu.Name Then
        Exit Sub
    End If
    '�󂾂�����A��������Ȃ������肵���牽�����Ȃ�
    If txtBoxNewMaisuu.Text = "" Then
        txtboxNewSheetQty.Text = ""
        Exit Sub
    End If
    If Not IsNumeric(CLng(txtBoxNewMaisuu.Text)) Then
        Exit Sub
    End If
    If lblNowKishuNickName.Caption = "" Then
        Exit Sub
    End If
    KishuLocal = GetKishuinfoByNickName(lblNowKishuNickName.Caption)
    txtboxNewSheetQty.Text = CLng(txtBoxNewMaisuu.Text) / CLng(KishuLocal.MaiPerSheet)
    Exit Sub
ErrorCatch:
    Debug.Print "txtBoxNewMaisuu_Change code: " & Err.Number & " Description: " & Err.Description
    Exit Sub
End Sub
Private Sub txtBoxNewMaisuu_Exit(ByVal Cancel As MSForms.ReturnBoolean)
    '��������͂�����A�V�[�g���𐮐��ɐ؂�グ����
    Dim KishuLocal As typKishuInfo
    KishuLocal = GetKishuinfoByNickName(lblNowKishuNickName.Caption)
    txtboxNewSheetQty.Text = Application.WorksheetFunction.RoundUp(txtboxNewSheetQty.Text, 0)
    txtBoxNewMaisuu.Text = CLng(txtboxNewSheetQty.Text) * CLng(KishuLocal.MaiPerSheet)
    If CLng(txtBoxNewMaisuu.Text) > CLng(lblRemainMaisuu.Caption) Then
        '�v�Z���Ă݂����ʎc�薇���𒴂���悤�Ȃ�A�c�薇�����V�[�g�Ŋ����āA�����؂�̂Ăɂ����̂��V�[�g���ɓ���Ă��
        txtboxNewSheetQty.Text = Int(CLng(lblRemainMaisuu.Caption) / CLng(KishuLocal.MaiPerSheet))
        txtBoxNewMaisuu.Text = CLng(txtboxNewSheetQty.Text) * CLng(KishuLocal.MaiPerSheet)
    End If
End Sub
Private Sub txtboxNewSheetQty_Change()
    Dim KishuLocal As typKishuInfo
    On Error GoTo ErrorCatch
    '�����̂Ƃ�����Ȃ��ꏊ���A�N�e�B�u�ɂȂ��Ă��牽�����Ȃ�
    If Not ActiveControl.Name = txtboxNewSheetQty.Name Then
        Exit Sub
    End If
    '�󂾂�����A��������Ȃ������肵���牽�����Ȃ�
    If txtboxNewSheetQty.Text = "" Then
        txtBoxNewMaisuu.Text = ""
        Exit Sub
    End If
    If Not IsNumeric(CLng(txtboxNewSheetQty.Text)) Then
        Exit Sub
    End If
    If lblNowKishuNickName.Caption = "" Then
        Exit Sub
    End If
    KishuLocal = GetKishuinfoByNickName(lblNowKishuNickName.Caption)
    txtBoxNewMaisuu.Text = CLng(txtboxNewSheetQty.Text) * CLng(KishuLocal.MaiPerSheet)
    Exit Sub
ErrorCatch:
    Debug.Print "txtBoxNewSheet_Change code: " & Err.Number & " Description: " & Err.Description
    Exit Sub
End Sub
Private Sub txtboxNewSheetQty_Exit(ByVal Cancel As MSForms.ReturnBoolean)
    '�ő吔�𒴂��ĂȂ����`�F�b�N����
    Dim KishuLocal As typKishuInfo
    On Error GoTo ErrorCatch
    KishuLocal = GetKishuinfoByNickName(lblNowKishuNickName.Caption)
    If CLng(txtboxNewSheetQty.Text) > CLng(lblRemainSheetQty.Caption) Then
        txtboxNewSheetQty.Text = lblRemainSheetQty.Caption
        txtBoxNewMaisuu.Text = CLng(txtboxNewSheetQty.Text) * CLng(KishuLocal.MaiPerSheet)
    End If
    Exit Sub
ErrorCatch:
    Debug.Print "txtboxNewSheetQty Exit code: "; Err.Number & " Description: " & Err.Description
    Exit Sub
End Sub
Private Sub UserForm_Initialize()
    '���[�J���R�s�[���[�h�̎��́A�e���|�����f�B���N�g�����쐬����
    #If READLOCAL = 1 Then
        Dim fsoLocal As FileSystemObject
        Set fsoLocal = New FileSystemObject
        strLocalPath = ThisWorkbook.Path & "\" & LocalTempDBDir
        strLocalDBFilePath = strLocalPath & "\" & LocalDBName
        If Not fsoLocal.FolderExists(strLocalPath) Then
            '�f�B���N�g��������΍쐬����
            MkDir strLocalPath
        End If
        Set fsoLocal = Nothing
    #End If
    '�Ŕ����t�H�[��������
    Dim dbKanban As clsSQLiteHandle
    Dim varArrKishuNickName As Variant
    Dim intCounterKishu As Integer
    Dim byteChrCodeCounter As Byte
    '�@��i�ʏ̖��j�ꗗ���擾����
    Set dbKanban = New clsSQLiteHandle
    dbKanban.SQL = "SELECT " & Kishu_KishuNickname & " FROM " & Table_Kishu
    dbKanban.DoSQL_No_Transaction
    varArrKishuNickName = dbKanban.RS_Array(boolPlusTytle:=False)
    Set dbKanban = Nothing
    '�@�햼�R���{�{�b�N�X�ɒǉ����Ă��
    cmbBoxKishuNickName.List = varArrKishuNickName
    '�Ŕ���������{�b�N�X��A-Z��ǉ�
    For byteChrCodeCounter = MIN_Kanban_ChrCode To MAX_Kanban_ChrCode
        cmbBoxKanbanChr.AddItem Chr(byteChrCodeCounter)
    Next byteChrCodeCounter
    btnQRRead.SetFocus
End Sub
Private Sub UserForm_Terminate()
    #If READLOCAL = 1 Then
        'todo
        '���[�J���R�s�[�g�p���͈ꎞ�t�@�C�����E�E�E�폜����H���Ȃ��H
        '�ڑ������ςȂ��ɂȂ��Ă�LocalDB���N���[�Y
        Set dbLocal = Nothing
    #End If
End Sub
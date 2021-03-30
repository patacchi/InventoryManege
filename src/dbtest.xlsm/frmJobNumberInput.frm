VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmJobNumberInput 
   Caption         =   "�W���u�ԍ��E����o�^���"
   ClientHeight    =   5115
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   7395
   OleObjectBlob   =   "frmJobNumberInput.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmJobNumberInput"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'Option Base 1
Private KishuInfoInfrmJobInput As typKishuInfo
Private Sub frmJobNumberInput_Initialize()
    '�t�H�[���������i�S�����������j
    txtboxJobNumber.Text = ""
    txtboxMaisuu.Text = ""
    txtboxStartRireki = ""
    labelZuban.Caption = ""
    strRegistRireki = ""
    btnQRFormShow.SetFocus
End Sub
Private Sub btnInputRirekiNumber_Click()
    '�W���u�ԍ��E�����̓o�^����
    'Dim KishuInfoInfrmJobInput As typKishuInfo
    Dim isCollect As Boolean
    Dim sqlbJobInput As clsSQLStringBuilder
    Dim dblTimer As Double
    Dim longStartRirekiNumber As Long
    Dim longEndRirekiNumber As Long
    Dim longDuplicateNumber As Long                 '�d�������̐�
    Dim longMsgBoxRetCode As Long
    On Error GoTo ErrorCatch
    If txtboxJobNumber.Text = Empty Or _
        txtboxMaisuu.Text = Empty Or _
        txtboxStartRireki.Text = Empty Then
        MsgBox ("�󔒂̍��ڂ�����܂��B�m�F���Ă�������")
        Exit Sub
    End If
    If CLng(txtboxMaisuu.Text) < 1 Then
        MsgBox ("�����ɂ�1�ȏ�̐�������͂��ĉ�����")
        txtboxMaisuu.SetFocus
        Exit Sub
    End If
    '���Ԍv���J�n
    If Not labelZuban.Caption = "" Then
'        QRField.Zuban = labelZuban.Caption
    End If
    dblTimer = timer()
    '�X�^�[�g��������KishuInfo�����������Ă���
    KishuInfoInfrmJobInput = getKishuInfoByRireki(txtboxStartRireki.Text)
    If KishuInfoInfrmJobInput.KishuHeader = "" Then
        'KishuInfo�����ĂȂ��Ƃ������Ƃ͎��s���Ă���ۂ��̂ŁA�����ŏ������~
        Exit Sub
    End If
    Set sqlbJobInput = New clsSQLStringBuilder
    With sqlbJobInput
        .JobNumber = CStr(txtboxJobNumber.Text)
        .FieldArray = arrFieldList_JobData
        .startRireki = CStr(txtboxStartRireki.Text)
        .Maisu = CLng(txtboxMaisuu.Text)
        .RenbanKeta = KishuInfoInfrmJobInput.RenbanKetasuu
        .TableName = Table_JobDataPri & KishuInfoInfrmJobInput.KishuName
    End With
    Set sqlbJobInput.FieldType = GetFieldTypeNameByTableName(sqlbJobInput.TableName)
    If Not Len(txtboxStartRireki.Text) = KishuInfoInfrmJobInput.TotalRirekiketa Then
        MsgBox "�����̌������o�^����Ă���@�햼�F" & KishuInfoInfrmJobInput.KishuName & " �� " & _
                KishuInfoInfrmJobInput.TotalRirekiketa & " ���ƈႢ�܂��B�����𒆎~���܂��B"
                txtboxStartRireki.SetFocus
                GoTo CloseAndExit
    End If
    '�X�^�[�g�����i�̘A�ԁj�ƃG���h�������Z�o���A�d�����Ȃ����`�F�b�N
    longStartRirekiNumber = CLng(Right(sqlbJobInput.startRireki, KishuInfoInfrmJobInput.RenbanKetasuu))
    longEndRirekiNumber = longStartRirekiNumber + sqlbJobInput.Maisu - 1
    longDuplicateNumber = GetRecordCountSimple(sqlbJobInput.TableName, Job_RirekiNumber, _
                            "BETWEEN " & longStartRirekiNumber & " AND " & longEndRirekiNumber & ";")
    If longDuplicateNumber >= 1 Then
        '�d�����������炵��
        longMsgBoxRetCode = MsgBox(prompt:="�o�^���悤�Ƃ��Ă���f�[�^�� " & longDuplicateNumber & " ���̏d�����������悤�ł��B���͂��Ȃ����܂����H" _
                            , Buttons:=vbYesNo)
        Select Case longMsgBoxRetCode
        Case vbYes
            '���͂��Ȃ����A�܂艽�����Ȃ��ŒE�o
            txtboxStartRireki.SetFocus
            GoTo CloseAndExit
        Case vbNo
            '���̂܂ܑ��s
        End Select
    End If
    isCollect = sqlbJobInput.CreateInsertSQL(boolCheckLastRireki:=True)
    If Not isCollect Then
        MsgBox "�W���u�o�^���ɉ����������悤�ł�"
        GoTo CloseAndExit
        Exit Sub
    End If
    MsgBox "�W���u�o�^�����B " & sqlbJobInput.Maisu & " ���̃f�[�^�� " & timer() - dblTimer & " �b�ŏ������܂���"
    Debug.Print "�W���u�o�^�����B " & sqlbJobInput.Maisu & " ���̃f�[�^�� " & timer() - dblTimer & " �b�ŏ������܂���"
    frmJobNumberInput_Initialize
    GoTo CloseAndExit
    Exit Sub
CloseAndExit:
    Set sqlbJobInput = Nothing
    Exit Sub
ErrorCatch:
    Debug.Print "ImputRireki Erro code: " & Err.Number & "Description: " & Err.Description
    Set sqlbJobInput = Nothing
    Exit Sub
End Sub
Private Sub btnQRFormShow_Click()
    Dim KishuLocal As typKishuInfo
    Dim varReturn As Variant
    Dim strNewRireki As String
    'QR�R�[�h�ǂݎ��t�H�[���\��
'    frmJobNumberInput.Hide
    frmQRAnalyze.Show
    If Not QRField.JobNumber = "" Then
        txtboxJobNumber.Text = QRField.JobNumber
    End If
    If Not QRField.Maisuu = 0 Then
        txtboxMaisuu.Text = QRField.Maisuu
    End If
    If Not QRField.Zuban = "" Then
        labelZuban.Caption = QRField.Zuban
        txtboxStartRireki.SetFocus
    End If
    If Not labelZuban.Caption = "" Then
        '�}�Ԃɉ��������Ă���KishuInfo���擾���Ă݂āA���̏������Ƃɋ@��w�b�_�𗚗��{�b�N�X�ɓ��͂��Ă��
        KishuLocal = GetKishuinfoByKishuName(labelZuban.Caption)
        If KishuLocal.KishuHeader = "" Then
            Debug.Print "QR�R�[�h����KishuInfo�������������ǋ󂾂���"
            txtboxStartRireki.Text = ""
            Exit Sub
        End If
        '�ŐV�����̓`�F�b�N�{�b�N�X��True�̏ꍇ�͍ŐV��������͂��Ă��
        If chkboxInputNextNumber = True Then
            '�ŐV�������擾
            strNewRireki = GetNextRireki(Table_JobDataPri & KishuLocal.KishuName)
            If strNewRireki = "" Then
                Debug.Print "�ŐV�����擾�������A�󂾂���"
                '�󂾂�����w�b�_�͓���Ă�낤
                txtboxStartRireki.Text = KishuLocal.KishuHeader
                Exit Sub
            End If
            txtboxStartRireki.Text = strNewRireki
        Else
            '�`�F�b�N����ĂȂ��ꍇ�́A�w�b�_�݂̂���͂���
            txtboxStartRireki.Text = KishuLocal.KishuHeader
        End If
    End If
End Sub
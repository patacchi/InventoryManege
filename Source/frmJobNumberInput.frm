VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmJobNumberInput 
   Caption         =   "�W���u�ԍ��E����o�^���"
   ClientHeight    =   5280
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   7050
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

Private Sub frmJobNumberInput_Initialize()
    '�t�H�[���������i�S�����������j
    txtboxJobNumber.Text = ""
    txtboxMaisuu.Text = ""
    txtboxStartRireki = ""
    labelZuban.Caption = ""
    btnQRFormShow.SetFocus
End Sub


Private Sub btnInputRirekiNumber_Click()
    '�W���u�ԍ��E�����̓o�^����
    Dim KishuInfoLocal As typKishuInfo
    Dim isCollect As Boolean
    Dim sqlbJobInput As clsSQLStringBuilder
    On Error GoTo ErrorCatch

    If txtboxJobNumber.Text = Empty Or _
        txtboxMaisuu.Text = Empty Or _
        txtboxStartRireki.Text = Empty Then
        MsgBox ("�󔒂̍��ڂ�����܂��B�m�F���Ă�������")
        Exit Sub
    End If

    If CLng(txtboxMaisuu.Text) < 1 Then
        MsgBox ("�����ɂ�1�ȏ�̐�������͂��ĉ�����")
        Exit Sub
    End If
    
    '�X�^�[�g��������KishuInfo�����������Ă���
    KishuInfoLocal = getKishuInfoByRireki(txtboxStartRireki.Text)
    Set sqlbJobInput = New clsSQLStringBuilder
    With sqlbJobInput
        .JobNumber = CStr(txtboxJobNumber.Text)
        .FieldArray = arrFieldList_JobData
        .StartRireki = CStr(txtboxStartRireki.Text)
        .Maisu = CLng(txtboxMaisuu.Text)
        .RenbanKeta = KishuInfoLocal.RenbanKetasuu
        .TableName = Table_JobDataPri & KishuInfoLocal.KishuName
    End With
    Set sqlbJobInput.FieldType = GetFieldTypeNameByTableName(sqlbJobInput.TableName)
    If Not Len(txtboxStartRireki.Text) = KishuInfoLocal.TotalRirekiketa Then
        MsgBox "�����̌������o�^����Ă���@�햼�F" & KishuInfoLocal.KishuName & " �� " & _
                KishuInfoLocal.TotalRirekiketa & " ���ƈႢ�܂��B�����𒆎~���܂��B"
                GoTo CloseAndExit
    End If
    
    isCollect = sqlbJobInput.CreateInsertSQL(boolCheckLastRireki:=True)
    If Not isCollect Then
        MsgBox "�W���u�o�^���ɉ����������悤�ł�"
        GoTo CloseAndExit
        Exit Sub
    End If
    
    MsgBox "�W���u�o�^����"
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
    'QR�R�[�h�ǂݎ��t�H�[���\��
'    frmJobNumberInput.Hide
    frmQRAnalyze.Show
End Sub

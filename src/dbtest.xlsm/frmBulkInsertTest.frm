VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmBulkInsertTest 
   Caption         =   "�o���N�C���T�[�g�e�X�g"
   ClientHeight    =   3930
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   9600.001
   OleObjectBlob   =   "frmBulkInsertTest.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmBulkInsertTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub UserForm_Initialize()
    '�e�X�g�p�Ƀf�[�^����������Ă��
    Dim KishuInfo As typKishuInfo
    txtboxStartRireki.Text = "Test0015T00000000001"
    txtboxJobNumber.Text = "TT00121"
    txtboxMaisuu.Text = 10000
    txtBoxFieldList.Text = Job_Number & "," & Job_RirekiHeader & "," & Job_RirekiNumber & "," & Job_Rireki
    KishuInfo = getKishuInfoByRireki(txtboxStartRireki.Text)
    If chkBoxInputNextRireki Then
        '�ŐV������͂Ƀ`�F�b�N�������Ă��ꍇ
        '������Job�ԍ����������͂���
        txtboxStartRireki.Text = GetNextRireki(Table_JobDataPri & KishuInfo.KishuName)
        txtboxJobNumber.Text = GetNextJobNumber_ForBulk(Table_JobDataPri & KishuInfo.KishuName)
    End If
    txtboxTableName.Text = Table_JobDataPri & KishuInfo.KishuName
End Sub
Private Sub btnGoInsert_Click()
    'Insert�e�X�g
    Dim isCollect  As Boolean
    Dim strLastRireki As String
    Dim vararrField As Variant
    Dim dbSQLite3 As clsSQLiteHandle
    Set dbSQLite3 = New clsSQLiteHandle
    Dim KishuInfo As typKishuInfo
    Dim sqlbBulkSQL As clsSQLStringBuilder
    On Error GoTo ErrorCatch
    Set sqlbBulkSQL = New clsSQLStringBuilder
    KishuInfo = getKishuInfoByRireki(txtboxStartRireki.Text)
    '�E���Ă����@��������ɂ��낢�낲�ɂ傲�ɂ�
    txtboxTableName.Text = Table_JobDataPri & KishuInfo.KishuName
    With sqlbBulkSQL
        .startRireki = txtboxStartRireki.Text
        .JobNumber = txtboxJobNumber.Text
        .Maisu = CLng(txtboxMaisuu.Text)
        .TableName = txtboxTableName.Text
        '.FieldArray = Split(txtBoxFieldList.Text, ",")
        .FieldArray = arrFieldList_JobData
        .RenbanKeta = KishuInfo.RenbanKetasuu
    End With
    Set sqlbBulkSQL.FieldType = GetFieldTypeNameByTableName(txtboxTableName.Text)
    Set dbSQLite3 = Nothing
    isCollect = sqlbBulkSQL.CreateInsertSQL()
    If Not isCollect Then
        MsgBox "�o���N�C���T�[�g�e�X�g�Ō�ɉ������������ۂ��H"
        GoTo ErrorCatch
    End If
    UserForm_Initialize
    Exit Sub
ErrorCatch:
    Debug.Print "btnGOInsert_Click code: " & Err.Number & "Description: " & Err.Description
End Sub
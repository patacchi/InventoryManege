VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmInputStocINDate 
   Caption         =   "���ɓ����̓t�H�[��"
   ClientHeight    =   2700
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   5910
   OleObjectBlob   =   "frmInputStocINDate.frx":0000
   ShowModal       =   0   'False
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmInputStocINDate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'''-------------------------------------------------------------------------------------------
'''�C�x���g
'''UserFormInitialize
Private Sub UserForm_Initialize()
    ConstRuctor
End Sub
'''UserFormTerminate
'''Modaless�ɂ��Ă�̂�Terminate�Ŋm����Unload���鎖
Private Sub UserForm_Terminate()
    DestRuctor
End Sub
'''���ɓ��e�L�X�g�{�b�N�XMouseUp�C�x���g�A���̃e�L�X�g�{�b�N�X�͊�{�I�ɂ�DatePicker����I��ł��炤�̂Ń��[�U�[�͓��͂��Ȃ�
Private Sub txtBoxStockINDate_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    Dim dateStockIN As Date
    dateStockIN = PublicModule.GetDateUseDatePicker
    If CDbl(dateStockIN) = 0 Then
        '�I�����s���Ă��牽�����Ȃ�
        Exit Sub
    End If
    txtBoxStockINDate.Text = dateStockIN
    Exit Sub
End Sub
'''-------------------------------------------------------------------------------------------
'''���\�b�h
'''�R���X�g���N�^
Private Sub ConstRuctor()
    '�Ƃ肠�������ɓ���{����
    txtBoxStockINDate.Text = Format(Year(Now()), "0000") & "/" & Format(Month(Now()), "00") & "/" & Format(Day(Now()), "00")
End Sub
'''�f�X�g���N�^
Private Sub DestRuctor()
    Unload Me
End Sub
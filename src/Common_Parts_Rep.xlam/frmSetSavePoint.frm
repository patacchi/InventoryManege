VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmSetSavePoint 
   Caption         =   "������X�g���ʖ����͉��"
   ClientHeight    =   2295
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   4395
   OleObjectBlob   =   "frmSetSavePoint.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmSetSavePoint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'''binLabel��SavePoint����͂���t�H�[��
Option Explicit
Private Const SAVEPOINT_NAME_1 As String = "BIN�J�[�h���x���o�͗p"
Private Const SAVEPOINT_NAME_2 As String = "���ɗp"
Private Const SAVEPOINT_NAME_3 As String = "�o�ɗp"
Private Const SAVEPOINT_NAME_4 As String = "���i�[�o�͗p"
Private Const SAVEPOINT_NAME_5 As String = "�X�y�b�N�\ �� (�ڍ׌��i�[)"
Private Sub UserForm_Initialize()
    ConstRuctor
End Sub
'click
'���͊���
Private Sub btnCompInput_Click()
    'FormCommon�̃O���[�o���ϐ��Ɍ��ʂ��i�[���A���g��Unload
    FormCommon.strSavePointName = cmbBox_SavePointName.Text
    Unload Me
End Sub
'''�t�H�[���R���X�g���N�^
Private Sub ConstRuctor()
    '�O���[�o���ϐ��̌��ʊi�[�p�ϐ����󕶎��Ƀ��Z�b�g����
    FormCommon.strSavePointName = ""
    '�R���{�{�b�N�X�ɒ�^����ݒ�
    cmbBox_SavePointName.AddItem SAVEPOINT_NAME_1
    cmbBox_SavePointName.AddItem SAVEPOINT_NAME_2
    cmbBox_SavePointName.AddItem SAVEPOINT_NAME_3
    cmbBox_SavePointName.AddItem SAVEPOINT_NAME_4
    cmbBox_SavePointName.AddItem SAVEPOINT_NAME_5
    '�R���{�{�b�N�X�����l�͋󕶎�
    cmbBox_SavePointName.Text = ""
End Sub
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


Private Sub btnInputRirekiNumber_Click()
    '�W���u�ԍ��E�����̓o�^����
    '�ȉ���DB������������Ă���
    Dim dicKishuInfo As New Scripting.Dictionary
    Dim byteRenbannKeta As Byte         '�A�ԕ����̌����iRight�֐��̈����j
    Dim byteRirekiKetaCount As Byte     '�����̌����g�[�^��
    
    Dim strHeader As String             '�w�b�_
    Dim longRenbann As Long             '����A�ԕ���
    Dim strRireki As String             '�w�b�_+�A��
    Dim longInputRow As Long            '�V�[�g���͎��̓��͍s��
    Dim longLocalCounter As Long        '���[�v�����p�J�E���^�[
    Dim nameRirekiKetasuu As Name       '���������̖��O��`
    Dim arryKishuHeader() As Variant    '�W���u���_�@��e�[�u������A�@�햼�ꗗ���󂯎��
    
    If txtboxJobNumber.Text = Empty Or _
        txtboxMaisuu.Text = Empty Or _
        txtboxStartRireki.Text = Empty Then
        MsgBox ("�󔒂̍��ڂ�����܂��B�m�F���Ă�������")
        Exit Sub
    End If
    
    If Len(txtboxStartRireki.Text) > constMaxRirekiKetasuu Then
        MsgBox ("�����̌�����" & constMaxRirekiKetasuu & "���𒴂��Ă��܂��B�����𒆎~���܂��B")
        Exit Sub
    End If

    If txtboxMaisuu.Text < 1 Then
        MsgBox ("�����ɂ�1�ȏ�̐�������͂��ĉ�����")
        Exit Sub
    End If

    
    '�w�b�_�[�e�[�u����藚����͕�������@�햼�i�����\���j�����������Ă���
    '�擪�̕������v�ł������ȁH
'    '�J�����g�f�B���N�g���ύX�iDB�f�B���N�g���ցj
'    If Not ChcurrentforDB() Then
'        MsgBox ("DB�f�B���N�g���F�����s�B�����𒆒f���܂��B")
'        Exit Sub
'    End If
'
'    'DB�t�@�C���̑��ݗL���̊m�F�i�Ȃ���΍��j
'    If Not IsDBFileExist() Then
'        MsgBox ("���s�E�E�E�E")
'    End If
    '�@�햼�ꗗ���󂯎�鏈��
    
    '�Ԃ��Ă��郊�X�g�́A�@��w�b�_�A�@�햼�A�g�[�^�������A�A�Ԍ����̏���
    'arryKishuHeader = KishuList()
    If Not arryKishuHeader Then
        '�@���񌩂���Ȃ������̂ŁA�@��o�^����
        
    End If
    
    '�t�H�[���ɓ��͂��ꂽ�����̐擪�Ɨ����w�b�_�i�@�픻�ʗp�j����v���邩���ׂ�
    '������Ȃ��ꍇ�͋@��o�^��ʂ�(todo)
    For longLocalCounter = 0 To UBound(arryKishuHeader)
        
    Next longLocalCounter
    
End Sub


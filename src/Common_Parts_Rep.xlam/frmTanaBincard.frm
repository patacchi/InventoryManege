VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmTanaBincard 
   Caption         =   "�I��BIN�J�[�h�`�F�b�N�p�t�H�[��"
   ClientHeight    =   7155
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8160
   OleObjectBlob   =   "frmTanaBincard.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmTanaBincard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'�t�H�[�������L�ϐ�
Private clsADOfrmBIN As clsADOHandle
Private clsINVDBfrmBIN As clsINVDB
Private clsEnumfrmBIN As clsEnum
Private clsSQLBc As clsSQLStringBuilder
Private objExcelFrmBIN As Excel.Application
Private dicoObjNameToFieldName As Dictionary
Private clsIncrementalfrmBIN As clsIncrementalSerch
Private Sub btnRegistTanaCSVtoDB_Click()
    '�ŏ���CSV�t�@�C����I�����Ă��炤
    Dim strCSVFullPath As String
    '�J�����g�f�B���N�g�����_�E�����[�h�f�B���N�g���ɕύX����
    Call ChCurrentDirW(GetDownloadPath)
    MsgBox "�f�C���[�I���Ń_�E�����[�h����CSV�t�@�C����I�����ĉ�����"
    strCSVFullPath = CStr(Application.GetOpenFilename("CSV�t�@�C��,*.csv", 1, "�f�C���[�I���Ń_�E�����[�h����CSV�t�@�C����I�����ĉ�����"))
    If strCSVFullPath = "False" Then
        '�L�����Z���{�^���������ꂽ
        MsgBox "�L�����Z�����܂���"
        Exit Sub
    End If
    Dim longAffected As Long
#If DontRemoveZaikoSH Then
    'DL�����t�@�C�����c���Ă����i�e�X�g�������j
    '�擾�����t�@�C�����������ɂ���DB�ɓo�^�i�g���q�ɂ���ď��������򂳂��͂��j
    longAffected = clsINVDBfrmBIN.UpsertINVPartsMasterfromZaikoSH(strCSVFullPath, objExcelFrmBIN, clsINVDBfrmBIN, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc, True)
#Else
    longAffected = clsINVDBfrmBIN.UpsertINVPartsMasterfromZaikoSH(strCSVFullPath, objExcelFrmBIN, clsINVDBfrmBIN, clsADOfrmBIN, clsEnumfrmBIN, clsSQLBc, False)
#End If
End Sub
'�t�H�[������������
Private Sub UserForm_Initialize()
    '�����o�C���X�^���X�ϐ��Z�b�g
    If clsADOfrmBIN Is Nothing Then
        Set clsADOfrmBIN = CreateclsADOHandleInstance
    End If
    If clsINVDBfrmBIN Is Nothing Then
        Set clsINVDBfrmBIN = CreateclsINVDB
    End If
    If clsEnumfrmBIN Is Nothing Then
        Set clsEnumfrmBIN = CreateclsEnum
    End If
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
    End If
    If objExcelFrmBIN Is Nothing Then
        Set objExcelFrmBIN = New Excel.Application
    End If
    If dicoObjNameToFieldName Is Nothing Then
        Set dicoObjNameToFieldName = New Dictionary
    End If
    If clsIncrementalfrmBIN Is Nothing Then
        Set clsIncrementalfrmBIN = CreateclsIncrementalSerch
    End If
End Sub
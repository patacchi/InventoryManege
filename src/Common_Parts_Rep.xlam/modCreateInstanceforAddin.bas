Attribute VB_Name = "modCreateInstanceforAddin"
Option Explicit
'''�A�h�C�����J�����ɃN���X�̃C���X�^���X���쐬���邱�Ƃ�ړI�Ƃ������W���[��
'''���J����ۂ�PublicNOTCreate�ɂȂ邽��
'�g�p�� Dim clsAdo as clsAdoHandle
'       set clsAdo = CreateclsADOHandleInstance()
'clsAdoHandle
Public Function CreateclsADOHandleInstance() As clsADOHandle
    Dim T As clsADOHandle
    Set T = New clsADOHandle
    Set CreateclsADOHandleInstance = T
    Set T = Nothing
    Exit Function
End Function
'clsSQLStringBuilder
Public Function CreateclsSQLStringBuilder() As clsSQLStringBuilder
    Dim T As clsSQLStringBuilder
    Set T = New clsSQLStringBuilder
    Set CreateclsSQLStringBuilder = T
    Set T = Nothing
    Exit Function
End Function
'clsEnum
Public Function CreateclsEnum() As clsEnum
    Dim T As clsEnum
    Set T = New clsEnum
    Set CreateclsEnum = T
    Set T = Nothing
    Exit Function
End Function
'clsINVFB
Public Function CreateclsINVDB() As clsINVDB
    Dim T As clsINVDB
    Set T = New clsINVDB
    Set CreateclsINVDB = T
    Set T = Nothing
    Exit Function
End Function
'clsIncrementalSerch
Public Function CreateclsIncrementalSerch() As clsIncrementalSerch
    Dim T As clsIncrementalSerch
    Set T = New clsIncrementalSerch
    Set CreateclsIncrementalSerch = T
    Set T = Nothing
    Exit Function
End Function
'clsGetIE
Public Function CreateclsGetIE() As clsGetIE
    Dim T As clsGetIE
    Set T = New clsGetIE
    Set CreateclsGetIE = T
    Set T = Nothing
    Exit Function
End Function
'''SQL�e�X�g�t�H�[����\������
Public Sub ShowfrmSQLTest()
    frmSQLTest.Show
    Exit Sub
End Sub
'''CATDB�̃t�B�[���h�`�F�b�N�t�H�[����\������
Public Sub ShowfrmFieldChange()
    frmFieldChange.Show
    Exit Sub
End Sub
'''INV_M_Parts�}�X�^�[�\���t�H�[����\������
Public Sub ShowfrmInvPartsMaster()
    frmINV_PartsMaster_List.Show
End Sub
'''frmTanaBincard�t�H�[����\������
Public Sub ShowfrmINVTanaBincard()
    frmTanaBincard.Show
End Sub
'''frmBinLabeoShow
Public Sub ShowfrmBinLabel()
    frmBinLabel.Show
End Sub
'''�I�ԐV�K�o�^�t�H�[���\��(���[�_��)
Public Sub ShowFrmRegistNewLocation()
    frmRegistNewLocation.Show vbModal
End Sub
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
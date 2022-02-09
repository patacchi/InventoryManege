VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmBinLabel 
   Caption         =   "BIN�J�[�h���x��������ڕҏW���"
   ClientHeight    =   5895
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   8610.001
   OleObjectBlob   =   "frmBinLabel.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmBinLabel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'�t�H�[�������L�ϐ�
Private clsADOfrmBIN As clsADOHandle
Private clsEnumfrmBIN As clsEnum
Private clsSQLBc As clsSQLStringBuilder
Private dicObjNameToFieldName As Dictionary
Private clsIncrementalfrmBIN As clsIncrementalSerch
'�����o�ϐ�
Private rsfrmBIN As ADODB.Recordset
Private confrmBIN As ADODB.Connection
Private StopEvents As Boolean
'------------------------------------------------------------------------------------------------------
'SQL
Private Const SQL_BIN_LABEL_DEFAULT_DATA As String = "SELECT TDBPrt.F_INV_Tehai_ID,TDBTana.F_INV_Tana_ID,TDBTana.F_INV_Tana_Local_Text as F_INV_Tana_Local_Text,TDBPrt.F_INV_Tehai_Code as F_INV_Tehai_Code,TDBPrt.F_INV_Label_Name_2 as F_INV_Label_Name_2 " & vbCrLf & _
"FROM T_INV_M_Parts AS TDBPrt " & vbCrLf & _
"    INNER JOIN T_INV_M_Tana as TDBTana " & vbCrLf & _
"    ON TDBPrt.F_INV_Tana_ID = TDBTana.F_INV_Tana_ID"
'------------------------------------------------------------------------------------------------------
'�C�x���g
'Form Initial
Private Sub UserForm_Initialize()
    '�t�H�[����������
    ConstRuctor
End Sub
'Form Terminate
Private Sub UserForm_Terminate()
    Destructor
End Sub
'Click
Private Sub btnMove_Click()
    If Not rsfrmBIN.BOF Then
        rsfrmBIN.MovePrevious
    End If
End Sub
Private Sub btnMoveNext_Click()
    If Not rsfrmBIN.EOF Then
        'EOF����Ȃ������玟�̃��R�[�h�ɐi��
        rsfrmBIN.MoveNext
    End If
End Sub
'------------------------------------------------------------------------------------------------------
'���\�b�h
'''�R���X�g���N�^
Private Sub ConstRuctor()
    '�C���X�^���X���L�ϐ��̏�����
    If clsADOfrmBIN Is Nothing Then
        Set clsADOfrmBIN = CreateclsADOHandleInstance
    End If
    If clsEnumfrmBIN Is Nothing Then
        Set clsEnumfrmBIN = CreateclsEnum
    End If
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
    End If
    If dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = New Dictionary
    End If
    If clsIncrementalfrmBIN Is Nothing Then
        Set clsIncrementalfrmBIN = CreateclsIncrementalSerch
    End If
    If rsfrmBIN Is Nothing Then
        Set rsfrmBIN = New ADODB.Recordset
    End If
    If confrmBIN Is Nothing Then
        Set confrmBIN = New ADODB.Connection
    End If
    '�Ƃ肠�����C�x���g�͒�~��Ԃɂ���
    StopEvents = True
    '����f�[�^�ݒ�
    SetDefaultValuetoRS
    'objToFieldName��ݒ�
    setObjToFieldNameDic
End Sub
'''�f�X�g���N�^
Private Sub Destructor()
    '�����o�ϐ��̉���A���ɐڑ����֘A���Ă�����̂͏d�_�I��
    If Not clsADOfrmBIN Is Nothing Then
        clsADOfrmBIN.CloseClassConnection
        Set clsADOfrmBIN = Nothing
    End If
    If Not rsfrmBIN Is Nothing Then
        rsfrmBIN.ActiveConnection.Close
'        rsfrmBIN.Close
        Set rsfrmBIN = Nothing
    End If
    If Not confrmBIN Is Nothing Then
        If confrmBIN.State And ObjectStateEnum.adStateOpen Then
            '�ڑ����Ă��������
            confrmBIN.Close
        End If
        Set confrmBIN = Nothing
    End If
End Sub
'''�����o�ϐ���RecordSet�ɏ����f�[�^��ݒ肷��
'''
Private Sub SetDefaultValuetoRS()
    '�ŏ���clsado��DBPath��DBFilname���f�t�H���g��
    clsADOfrmBIN.SetDBPathandFilenameDefault
    '�����ڑ�����Ă�����ؒf����
    If rsfrmBIN.State And ObjectStateEnum.adStateOpen Then
        rsfrmBIN.Close
    End If
    If confrmBIN.State And ObjectStateEnum.adStateOpen Then
        confrmBIN.Close
    End If
    'Connection�̐ݒ������
    confrmBIN.ConnectionString = clsADOfrmBIN.CreateConnectionString(clsADOfrmBIN.DBPath, clsADOfrmBIN.DBFileName)
    confrmBIN.CursorLocation = adUseClient
    confrmBIN.Mode = adModeRead Or adModeShareDenyNone
    '�ڑ��I�[�v��
    confrmBIN.Open
    'RS�̃v���p�e�B��ݒ肵�Ă���
    rsfrmBIN.LockType = adLockBatchOptimistic
    rsfrmBIN.CursorType = adOpenStatic
    'rs��Source��SQL�ݒ�(��Ńp�����[�^�Ή�����)
    rsfrmBIN.Source = SQL_BIN_LABEL_DEFAULT_DATA
    'rs��ActiveConnection��Connection�I�u�W�F�N�g�w��
    Set rsfrmBIN.ActiveConnection = confrmBIN
    'rs�I�[�v��
    rsfrmBIN.Open , , , , CommandTypeEnum.adCmdText
    '�ȉ��͐���ɓ���
    '�X�V�ɕK�v�ȃL�[��̏�񂪁`�E�E�E�������̃e�[�u���̎�L�[��SELECT�̃t�B�[���h�Ɋ܂߂�Ɖ���
    rsfrmBIN.Fields("F_INV_Label_Name_2").Value = "InputTest"
'    rsfrmBIN.Fields("F_INV_Tana_Local_Text").Value = "K23 A01"
'    rsfrmBIN.Update
'    rsfrmBIN.UpdateBatch
    DebugMsgWithTime "Default Data count: " & rsfrmBIN.RecordCount
End Sub
'dicobjToFieldName�̐ݒ�
Private Sub setObjToFieldNameDic()
    If dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = New Dictionary
    End If
    '�ŏ��ɑS����
    dicObjNameToFieldName.RemoveAll
    '���ڂ�ǉ����Ă���
    '����̓e�[�u�����Ƀt�B�[���h�����Ɨ����Ă���̂ŁA�e�[�u���v���t�B�b�N�X�͖�����RS�Ŋi�[���Ă���
    dicObjNameToFieldName.Add txtBox_F_INV_Tana_Local_Text.Name, clsEnumfrmBIN.INVMasterTana(F_INV_Tana_Local_Text_IMT)
    dicObjNameToFieldName.Add txtBox_F_INV_Tehai_Code.Name, clsEnumfrmBIN.INVMasterParts(F_Tehai_Code_IMPrt)
End Sub
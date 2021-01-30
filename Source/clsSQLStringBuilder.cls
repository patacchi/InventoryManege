VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsSQLStringBuilder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'SQL��������i��Ɍ����j�̂��߂̃N���X
'�J�n�����A�I��������ݒ肵�āA������A���͔z���Join�ōs������

Private strSQL As String                '�Ō�̌��ʂ�SQL��
Private arrstrField() As String         '�t�B�[���h�̕�����z��
Private intFieldCount As Integer        '�t�B�[���h�̐�
Private intBulkCount As Integer         '�o���N��
Private strStartRireki As String        '�X�^�[�g�̗���
Private strEndRireki As String          '�G���h�̗���
Private longStringLength As Long        '������̒���
Private strTableName As String          '�e�[�u����
Private intCurrentValueCount As Integer '���݂̏������f�[�^�̏ꏊ�i�o���N�̎��Ɏg���j


Private Sub Class_Initialize()
    '�N���X����������
    strSQL = Empty
    intFieldCount = 0
    intCurrentValueCount = 0
    intBulkCount = 500                  '�o���N�������ݒ�
    strStartRireki = Empty
    strEndRireki = Empty
    longStringLength = 0
End Sub

Private Sub Class_Terminate()
    '�N���X�j�����Ɏ��s
    strSQL = Empty
    intFieldCount = 0
    strStartRireki = Empty
    strEndRireki = Empty
    longStringLength = 0
End Sub
'�v���p�e�B�ݒ�
Property Let FieldArray(arrstrargField() As String)
    '�t�B�[���h����z��̌`�Ŏw��
    arrstrField = arrstrargField
End Property
Property Get FieldArray() As String()
    '�t�B�[���h�̔z���Ԃ�
    FieldArray = arrstrField
End Property
Property Let BulkCount(intargBulkCount As Integer)
    '�o���N���ݒ�
    intBulkCount = intargBulkCount
End Property
Property Get BulkCount() As Integer
    '�o���N���擾
    BulkCount = intBulkCount
End Property
Property Let StartRireki(strargStartRireki As String)
    '�X�^�[�g����ݒ�
    strStartRireki = strargStartRireki
End Property
Property Get StartRireki() As String
    '�X�^�[�g�����擾
    StartRireki = strStartRireki
End Property
Property Let EndRireki(strargEndRireki As String)
    '�G���h����ݒ�
    strEndRireki = strargEndRireki
End Property
Property Get EndRireki() As String
    '�G���h�����擾
    EndRireki = strEndRireki
End Property
Property Let TableName(strargTableName As String)
    '�e�[�u�����ݒ�
    strTableName = strargTableName
End Property
Property Get TableName() As String
    '�e�[�u�����擾
    TableName = strTableName
End Property

'���\�����b�h
Public Function CreateInsertSQL(Optional ByVal strargStartRireki As String, _
                                Optional ByVal strargEndRireki As String, _
                                Optional ByVal strargTableName As String) As Boolean
    '�t�B�[���h���͐�Ƀv���p�e�B�ŃZ�b�g���Ăق����́E�E�E
    If Not strargStartRireki = "" Then
        Me.StartRireki = strargStartRireki
    End If
    If Not strargEndRireki = "" Then
        Me.EndRireki = strargEndRireki
    End If
    If Not strargTableName = "" Then
        Me.TableName = strargTableName
    End If
    
    If Me.StartRireki = "" Or _
        Me.EndRireki = "" Or _
        Me.TableName = "" Then
        MsgBox "CreateInsertSQL �G���[�F�K�{���ڂœ��͂���Ă��Ȃ��ꏊ������܂�"
        CreateInsertSQL = False
        Exit Function
    End If
    'DB���痚���̌����Ƃ��E���Ă���
    
End Function
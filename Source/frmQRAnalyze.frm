VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmQRAnalyze 
   Caption         =   "QR�R�[�h�ǂݎ��"
   ClientHeight    =   2280
   ClientLeft      =   30
   ClientTop       =   375
   ClientWidth     =   4305
   OleObjectBlob   =   "frmQRAnalyze.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmQRAnalyze"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub btnCancel_Click()
    txtboxQRString.Text = ""
    frmQRAnalyze.Hide
    'formJobNumberInput.Show
    
End Sub
Private Sub txtboxQRString_Exit(ByVal Cancel As MSForms.ReturnBoolean)
    '�������͂��ꂽ�甽������
    Dim strSplit As Variant
    Dim strJobNumber As String
    Dim intMaisuu As Integer
    Dim intCount As Integer
    Dim strBuf As String
    If txtboxQRString.Text = "" Then
        Debug.Print "String Empty"
        Exit Sub
    End If
    On Error GoTo ErrorCatcch
    strSplit = Split(txtboxQRString.Text, ",")
    If UBound(strSplit) < 4 Then
        '�v�f����4�ȉ��̏ꍇ�͎w������QR�R�[�h����Ȃ����ۂ�
        MsgBox "�w������QR�R�[�h�ȊO���ǂݍ��܂ꂽ�\��������܂��B"
        txtboxQRString.Text = ""
        frmQRAnalyze.Hide
        frmQRAnalyze.Show
        Exit Sub
    End If
    intMaisuu = CInt(strSplit(3))
    '�W���u�ԍ��̋󔒂̘A�����}�[�W����
    strBuf = ""
    For intCount = 1 To Len(strSplit(0))
        Select Case intCount
        Case 1
            '1�����ڂ͑f���Ƀo�b�t�@�ɓ���Ă��
            strBuf = strBuf & Mid(strSplit(0), intCount, 1)
        Case Else
            If Not Mid(strSplit(0), intCount, 1) = " " Then
                '�󔒈ȊO��������f���Ƀo�b�t�@�ɓ���Ă��
                strBuf = strBuf & Mid(strSplit(0), intCount, 1)
            Else
                '�󔒂������ꍇ�́A���O�̃o�b�t�@�̏I�[�������󔒂��ǂ����œ���邩���f
                If Right(strBuf, 1) = " " Then
                    '���X�g���󔒂������獡��̃��[�v�ł͉������Ȃ�
                Else
                    '���X�g���󔒂����Ȃ�����1��ڂ̃X�y�[�X�Ƃ��ăo�b�t�@�ɓ����
                    strBuf = strBuf & Mid(strSplit(0), intCount, 1)
                End If
            End If
            
        End Select
        strJobNumber = strBuf
    Next intCount
    formJobNumberInput.textBoxJobNumber.Text = strJobNumber
    formJobNumberInput.textboxMisuu = intMaisuu
    formJobNumberInput.Show
    formJobNumberInput.textboxStartRireki.SetFocus
ErrorCatcch:
    '��{�I�ɃG���[���������牽�����Ȃ���
    Debug.Print "Errror code: " & Err.Number & "Description: " & Err.Description
    txtboxQRString.Text = ""
    txtboxQRString.Enabled = False
    frmQRAnalyze.Hide
End Sub

Private Sub UserForm_Activate()
    txtboxQRString.Enabled = True
    txtboxQRString.SetFocus
End Sub


VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmSQLTest 
   Caption         =   "SQL�e�X�g"
   ClientHeight    =   8625.001
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   13785
   OleObjectBlob   =   "frmSQLTest.frx":0000
   StartUpPosition =   1  '�I�[�i�[ �t�H�[���̒���
End
Attribute VB_Name = "frmSQLTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'���T�C�Y�����̂���Win32API�g�p
'const
Option Explicit
Private Const GWL_STYLE As Long = (-16)                     '�E�B���h�E�X�^�C���̃n���h���ԍ�
Private Const WS_MAXIMIZEBOX As Long = &H10000  '�E�B���h�E�X�^�C���ōő剻�{�^��������
Private Const WS_MINIMIZEBOX As Long = &H20000  '�E�B���h�E�X�^�C���ōŏ����{�^����t����
Private Const WS_THICKFRAME As Long = &H40000   '�E�B���h�E�X�^�C���ŃT�C�Y�ύX������
Private Const WS_SYSMENU As Long = &H80000      '�E�B���h�E�X�^�C���ŃR���g���[�����j���[�{�b�N�X�����E�B���h�E���쐬����
'-----Windows API�錾-----
Private Declare PtrSafe Function GetActiveWindow Lib "user32" () As LongPtr
#If Win64 Then
Private Declare PtrSafe Function GetWindowLongPtr Lib "user32" Alias "GetWindowLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long) As LongPtr
Private Declare PtrSafe Function SetWindowLongPtr Lib "user32" Alias "SetWindowLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
Private Declare PtrSafe Function SetClassLongPtr Lib "user32" Alias "SetClassLongPtrA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
#Else
Private Declare PtrSafe Function GetWindowLongPtr Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long) As LongPtr
Private Declare PtrSafe Function SetWindowLongPtr Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
Private Declare PtrSafe Function SetClassLongPtr Lib "user32" Alias "SetClassLongA" (ByVal hwnd As LongPtr, ByVal nIndex As Long, ByVal dwNewLong As LongPtr) As LongPtr
#End If
'-------���X�g�\���̂��߂̒萔��`
'MS �S�V�b�N�i�����j�����T�C�Y9pt�̏ꍇ
Private Const sglChrLengthToPoint = 6.3
Private Const longMinimulPpiont = 20
'�t�H�[���ɍő剻�E���T�C�Y�@�\��ǉ�����B
Public Sub FormResize()
        Dim hwnd As LongPtr
        Dim WndStyle As LongPtr
    '�E�B���h�E�n���h���̎擾
    hwnd = GetActiveWindow()
    '�E�B���h�E�̃X�^�C�����擾
    WndStyle = GetWindowLongPtr(hwnd, GWL_STYLE)
    '�ő�E�ŏ��E�T�C�Y�ύX��ǉ�����
    WndStyle = WndStyle Or WS_THICKFRAME Or WS_MAXIMIZEBOX Or WS_MINIMIZEBOX Or WS_SYSMENU
    Call SetWindowLongPtr(hwnd, GWL_STYLE, WndStyle)
End Sub
Private Sub btnExportCSV_Click()
    'CSV�o��
    Dim strFilePath As String
    strFilePath = Application.GetSaveAsFilename(InitialFileName:="\\PC24929-tdms\DBLearn\Test\CSV_Output\", filefilter:="CSV�t�@�C��(*.csv),*.csv")
    If strFilePath = "False" Then
        Debug.Print "btnExportCSV�ŃL�����Z���������ꂽ"
        Exit Sub
    End If
    Call OutputArrayToCSV(Me.listBoxSQLResult.List, strFilePath)
    Exit Sub
End Sub
Private Sub btnFieldAndTableAdd_Click()
    CheckNewField
End Sub
Private Sub UserForm_Activate()
    '���T�C�Y�@�\�ǉ�
    Call FormResize
End Sub
Private Sub UserForm_Resize()
    '�t�H�[�����T�C�Y���ɁA���̃��X�g�{�b�N�X���T�C�Y�ύX���Ă��
    Dim intListHeight As Integer
    Dim intListWidth As Integer
    intListHeight = Me.InsideHeight - listBoxSQLResult.Top * 2
    intListWidth = Me.InsideWidth - (txtboxSQLText.Left * 2) - txtboxSQLText.Width - (listBoxSQLResult.Left - txtboxSQLText.Width - txtboxSQLText.Left)
    If (intListHeight > 0 And intListWidth > 0) Then
        listBoxSQLResult.Height = intListHeight
        listBoxSQLResult.Width = intListWidth
    End If
End Sub
Private Sub btnBulkDataInput_Click()
    Dim strSQL
    Randomize
    frmBulkInsertTest.Show
    '����͈̗͂����̔����̂�����
    'Int((�͈͏���l - �͈͉����l + 1) * Rnd + �͈͉����l)
End Sub
Private Sub btnSQLGo_Click()
    '�G���[�`�F�b�N�Ƃ��قƂ�ǂȂ�
    '�e�L�X�g�{�b�N�X�ɓ��ꂽSQL�����s����t�H�[�����ۂ���
    If txtboxSQLText.Text = "" Then
        MsgBox "�󔒂͂�����ƁE�E�E"
        Exit Sub
    End If
    Dim dbSQLite3 As clsSQLiteHandle
    Dim varRetValue As Variant
    Dim isCollect As Boolean
    Dim strWidths As String
    Set dbSQLite3 = New clsSQLiteHandle
    IsDBFileExist
    isCollect = dbSQLite3.DoSQL_No_Transaction(txtboxSQLText.Text)
    If isCollect Then
        If chkboxNoTitle.Value = True Then
            '�^�C�g���Ȃ�����]�̏ꍇ�͂�����
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=False)
            strWidths = GetColumnWidthString(varRetValue, 0)
        Else
            '�f�t�H���g�̓^�C�g������
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=True)
            strWidths = GetColumnWidthString(varRetValue, 1)
        End If
    Else
        '�G���[���������ꍇ�̏����E�E�E�Ȃ񂾂���
        '�G���[���b�Z�[�W�����̂܂ܕ\������΂����̂ł́E�E�E
        If chkboxNoTitle.Value = True Then
            '�^�C�g���Ȃ�����]�̏ꍇ�͂�����
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=False)
            strWidths = GetColumnWidthString(varRetValue, 0)
        Else
            '�f�t�H���g�̓^�C�g������
            varRetValue = dbSQLite3.RS_Array(boolPlusTytle:=True)
            strWidths = GetColumnWidthString(varRetValue, 1)
        End If
    End If
    If VarType(varRetValue) = vbEmpty Then
        listBoxSQLResult.Clear
        listBoxSQLResult.AddItem "�f�[�^�Ȃ�"
        Exit Sub
    End If
    Set dbSQLite3 = Nothing
    With listBoxSQLResult
        .ColumnCount = UBound(varRetValue, 2) - LBound(varRetValue, 2) + 1
        .ColumnWidths = strWidths
        '.List = Join(varRetValue)
        .List = varRetValue
        '.AddItem (varRetValue(1)(1))
    End With
End Sub
Private Function GetColumnWidthString(ByRef argVarData As Variant, ByVal arglongIndex As Long) As String
    '�w�肵���f�[�^�A�s���iIndex�j����AListBox�̕��i�|�C���g����;�ŋ�؂���������j�Ƃ��ĕԂ�
    Dim strWidth As String
    Dim intFieldCounter As Integer
    On Error GoTo ErrorCatch
    strWidth = ""
    For intFieldCounter = LBound(argVarData, 2) To UBound(argVarData, 2)
        Select Case intFieldCounter
            Case UBound(argVarData, 2)
                '�Ō�̏ꍇ;�����ɂ���Ȃ�
                If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                    '�t�B�[���h�l��Null�̏ꍇ�͕\�����Ȃ��ł����
                    strWidth = strWidth & "0 pt"
                Else
                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMinimulPpiont, Len(argVarData(arglongIndex, intFieldCounter)) * sglChrLengthToPoint)) & "pt"
                End If
            Case Else
                '�ŏ�����r���̏ꍇ
                If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                    'Null�������ꍇ
                    strWidth = strWidth & "0 pt;"
                Else
                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMinimulPpiont, Len(argVarData(arglongIndex, intFieldCounter)) * sglChrLengthToPoint)) & "pt;"
                End If
        End Select
    Next intFieldCounter
    GetColumnWidthString = strWidth
    Exit Function
ErrorCatch:
    Debug.Print "GetColumnWidth code: " & Err.Number & " Description :" & Err.Description
    GetColumnWidthString = ""
    Exit Function
End Function
Private Sub listBoxSQLResult_DblClick(ByVal Cancel As MSForms.ReturnBoolean)
    '���X�g�_�u���N���b�N������N���b�v�{�[�h�ɃR�s�[���Ă݂��悤
    Dim objDataObj As DataObject
    Dim intCounterColumn As Integer
    Dim strListText As String
    Set objDataObj = New DataObject
        objDataObj.SetText (listBoxSQLResult.List(listBoxSQLResult.ListIndex))
        objDataObj.PutInClipboard
        strListText = ""
        For intCounterColumn = 0 To listBoxSQLResult.ColumnCount - 1
            If IsNull(listBoxSQLResult.List(listBoxSQLResult.ListIndex, intCounterColumn)) Then
                'Null�̏ꍇ��NULL���ē���Ă�낤
                strListText = strListText & " NULL"
            Else
                strListText = strListText & " " & CStr(listBoxSQLResult.List(listBoxSQLResult.ListIndex, intCounterColumn))
            End If
        Next intCounterColumn
        LTrim (strListText)
        MsgBox strListText
        Debug.Print strListText
End Sub
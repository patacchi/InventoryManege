VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsGetIE"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'''
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''IE�̃R���e���c��VBA�ň�����悤�ɂ���N���X�ł�
'''--------------------------------------------------------------------------------------------------------------
'''�K�{�Q�Ɛݒ�
'''Microsoft Internet Controles
'''Microsoft HTML Object Libraly
Private Const START_ROW_DEFAULT As Long = 6                                 '�V�[�g�����o���̍ۂ̃f�t�H���g�X�^�[�g�s
Private Const START_COLUMN_DEFAULT As Long = 2                              '�V�[�g�����o���̃f�t�H���g�X�^�[�g��
'IE�ڑ��Ɋւ��郁���o�ϐ�
Private IEObject As InternetExplorer                                        'IE�I�u�W�F�N�g
Private strURL As String                                                    'IE�ŊJ��URL��ێ����郁���o�ϐ�
Private isVisible As Boolean                                                'IE��ʂ�\�����邩�ǂ����ATrue�ŕ\��
Private tableRow As HTMLTableRow                                            '�e�[�u����<tr>�̓��e�A�s���
Private tableData As HTMLTableCell                                          '�e�[�u����<td>�̓��e�A�ʂ̃f�[�^
'�V�[�g�����o���̍ۂɎg�p���郁���o�ϐ�
Private longColumn As Long                                                  '�V�[�g�����o���ۂ̗�ԍ�
Private longRow As Long                                                     '�V�[�g�����o���ۂ̍s�ԍ�
'�v���p�e�B�i�A�N�Z�T�j
'URL
Property Get URL() As String
    URL = strURL
End Property
Property Let URL(strargURL As String)
    If Not strargURL = "" Then
        strURL = strargURL
    End If
End Property
'Column
Property Get shColumn() As Long
    '0�ȉ��̏ꍇ�̓f�t�H���g�l���Z�b�g���Ă��
    If longColumn <= 0 Then
        longColumn = START_COLUMN_DEFAULT
    End If
    shColumn = longColumn
End Property
Property Let shColumn(longargColumn As Long)
    '����1�ȏ�̐��̂ݎ�t
    If longargColumn >= 1 Then
        longColumn = CLng(longargColumn)
    End If
End Property
'Row
Property Get shRow() As Long
    '0�ȉ��̏ꍇ�̓f�t�H���g�l���Z�b�g���Ă��
    If longRow <= 0 Then
        longRow = START_ROW_DEFAULT
    End If
    shRow = longRow
End Property
Property Let shRow(longargRow As Long)
    '����1�ȏ�̐��̂ݎ�t
    If longargRow >= 1 Then
        longRow = CLng(longargRow)
    End If
End Property
'ieObject �l��ݒ肷��̂ɕK�v����
Property Get IEInstance() As InternetExplorer
    Set IEInstance = IEObject
    Exit Property
End Property
'Visible
Property Get Visible() As Boolean
    Visible = isVisible
End Property
Property Let Visible(boolargVisible As Boolean)
    isVisible = boolargVisible
End Property
'�R���X�g���N�^
'���ۂ̏������e�̓��\�b�h�ɕ�������
Private Sub Class_Initialize()
    Call Initialize
End Sub
'�f�X�g���N�^
Private Sub Class_Terminate()
    Call Finalize
End Sub
'���ۂ̏������e�̓��\�b�h�ɕ�������
'���\�b�h
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''���������Ɏ��s���鏈��
'''--------------------------------------------------------------------------------------------------------------
Private Sub Initialize()
    longColumn = START_COLUMN_DEFAULT
    longRow = START_ROW_DEFAULT
'    Set ieObject = New InternetExplorer
    '
    Set IEObject = New InternetExplorerMedium
    isVisible = False
End Sub
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''�N���X�j�����Ɏ��s���鏈��
'''--------------------------------------------------------------------------------------------------------------
Private Sub Finalize()
    On Error GoTo ErrorCatch
    If Not IEObject Is Nothing Then
        IEObject.Quit
    End If
    Set IEObject = Nothing
    Exit Sub
ErrorCatch:
    Set IEObject = Nothing
    Exit Sub
End Sub
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''�w�肳�ꂽURL���u���E�U�ŊJ��
'''--------------------------------------------------------------------------------------------------------------
Public Function OpenIEwithURL(Optional strargURL As String) As Boolean
    'URL���w�肳��Ă��Ȃ������瑦������
    If strargURL = "" Then
        strargURL = strURL
    End If
    If strargURL = "" Then
        MsgBox "URL���w�肳��Ă��܂���i�K�{�j"
        DebugMsgWithTime "OpenIEwithURL: URL is empty"
        OpenIEwithURL = False
        Exit Function
    End If
    'isVisible�v���p�e�B�̐ݒ�l�𔽉f������
    IEObject.Visible = isVisible
    IEObject.navigate strargURL
End Function
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''�w�肳�ꂽURL������HTMLDocument�I�u�W�F�N�g��l�Ɏ���Dictionary��Ԃ�
'''�L�[�Ƃ��ăt���[���ԍ������
'''�e�h�L�������g�� "top"���L�[�Ƃ��āA�i�[����
'''--------------------------------------------------------------------------------------------------------------
'''Parms
'''strargURL        IE�ɓn��URL���w��
Public Function ReturnHTMLDocbyURL(Optional strargURL As String) As Dictionary
    Dim localDic As Dictionary
    Dim longElementCount As Long
    Dim intFrameCount As Integer
    Dim topDoc As HTMLDocument
    Dim frameDoc As HTMLDocument
    '������URL���w�肳��Ă��Ȃ��āA�v���p�e�B�Ŏw�肪����ꍇ�́A��������g���Ă��
    If strargURL = "" And Not (strURL = "") Then
        strargURL = strURL
    End If
    If strargURL = "" Then
        MsgBox "URL���w�肳��Ă��܂���i�K�{�j"
        DebugMsgWithTime "OpenIEwithURL: URL is empty"
        Set ReturnHTMLDocbyURL = localDic
        GoTo CloseAndExit
    End If
    '�w��̃y�[�W���J��
    OpenIEwithURL (strargURL)
'    ieObject.navigate strargURL
    '�e�y�[�W�ǂݍ��݊����܂őҋ@����
    Application.StatusBar = "TOP�y�[�W�ǂݍ��݊����҂�"
    Do Until IEObject.Busy = False And IEObject.readyState = READYSTATE_COMPLETE
        DoEvents
    Loop
    Application.StatusBar = "TOP�y�[�W�ǂݍ��݊����B�q�y�[�W�ǂݍ��݂ɓ���܂�"
    Set topDoc = IEObject.document
    'HTMLDocument�̓ǂݍ��݊�����҂��Ă���A�t���[���̗L���ɂ��Ċm�F��
    '�t���[�������݂���ꍇ�́A�t���[�����̓ǂݍ��݊������ҋ@����
    Call IsReadComp(topDoc)
    Application.StatusBar = "TOP�y�[�W��������"
    '2021_11_18 Daisuke_oota
    '�F�؃`�F�b�N
    '�����ŁA�w�肳��Ă���URL��ieobject��Location������Ă����ꍇ�́A���O�C����ʂɃ��_�C���N�g����Ă�Ǝv���̂�
    '��UVisible��True�ɂ��Ă���āA���O�C�����������Ă��炤
    If strargURL <> IEObject.LocationURL Then
        DebugMsgWithTime "URL�s��v�A���_�C���N�g���ꂽ�\��������܂�"
        '�����I��Visible��True�ɂ���
        IEObject.Visible = True
        '���O�C���������������猳�̃y�[�W�ɖ߂�͂��Ȃ̂ŁAieobject��LocationURL���w�肳�ꂽ���̂ɂȂ�܂őҋ@
        '�T�C�g�ɂ���Ă͖������[�v�̉\���L��E�E�E
        Do Until IEObject.LocationURL = strargURL And IEObject.Busy = False And IEObject.readyState = READYSTATE_COMPLETE
            DoEvents
        Loop
        'Visible�̏�Ԃ��v���p�e�B�Őݒ肵�Ă��Ԃɖ߂��Ă��
        IEObject.Visible = Me.Visible
    End If
    If topDoc Is Nothing Then
        '�������̎��_��HTMLDoc��Nothing�������牽���������Ǝv���̂ŁA�Ȍ�̏����͒��~����
        DebugMsgWithTime "ReturnHTMLDocbyURL: topHTMLDoc is nothing"
        Set ReturnHTMLDocbyURL = localDic
    End If
    '���̎��_�Őe�h�L�������g�͓ǂݍ��݊������Ă���̂ŁADictionary�ɒǉ����Ă��
    Set localDic = New Dictionary
    localDic.Add "top", topDoc
    intFrameCount = 0
    If topDoc.frames.Length > 0 Then
        '�t���[�������݂���ꍇ
        Application.StatusBar = "�t���[�������݂���̂Ńt���[���̓ǂݍ��݊����ҋ@�ɓ���܂��B"
        For intFrameCount = 0 To topDoc.frames.Length - 1
            '�t���[���̑��݂��鐔�����[�v
            On Error Resume Next
                Set frameDoc = topDoc.frames(intFrameCount).document
                '�G���[�������Ă���f�o�b�O�E�B���h�E�ɕ\�����Ă��
                If Err.Number <> 0 Then
                    DebugMsgWithTime "ReturnHTMLDocbyURL code: " & Err.Number & " Description: " & Err.Description & " FrameCount: " & intFrameCount
                End If
            On Error GoTo 0
            If Not frameDoc Is Nothing Then
                '�t���[���̒��g������݂���
                Application.StatusBar = intFrameCount & " �Ԗڂ̃t���[���ǂݍ��݊����҂�"
                '�t���[���̓ǂݍ��݊�����҂�
                Call IsReadComp(frameDoc)
                'Dictionary�ɒǉ����Ă��
                localDic.Add intFrameCount, frameDoc
                Set frameDoc = Nothing
            End If
        Next intFrameCount
        Application.StatusBar = "�t���[���ǂݍ�����"
        '���ʂ�Ԃ��Ă��
        Set ReturnHTMLDocbyURL = localDic
        Application.StatusBar = "���ʏ����o������"
        GoTo CloseAndExit
    Else
        '�t���[�������݂��Ȃ��ꍇ
'        'top�݂̂�Dictionary�ɓ���ĕԂ�
'        localDic.Add intFrameCount, topDoc
        Set ReturnHTMLDocbyURL = localDic
        GoTo CloseAndExit
        Exit Function
    End If
CloseAndExit:
    Set localDic = Nothing
    Exit Function
End Function
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''HTML�h�L�������g�������Ƃ��āA�ǂݍ��݊����܂őҋ@���A����������True��Ԃ�
'''--------------------------------------------------------------------------------------------------------------
'''Parms
'''argHTMLDoc           �ǂݍ��݊�����҂�HTML�h�L�������g
Private Function IsReadComp(argHTMLDoc As HTMLDocument) As Boolean
    Application.StatusBar = argHTMLDoc.Title & " �̃y�[�W�ǂݍ��݊�����ҋ@���Ă��܂� "
    If Not argHTMLDoc Is Nothing Then
        'HTMLDoc�����g���鎞�����ҋ@���[�v����
        Do Until argHTMLDoc.readyState = "complete"
            DoEvents
        Loop
    End If
    Application.StatusBar = "�ǂݍ��݊���"
    IsReadComp = True
    Exit Function
End Function
'''Author Daisuke_Oota
'''--------------------------------------------------------------------------------------------------------------
'''Summary
'''HTML�h�L�������g�������Ƃ���
'''�w�肳�ꂽ�e�^�O�̒���(��FTable)�q�^�O(th)�̒��g(Text)���擾����
'''�߂�l��String�z��
'''--------------------------------------------------------------------------------------------------------------
'''Parms
Public Function getTextArrayByTagName(argHTMLDoc As HTMLDocument, argTopTagName As String, Optional argChildTagName As String = "") As String()
    '�e�^�O�̗v�f���擾����
    If (argHTMLDoc Is Nothing) Or (argTopTagName = "") Then
        DebugMsgWithTime "getTextArrayByTagName HTMLDocument or TopTagName is empty"
    End If
    Dim localarrString() As String
    On Error GoTo ErrorCatch
    Dim parentElement As Object
'    Dim parentElement As HTMLElementCollection
    Set parentElement = argHTMLDoc.getElementsByTagName(argTopTagName)
    If parentElement.Length = 0 Then
        '�v�f����0�̏ꍇ�͂����Ŕ�����
        getTextArrayByTagName = localarrString
        Set parentElement = Nothing
        Exit Function
    End If
    ReDim localarrString(parentElement.Length)
    Dim varElement As Variant
    Dim longRowCount As Long
    longRowCount = 0
    For Each varElement In parentElement
'        DebugMsgWithTime varElement.innerText
        '�����ŗv�f��Text��String�z��ɒǉ����Ă����Ă��\��
        localarrString(longRowCount) = varElement.innerText
        longRowCount = longRowCount + 1
    Next varElement
    '�q�^�O�̈����Ƀf�[�^�������Ă���΍X�Ɏq�^�O�̗v�f���擾����
    If argChildTagName <> "" Then
        Dim childElement As HTMLElementCollection
    End If
    getTextArrayByTagName = localarrString
    Exit Function
ErrorCatch:
    DebugMsgWithTime "getTestArrayByTagNae code: " & Err.Number & " Description: " & Err.Description
    getTextArrayByTagName = localarrString
    Exit Function
End Function
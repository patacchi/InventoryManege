Attribute VB_Name = "IE_Connect_Test"
Option Explicit
Private Const START_COLUMN As Long = 2
Private Const START_ROW As Long = 4
Public Sub OpenUrlatIE()
'    Dim ieObject As InternetExplorerMedium
'    Dim ieObject As InternetExplorer
'    Dim returnHTML As HTMLDocument
''    Dim tableWhole As IHTMLElementCollection
'    Dim tableRow As HTMLTableRow
'    Dim tableHeader As HTMLTableCell
'    Dim tableData As HTMLTableCell
'    Dim longColumnCount As Long
'    Dim longRowCount As Long
'    Set ieObject = New InternetExplorer
'    ieObject.Visible = False
    Dim clsIETest As clsGetIE
    Set clsIETest = New clsGetIE
    '���ꌧ�s�����ꗗ�_�E�����[�h_SaveAs�e�X�g
    clsIETest.URL = "https://saigai.gsi.go.jp/jusho/download/pref/47.html"
    clsIETest.Visible = True
    '���ʂ�dicHTMLdoc�Ŏ󂯎��
    Dim dicResultHTML As Dictionary
    Set dicResultHTML = clsIETest.ResultHTMLDoc
    '�g�b�v�h�L�������g��HTMLDoc�Ƃ��Ď󂯎��
    Dim topHTMLdoc As HTMLDocument
    Set topHTMLdoc = dicResultHTML("d")
    '�g�b�v��Links(a�^�O�j�̒��Ŏ����s�̕����񂪂��镨���N���b�N����izip�t�@�C���j
    Dim htmlLink As HTMLHtmlElement
    For Each htmlLink In topHTMLdoc.Links
        If InStr(htmlLink.innerHTML, "�����s") > 0 Then
            '�����s���܂܂�Ă���N���b�N����
            htmlLink.Click
            '�ۑ��{�^���������̂�����Ă݂�
            clsIETest.DownloadNotificationBarSaveAs ("Test20211128")
        End If
    Next htmlLink
''-----------------------------------------------------------------------------------------------------------------------------
'    'confirm���s�˔j�e�X�g�p
'   clsIETest.URL = "http://needtec.sakura.ne.jp/auto_demo/form1.html"
'    '�ǂݍ��݊����܂ő҂���
'    Do While ieObject.Busy = True And ieObject.readyState <> READYSTATE_COMPLETE
'        Application.StatusBar = "�g�b�v��ʓǂݍ��݊����҂�"
'        DoEvents
'    Loop
'    Application.StatusBar = ""
    'HTMLDobument�I�u�W�F�N�g�Ƃ��Ď擾
'    Set returnHTML = ieObject.document
'    '�ǂݍ��񂾃h�L�������g�̓ǂݍ��݊�����ҋ@
'    Do While returnHTML.readyState <> "complete"
'        Application.StatusBar = "Document�ǂݍ��݊����ҋ@��..."
'        DoEvents
'    Loop
'    Application.StatusBar = "�ǂݍ��݊���"
'    ieObject.Visible = True
'    Dim htmlelmName As HTMLDocument
'    Set htmlelmName = returnHTML.getElementsByName("name").Item(, 0)
'    htmlelmName.Value = "�ۂɂՂ�"
'    Dim htmlelmMail As HTMLDocument
'    Set htmlelmMail = returnHTML.getElementsByName("mail").Item(, 0)
'    htmlelmMail.Value = "puni@poni"
'    'confirm�U��
'    returnHTML.parentWindow.execScript "confirm = function(){return true;}"
'    Dim htmlelmSubmitButton As Object
'    Set htmlelmSubmitButton = returnHTML.getElementsByTagName("input")
'    Dim objelm As Object
'    For Each objelm In htmlelmSubmitButton
'        If InStr(objelm.outerHTML, "�o�^����") >= 1 Then
'            objelm.Click
'        End If
'    Next objelm
''-----------------------------------------------------------------------------------------------------------------------------
''NotificationSaveAs �g�p��
'    �����s�̃f�[�^���y���̂ł��̃����N��T��
'    https://saigai.gsi.go.jp/jusho/download/data/47210.zip <a href>
'    Dim htmlLiks As HTMLHtmlElement
'    HTMLDoc.Liks �� a�^�O��href�̈ꗗ���擾�ł��邻��
'    Dim fsoLink As FileSystemObject
'    For Each htmlLiks In returnHTML.Links
'        If InStr(htmlLiks.innerText, "�����s") > 0 Then
'            �����s��������t�@�C���_�E�����[�h���Ă݂�
'            �����N���N���b�N
'            htmlLiks.Click
'            ieObject.Visible = True
'            Call ShowWindow(ieObject.hwnd, SW_MINIMIZE)
'            Set fsoLink = New FileSystemObject
'            Dim strFilePath As String
'            �t�@�C���������Temp�f�B���N�g���Ť�g���q�͖����Őݒ肷��
'            strFilePath = fsoLink.BuildPath(fsoLink.GetSpecialFolder(TemporaryFolder), Format(Now(), "yyyymmddhhmmss"))
'            ���O��t���ĕۑ������s��ۑ���̃t���p�X�����߂�l�Ƃ��ĕԂ��Ă��� (�����g���q�Ƃ��t���Ă���Ă�͂�)
'            Dim strResultFilePath As String
'            strResultFilePath = IE_Save_As.DownloadNotificationBarSaveAs(ieObject.hwnd, strFilePath)
'            Call ieObject.Quit
'            Set ieObject = Nothing
'            If fsoLink.FileExists(strResultFilePath) Then
'                Application.StatusBar = strResultFilePath & " �̃_�E�����[�h����"
'            End If
'            Exit For
'        End If
'    Next htmlLiks
''-----------------------------------------------------------------------------------------------------------------------------
'
'    '�Ƃ肠�����V�[�g�ɃL�������Ƃ����o���Ă݂�
'    Application.ScreenUpdating = False
'    longColumnCount = START_COLUMN
'    longRowCount = START_ROW
'    '�w�b�_
'    For Each tableHeader In returnHTML.getElementsByName("sortabletable1")(0).getElementsByTagName("thead")(0).getElementsByTagName("th")
'        shIETest.Cells(longRowCount, longColumnCount).Value = tableHeader.innerText
'        '���̗��
'        Debug.Print tableHeader.innerText
'        longColumnCount = longColumnCount + 1
'    Next tableHeader
'    '�f�[�^
'    longRowCount = START_ROW + 1
'    Application.StatusBar = "���擾��..."
'    For Each tableRow In returnHTML.getElementsByName("sortabletable1")(0).getElementsByTagName("tbody")(0).getElementsByTagName("tr")
'        '�e�s�ɑ΂��ď������s���Ă���
'        'tr�^�O�̒���td�^�O�̒��g��������������
'        '��������ʒu��
'        longColumnCount = START_COLUMN
'        For Each tableData In tableRow.getElementsByTagName("td")
'            shIETest.Cells(longRowCount, longColumnCount).Value = tableData.innerText
''            Debug.Print tableData.innerHTML
'            '���̗��
'            longColumnCount = longColumnCount + 1
'        Next tableData
'        '���̍s��
'        longRowCount = longRowCount + 1
'        Application.StatusBar = "���擾��..." & longRowCount - START_ROW & " ���擾�ς�"
'        DoEvents
'    Next tableRow
'    Application.StatusBar = "�擾����"
    Application.ScreenUpdating = True
    Stop
    If Not clsIETest Is Nothing Then
        Set clsIETest = Nothing
    End If
End Sub
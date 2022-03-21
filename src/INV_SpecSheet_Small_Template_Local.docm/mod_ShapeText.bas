Attribute VB_Name = "mod_ShapeText"
Option Explicit
'Range�I�u�W�F�N�g�̓��삪�d�����ւ̑Ώ��A�w�蕶���������͖�������
Private Const MIN_SHAPE_CHAR_LENGTHB As Long = 9                    '�t�H���g�T�C�Y�������A���̒萔�ȏ�̃o�C�g���̕�����𐮌`�ΏۂƂ���Arange.Information�̓��삪�x�����ߑΏۂ����Ȃ�
Private Const MIN_FONT_SIZE As Long = 5                             '�ŏ��t�H���g�T�C�Y�A���̃t�H���g�ɂȂ�����k�������𒆒f����
Private Const SCALE_MESURE_API_TO_REAL As Single = 0.73!            'API��MesureTextWidth�����̂��傫�����l��Ԃ��̂ŁA�W�����|����
'''2�s�ɂ܂�����i�����P�s�Ɏ��܂�悤�Ƀt�H���g�T�C�Y�𒲐�����
'''
Public Sub CalcFontSizeToOneLine()
    '��ʍX�V���~����
    Application.ScreenUpdating = False
    Dim strarrPerParagraph() As String
    'ActiveDocument�̑S�������擾���A�i���L��(�����R�[�h 13)�ŕ������A�z��Ɏ��߂�
    '���̔z��̓Y���� +1 ��Paragrafs(x)��Index�ԍ��ƈ�v����(Paragrafs�̓C���f�b�N�X1�X�^�[�g)
    strarrPerParagraph = Split(Replace(ActiveDocument.Range(0, ActiveDocument.Range.End).Text, ChrW(7), ""), ChrW(13))
    '�擾�����i���z������[�v
    Dim longParaArrayRowCounter As Long
    '�z��̍Ō�͋󕶎��Ȃ̂Ŗ�������
    For longParaArrayRowCounter = LBound(strarrPerParagraph) To UBound(strarrPerParagraph) - 1
        Select Case True
        Case LenB(strarrPerParagraph(longParaArrayRowCounter)) > MIN_SHAPE_CHAR_LENGTHB
            '�Ώۍŏ��o�C�g���������Ă����ꍇ
            '�s�J�n�ʒu�����A�t�H���g�T�C�Y�ݒ�Ώ�
            '�Ō�̉��s������Range���擾
            Dim rngNoCrlf As Range
            '�i���z��̓Y����+1��Paragrafs��Index
            Set rngNoCrlf = ActiveDocument.Range( _
                            ActiveDocument.Paragraphs(longParaArrayRowCounter + 1).Range.Start, _
                            ActiveDocument.Paragraphs(longParaArrayRowCounter + 1).Range.End - 1 _
                            )
            '�J�n�ʒu�ƏI���ʒu���擾(�s�����Ƃ��߂�����)
            '���g��|����Ƃ��܂������Ȃ��̂�API�̂��g���Ă݂悤�E�E�E
            Dim longPixColumnWidth As Long          '���݂̗�̕���Pixcel���擾
            Dim longPixCurrent As Long              '�J�����g�������Picel���擾
            '���݂̗�̕���Pixcel���擾
            longPixColumnWidth = Application.PointsToPixels(rngNoCrlf.Cells.Width)
            '�J�����g������̕����擾
            longPixCurrent = CSng(Mod_WinAPI.MesureTextWidth(rngNoCrlf.Text, rngNoCrlf.Font.Name, rngNoCrlf.Font.Size, rngNoCrlf.Font.Scaling)) * SCALE_MESURE_API_TO_REAL
            '�J�����g�����񂪃Z���̕���蒷���ԃ��[�v����
            Do While longPixCurrent > longPixColumnWidth
                If rngNoCrlf.Font.Size <= MIN_FONT_SIZE Then
                    '�ŏ��t�H���g�T�C�Y��菬��������
                    MsgBox "�\����2�s�ɕ�����Ă���\��������܂����A����������ȏ㏬�����ł��Ȃ����ߏ����𒆒f���܂���" & vbCrLf & _
                    "�Ώە�����F" & strarrPerParagraph(longParaArrayRowCounter)
                End If
                'FontSize�� -0.5
                rngNoCrlf.Font.Size = rngNoCrlf.Font.Size - 0.5
                '�ēx�����擾
                '���݂̗�̕���Pixcel���擾
                longPixColumnWidth = Application.PointsToPixels(rngNoCrlf.Cells.Width)
                '�J�����g������̕����擾
                longPixCurrent = Mod_WinAPI.MesureTextWidth(rngNoCrlf.Text, rngNoCrlf.Font.Name, rngNoCrlf.Font.Size, rngNoCrlf.Font.Scaling)
            Loop
'            Dim sglStartVPos As Single       '�i���̍ŏ��̕����̐��������̏�[����̃|�C���g��
'            Dim sglEndVPos As Single         '�i���̍Ō�̕����̐��������̏�[����̃|�C���g��
'            sglStartVPos = rngNoCrlf.Information(wdVerticalPositionRelativeToPage)
'            sglEndVPos = rngNoCrlf.Characters.Last.Information(wdVerticalPositionRelativeToPage)
'            �X�^�[�g�s�ƃG���h�s���Ⴄ�Ԃ̓��[�v����
'            Do While sglStartVPos <> sglEndVPos
'                �X�^�[�g�s��End�s�������
'                If rngNoCrlf.Font.Size <= MIN_FONT_SIZE Then
'                    �ŏ��t�H���g�T�C�Y��菬��������
'                    MsgBox "�\����2�s�ɕ�����Ă���\��������܂����A����������ȏ㏬�����ł��Ȃ����ߏ����𒆒f���܂���" & vbCrLf & _
'                    "�Ώە�����F" & strarrPerParagraph(longParaArrayRowCounter)
'                End If
'                FontSize�� -0.5
'                rngNoCrlf.Font.Size = rngNoCrlf.Font.Size - 0.5
'                �ēx�J�n�s�ƏI���s���擾����
'                sglStartVPos = rngNoCrlf.Information(wdVerticalPositionRelativeToPage)
'                sglEndVPos = rngNoCrlf.Characters.Last.Information(wdVerticalPositionRelativeToPage)
'            Loop
'            Debug.Print longParaArrayRowCounter & vbCrLf & "Text: " & rngNoCrlf.Text & vbCrLf & "StartLine: " & sglStartVPos & vbCrLf & "End Line: " & sglEndVPos
            Set rngNoCrlf = Nothing
            '�����Windows�ɖ߂�
            DoEvents
        End Select  'LenB
    Next longParaArrayRowCounter
    '��ʍX�V���ĊJ����
    Application.ScreenUpdating = True
End Sub
Attribute VB_Name = "Mod_WinAPI"
Option Explicit
'WindowAPI �֐��錾
Private Declare PtrSafe Function GetDC Lib "user32" (ByVal hwnd As LongPtr) As LongPtr
Private Declare PtrSafe Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As LongPtr) As LongPtr
Private Declare PtrSafe Function SelectObject Lib "gdi32" (ByVal hdc As LongPtr, ByVal hObject As LongPtr) As LongPtr
Private Declare PtrSafe Function DeleteObject Lib "gdi32" (ByVal hObject As LongPtr) As Long
Private Declare PtrSafe Function ReleaseDC Lib "user32" (ByVal hwnd As LongPtr, ByVal hdc As LongPtr) As Long
Private Declare PtrSafe Function CreateFont Lib "gdi32" Alias "CreateFontA" (ByVal nHeight As Long, _
    ByVal nWidth As Long, _
    ByVal nEscapement As Long, _
    ByVal nOrientation As Long, _
    ByVal fnWeight As Long, _
    ByVal IfdwItalic As Long, _
    ByVal fdwUnderline As Long, _
    ByVal fdwStrikeOut As Long, _
    ByVal fdwCharSet As Long, _
    ByVal fdwOutputPrecision As Long, _
    ByVal fdwClipPrecision As Long, _
    ByVal fdwQuality As Long, _
    ByVal fdwPitchAndFamily As Long, _
    ByVal lpszFace As String) As LongPtr
Private Declare PtrSafe Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hdc As LongPtr, _
    ByVal lpStr As String, _
    ByVal nCount As Long, _
    lpRect As RECT, _
    ByVal wFormat As Long) As Long
'---------------------------------------------------------------------
'�萔�E�\���̐錾
'RECT�\���̒�`
Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type
'CreateFont�p�萔
Private Const FW_NORMAL = 400
Private Const FW_BOLD = 700
Private Const DEFAULT_CHARSET = 1
Private Const OUT_DEFAULT_PRECIS = 0
Private Const CLIP_DEFAULT_PRECIS = 0
Private Const DEFAULT_QUALITY = 0
Private Const DEFAULT_PITCH = 0
Private Const FF_SCRIPT = 64
Private Const DT_CALCRECT = &H400
'-----------------------------------------------------------------------------------------------------------------------
'�v���V�[�W����`
'''�^���炽������A�t�H���g�A�T�C�Y�����ʂ̎��`�撷���擾����֐�
'''Return Long      ���`��|�C���g��?
'''args
'''strargTargetText         �^�[�Q�b�g�ƂȂ�e�L�X�g
'''strargFONT_NAME          �t�H���g��
'''longargFont_Height       �t�H���g�T�C�Y?�c�̒����炵�����ǁE�E�E
'''Optional longargFontWidtsScal   �t�H���g�̉��g��T�C�Y��%�� �f�t�H���g��100
Public Function MesureTextWidth( _
    strargTargetText As String, _
    strargFONT_NAME As String, _
    longargFont_Height As Long, _
    Optional longargFontWidtsScale = 100) As Long
    On Error GoTo ErrorCatch
    '��ʑS�̂̕`��̈�̃n���h�����擾
    Dim hwholeScreenDC As LongPtr
    hwholeScreenDC = GetDC(0&)
    '���z��ʕ`��̈�̃n���h�����擾
    Dim hvirtualDC As LongPtr
    hvirtualDC = CreateCompatibleDC(hwholeScreenDC)
    '�����̊g�嗦�ɉ����ĉ�����ݒ�
    Dim longWidth As Long
    Select Case longargFontWidtsScale
    Case 100
        '0�A���{�̏ꍇ
        '�����ݒ�ɂ���E�E�E�Ƃ��܂������Ȃ��E�E�H
        '�Ƃ肠��������(Font.Size)�Ɠ����ɂ��Ă݂�
        longWidth = longargFont_Height
    Case Else
        '�{���w�肳��Ă����ꍇ
        '�w��{�����|���Ă��
        '�����l�Ƃ�����ƈႤ���ʂɂȂ��Ă��̂Ō��ŕ␳
        longWidth = CLng(longargFont_Height * (longargFontWidtsScale / 100) * 80 / 100)
    End Select
    '�t�H���g�̃n���h�����擾
    Dim hFont As LongPtr
    hFont = CreateFont(longargFont_Height, longWidth, 0, 0, FW_NORMAL, _
    0, 0, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, _
    CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, _
    DEFAULT_PITCH Or FF_SCRIPT, strargFONT_NAME)
    '���z�`��̈�Ƀt�H���g��ݒ�
    Call SelectObject(hvirtualDC, hFont)
    '�`��̈�̎��͂��擾
    Dim DrawAreaRectangle As RECT
    '�ݒ肵���t�H���g��K�p���A�e�L�X�g�����o��
    Call DrawText(hvirtualDC, strargTargetText, -1, DrawAreaRectangle, DT_CALCRECT)
    '�g�p�����I�u�W�F�N�g���J������
    Call DeleteObject(hFont)
    Call DeleteObject(hvirtualDC)
    Call ReleaseDC(0&, hwholeScreenDC)
    '���ʂ�Ԃ�
    MesureTextWidth = DrawAreaRectangle.Right - DrawAreaRectangle.Left
    GoTo CloseAndExit
ErrorCatch:
    Debug.Print "MesureTextWidth code : " & Err.Number & " Descriptoin: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
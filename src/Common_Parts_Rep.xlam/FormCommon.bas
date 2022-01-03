Attribute VB_Name = "FormCommon"
Option Explicit
'�t�H�[�������ŋ��ʂ̏������܂Ƃ߂Ă����\��
Public Function GetColumnWidthString(ByRef argVarData As Variant, Optional ByVal arglongIndex As Long = 0, Optional ByVal boolMaxLengthFind As Boolean) As String
    '�w�肵���f�[�^�A�s���iIndex�j����AListBox�̕��i�|�C���g����;�ŋ�؂���������j�Ƃ��ĕԂ�
    'MaxLength�I�v�V�������t�^����Ă�����A�ő啶��������������i�����������Ƒ�ρj
    '�����񐔂́Asingle�z��Ŏ����Ƃɂ����
    Dim strWidth As String
    Dim intFieldCounter As Integer
    Dim longRowCounter As Long
    Dim sglArrChrLength() As Single
    On Error GoTo ErrorCatch
    ReDim sglArrChrLength(UBound(argVarData, 2))
    '������z��擾
    Select Case boolMaxLengthFind
    Case True
        '�ő啶�����擾����
        '�S�s�������[�v
        For longRowCounter = LBound(argVarData, 1) To UBound(argVarData, 1)
            For intFieldCounter = LBound(argVarData, 2) To UBound(argVarData, 2)
                '���̃t�B�[���h�ŁA�z��̂ق����Z����΍X�V���Ă��
                If IsNull(argVarData(longRowCounter, intFieldCounter)) Then
                    '���g��Null�������ꍇ�A���̃��[�v�ł͉������Ȃ�
'                    Exit For
                End If
                If sglArrChrLength(intFieldCounter) < LenB(argVarData(longRowCounter, intFieldCounter)) Then
                    sglArrChrLength(intFieldCounter) = LenB(argVarData(longRowCounter, intFieldCounter))
                End If
            Next intFieldCounter
        Next longRowCounter
    Case False
        '�ő啶�����擾�Ȃ�
        '1�񂾂��t�B�[���h�����[�v���ďI���
        For intFieldCounter = LBound(argVarData, 2) To UBound(argVarData, 2)
            If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                Exit For
            End If
            sglArrChrLength(intFieldCounter) = LenB(argVarData(arglongIndex, intFieldCounter))
        Next intFieldCounter
    End Select
    strWidth = ""
    For intFieldCounter = LBound(argVarData, 2) To UBound(argVarData, 2)
        Select Case intFieldCounter
            Case UBound(argVarData, 2)
                '�Ō�̏ꍇ;�����ɂ���Ȃ�
                If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                    '�t�B�[���h�l��Null�̏ꍇ�͕\�����Ȃ��ł����
                    strWidth = strWidth & "0 pt"
                Else
                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMINIMULPOINT, sglArrChrLength(intFieldCounter) * sglChrLengthToPoint)) & "pt"
                End If
            Case Else
                '�ŏ�����r���̏ꍇ
                If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                    'Null�������ꍇ
                    strWidth = strWidth & "0 pt;"
                Else
                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMINIMULPOINT, sglArrChrLength(intFieldCounter) * sglChrLengthToPoint)) & "pt;"
                End If
        End Select
    Next intFieldCounter
    GetColumnWidthString = strWidth
    Exit Function
ErrorCatch:
    DebugMsgWithTime "GetColumnWidth code: " & Err.Number & " Description :" & Err.Description
    GetColumnWidthString = ""
    Exit Function
End Function
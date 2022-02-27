Attribute VB_Name = "FormCommon"
Option Explicit
'フォーム共通定数定義
'テキストボックス関係
Public Const TXTBOX_BACKCOLORE_EDITABLE As Long = &HC0FFC0         '薄い緑
Public Const TXTBOX_BACKCOLORE_NORMAL As Long = &H80000005         'ウィンドウの背景
'フォーム処理で共通の処理をまとめていく予定
Public Function GetColumnWidthString(ByRef argVarData As Variant, Optional ByVal arglongIndex As Long = 0, Optional ByVal boolMaxLengthFind As Boolean) As String
    '指定したデータ、行数（Index）から、ListBoxの幅（ポイント数を;で区切った文字列）として返す
    'MaxLengthオプションが付与されていたら、最大文字数を検索する（件数が多いと大変）
    '文字列数は、single配列で持つことにするよ
    Dim strWidth As String
    Dim intFieldCounter As Integer
    Dim longRowCounter As Long
    Dim sglArrChrLength() As Single
    On Error GoTo ErrorCatch
    ReDim sglArrChrLength(UBound(argVarData, 2))
    '文字列配列取得
    Select Case boolMaxLengthFind
    Case True
        '最大文字数取得あり
        '全行数分ループ
        For longRowCounter = LBound(argVarData, 1) To UBound(argVarData, 1)
            For intFieldCounter = LBound(argVarData, 2) To UBound(argVarData, 2)
                '今のフィールドで、配列のほうが短ければ更新してやる
                If IsNull(argVarData(longRowCounter, intFieldCounter)) Then
                    '中身がNullだった場合、このループでは何もしない
'                    Exit For
                End If
                If sglArrChrLength(intFieldCounter) < LenB(argVarData(longRowCounter, intFieldCounter)) Then
                    sglArrChrLength(intFieldCounter) = LenB(argVarData(longRowCounter, intFieldCounter))
                End If
            Next intFieldCounter
        Next longRowCounter
    Case False
        '最大文字数取得なし
        '1回だけフィールド数ループして終わり
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
                '最後の場合;が後ろにいらない
                If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                    'フィールド値がNullの場合は表示しないでやって
                    strWidth = strWidth & "0 pt"
                Else
                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMINIMULPOINT, sglArrChrLength(intFieldCounter) * sglChrLengthToPoint)) & "pt"
                End If
            Case Else
                '最初から途中の場合
                If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                    'Nullだった場合
                    strWidth = strWidth & "0 pt;"
                Else
                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMINIMULPOINT, sglArrChrLength(intFieldCounter) * sglChrLengthToPoint)) & "pt;"
                End If
        End Select
    Next intFieldCounter
    GetColumnWidthString = strWidth
    Exit Function
ErrorCatch:
    DebugMsgWithTime "GetColumnWidth code: " & err.Number & " Description :" & err.Description
    GetColumnWidthString = ""
    Exit Function
End Function
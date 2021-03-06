Attribute VB_Name = "FormCommon"
Option Explicit
'フォーム共通定数定義
'テキストボックス関係
Public Const TXTBOX_BACKCOLORE_EDITABLE As Long = &HC0FFC0          '薄い緑
Public Const TXTBOX_BACKCOLORE_NORMAL As Long = &H80000005          'ウィンドウの背景
Public Const TEXT_NORMAL_BLACK As Long = &H80000012                 '文字色、標準黒
Public Const TEXT_NOT_ENABLE_GRAY As Long = &H80000010              '文字色、EnableがFalseされた色に近い、薄グレー
Public Const BACK_COLOR_NORMAL_BACKCOLOR_GRAY As Long = &H8000000F  'フォームの標準背景色、ボタンの標準色
Public Const BACK_COLOR_SELECTABLE_PINK As Long = &HFFC0FF          '選択可能な何か、ピンク
Public Const BACK_COLOR_SATURDAY_BLUE As Long = &H80000002          '土曜の背景色、グレーっぽいブルー
Public Const BACK_COLOR_SUNDAY_RED As Long = &H8080FF               '日曜の背景色、赤っぽい朱色かなにか
'DatePicker関係
Public Const LABEL_DAY_PRIFIX As String = "lbl_Day"         '日付ラベルの共通Prefix、この後に数字2桁が続く
Public datePickerResult As Date                             'DatePickerの結果のDateを格納
'binLabel関係
Public strSavePointName As String                                   'frmSetSavePointの返値が格納される変数
'フォーム処理で共通の処理をまとめていく予定
'''Variant配列を引数として、各フィールドの最長ポイント数を取得し、List.widthの引数の文字列を作成する
'''Retuen string    list.ColumnWidthの引数となるString
'''args
'''argVarData                           元データが入ったVariant配列、2次元を想定
'''argFont                              Fontの参照
'''Optional ByVal boolMaxLengthFind     Trueをセットするとデータ全件調べて最長文字列を探す、デフォルトはFalseで、1行目のデータしか見ない
'''Optional ByVal arglongIndex          読み込み開始行・・・らしいけど現状ほとんど使ってない
Public Function GetColumnWidthString(ByRef argVarData As Variant, ByRef argFont As Object, Optional ByVal arglongIndex As Long = 0, Optional ByVal boolMaxLengthFind As Boolean = False) As String
    '指定したデータ、行数（Index）から、ListBoxの幅（ポイント数を;で区切った文字列）として返す
    'MaxLengthオプションが付与されていたら、最大文字数を検索する（件数が多いと大変）
    '文字列数は、single配列で持つことにするよ
    Dim strWidth As String
    Dim intFieldCounter As Integer
    Dim longRowCounter As Long
    Dim sglArrChrLength() As Single
    Dim strarrMaxLength() As String             'フィールドごとの最長文字列を格納する配列
    On Error GoTo ErrorCatch
    'フィールド数分配列を確保
    ReDim sglArrChrLength(UBound(argVarData, 2))
    ReDim strarrMaxLength(UBound(argVarData, 2))
    '文字列配列取得
    Select Case boolMaxLengthFind
    Case True
        '最大文字数取得あり
        '全行数分ループ
        For longRowCounter = LBound(argVarData, 1) To UBound(argVarData, 1)
            For intFieldCounter = LBound(argVarData, 2) To UBound(argVarData, 2)
                '今のフィールドで、配列のほうが短ければ更新してやる
                'ついでにその時の文字列も格納する
                If IsNull(argVarData(longRowCounter, intFieldCounter)) Then
                    '中身がNullだった場合、このループでは何もしない
'                    Exit For
                End If
'                If sglArrChrLength(intFieldCounter) < LenB(argVarData(longRowCounter, intFieldCounter)) Then
                If sglArrChrLength(intFieldCounter) < modWinAPI.MesureTextWidth(CStr(argVarData(longRowCounter, intFieldCounter)), argFont.Name, argFont.Size) Then
'                    sglArrChrLength(intFieldCounter) = LenB(argVarData(longRowCounter, intFieldCounter))
                    sglArrChrLength(intFieldCounter) = modWinAPI.MesureTextWidth(CStr(argVarData(longRowCounter, intFieldCounter)), argFont.Name, argFont.Size)
                    strarrMaxLength(intFieldCounter) = CStr(argVarData(longRowCounter, intFieldCounter)) & "  "
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
            strarrMaxLength(intFieldCounter) = CStr(argVarData(arglongIndex, intFieldCounter)) & "  "
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
'                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMINIMULPOINT, sglArrChrLength(intFieldCounter) * sglChrLengthToPoint)) & "pt"
                    strWidth = strWidth & CStr(modWinAPI.MesureTextWidth(strarrMaxLength(intFieldCounter), argFont.Name, argFont.Size)) & "pt"
                End If
            Case Else
                '最初から途中の場合
                If IsNull(argVarData(arglongIndex, intFieldCounter)) Then
                    'Nullだった場合
                    strWidth = strWidth & "0 pt;"
                Else
'                    strWidth = strWidth & CStr(Application.WorksheetFunction.Max(longMINIMULPOINT, sglArrChrLength(intFieldCounter) * sglChrLengthToPoint)) & "pt;"
                    strWidth = strWidth & CStr(modWinAPI.MesureTextWidth(strarrMaxLength(intFieldCounter), argFont.Name, argFont.Size)) & "pt;"
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
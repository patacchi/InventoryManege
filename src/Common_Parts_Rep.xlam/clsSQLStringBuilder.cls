VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsSQLStringBuilder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'SQL文字操作（主に結合）のためのクラス
'開始履歴、終了履歴を設定して、文字列連結は配列のJoinで行う方向
Private strSQLBuilder As String         '最後の結果のSQL文
Private longStringLength As Long        '文字列の長さ
Private dblTimer As Double              '処理時間計測用タイマーアーアーア
'Private longRecordCount As Long         '現在の処理中データの場所（バルクの時に使う）
Private Sub Class_Initialize()
    'クラス初期化動作
    strSQLBuilder = Empty
    longStringLength = 0
End Sub
Private Sub Class_Terminate()
    'クラス破棄時に実行
    strSQLBuilder = Empty
    longStringLength = 0
End Sub
'''Author Daiske_Oota 2021_10_18
'''Printfのような関数
'''.NETのStringBuilderのAppendFormatのオーバーロード4を使用し
'''{index number 0start}形式のプレースホルダに穴埋めできる（ほかにも色々書式設定しようと思えばできる）
'''------------------------------------------------------------------------------------------------------
'''Parms
'''strargOriginString       プレースホルダ混みのオリジナル文字列
'''dicargParm               キーにインデックス番号、Itemにプレースホルダに入れるべき文字列を入れる。プレースホルダより数が少ない場合は例外がスローされる
Public Function ReplaceParm(strargOriginString As String, dicargParm As Dictionary) As String
    If strargOriginString = "" Then
        DebugMsgWithTime "ReplaceParm Orrigin String is empty"
        ReplaceParm = ""
        Exit Function
    End If
    If dicargParm.Count <= 0 Then
        '置き換え後のオブジェクト数がゼロだったら抜ける
        DebugMsgWithTime "ReplaceParm Parm list empty"
        ReplaceParm = ""
        Exit Function
    End If
    On Error GoTo ErrorCatch
    '引数のDictionaryを元にプレースホルダに対応するオブジェクトの配列を作成する
    Dim arrParm() As Variant
    ReDim arrParm(dicargParm.Count - 1)
    Dim longParmCount As Long
    For longParmCount = 0 To dicargParm.Count - 1
        arrParm(longParmCount) = dicargParm(longParmCount)
    Next longParmCount
    Dim objBuilder As Object
    Set objBuilder = CreateObject("System.Text.StringBuilder")
    ' System.Text.StringBuilder AppendFormat_4(string format, Params System.Object[] args)
    ReplaceParm = objBuilder.AppendFormat_4(strargOriginString, arrParm).ToString
'    objBuilder.Clear
    Set objBuilder = Nothing
    Exit Function
ErrorCatch:
    Set objBuilder = Nothing
    DebugMsgWithTime "ReplaceParm code: " & Err.Number & vbCrLf & " Description: " & Err.Description
    Exit Function
End Function
'''------------------------------------------------------------------------------------------------------
Private Function Append(ByVal strargOrignString As String, ByRef varAryString As Variant, Optional strDelimiter As String = ",") As String
    Dim strarrBuf() As String
    Dim longElementCount As Long
    Dim longCounter As Long
    On Error GoTo ErrorCatch
    Select Case Len(strargOrignString)
    Case 0
        '元のStringが長さ0の時は、追加の分が最初
        longElementCount = UBound(varAryString) - LBound(varAryString)
    Case Else
        '元のが文字ありだった場合
        '引数に指定されている要素数 + オリジナルのプラス一つ
        longElementCount = UBound(varAryString) - LBound(varAryString) + 1
    End Select
    ReDim strarrBuf(longElementCount)
    Select Case Len(strargOrignString)
    Case 0
        '元の長さが0の場合は追加の配列と同じでいい・・・
        strarrBuf = varAryString
    Case Else
        'オリジナルが文字ありだった場合
        'まず先頭にオリジナルのStringをくっつけてやる
        longCounter = 0
        strarrBuf(longCounter) = strargOrignString
        '追加分の配列を順番にくっつける
        For longCounter = 1 To longElementCount
            strarrBuf(longCounter) = varAryString(longCounter - (1 - LBound(varAryString)))
        Next longCounter
    End Select
    '配列に格納し終わったらJoinでStringにする
    Append = Join(strarrBuf, strDelimiter)
    Exit Function
ErrorCatch:
    DebugMsgWithTime "Append Error code: " & Err.Number & "Description: " & Err.Description
End Function
Public Function addQuote(ByVal strargOriginalString As String, Optional ByVal strQuote As String = """") As String
    '与えられた文字列に、エスケープ処理をする
    Dim strBuf(2) As String
    On Error GoTo ErrorCatch
    strBuf(0) = strQuote
    strBuf(1) = REPLACE(strargOriginalString, """", """""")
    strBuf(2) = strQuote
    addQuote = Append("", strBuf, "")
    Exit Function
ErrorCatch:
    DebugMsgWithTime "addQuote Error code: " & Err.Number & "Description: " & Err.Description
End Function
'''INVPartMasterテーブルと対応する在庫情報シートのフィールド名から UPDATE の SET パラメータや WHERE パラメータを作成する
'''対応フィールドを配列引数で受け取るよう変更 2022_01_27 Daisuke Oota
'''対応するフィールド名を = や <> で連結したStringを返す
'''各フィールド名の前には、プレフィックスとしてテーブル名の短縮名エイリアスがつく
'''戻り値 String  ex) "TDBPrts.F_INV_Tehai_Text = TTmp.手配コード,TDBPrts.F_INV_Stock_Amount = TTmp.在庫数量・・・・"
'''args
'''arrstrargFieldPair()    対応フィールドの組合せの2次元配列(元フィールド , 対応フィールド)
'''                         両方のフィールド名が同じ（テーブルプレフィックスが違う）場合は、1次元配列も指定可能
'''argReverseDic        key valueが反転したEnum Dictionaryを指定
'''PartsPrefix          PartsMasterのフィールドの前に付くプレフィックス
'''ZaikoSHPrefix        シートフィールド名の前につくプレフィックス、普通はTTmpになる
'''FieldCondition       フィールド間をつなぐ文字列の列挙体の数値
'''ConnectEnum          複数条件時の条件間をつなぐ文字列 OR とか AND とか ,とか
'''clsEnumCondition     コンストラクタ動作軽量化のためのインスタンス共有
Public Function ReturnCommonFieldCondition(arrstrargFieldPair() As String, ByRef argReverseDic As Dictionary, ByRef argNeedtrimDic As Dictionary, _
PartsPrefix As Enum_SQL_INV_Alias, ZaikoSHPrefix As Enum_SQL_INV_Alias, FieldCondition As Enum_SQL_F_Condition, _
ConnectEnum As Enum_SQL_F_Condition, ByRef clsEnumCondition As clsEnum) As String
    On Error GoTo ErrorCatch
    'クラス変数チェック
    If clsEnumCondition Is Nothing Then
        'Enumが初期化されてなかった
        DebugMsgWithTime "ReturnArrayINVPartsandZaikoSHFieldCondition: Warning!! Enum instance not initialized.will delay..."
        Set clsEnumCondition = CreateclsEnum
    End If
    If Not IsRedim(arrstrargFieldPair) Then
        DebugMsgWithTime "ReturnCommonFieldCondition: arrFieldPair is not Initialized or not Array."
        GoTo CloseAndExit
        Exit Function
    End If
    'まずはノーマルのフィールド一覧を受け取る(TRIM適用済み）x ここでTrimつけるのは早すぎる
    '引数で受け取るよう変更
'    Dim arrstrargFieldPair() As String
'    arrstrargFieldPair = clsEnumCondition.GetUpdateCommonFieldZaikSHandMParts
    Dim longArrayRowCounter As Long
    '次に各要素にテーブル名プレフィックスをつける
    Dim bytArgArrayDimention As Byte
    '引数の配列の次元数を取得
    bytArgArrayDimention = PublicModule.getArryDimmensions(arrstrargFieldPair)
    Dim arrstrAppendTablePreFix() As String
    ReDim arrstrAppendTablePreFix(UBound(arrstrargFieldPair), 1)
    '受け取った配列のサイズ分ループ
    For longArrayRowCounter = LBound(arrstrargFieldPair) To UBound(arrstrargFieldPair)
        '連結用String配列
        Dim arrstrPrefix(2) As String
        'DBPartsPrefix
        arrstrPrefix(0) = clsEnumCondition.SQL_INV_Alias(PartsPrefix)
        arrstrPrefix(1) = "."
        '配列の次元数により処理を分岐
        Select Case bytArgArrayDimention
        Case 2
            '引数が2次元だった
            arrstrPrefix(2) = arrstrargFieldPair(longArrayRowCounter, 0)
        Case 1
            '引数が1次元だった場合
            arrstrPrefix(2) = arrstrargFieldPair(longArrayRowCounter)
        End Select
        arrstrAppendTablePreFix(longArrayRowCounter, 0) = Join(arrstrPrefix, "")
        'SHPrefix
        arrstrPrefix(0) = clsEnumCondition.SQL_INV_Alias(ZaikoSHPrefix)
        arrstrPrefix(1) = "."
        '配列の次元数により処理を分岐
        Select Case bytArgArrayDimention
        Case 2
            '2次元
            arrstrPrefix(2) = arrstrargFieldPair(longArrayRowCounter, 1)
        Case 1
            '1次元
            '1次元の場合は演算子の前後でフィールド名は共通とする
            arrstrPrefix(2) = arrstrargFieldPair(longArrayRowCounter)
        End Select
        '条件によってはここでTrimをつけるかどうか判断する
'        If clsEnumCondition.IsNeedTrim(arrstrargFieldPair(longArrayRowCounter, 1), argReverseDic, argNeedtrimDic) Then
        If clsEnumCondition.IsNeedTrim(arrstrPrefix(2), argReverseDic, argNeedtrimDic) Then
            'Trimが必要
            'プレフィックス、サフィックスを付加したものを返す
            'Nullデータ排除のため、文字列形式にもIsNullでの処理を入れる 2022_01_28 Daisuke Oota
            Dim arrstrTrim(2) As String
            Dim dicReplaceCondition As Dictionary
            If dicReplaceCondition Is Nothing Then
                '初期化されてなかったら初期化する
                Set dicReplaceCondition = New Dictionary
            End If
            dicReplaceCondition.RemoveAll
            'テーブルエイリアスのプレフィックスを付加したフィールド名を置換用Dictionaryにセット
            dicReplaceCondition.Add 0, Join(arrstrPrefix, "")
            '以下の置換を実行するとIIF,ISNULL,TRIMが一気に入る
            arrstrAppendTablePreFix(longArrayRowCounter, 1) = Me.ReplaceParm(PublicConst.SQL_ISNULLTRIM_0FieldName, dicReplaceCondition)
        Else
            'Trimは不要
            'そのまま結合はしない 2022_01_27 Daisuke Oota
            'Trim不要な列は基本的に数値列で、Nullや空文字のデータがあると、WHEREで「抽出条件のデータ型が・・・」と言われるので
            'IIFとISNUMERICで数値変換できないデータは明示的に0をいれてやる
            'IIF 置換用dic
            If dicReplaceCondition Is Nothing Then
                '初期化されてなかったら初期化する
                Set dicReplaceCondition = New Dictionary
            End If
            dicReplaceCondition.RemoveAll
            dicReplaceCondition.Add 0, Join(arrstrPrefix, "")
            arrstrAppendTablePreFix(longArrayRowCounter, 1) = Me.ReplaceParm(PublicConst.SQL_ISNUMERIC_0FieldName, dicReplaceCondition)
        End If
    Next longArrayRowCounter
    '次に演算子を結合する
    '1次元に集約する
    Dim arrstrOperatorAdd() As String
    ReDim arrstrOperatorAdd(UBound(arrstrAppendTablePreFix))
    For longArrayRowCounter = LBound(arrstrAppendTablePreFix) To UBound(arrstrAppendTablePreFix)
        Dim arrstrOperator(2) As String
        arrstrOperator(0) = arrstrAppendTablePreFix(longArrayRowCounter, 0)
        arrstrOperator(1) = clsEnumCondition.SQLFieldCondition(FieldCondition)
        arrstrOperator(2) = arrstrAppendTablePreFix(longArrayRowCounter, 1)
        arrstrOperatorAdd(longArrayRowCounter) = Join(arrstrOperator, "")
    Next longArrayRowCounter
    '各条件を結合文字列で区切ってStringとして渡すが、要素が１個しかない時は不要なので処理を分岐させる
    If (UBound(arrstrOperatorAdd) - LBound(arrstrOperatorAdd)) >= 1 Then
        '要素数が2個以上ある時
        '要素を結合文字列で区切って渡す
        ReturnCommonFieldCondition = Join(arrstrOperatorAdd, clsEnumCondition.SQLFieldCondition(ConnectEnum))
    Else
        '要素が1個だけだった場合
        '最初の要素をそのまま返す
        ReturnCommonFieldCondition = arrstrOperatorAdd(LBound(arrstrOperatorAdd))
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "ReturnCommonFieldCondition code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''テーブルエイリアスを付加したフィールド名を返す
'''Return   String      完全修飾フィールド名
'''args
'''TableAlias           Enum_SQL_INV_Aliasの定数値
'''strFieldName         フィルド名
'''clsEnumField         インスタンス共有変数
'''Optional NoQuote     Trueをセットすると[]でのクォートを行わない、デフォルトはFalse(クォートする)付けたままだと一部SETの引数でエラーになる・・？
Public Function ReturnTableAliasPlusedFieldName(TableAlias As Enum_SQL_INV_Alias, strargFieldName As String, _
ByRef clsEnumField As clsEnum, Optional NoQuote As Boolean = False) As String
    If strargFieldName = "" Then
        'フィールド名が指定されてないなかったら抜ける
        DebugMsgWithTime "ReturnTahleAliasPlusedFieldName: no field name given"
        Exit Function
    End If
    '空白を含むフィールド名に対応するために[]でクオートする
    '[]でクォートするのはフィールド名のみにしないとエラーが発生することがある？(テーブルエイリアスには付けない）
    Dim strField(4) As String
    If NoQuote Then
        'クォート無しの場合
        strField(0) = ""
        strField(1) = clsEnumField.SQL_INV_Alias(TableAlias)
        strField(2) = "."
        strField(3) = strargFieldName
        strField(4) = ""
    Else
        'クォート有りの場合(デフォルト)
        strField(0) = "["
        strField(1) = clsEnumField.SQL_INV_Alias(TableAlias)
        strField(2) = "."
        strField(3) = strargFieldName
        strField(4) = "]"
    End If
    ReturnTableAliasPlusedFieldName = Join(strField, "")
    Exit Function
End Function
'''accdb,ExcelファイルフルパスからIN句の後に続く文字列を作成する
'''戻り値 String        Select FROM の IN句 ""の後に付く文字列ex)[Excel 12.0;DATABASE=R:\Tmp\Patacchi\Test Dir\Zaiko_0_Local.xls;]
'''args
'''EnumINWord          Enumの共有インスタンス
Public Function CreateAfterIN_WordFromSHFullPath(strargDBFileFullPah As String, ByRef EnumInWord As clsEnum) As String
    If strargDBFileFullPah = "" Then
        DebugMsgWithTime "CreateAfterINword: sheet file name empty"
    End If
    Dim dicExttoEnumValu As Dictionary
    '置換用Dic作成
    Dim dicReplaceParm As Dictionary
    Set dicReplaceParm = New Dictionary
    '{0}がファイルフルパスなのは確定してるのでここで入れてしまう
    dicReplaceParm.Add 0, strargDBFileFullPah
    'ファイルの拡張子により処理を分岐
    Dim fsoINWord As FileSystemObject
    Set fsoINWord = New FileSystemObject
    Dim sqlBC As clsSQLStringBuilder
    Set sqlBC = CreateclsSQLStringBuilder
    Select Case LCase(fsoINWord.GetExtensionName(strargDBFileFullPah))
    Case EnumInWord.DBFileExetension(accdb_dext)
        'accdb
        CreateAfterIN_WordFromSHFullPath = sqlBC.ReplaceParm(INV_CONST.SQL_AFTER_IN_ACCDB_0FullPath, dicReplaceParm)
    Case EnumInWord.DBFileExetension(xlam_dext), EnumInWord.DBFileExetension(xlsm_dext)
        'xlsm (xlam・・は使わないと思う)
        CreateAfterIN_WordFromSHFullPath = sqlBC.ReplaceParm(INV_CONST.SQL_AFTER_IN_XLSM_0FullPath, dicReplaceParm)
    Case EnumInWord.DBFileExetension(xlsx_dext)
        'xlsx
        CreateAfterIN_WordFromSHFullPath = sqlBC.ReplaceParm(INV_CONST.SQL_AFTER_IN_XLSX_0FullPath, dicReplaceParm)
    Case EnumInWord.DBFileExetension(xlsb_dext)
        'xlsb
        CreateAfterIN_WordFromSHFullPath = sqlBC.ReplaceParm(INV_CONST.SQL_AFTER_IN_XLSB_0FullPath, dicReplaceParm)
    Case EnumInWord.DBFileExetension(xls_dext)
        'xls
        CreateAfterIN_WordFromSHFullPath = sqlBC.ReplaceParm(INV_CONST.SQL_AFTER_IN_XLS_0FullPath, dicReplaceParm)
    Case Else
        'それ以外は（CSVも含めて）対応なしの予定
        DebugMsgWithTime "CreateAfterINWordFromSHFullPath: no support extention: " & LCase(fsoINWord.GetExtensionName(strargDBFileFullPah))
        CreateAfterIN_WordFromSHFullPath = ""
    End Select
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "CreateAfterINWordFromSHFullPath code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Set dicReplaceParm = Nothing
    Set fsoINWord = Nothing
    Exit Function
End Function
'''AdoHandleより返された2次元配列を1次元配列に置き換えて返す
'''Return Variant配列   引数の2次元配列のうち、最初の次元のデータしか有効にならない
Public Function SQLResutArrayto1Dimmention(varargArr2Demmention As Variant) As Variant
    On Error GoTo ErrorCatch
    If Not IsRedim(varargArr2Demmention) Or getArryDimmensions(varargArr2Demmention) <> 2 Then
        DebugMsgWithTime "arg array not AdoHandle Return array"
        GoTo CloseAndExit
    End If
    If UBound(varargArr2Demmention, 2) - LBound(varargArr2Demmention, 2) <> 0 Then
        '2次元目の要素数が1個以外だった
        DebugMsgWithTime "SWLResultArrayto1Dimmention: Dimmention 2 have not 1 elements"
        GoTo CloseAndExit
    End If
    '配列の要素数分ループ
    Dim vararr1Dimmention As Variant
    '配列のサイズを初期化
    ReDim vararr1Dimmention(UBound(varargArr2Demmention, 1))
    Dim longArrayRowCounter As Long
    For longArrayRowCounter = LBound(varargArr2Demmention, 1) To UBound(varargArr2Demmention, 1)
        vararr1Dimmention(longArrayRowCounter) = varargArr2Demmention(longArrayRowCounter, 0)
    Next longArrayRowCounter
    '結果を返す
    SQLResutArrayto1Dimmention = vararr1Dimmention
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "SQLResultArrayto1Dimention code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''プロパティのdicObjToFieldNameより全フィールド選択のSELECT 引数を作成する
'''戻り値   string      SELECTの後にくっつけて使用する
'''args
'''argdicObjToField     ObjectName から フィールド名（テーブル名エイリアスプレフィックス付き）の対応をセットしたDictionary
Public Function GetSELECTfieldListFromDicObjctToFieldName(ByRef argdicObjToField As Dictionary) As String
    On Error GoTo ErrorCatch
    '引数チェック
    If argdicObjToField Is Nothing Then
        DebugMsgWithTime "GetSELECTfieldListFromDicObjctToFieldName : argDic not initialized..."
        GetSELECTfieldListFromDicObjctToFieldName = ""
        GoTo CloseAndExit
    End If
    'dicobj.count分の配列を定義
    Dim strarrSELECTfield() As String
    ReDim strarrSELECTfield(argdicObjToField.Count - 1)
    Dim varKeyDicObj As Variant
    Dim longArrRowCounter As Long
    longArrRowCounter = 0
    'フィールド重複チェック用Dictionary定義
    Dim dicCheckDistinct As Dictionary
    Set dicCheckDistinct = New Dictionary
    For Each varKeyDicObj In argdicObjToField
        '配列にフィールド名を格納していく
        'フィールド名を明示的に指定しないとSELECTした結果がエイリアス外されちゃう
        'ついでにドットは特殊文字扱いされるのでRelaceしなきゃだめ
        'AS の後ろは何をしてもピリオドは使用不可だった
        Dim strarrPlusAlias(2) As String
        strarrPlusAlias(0) = argdicObjToField(varKeyDicObj)
        strarrPlusAlias(1) = " AS "
        strarrPlusAlias(2) = REPLACE(strarrPlusAlias(0), ".", "_")
        'ここでフィールド重複チェックをする
        'フィルタ用のテキストボックスと更新用のテキストボックス二つで同じフィールドを使用することがあるため
        If dicCheckDistinct.Exists(Join(strarrPlusAlias, "")) Then
            '既に同じフィールドが存在していた場合
            '結果配列のサイズをひとつ切り下げる
            ReDim Preserve strarrSELECTfield(UBound(strarrSELECTfield) - 1)
            'このループでは何もしない
        Else
            '重複がなかった場合(通常動作)
            '重複チェック用Dictionaryに項目追加
            dicCheckDistinct.Add Join(strarrPlusAlias, ""), Empty
            '結果配列にも追加
            strarrSELECTfield(longArrRowCounter) = Join(strarrPlusAlias, "")
            '配列の行カウンターをインクリメント
            longArrRowCounter = longArrRowCounter + 1
        End If
    Next varKeyDicObj
    '結果を返す
    GetSELECTfieldListFromDicObjctToFieldName = Join(strarrSELECTfield, ",")
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "GetSELECTfieldListFromDicObjctToFieldName code: " & Err.Number & " Descriptoin: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''dicObjFieldとフィールド名を引数に取り、ドット(.)をアンダースコート(_)に変換し、なおかつ前後の[]クオートを外したものを返す
'''RSに収納後のFieldsの引数として使う
'''args
'''dicargObjToField     objToFieldのDictionaryの参照
'''strargContrlName     objToFielcのkey、コントロール.nameになってるはず
Public Function RepDotField(ByRef dicargObjToField As Dictionary, strargContrlName As String) As String
    If Not dicargObjToField.Exists(strargContrlName) Then
        '指定されたフィールド名が存在しなかったら抜ける
        RepDotField = ""
        DebugMsgWithTime "RepDotField : ControlName not found : " & strargContrlName
        GoTo CloseAndExit
        Exit Function
    End If
    'Replace入れ子にして結果を返す
    RepDotField = REPLACE(REPLACE(REPLACE(dicargObjToField(strargContrlName), "[", ""), "]", ""), ".", "_")
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "RepDotField coce: " & Err.Number & " Description:" & Err.Description
    RepDotField = ""
    GoTo CloseAndExit
CloseAndExit:
    Exit Function
End Function
'''引数のRSより指定されたフィールドの1次元配列(Variant)を返す
'''return Variant()     指定されたフィールドの値を入れた1次元配列(タイトルはなし)、指定されたフィールドで昇順並び替えを行う
'''args
'''argRS                    大元のデータが入ったRecordSet
'''strargFieldName          対象となるフィールド名
'''Optional strargFilter    フィルタ文字列があれば、'%引数%'という風にセットする、デフォルトは""(無し)
Public Function Get1DimentionVarArrFromRS(ByRef argRS As ADODB.Recordset, strargFieldName As String, Optional strargFilter As String = "") As Variant
    On Error GoTo ErrorCatch
    '引数チェック
    If argRS Is Nothing Or strargFieldName = "" Then
        DebugMsgWithTime "Get1DimentionVarArrFromRS : arg is nothing or empty"
        GoTo CloseAndExit
        Set Get1DimentionVarArrFromRS = Empty
        Exit Function
    End If
    'フィルタを一旦解除する
    argRS.Filter = adFilterNone
    If argRS.BOF And argRS.EOF Then
        'データがなかった
        DebugMsgWithTime "Get1DimentionVarArrFromRS : no data avilable"
        MsgBox "Get1DimentionVarArrFromRS:引数で与えられたRecordsetにデータがありませんでした。"
        Get1DimentionVarArrFromRS = Empty
        GoTo CloseAndExit
        Exit Function
    End If
    'フィルタが指定されていればフィルタかけてやる
    Select Case True
    Case strargFilter <> ""
        'フィル文字列が指定されている場合
        Dim strarrFilter(3) As String
        strarrFilter(0) = strargFieldName
        strarrFilter(1) = " Like '%"
        strarrFilter(2) = strargFilter
        strarrFilter(3) = "%'"
        'RSのFilterにセットしてやる
        argRS.Filter = Join(strarrFilter, "")
    End Select
    'フィルタ処理後レコードなければ抜ける
    If argRS.BOF And argRS.EOF Then
        DebugMsgWithTime "Get1DimentionVarArrFromRS : No recored found filter: " & argRS.Filter
        'ここではメッセージボックスは表示しない、新規追加時など件数0が正の動きをするものがあるため
'            MsgBox "フィルタ処理後のレコード件数が0でした。"
        Get1DimentionVarArrFromRS = Empty
        GoTo CloseAndExit
        Exit Function
    End If
    If argRS.CursorLocation = adUseClient Then
        'クライアントカーソルの場合
        '昇順ソート
        Dim strarrSort(1) As String
        strarrSort(0) = strargFieldName
        strarrSort(1) = " ASC"
        argRS.Sort = Join(strarrSort, "")
    End If
    '結果格納開始
    '重複確認のため一旦Dictionaryに格納
    '重複は排除、Nullは格納しない
    Dim dicResult As Dictionary
    Set dicResult = New Dictionary
    '明示的にMoveFirst
    argRS.MoveFirst
    'EOFまでループ
    Do
        Select Case True
        Case IsNull(argRS.Fields(strargFieldName).Value), argRS.Fields(strargFieldName).Value = ""
            'データがNullだった
            'そのレコードはスキップする
            DebugMsgWithTime "Get1DimentionVarArrFromRS :Skip cause Null data "
        Case dicResult.Exists(argRS.Fields(strargFieldName).Value)
            '既に値が存在した場合もスキップ
            DebugMsgWithTime "Get1DimentionVarArrFromRS : Skip cause AlreadyDataExists"
        Case Else
            'それ以外の場合は値をDictonaryに格納
            dicResult.Add argRS.Fields(strargFieldName).Value, Empty
        End Select
        '次のレコードへ
        argRS.MoveNext
    Loop Until argRS.EOF
    '次のために最初のレコードに移動しておく
    argRS.MoveFirst
    'ここまでで重複、Null排除が終わってるのでDictionaryの要素を全ループし、1次元配列に格納する
    Dim vararrResult() As Variant
    ReDim vararrResult(dicResult.Count - 1)
    Dim longArrCounter As Long
    longArrCounter = 0
    Dim varKeyDic As Variant
    For Each varKeyDic In dicResult
        '1次元配列にDictionaryのKeyを格納
        vararrResult(longArrCounter) = varKeyDic
        '配列の行カウンターをインクリメント
        longArrCounter = longArrCounter + 1
    Next varKeyDic
    Get1DimentionVarArrFromRS = vararrResult
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "Get1DimentionVarArrFromRS code: " & Err.Number & " Description: " & Err.Description
    Set Get1DimentionVarArrFromRS = Nothing
    GoTo CloseAndExit
CloseAndExit:
    Set dicResult = Nothing
    Exit Function
End Function
'''配列を引数として、binLabelのMailMergeのWhere条件の設定
'''テーブルプリフィックスなし、フィールド名順序固定等簡素化した内容になっている
'''Return String    Where の条件、フィールド間は AND で結合し、 条件間はORで結合する
'''args
'''varargArray      元になる配列、1次元目はSavePoint、2次元目はFormStartTime
Public Function ReturnMailMergeWhere(varargArray As Variant) As String
    If Not IsRedim(varargArray) Then
        '配列じゃないっぽいのが返ってきた
        DebugMsgWithTime "ReturnMailMergeWhere : arg not array"
        MsgBox "ReturnMailMergeWhere : 引数が配列では有りませんでした"
        ReturnMailMergeWhere = ""
        Exit Function
    End If
    If getArryDimmensions(varargArray) < 2 Then
        MsgBox "配列の次元数が少なすぎます"
        ReturnMailMergeWhere = ""
    End If
    '引数の要素分のString配列を定義
    Dim strarrWork() As String
    ReDim strarrWork(UBound(varargArray, 1))
    Dim longArrayRowCounter As Long
    '引数の全要素ループ
    For longArrayRowCounter = LBound(varargArray, 1) To UBound(varargArray, 1)
        'Quoteした文字列をセット
        '(SavePoint = xx AND InputDate = YY) OR (・・・
        Dim strarrPart(8) As String
        strarrPart(0) = "(["
        strarrPart(1) = INV_CONST.F_INV_LABEL_TEMP_SAVEPOINT
        strarrPart(2) = "] = "
        strarrPart(3) = addQuote(varargArray(longArrayRowCounter, 0))
        strarrPart(4) = " AND ["
        strarrPart(5) = INV_CONST.F_INV_LABEL_TEMP_FORMSTARTTIME
        strarrPart(6) = "] = "
        strarrPart(7) = addQuote(varargArray(longArrayRowCounter, 1))
        strarrPart(8) = ")"
        strarrWork(longArrayRowCounter) = Join(strarrPart, "")
    Next longArrayRowCounter
    'Joinした結果を返す
    ReturnMailMergeWhere = Join(strarrWork, " OR ")
End Function
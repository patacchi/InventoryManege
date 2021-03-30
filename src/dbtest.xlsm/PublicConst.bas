Attribute VB_Name = "PublicConst"
Option Explicit
'office 2013導入により、mdbからaccdb形式に移行
'DBをSQLite3に移行  2021_01_10 Pataccchi
Public Const constDatabasePath              As String = "\\toshiba.local\adsf\tdms_js_js\（実装）SMTグループ\SMT計画#2\中量産(LINE4)\JobNumberManege\Database"      'データベースディレクトリ
Public Const constJobNumberDBname           As String = "JobNumberDB.sqlite3"   'ジョブ番号情報DBのファイル名
Public Const LocalTempDBDir                 As String = "TempDB"                'ローカルコピー機能使用時のTempDBの置き場所
Public Const LocalDBName                    As String = "LocalDB.sqlite3"       'ローカル時のDBファイル名
Public Const Field_Initialdate              As String = "InitialInputDate"      '各テーブル共通、初回入力時刻
Public Const Field_Update                   As String = "UpdateDate"            '各テーブル共通、最終更新時刻
Public Const Field_BarcordeNumber           As String = "BarcodeNumber"         'テーブル共通、トレサIDバーコードデータ
Public Const Field_LocalInput               As String = "LocalInput"            'テーブル共通、ローカル入力時 1（ローカル・リモートバックアップ判定）
Public Const Field_RemoteInput              As String = "RemoteInput"           'テーブル共通、リモート入力時 1（こっちが本体になるはず）
'ジョブ番号管理DBテーブル・フィールド名定義
'Jsonテーブル
Public Const Table_JSON                     As String = "T_JSON"                'JSON情報格納テーブル
Public Const JSON_Field_Name                As String = "Name"                  'JSONルート識別名 TEXT NOT NULL UNIQUE
Public Const JSON_Field_string              As String = "JSON_String"           'JSON本体格納
'機種別情報格納テーブル定義
Public Const Table_Kishu                    As String = "T_Kishu"               '機種別情報格納テーブル名
Public Const Kishu_Header                   As String = "KishuHeader"           '機種判別用ヘッダ情報フィールド（重複不可）
Public Const Kishu_KishuName                As String = "KishuName"             '機種名フィールド P70664A
Public Const Kishu_KishuNickname            As String = "KishuNickName"         '機種通称名 マスター
Public Const Kishu_TotalKeta                As String = "TotalRirekiketa"       '総桁数フィールド（多分20しかないと思う）
Public Const Kishu_RenbanKetasuu            As String = "RenbanKetasuu"         '連番桁数フィールド
Public Const Kishu_Mai_Per_Sheet            As String = "Mai_Per_Sheet"         '1シートあたりの枚数
Public Const Kishu_Sheet_Per_Rack           As String = "Sheet_Per_Rack"        '1ラックあたりのシート数
Public Const Kishu_Barcord_Read_Number      As String = "Barcord_Read_Number"   'バーコード読み取り数
Public Const Kishu_Jobnumber_Lastnumber     As String = "JobNumber_LastNumber"  'Job登録した際の履歴連番の最大値
Public Const Kishu_Kanbanchr_Lastnumber     As String = "KanbanChr_LastNumber"  '看板分割の履歴連番の最大値
'ログ情報格納テーブル定義
'ログは基本的にトリガーで入力する
Public Const Table_Log                      As String = "T_Log"                 'ログ情報テーブル名
Public Const Log_ActionType                 As String = "ActionType"            'INSERT,UPDATE,DELETEのいずれかが入る
Public Const Log_Table                      As String = "TableName"             'テーブル名
Public Const Log_StartRireki                As String = "StartRireki"           '(INSERT)開始履歴
Public Const Log_Maisuu                     As String = "Maisuu"                '(INSERT)枚数
Public Const Log_JobNumber                  As String = "JobNumber"             '(INSERT) T_JobData_ ジョブ番号
Public Const Log_RirekiHeader               As String = "RirekiHeader"          '(INSERT) T_JobData_ 履歴ヘッダ
Public Const Log_BarcordNumber              As String = "BarcodeNumber"         '(INSERT) T_Barcode_ バーコード番号
Public Const Log_SQL                        As String = "SQL"                   '(UPDATE,DELETE)この場合はSQLのみ格納
'ジョブ・履歴情報テーブル定義
Public Const Table_JobDataPri               As String = "T_JobData_"            'ジョブ履歴テーブル名前半部分、実際はこの後に機種名が連結されてテーブル名となる
Public Const Job_Number                     As String = "JobNumber"             'ジョブ番号フィールド名
Public Const Job_RirekiHeader               As String = "RirekiHeader"          '履歴ヘッダフィールド名
Public Const Job_RirekiNumber               As String = "RirekiNumber"          '履歴の連番部分（Longで格納）
Public Const Job_Rireki                     As String = "Rireki"                'ヘッダ+履歴連番（作成するか要検討）
Public Const Job_KanbanChr                  As String = "KanbanChr"             'カンバン分割文字列
Public Const Job_KanbanNumber               As String = "KanbanNumber"          'カンバン分割番号(B) 30←ココ Integer
Public Const Job_ProductDate                As String = "ProductDate"           '製造予定日（計画引き当てに使う）
'こっちは全部機種別にテーブルを分ける
'通常バーコード記録テーブル
Public Const Table_Barcodepri               As String = "T_Barcode_"            '機種別バーコード入力情報テーブル、実際は後半に機種名が連結される
Public Const Laser_Rireki                   As String = "LaserRirekiNumber"       'レーザーの履歴番号格納フィールド（Longで格納）、重複不可
'再印字等バーコード記録テーブル
Public Const Table_Retrypri                 As String = "T_Retry_"              '機種別再印字バーコード履歴格納テーブル、実際は後半に機種名が連結される
Public Const Retry_Rireki                   As String = "LaserRetryRireki"      '再印字の履歴フィールド名（Longで格納）、再印字は履歴重複OK
Public Const Retry_Reason                   As String = "RetryReason"           '再印字理由フィールド
'フィールド追加用SQL定型文
Public Const strOLDAddField1_NextTableName     As String = "ALTER TABLE """        '追加の最初、この次にテーブル名が入る
Public Const strOLDAddField2_NextFieldName     As String = """ ADD COLUMN """      '二番目、この次にフィールド名が入る
Public Const strOLDAddField3_Text_Last         As String = """ TEXT;"              '最後、ただしTEXT型の場合
Public Const strOLDAddField3_Numeric_Last      As String = """ NUMERIC;"           '数値の場合の最後
Public Const strOLDAddField3_JSON_Last         As String = """ JSON;"              'JSONラスト
'インデックス追加用SQL定型文
Public Const strOLDIndex1_NextTable            As String = "CREATE INDEX IF NOT EXISTS ""ixJob_"
Public Const strOLDIndex2_NextTable            As String = """ ON """
Public Const strOLDIndex3_Field1               As String = """ ("""
Public Const strOLDIndex4_FieldNext            As String = """ ASC ,"""            '複数フィールドに対して実行する場合は、以後これの繰り返し
Public Const strOLDIndex5_Last                 As String = """ ASC);"
'テーブル追加用SQL定型文
Public Const strTable1_NextTable                As String = "CREATE TABLE IF NOT EXISTS " 'CRLF付加、およびフィールド制約追加対応テンプレ
Public Const strTable2_Next1stField             As String = " (" & vbCrLf           'CRLF対応作成テンプレ、こちらを使う場合はAddQuoteを使ってエスケープ処理すること
'フィールド定義、フィールド名（クオート）→3(型名)→[Append](各種制約、あれば)→(EndRow)の流れ
Public Const strTable3_TEXT                     As String = " TEXT "                '前がTEXT
Public Const strTable3_NUMERIC                  As String = " NUMERIC "             '前がNUMERIC
Public Const strTable3_JSON                     As String = " JSON "                '前がJSON
Public Const strTable_NotNull                   As String = " NOT NULL "            'NOT NULL制約追加
Public Const strTable_Unique                    As String = " UNIQUE "              'UNIQUE制約追加
Public Const strTable_Default                   As String = " DEFAULT "             'DEFAULT追加、この後にデフォルト値をクオート処理して追加すること
Public Const strTable4_EndRow                   As String = "," & vbCrLf            '行の終わり、まだ続きがある場合
Public Const strTable5_EndSQL                   As String = ");" & vbCrLf           'SQL文の終わり
Public Const strOLDAddTable1_NextTable          As String = "CREATE TABLE IF NOT EXISTS """ 'テーブル追加用定型文ここから
Public Const strOLDAddTable2_Field1_Next_Field  As String = """ ("""                'フィールドの最初だけこいつを使う、次に最初のフィールド名
Public Const strOLDAddTable_TEXT_Next_Field     As String = """ TEXT,"""            '紛らわしいけど、「前」がText型の場合こっちを使う、次にフィールド名が続く
Public Const strOLDAddTable_TEXT_UNIQUE_Next_Field As String = """ TEXT UNIQUE,"""  '前がTEXT かつ UNIQUEの場合
Public Const strOLDAddTable_NUMELIC_Next_Field  As String = """ NUMERIC,"""         '「前」がNumericの場合はこっち
Public Const strOLDAddTable_Text_Last           As String = """ TEXT);"             'メンドウなので、最後はTextで終わらせて・・・
Public Const strOLDAddTable_Numeric_Last        As String = """ NUMERIC);"          '一応数値型で終わるやつも
'シート情報格納関係定数
Public Const constMaisuu_Label                  As String = "Maisuu"                '履歴枚数（単独セル参照）名前定義
Public Const constRirekiFromLabel               As String = "Rireki_From"           '履歴From（単独セル参照）名前定義
Public Const constRirekiToLabel                 As String = "Rireki_To"             '履歴To（単独セル参照）名前定義
Public Const constMaxRirekiKetasuu              As Byte = 20                        '履歴桁数のMax値
Public Const constDefaultArraySize              As Long = 6000                      'DBからの結果セットの配列の初期上限
Public Const constAddArraySize                  As Long = 2000                      '配列確保行数が足りなくなった場合の1回で増量する分
'機種テーブル、最終履歴番号（連番）取得の種類設定（今のところ看板分割かJob番号かの選択）
Public Const JOBNUMBER_LASTNUMBER         As Long = 0                         'Job番号の最終連番の場合
Public Const KANBANCHR_LASTNUMBER         As Long = 1                         '看板分割の最終連番の場合
Public Enum LastRirekiNumber
    JobNumberField = JOBNUMBER_LASTNUMBER
    KanbanChrField = KANBANCHR_LASTNUMBER
End Enum
'エラーコード定義（もう使わないかも・・・
Public Const errcNone                       As Integer = 0                      '正常終了
Public Const errcDBAlreadyExistValue        As Integer = -2                      '既に同じ値がDB上に有る場合
Public Const errcDBFileNotFound             As Integer = -4                      'DBファイル見つからないよぅ
Public Const errcDBFieldNotFont             As Integer = -8                      'DBで指定されたフィールドが見つからない
Public Const errcxlNameNotFound             As Integer = -16                     'Excelで名前定義が見つからない
Public Const errcxlDataNothing              As Integer = -32                     'ExcelでデータNothing
Public Const errcOthers                     As Integer = -16384                  'その他エラー
'機種情報を格納する構造体
Public Type typKishuInfo
    KishuHeader As String
    KishuName As String
    KishuNickName As String
    TotalRirekiketa As Byte
    RenbanKetasuu As Byte
    MaiPerSheet As Byte
    SheetPerRack As Byte
    BarcordReadNumber As Byte
End Type
'Jobの情報を受け取る構造体を定義
Public Type typJobInfo
    StartNumber As Long
    startRireki As String
    EndNumber  As Long
    EndRireki As String
    JobNumber As String
    InitialDate As String
End Type
'QRコード読み取り時の情報を格納する構造体
Public Type typQRDataField
    JobNumber As String
    Zuban As String
    Maisuu As Integer
End Type
'看板作成に必要な情報をまとめた構造体
Public Type typKanbanInput
    Zuban As String                         '図番（機種ニックネーム）
    Maisu_Current As Integer                '枚数（看板毎、最後の1枚以外はずっと変わらないはず）
    JobNumber_with_KanbanChr As String      'Job番号+看板分割文字（ZT012345_sp3_0001(_sp3_AX)(KanbanChr)）
    RackNumber_Now_and_Total As String      '3桁揃え（現在ラック）/3桁揃え（合計ラック） 先頭に空白3つを結合し、Rightで3
    JobMaisuu As Long                       'Jobのトータル枚数
    FromRireki As String                    'From履歴
    ToRireki As String                      'To履歴
    QRQty   As Long                         'QRコード完了数、Jobのスタートからの枚数になる
    KouteiNo() As String                    '行程Noの1次元配列
    KouteiMei() As String                   '行程名の1次元配列
End Type
Public arrKishuInfoGlobal() As typKishuInfo
'QR読んだらぐろばんる変数で保持してるので、そこに入力してやる(フォーム間のデータ受け渡しになるため）
Public QRField As typQRDataField
'いんすーとする時のフィールド定義をもうここでハードコーディングしちゃう・・・
'テーブルが増えるたびに記述すること・・・
'どうやら配列は定数に出来ないようなので、SQLBuilderのコンストラクタ内で初期化する
Public arrFieldList_JobData() As String                                         'JobDataテーブルのフィールド定義
Public arrFieldList_Barcode() As String                                         'Barcodeテーブルのフィールド定義
Public arrFieldList_Retry() As String                                           'Retryテーブルのフィールド定義
Public strRegistRireki As String                                                '機種登録時履歴、フォーム間の受け渡しに使う
'Public strQRZuban As String                                                     '指示書QRコード読み取り時の図番格納、主に機種登録で使う
Public boolRegistOK As Boolean                                                  '機種登録が成功したらTrueフラグを立てる
Public boolNoTableKishuRecord As Boolean                                        '機種テーブルにデータが存在しない場合True、初期のみ
'-------リスト表示のための定数定義
'MS ゴシック（等幅）文字サイズ9ptの場合
Public Const sglChrLengthToPoint = 3.3
Public Const longMinimulPpiont = 50
'------------------------------------ここからJSONのターン---------------------------------
'各Jsonファイルには、Name キーが必須、この名前でDBのNameに登録される
Public Const JSON_File_InitialDB                As String = "InitialTable.json"     '初期テーブル情報格納JSON
Public Const JSON_TableSetting_NextTableName    As String = "TableSetting"          'JSONで、テーブル定義のルート要素、JSONテーブルのNameに入る
Public Const JSON_Table_SQL                     As String = "SQL"                   'テーブル作成時の初期SQL→SQLをそのまま入れてやる
Public Const JSON_Table_Description             As String = "Description"           'テーブルの説明（後で）
Public Const JSON_AppendField                   As String = "AppendField"           '追加フィールド定義開始（またDictionary）
Public Const JSON_BarcordSheetSetting           As String = "BarcordeSheet"         'JSON バーコードシート定義ルート、JSONテーブルのNameに入る
'-----------------------------------看板作成関係------------------------------------------
Public Const Kanban_Json_Root                   As String = "KanbanTemplate"    '看板テンプレートのJSONのName、この名前がJSONテーブルのNameに入る
'Jsonは、ルート（KanbanTempLate）下にテンプレ名、その下にKoutei1、その下にKoutei_NoとKoutei_MeiMei
Public Const nameKanbanZuban                    As String = "Zuban"             '看板作成テンプレートにおいての図番名前定義
Public Const nameKanbanMaisuu                   As String = "KanbanMaisu"       '看板の枚数、その看板に収納される枚数、E74だと68枚とか
Public Const nameJobNumber                      As String = "KanbanJobNumber"   '看板のJob番号
Public Const nameRackNumber                     As String = "RackNumber"        '看板のラック数、現在ラック数/合計ラック数
Public Const nameJobMaisuu                      As String = "JobMaisuu"         '看板のJobの合計枚数
Public Const nameFromRireki                     As String = "FromRireki"        'バーコード用の開始履歴
Public Const nameToRireki                       As String = "ToRireki"          'バーコード用の終了履歴
Public Const nameQRQty                          As String = "QRQty"             'QRコードの完了数、今まで電卓で計算してたやつ
Public Const nameRangeKouteiNo                  As String = "RangeKouteiNo"     '工程NoのRange、セル結合してる関係上Noと工程名と別にする
Public Const nameRangeKouteiName                As String = "RangeKouteiName"   '工程名Range
Public Const MIN_Kanban_ChrCode                 As Byte = 65                    '看板文字列の文字コードの最小値（A）
Public Const MAX_Kanban_ChrCode                 As Byte = 90                    '看板文字列の文字コードの最大値（Z)
Public Const BarCodeHeight                      As Double = 39.75               '高さ 何故かバーコードコントロールのサイズ変わっちゃうので、ここで再設定・・・
Public Const BarCodeWidth                       As Double = 74.25               '幅
Public Const BarcodeTop                         As Double = 64.5                '上原点
Public Const BarcodeFromLeft                    As Double = 278.25              'From左原点
Public Const BarcodeToLeft                      As Double = 462                 'To左原点
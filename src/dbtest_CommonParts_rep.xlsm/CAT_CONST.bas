Attribute VB_Name = "CAT_CONST"
Option Explicit
'''CATテーブルに関する定数を置いておく
'Global
Public Const CAT_DB_FILENAME As String = "CAT_Find.accdb"                   'CATコードのDBファイル名
'各テーブルにはDefaultとしてInputDateが入る
Public Const INPUT_DATE As String = "InputDate"
'Header
Public Const T_CAT_HEADER As String = "T_CAT_Header"                        'CATコードのヘッダ情報を詰め込んだテーブル（起点）
Public Const F_CAT_HEADER As String = "F_CAT_Header"                        'CATヘッダのフィールド名
Public Const F_CAT_DESCRIPTIONTABLE As String = "F_CAT_DescriptionTable"    'Descriptionテーブルのフィールド名
Public Const F_CAT_DETAILTABLE As String = "F_CAT_DetailTable"              '詳細（仕様）テーブル名のフィールド名
Public Const F_CAT_SPECIALTABLE As String = "F_CAT_SpecialTable"            '特殊条件を記載したテーブル名のフィールド名
'（各機種）_Description
'各桁の概要（種類）を格納する テーブル名は T_CAT_（各機種名）_Description とする
'説明自体は外部キーとして設定し、親テーブルはT_CAT_M_Descriptionとする
'数機種で共有する前提で設計する
Public Const T_CAT_DESCRIPTION_0kishu As String = "T_CAT_{0}_Description"   'Detailテーブル名 {0}に各機種を埋め込む
Public Const F_CAT_DIGITID As String = "F_CAT_Digit_Row"                    '桁数のフラグを立てたLongの数字。n桁目は、2^(n-1) 3桁の時は2^2で4
Public Const F_CAT_DIGITOFFSET As String = "F_CAT_DigitOffset"              'ヘッダの文字の最後を0とした文字位置のオフセット（最初は1から始まる）
Public Const F_CAT_ID_DESCRIPTION As String = "F_CAT_Description_ID"        'DescriptionのIDが入る
'（各機種）_Detail
'CATコードの各桁位置に対する説明を格納する（メインテーブル）
'テーブル名は T_CAT_（各機種名）_Detailとする 一つのテーブルに複数機種を格納する可能性がある
Public Const T_CAT_DETAIL_0kishu As String = "T_CAT_{0}_Detail"             '{0}に機種名を埋め込む
'F_CAT_DIGITIDはDescriptionと同じフィールド名
Public Const F_CAT_CHR As String = "F_CAT_Chr"                              'その桁に入る文字列
Public Const F_CAT_ID_DETAIL As String = "F_CAT_Detail_ID"                  'DetailのIDが入る
'（各機種）_Special
'特殊な組み合わせで表現が変わるものを集めたテーブル
'条件、結果（改変実行）どちらもJSONで格納する
Public Const T_CAT_SPECIAL_0kishu As String = "T_CAT_{0}_Special"           '{0}に機種名が入る
Public Const F_CAT_CONDITION As String = "F_CAT_Condition"                  '条件をJSONで格納
Public Const F_CAT_EXECUTE As String = "F_CAT_Excute"                       '改変する内容をJSONで格納
'Descriptionマスターテーブル
'実際の概要はこっちに入る。親テーブル
Public Const T_CAT_Description_MASTER As String = "T_CAT_M_Description"     'Descriptionのマスター
'F_CAT_DescriptionID
'F_CAT_DigitID
'は各機種_Descriptionテーブルと共用
Public Const F_DESCRIPTION As String = "F_CAT_Description"                  '実際の概要の内容が入るフィールド
'Detailマスターテーブル
'Descriptionと大体同じ
'F_CAT_ID_Detail
'F_CAT_DigitID
'F_CAT_Chr
'は各機種_Detailと共用
Public Const F_DETAIL As String = "F_CAT_Detail"                            '実際の仕様詳細が入るフィールド
'桁数マスターテーブル
Public Const T_CAT_DIGIT_MASTER As String = "T_CAT_M_Digit"                 '桁数とLongの数の対応テーブル
Public Const F_CAT_DIGIT_ROW As String = "F_CAT_Digit_"
'F_CAT_DIGITID
'SQL定義
'既存機種用に機種名一覧を取り出すSQL
Public Const SQL_KISHU_LIST As String = "SELECT " & F_CAT_HEADER & "," & F_CAT_DESCRIPTIONTABLE & "," & F_CAT_DETAILTABLE & "," & F_CAT_SPECIALTABLE & vbCrLf _
                                        & " FROM " & T_CAT_HEADER
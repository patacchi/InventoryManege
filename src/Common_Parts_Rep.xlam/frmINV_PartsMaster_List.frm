VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmINV_PartsMaster_List 
   Caption         =   "在庫情報マスター表示画面"
   ClientHeight    =   3765
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   15120
   OleObjectBlob   =   "frmINV_PartsMaster_List.frx":0000
   ShowModal       =   0   'False
   StartUpPosition =   1  'オーナー フォームの中央
End
Attribute VB_Name = "frmINV_PartsMaster_List"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'フォーム内共通のメンバ変数を定義
'インスタンス共有変数
Private clsADOfrmPMList As clsADOHandle
Private clsINVDBfrmPMList As clsINVDB
Private clsEnumPMList As clsEnum
Private clsSQLBc As clsSQLStringBuilder
Private clsIncrementalParts As clsIncrementalSerch
Private clsGetIEfrmPMList As clsGetIE
Private objExcelfrmPMList As Excel.Application
'keyがオブジェクト名で、値がテーブルエイリアス付きのフィールド名
Private dicObjNameToFieldName As Dictionary
'Replace用Dictionary
Private dicReplacePartsMaster As Dictionary
'イベント停止フラグ
Private StopEvents As Boolean
'定数定義
Private Const TEXT_BOX_NAME_PREFIX As String = "txtBox_"
Private Const LABEL_NAME_PREFIX As String = "lbl_"
'''TanaマスターのLocal_Textを一括設定する
'''Nullになっている場所をSystem_Textの物で設定してやる
Private Sub btnTehai_Text_Local_Set_All_Click()
    On Error GoTo ErrorCatch
    'クラス変数の確認
    If clsADOfrmPMList Is Nothing Then
        Set clsADOfrmPMList = CreateclsADOHandleInstance
    End If
    If clsEnumPMList Is Nothing Then
        Set clsEnumPMList = CreateclsEnum
    End If
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
    End If
    'Set
    Dim strSetCondition As String
    Dim strarrSetCondition(2) As String
    '何故かここは[]クォート外さないと動かない・・？
    strarrSetCondition(0) = clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_Local_Text_IMT), clsEnumPMList, True)
    strarrSetCondition(1) = " = "
    strarrSetCondition(2) = clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_System_Text_IMT), clsEnumPMList)
    strSetCondition = Join(strarrSetCondition, "")
    'WHERE
    Dim strWHEREcondition As String
    Dim strarrWhere(2) As String
    strarrWhere(0) = "AND "
    strarrWhere(1) = clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_Local_Text_IMT), clsEnumPMList)
    strarrWhere(2) = " IS NULL"
    strWHEREcondition = Join(strarrWhere, "")
    '置換用dictionary構築
    Dim dicReplaceWHERE As Dictionary
    Set dicReplaceWHERE = New Dictionary
    dicReplaceWHERE.Add 0, INV_CONST.T_INV_M_Tana
    dicReplaceWHERE.Add 1, clsEnumPMList.SQL_INV_Alias(INVDB_Tana_Alias_sia)
    dicReplaceWHERE.Add 2, strSetCondition
    dicReplaceWHERE.Add 3, strWHEREcondition
    'プロパティにSQL設定
    clsADOfrmPMList.SQL = clsSQLBc.ReplaceParm(INV_CONST.SQL_INV_TANA_SET_LOCAL_TEXT_BY_SYSTEM, dicReplaceWHERE)
    '実行前にConnectModeにWriteフラグ立てる
    clsADOfrmPMList.ConnectMode = clsADOfrmPMList.ConnectMode Or adModeWrite
    'SQL実行
    Dim isCollect As Boolean
    isCollect = clsADOfrmPMList.Do_SQL_with_NO_Transaction
    'Writeフラグを下げる
    clsADOfrmPMList.ConnectMode = clsADOfrmPMList.ConnectMode And Not adModeWrite
    If Not isCollect Then
        'SQL実行失敗
        DebugMsgWithTime "btnTehai_Text_Local_Set_All_Click : SQL Execute fail..."
        GoTo CloseAndExit
    End If
    '成功
    DebugMsgWithTime "btnTehai_Text_Local_Set_All_Click : Update Success"
    MsgBox "更新完了。今回の更新件数: " & clsADOfrmPMList.Affected
    GoTo CloseAndExit
ErrorCatch:
CloseAndExit:
End Sub
'''手配コードテキストボックスに入っている物をデータDLし、更新する
Private Sub btnUpdateOriginData_Click()
    'イベント停止する
    clsIncrementalParts.StopEvent = True
    '現在の手配コードボックスの値を退避する
    Dim strOldTehaiCode As String
    strOldTehaiCode = txtBox_F_INV_Tehai_Code.Text
    '全項目消去
    ClearAllTextBoxAndLabel
    'getIEとobjExcelインスタンス変数がNothingだったら初期化する
    If clsGetIEfrmPMList Is Nothing Then
        Set clsGetIEfrmPMList = CreateclsGetIE
    End If
    If objExcelfrmPMList Is Nothing Then
        Set objExcelfrmPMList = New Excel.Application
    End If
    '手配コードを指定し、在庫情報シートをDLしフルパスを取得する
    Dim strZaikoSHFullPath As String
#If NoIEConnect Then
    'ローカルテストファイル環境の時
    'ファイル選択してもらう、ディレクトリはデータベースディレクトリ
    Call ChCurrentDirW(clsADOfrmPMList.DBPath)
    strZaikoSHFullPath = Application.GetOpenFilename
    If strZaikoSHFullPath = "False" Then
        MsgBox "キャンセルされました"
        Exit Sub
    End If
#Else
    'Webから情報取得できる環境の時
    strZaikoSHFullPath = modZaikoSerch.ZaikoSerchbyTehaiCode(strOldTehaiCode, clsGetIEfrmPMList)
#End If
    '指定の在庫情報ファイルでDB PartsMasterをUPdateし、処理レコード数を受け取る
    Dim longAffected As Long
    If objExcelfrmPMList Is Nothing Then
        'クラス変数が初期化されていなかったら初期化する
        Set objExcelfrmPMList = New Excel.Application
    End If
#If NoDeleteOriginSH Then
    '在庫情報SHファイル残すとき
    MsgBox "NoDeleteOriginSH 有効"
    longAffected = clsINVDBfrmPMList.UpsertINVPartsMasterfromZaikoSH(strZaikoSHFullPath, objExcelfrmPMList, clsINVDBfrmPMList, clsADOfrmPMList, clsEnumPMList, clsSQLBc, True)
#Else
    '在庫情報SHファイル削除するとき(デフォルト動作)
    longAffected = clsINVDBfrmPMList.UpsertINVPartsMasterfromZaikoSH(strZaikoSHFullPath, objExcelfrmPMList, clsINVDBfrmPMList, clsADOfrmPMList, clsEnumPMList, clsSQLBc, False)
#End If
    MsgBox longAffected & " 件のデータを更新しました。"
    'DBからRSにデータ取得しなおす
    setDefaultDatatoRS
    'イベント再開
    clsIncrementalParts.StopEvent = False
    '手配コードを戻してやる
    txtBox_F_INV_Tehai_Code.Text = strOldTehaiCode
End Sub
Private Sub lstBox_Incremental_Click()
    'インクリメンタルリストが選択された
    'SQLごーしちゃっていいと思う
    On Error GoTo ErrorCatch
    If clsIncrementalParts.Incremental_LstBox_Click Then
        'イベントの実行を抑止する
        clsIncrementalParts.StopEvent = True
        Dim varCtrlKey As Control
        '全てのコントロールをループし、dicObjtoFieldNameに含まれるもののみ値をセットしていく
        For Each varCtrlKey In Me.Controls
            If dicObjNameToFieldName.Exists(varCtrlKey.Name) Then
                'Dictionaryにあった
                '別名が.を_に置換した名前になっているので、フィールド名からその文字列を生成する
                Dim strFieldName As String
'                strFieldName = REPLACE(dicObjNameToFieldName(varCtrlKey.Name), ".", "_")
                strFieldName = clsSQLBc.RepDotField(dicObjNameToFieldName, varCtrlKey.Name)
                '値を取得
                Dim strResultValue As String
                If (IsNull(clsADOfrmPMList.RS.Fields(strFieldName))) Then
                    strResultValue = ""
                Else
                    strResultValue = CStr(clsADOfrmPMList.RS.Fields(strFieldName))
                End If
                'オブジェクトの種類により処理を分岐
                Select Case TypeName(varCtrlKey)
                Case "TextBox"
                    'テキストボックスの時
                    varCtrlKey.Text = strResultValue
                Case "Label"
                    'ラベルの時
                    varCtrlKey.Caption = strResultValue
                End Select
            Else
                'Dictionaryに含まれていないので今回のコントロールは対象外
            End If
        Next varCtrlKey
        '値を全部セットし終わってからイベント受付再開する
        clsIncrementalParts.StopEvent = False
    Else
        'Clickイベントで何かしらあった
        Exit Sub
    End If
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "IncremantalList_Click code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'パラメータセット済みの別のフォーム表示できるかテスト
Private Sub btnShowParmSetLabelfrm_Click()
    If txtBox_F_INV_Tehai_Code.Text = "" Then
        Exit Sub
    End If
    Load frmBinLabel
    If frmBinLabel.UpdateMode Then
        MsgBox "表示項目編集完了まで値のセットはできません"
        Exit Sub
    End If
    'Enterイベントを発生させてclsIncremantalの初期化をするためにSetFocus
    frmBinLabel.txtBox_F_INV_Tehai_Code.SetFocus
    frmBinLabel.txtBox_F_INV_Tehai_Code.Text = Me.txtBox_F_INV_Tehai_Code.Text
    'RSから情報をセットするためにインクリメンタルリストのClickイベントを発生させる(決め打ちで一番上のを選ぶ)
    frmBinLabel.lstBox_Incremental.ListIndex = 0
    frmBinLabel.lstBox_Incremental.Visible = False
    frmBinLabel.Show
End Sub
Private Sub lstBox_Incremental_Enter()
    If StopEvents Then
        'イベント停止フラグ立ってたら抜ける
        Exit Sub
    End If
    'イベント停止する
    StopEvents = True
    clsIncrementalParts.Incremental_LstBox_Enter
    'イベント再開する
    StopEvents = False
End Sub
Private Sub lstBox_Incremental_KeyUp(ByVal KeyCode As MSForms.ReturnInteger, ByVal Shift As Integer)
    'キーボードの場合はこっち
    clsIncrementalParts.Incremental_LstBox_Key_UP KeyCode, Shift
End Sub
Private Sub lstBox_Incremental_MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
    'このイベントがリスト選択直後に発生するのでよさそう
    clsIncrementalParts.Incremental_LstBox_Mouse_UP Button
End Sub
Private Sub txtBox_F_INV_Tana_Local_Text_Change()
    If StopEvents Then
        'イベント停止フラグ立ってたら抜ける
        Exit Sub
    End If
    If Me.txtBox_F_INV_Tana_Local_Text.Text = "" Then
        'テキストが空白だったら何もしない
'        Exit Sub
    End If
    'イベント停止する
    StopEvents = True
    '全て大文字に変換する
    Me.txtBox_F_INV_Tana_Local_Text.Text = UCase(Me.txtBox_F_INV_Tana_Local_Text.Text)
    clsIncrementalParts.Incremental_TextBox_Change
    'イベント再開
    StopEvents = False
End Sub
Private Sub txtBox_F_INV_Tana_Local_Text_Enter()
    '棚番表示用 Enterイベント
    If StopEvents Then
        'イベント停止フラグ立ってたら抜ける
        Exit Sub
    End If
    'イベント停止する
    StopEvents = True
    clsIncrementalParts.Incremental_TextBox_Enter Me.txtBox_F_INV_Tana_Local_Text, lstBox_Incremental
    'イベント再開する
    StopEvents = False
End Sub
Private Sub txtBox_F_INV_Tehai_Code_Change()
    If StopEvents Then
        'イベント停止フラグ立ってたら抜ける
        Exit Sub
    End If
    If Me.txtBox_F_INV_Tehai_Code.Text = "" Then
        'テキストが空白だったら何もしない
    End If
    'イベント停止する
    StopEvents = True
    '全て大文字に変換する
    Me.txtBox_F_INV_Tehai_Code.Text = UCase(Me.txtBox_F_INV_Tehai_Code.Text)
'    ClearAllTextBoxAndLabel Me.txtBox_F_INV_Tehai_Code.Name
    'インクリメンタルサーチ実行
    clsIncrementalParts.Incremental_TextBox_Change
    'イベント再開する
    StopEvents = False
End Sub
Private Sub txtBox_F_INV_Tehai_Code_Enter()
    If StopEvents Then
        'イベント停止フラグ立ってたら抜ける
        Exit Sub
    End If
    'イベント停止する
    StopEvents = True
    'インクリメンタルサーチ Enterイベント
    clsIncrementalParts.Incremental_TextBox_Enter Me.txtBox_F_INV_Tehai_Code, lstBox_Incremental
    'イベント再開する
    StopEvents = False
End Sub
'-----------------------------------------------------------------------------------------
'メソッド定義
Private Sub UserForm_Initialize()
    On Error GoTo ErrorCatch
    'フォーム初期化動作
    'メンバのクラス変数の初期化を行う
    'clsADO
    If clsADOfrmPMList Is Nothing Then
        Set clsADOfrmPMList = CreateclsADOHandleInstance
    End If
    'clsINVDB
    If clsINVDBfrmPMList Is Nothing Then
        Set clsINVDBfrmPMList = CreateclsINVDB
    End If
    'clsEnum
    If clsEnumPMList Is Nothing Then
        Set clsEnumPMList = CreateclsEnum
    End If
    'clsStringBuilderSQL
    If clsSQLBc Is Nothing Then
        Set clsSQLBc = CreateclsSQLStringBuilder
    End If
    'clsIncrementalSerch
    If clsIncrementalParts Is Nothing Then
        Set clsIncrementalParts = CreateclsIncrementalSerch
    End If
    'DBからRSにデータ取得する
    setDefaultDatatoRS
    'イベント受付開始
    StopEvents = False
    '棚番テキストボックスにフォーカスを移動
    txtBox_F_INV_Tana_Local_Text.SetFocus
    '初期化が終わる前に全消去しようとすると、Dictionary等の準備ができてないのにTxtBox_Changeイベントが先に発生してしまうので消去は最後に
#If DebugDB Then
    MsgBox "DebugDB Enable"
#End If
    'テキストボックス、ラベル全消去
    ClearAllTextBoxAndLabel
    '実際の値の入れ込みはインクリメンタルサーチの中で行う
    GoTo CloseAndExit
ErrorCatch:
    DebugMsgWithTime "frmPartsMaster_Initialize code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
'''テキストボックス、ラベルを全消去する
'''args
'''strExceptContrlName      この名前に一致するコントロールのは消去しない
Private Sub ClearAllTextBoxAndLabel(Optional strExceptContrlName As String)
    'コントロールのNameプロパティで定数に定義してあるテキストボックスとラベルについて、内容をそれぞれ消去してやる
    Dim controlKey As Control
    For Each controlKey In Me.Controls
        If dicObjNameToFieldName.Exists(controlKey.Name) And controlKey.Name <> strExceptContrlName Then
            'dicObjctToFieldで定義された物だけ消去するようにする
            Select Case TypeName(controlKey)
            Case "TextBox"
                'テキストボックスの場合
                controlKey.Text = ""
            Case "Label"
                'ラベルの場合
                controlKey.Caption = ""
            End Select
        End If
    Next controlKey
End Sub
'''オブジェクト名、フィールド名Dictionaryの初期化
Private Sub InitializeFieldNameDic()
    If dicObjNameToFieldName Is Nothing Then
        Set dicObjNameToFieldName = New Dictionary
    End If
    '2回目の実行に対応するため一旦RemoveAllする
    dicObjNameToFieldName.RemoveAll
    dicObjNameToFieldName.Add txtBox_F_INV_Tehai_Code.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Tehai_Code_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Manege_Section.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Manege_Section_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add lbl_F_INV_Tana_System_Text.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_System_Text_IMT), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Kishu.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Kishu_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Store_Code.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Store_Code_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Deliver_Lot.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Deliver_Lot_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Fill_Lot.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Fill_Lot_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Lead_Time.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Lead_Time_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Order_Amount.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Order_Amount_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Order_Remain.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Order_Remain_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Stock_Amount.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Stock_Amount_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add lbl_F_INV_Tana_ID.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Tana_ID_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_System_Name.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_System_Name_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_System_Spec.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_System_Spec_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Sotre_Unit.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Store_Unit_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_System_Description.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_System_Description_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Manege_Section_Sub.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Manege_Section_Sub_IMPrt), clsEnumPMList)
    dicObjNameToFieldName.Add txtBox_F_INV_Tana_Local_Text.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Tana_Alias_sia, clsEnumPMList.INVMasterTana(F_INV_Tana_Local_Text_IMT), clsEnumPMList)
    dicObjNameToFieldName.Add lbl_F_INV_Tehai_ID.Name, clsSQLBc.ReturnTableAliasPlusedFieldName(INVDB_Parts_Alias_sia, clsEnumPMList.INVMasterParts(F_Tehai_ID_IMPrt), clsEnumPMList)
    Exit Sub
End Sub
Private Sub setDefaultDatatoRS()
    On Error GoTo ErrorCatch
    '初期化完了するまでイベントストップする
    clsIncrementalParts.StopEvent = True
    'DBPathをデフォルトへ
    clsADOfrmPMList.SetDBPathandFilenameDefault
    'DBPathとDBFilenameを設定する
    txtBox_DB_Path.Text = clsADOfrmPMList.DBPath
    txtBox_DB_Filename.Text = clsADOfrmPMList.DBFileName
    'オブジェクト名→フィールド名のDictionaryの設定を行う
    InitializeFieldNameDic
    'clsIncrementalSerchのコンストラクタ
    clsIncrementalParts.ConstRuctor Me, dicObjNameToFieldName, clsADOfrmPMList, clsEnumPMList, clsSQLBc
    'ここでフィルタ前の全情報を取得する、Where条件は今回はなし
    'ReplaceDicを設定する
    clsIncrementalParts.SetReplaceParmDic dicReplacePartsMaster, clsSQLBc.GetSELECTfieldListFromDicObjctToFieldName(dicObjNameToFieldName)
    'clsADOのプロパティにSQLをセット
    clsADOfrmPMList.SQL = clsSQLBc.ReplaceParm(INV_CONST.SQL_INV_JOIN_TANA_PARTS, dicReplacePartsMaster)
    'clsADOのConnectionをを共有読み取りモードに設定する
    clsADOfrmPMList.ConnectMode = adModeRead Or adModeShareDenyNone
    'SQL実行し、clsADOのRSにデータを格納する
    Dim isCollect As Boolean
    isCollect = clsADOfrmPMList.Do_SQL_with_NO_Transaction
    If Not isCollect Then
        DebugMsgWithTime "frmPartsMaster_Initialize : do first sql fail..."
        MsgBox "初回情報取得時のSQL実行でエラーがありました。"
        GoTo CloseAndExit
        Exit Sub
    End If
    'clsADOのRSをデータソースから切り離す
    Set clsADOfrmPMList.RS.ActiveConnection = Nothing
    '後のFilterやSortは基本的にclsADOのRSに対して行う
    'イベント再開
    clsIncrementalParts.StopEvent = False
ErrorCatch:
    DebugMsgWithTime "SetDefaultDatatoRS code: " & Err.Number & " Description: " & Err.Description
    GoTo CloseAndExit
CloseAndExit:
    Exit Sub
End Sub
Private Sub UserForm_Terminate()
    'デストラクタ
    Destractor
End Sub
'クラスのデストラクタ
Private Sub Destractor()
    If Not clsADOfrmPMList Is Nothing Then
        'ADOが生き残っている
        clsADOfrmPMList.CloseClassConnection
        Set clsADOfrmPMList = Nothing
    End If
    If Not objExcelfrmPMList Is Nothing Then
        'objExcel
        objExcelfrmPMList.Quit
        Set objExcelfrmPMList = Nothing
    End If
    If Not clsINVDBfrmPMList Is Nothing Then
        Set clsINVDBfrmPMList = Nothing
    End If
    If Not clsSQLBc Is Nothing Then
        Set clsSQLBc = Nothing
    End If
    If Not clsEnumPMList Is Nothing Then
        Set clsEnumPMList = Nothing
    End If
    If Not clsIncrementalParts Is Nothing Then
        Set clsIncrementalParts = Nothing
    End If
    If Not clsGetIEfrmPMList Is Nothing Then
        Set clsGetIEfrmPMList = Nothing
    End If
    Me.Hide
    Unload Me
End Sub
﻿#define DEBUG
// See   https://aka.ms/new-console-template for more information
using System.Collections.Generic;
using System.IO;
using System;
using CSharp_DBHandle.CSDB_COMServer;
using CSharp_DBHandle.CSDB_COMServer.Entity;
namespace CSharp_Bridge_Label
{
    static class LabelFileRead
    {
        /// <summary>
        /// ラベルファイルのフィールド構成を記録したRecord
        /// </summary>
        /// <param name="longLabelType">ラベル種別</param>
        /// <param name="F_Seiban">製番</param>
        /// <param name="stKiguKigou">器具記号</param>
        /// <param name="strSBL">SBL項番</param>
        /// <param name="strMLNo">ML No</param>
        /// <param name="F_OrderNumber">オーダーナンバー</param>
        /// <param name="strMLCode">ML情報コード</param>
        /// <param name="F_INV_Tehai_Code">手配コード</param>
        /// <param name="F_INV_System_Name">品名記号 CASEとか</param>
        /// <param name="F_INV_Tana_System_Text">ロケーション K9GA01 システムロケーション</param>
        /// <param name="strLocation2">ロケーション2</param>
        /// <param name="strLocation3">ロケーション3</param>
        /// <param name="strGrantCode">払出/支給先コード</param>
        /// <param name="longRequireAmount">手配数量</param>
        /// <param name="longCurrentAmount">数量(再発行等で数量指定されると反映されるのはこっち)</param>
        /// <param name="strDateProcess">処理日 datetimeにうまく変換できなかったのでStringのまま</param>
        /// <param name="GrantName">払出/支給先名称</param>
        /// <param name="strKishu">手配機種 JL J7</param>
        /// <param name="longNoItemFlag">欠品フラグ</param>
        /// <param name="strCustomerSeiban">発注元製番(Nullかも)</param>
        /// <returns></returns>
        record rLabel (long longLabelType,
            string F_Seiban,
            string stKiguKigou,
            string strSBL,
            string strMLNo,
            string F_OrderNumber,
            string strMLCode,
            string F_INV_Tehai_Code,
            string F_INV_System_Name,
            string F_INV_Tana_System_Text,
            string strLocation2,
            string strLocation3,
            string strGrantCode,
            long longRequireAmount,
            long longCurrentAmount,
            string strDateProcess,
            string GrantName,
            string strKishu,
            long longNoItemFlag,
            string strCustomerSeiban);

        /// <summary>
        /// メインプログラムです
        /// </summary>
        /// <param name="args">引数で指定された(ファイル)が配列で格納される</param>
        static void Main(string[] args)
        {
            //引数が空なら抜ける
            if (args.Length <= 0)
            {
                Console.WriteLine("引数が空でした。実行時には引数にlblファイルを指定して下さい");
                return;
            }
            //第一引数に指定されたファイルが存在しない場合は抜ける
            if (!System.IO.File.Exists(args[0]))
            {
                Console.WriteLine("File not found " + args[0]);
                return;
            }
            //拡張子を得る(lowercase)
            string strExtention = System.IO.Path.GetExtension(args[0]).ToLower();
            switch (strExtention)
            {
                case ".lbl" :
                //lblファイルだった場合(当面この拡張子のみ相手にする)
                #if DEBUG
                Console.WriteLine("処理対象ファイル： " + args[0]);
                #endif
                //読み取った結果を格納する rLabelレコードのList
                var listRecords = new List<rLabel>();
                List<T_INV_Label_Temp> listTLabel = new List<T_INV_Label_Temp>();
                //指定されたファイルをテキストファイルとして1行ずつ読み込む
                //lines にはstring型の IEnumerable
                IEnumerable<string> strlines = File.ReadLines(args[0]);
                long longRowCounter=0;
                foreach(string oneline in strlines)
                {
                    //行数カウンタをインクリメント
                    longRowCounter++;
                    if (oneline == "")
                    {
                        //空行を読み取った場合は何もせずに次のループへ
                        continue;
                    }
                    Console.WriteLine(longRowCounter + " 行目の結果 " + oneline);
                    //結果を,をデリミタとして配列に格納
                    var varSpritText = oneline.Split(",");
                    //x 配列の結果をrLabelに入れていく
                    
                    listRecords.Add (new rLabel(
                        Convert.ToInt64(varSpritText[0]),
                        //製番
                        varSpritText[1],
                        //器具記号
                        varSpritText[2],
                        //SBL項番
                        varSpritText[3],
                        //MLNo
                        varSpritText[4],
                        //オーダーNo
                        varSpritText[5],
                        //ML情報コード
                        varSpritText[6],
                        //手配コード
                        varSpritText[7],
                        //品名記号
                        varSpritText[8],
                        //棚番1
                        varSpritText[9],
                        //棚番2
                        varSpritText[10],
                        //棚番3
                        varSpritText[11],
                        //払出/支給先コード
                        varSpritText[12],
                        //手配数量
                        Convert.ToInt64(varSpritText[13]),
                        //数量
                        Convert.ToInt64(varSpritText[14]),
                        //処理日
                        varSpritText[15],
                        //払出/支給先名称
                        varSpritText[16],
                        //手配機種コード
                        varSpritText[17],
                        //欠品フラグ
                        Convert.ToInt64(varSpritText[18]),
                        //客先製番
                        varSpritText[19]));
                        //
                        //Dapper の Entity ラベルクラスのインスタンスを作成し、値をセットしていく
                        T_INV_Label_Temp currentRecord = new T_INV_Label_Temp();
                        currentRecord.F_INV_Label_Type_Code = (T_INV_Label_Temp.enumLabelType)Convert.ToInt64(varSpritText[0]);
                        currentRecord.F_INV_Seiban = varSpritText[1];
                        currentRecord.F_INV_SBL = varSpritText[3];
                        currentRecord.F_INV_ML_No = varSpritText[4];
                        currentRecord.F_INV_Tana_Local_Text = varSpritText[9];
                        currentRecord.F_INV_Tana_Local_Text = varSpritText[7];
                        currentRecord.F_INV_OrderNumber = varSpritText[5];
                        currentRecord.F_INV_Current_Amount = Convert.ToInt64(varSpritText[14]);
                        currentRecord.F_INV_Requre_Amount = Convert.ToInt64(varSpritText[13]);
                        string strDate = varSpritText[15].Substring(0,3) + "-" + varSpritText[15].Substring(4,2) + "-" + varSpritText[15].Substring(6,2);
                        currentRecord.F_InputDate = strDate;
                        //リストに追加する
                        listTLabel.Add(currentRecord);
                }
                
                foreach (rLabel rElements in listRecords)
                {
                    //リストをループし、処理をする
                    //ここでDBに登録？なりを行う
                    Console.WriteLine(nameof(rElements.strGrantCode)+ " の値は " + rElements.strGrantCode.ToString());
                    Console.WriteLine(nameof(rElements.strMLCode) + " の値は " + rElements.strMLCode);
                    Console.WriteLine(nameof(rElements.longRequireAmount) + " の値は " + rElements.longRequireAmount);
                }
                return;
                // break;
                default :
                Console.WriteLine("想定外のファイルが指定されました");
                return;
            }
        }
    }
}

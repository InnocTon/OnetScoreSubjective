using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

public partial class rater31data : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
       
    }
    public class recieveValue31
    {
        public string score1_1 { get; set; }
        public string score1_2 { get; set; }
        public string score2_1 { get; set; }
        public string score2_2 { get; set; }
        public string score3_1 { get; set; }
        public string score3_2 { get; set; }
        public string score3_3 { get; set; }
        public string score3_4 { get; set; }
        public string sumScore { get; set; }
        public string stdCode { get; set; }
        public string useScore1_1 { get; set; }
        public string useScore1_2 { get; set; }
        public string useScore1_3 { get; set; }
        public string useScore1_4 { get; set; }
        public string useScore1_5 { get; set; }
        public string useScore1_6 { get; set; }
        public string useScore1_7 { get; set; }
        public string useScore1_8 { get; set; }
        public string useScoreSum { get; set; }
        public string QNO { get; set; }

    }
    public class recieveValue32
    {
        public string score1_1 { get; set; }
        public string score1_2 { get; set; }
        public string score2_1 { get; set; }
        public string score2_2 { get; set; }
        public string sumScore { get; set; }
        public string stdCode { get; set; }
        public string useScore1_1 { get; set; }
        public string useScore1_2 { get; set; }
        public string useScore1_3 { get; set; }
        public string useScore1_4 { get; set; }
        public string useScoreSum { get; set; }
        public string QNO { get; set; }

    }
    [WebMethod(EnableSession = true)]
    public static string recieve(string recieveValue)
    {
        var query = JsonConvert.DeserializeObject<recieveValue31>(recieveValue);
        //string t = query.score3_2;
        
        decimal score11 = Convert.ToDecimal(query.score1_1.ToString());
        decimal score12 = Convert.ToDecimal(query.score1_2.ToString());
        decimal score21 = Convert.ToDecimal(query.score2_1.ToString());
        decimal score22 = Convert.ToDecimal(query.score2_2.ToString());
        decimal score31 = Convert.ToDecimal(query.score3_1.ToString());
        decimal score32 = Convert.ToDecimal(query.score3_2.ToString());
        decimal score33 = Convert.ToDecimal(query.score3_3.ToString());
        decimal score34 = Convert.ToDecimal(query.score3_4.ToString());
        decimal scoreSum = Convert.ToDecimal(query.sumScore.ToString());
        String studentCode = query.stdCode.ToString();
        string FpaperBarCode = studentCode.Substring(0, 5);
        string BpaperBarCode = studentCode.Substring(5, 8);
        string paperBarCode = FpaperBarCode + '3' + BpaperBarCode;


        decimal scoreUse11 = Convert.ToDecimal(query.useScore1_1.ToString());
        decimal scoreUse12 = Convert.ToDecimal(query.useScore1_2.ToString());
        decimal scoreUse21 = Convert.ToDecimal(query.useScore1_3.ToString());
        decimal scoreUse22 = Convert.ToDecimal(query.useScore1_4.ToString());
        decimal scoreUse31 = Convert.ToDecimal(query.useScore1_5.ToString());
        decimal scoreUse32 = Convert.ToDecimal(query.useScore1_6.ToString());
        decimal scoreUse33 = Convert.ToDecimal(query.useScore1_7.ToString());
        decimal scoreUse34 = Convert.ToDecimal(query.useScore1_8.ToString());
        decimal useScoreSum = Convert.ToDecimal(query.useScoreSum.ToString());
        decimal QNOuse = Convert.ToDecimal(query.QNO.ToString());

        SqlConnection conn = new SqlConnection(connStr);
        SqlTransaction trans = null;
        
        //SCORE Add Score For Tepa No1
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("INSERT INTO [TRN_XM_SCORE] ([STD_CODE],[QNO],[SCORE_TOTAL],[CRITERION1],[CRITERION2],[CRITERION3],[CRITERION4],[CRITERION5],[CRITERION6],[CRITERION7],[CRITERION8],[SCORE_TYPE],[CREATE_BY],[CREATE_DATETIME])  VALUES(@stdCode,@QNOuse,@scoreSum,@score11,@score12,@score21,@score22,@score31,@score32,@score33,@score34,@scoreType,@createby,getdate());", conn);
            //command.Parameters.AddWithValue("@stdCode", "2261100001001");
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@QNOuse", QNOuse);
            command.Parameters.AddWithValue("@scoreSum", useScoreSum);
            command.Parameters.AddWithValue("@score11", scoreUse11);
            command.Parameters.AddWithValue("@score12", scoreUse12);
            command.Parameters.AddWithValue("@score21", scoreUse21);
            command.Parameters.AddWithValue("@score22", scoreUse22);
            command.Parameters.AddWithValue("@score31", scoreUse31);
            command.Parameters.AddWithValue("@score32", scoreUse32);
            command.Parameters.AddWithValue("@score33", scoreUse33);
            command.Parameters.AddWithValue("@score34", scoreUse34);
            command.Parameters.AddWithValue("@scoreType", "RATER3");
            //command.Parameters.AddWithValue("@createby", "iOui");
            command.Parameters.AddWithValue("@createby",HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
                //showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
            }
            else
            {
                trans.Rollback();
                //showMessage("ข้อผิดพลาด!", "เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            trans.Rollback();
            //showMessage("ข้อผิดพลาด!", ex.Message, "error");
            //return new JavaScriptSerializer().Serialize(ex.Message); 

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        //add to Copy3 No1
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("INSERT INTO [TRN_XM_SCORE_COPY3] ([OMR_SEQ],[STD_CODE],[PAPER_BARCODE],[EXAM_KEY],[IS_ROWSMIN],[SCR_CRIT1],[SCR_CRIT2],[SCR_CRIT3],[SCR_CRIT4],[SCR_CRIT5],[SCR_CRIT6],[SCR_CRIT7],[SCR_CRIT8],[SCR_SUM],[QNO],[COPYNO],[IS_DIFF],[IS_COMPLETE],[CREATE_BY],[CREATE_DATETIME])  VALUES(@omrSeq,@stdCode,@paperBarCode,@examKey,@isRowMin,@score11,@score12,@score21,@score22,@score31,@score32,@score33,@score34,@scoreSum,@QNOuse,@copyNo,@isDiff,@isComplete,@createby,getdate());", conn);
            command.Parameters.AddWithValue("@omrSeq", "");
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@paperBarCode", paperBarCode);
            command.Parameters.AddWithValue("@examKey", "");
            command.Parameters.AddWithValue("@isRowMin", "");
            command.Parameters.AddWithValue("@scoreSum", useScoreSum);
            command.Parameters.AddWithValue("@score11", scoreUse11);
            command.Parameters.AddWithValue("@score12", scoreUse12);
            command.Parameters.AddWithValue("@score21", scoreUse21);
            command.Parameters.AddWithValue("@score22", scoreUse22);
            command.Parameters.AddWithValue("@score31", scoreUse31);
            command.Parameters.AddWithValue("@score32", scoreUse32);
            command.Parameters.AddWithValue("@score33", scoreUse33);
            command.Parameters.AddWithValue("@score34", scoreUse34);
            command.Parameters.AddWithValue("@QNOuse", QNOuse);
            command.Parameters.AddWithValue("@copyNo", "3");
            command.Parameters.AddWithValue("@isDiff", "1");
            command.Parameters.AddWithValue("@isComplete", "1");
            command.Parameters.AddWithValue("@createby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
                //showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
                //return new JavaScriptSerializer().Serialize(ex.Message);
            }
            else
            {
                trans.Rollback();
                //showMessage("ข้อผิดพลาด!", "เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            return new JavaScriptSerializer().Serialize(ex.Message);
            trans.Rollback();
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }


        //Copy1 Update No1
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("UPDATE TRN_XM_SCORE_COPY1 SET IS_COMPLETE = '1',UPDATE_BY = @updateby,UPDATE_DATETIME = getdate() WHERE STD_CODE = @stdCode;", conn);
            //command.Parameters.AddWithValue("@updateby", "iOui");
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@updateby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
                //showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
            }
            else
            {
                trans.Rollback();
                //showMessage("ข้อผิดพลาด!", "เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            trans.Rollback();
            //showMessage("ข้อผิดพลาด!", ex.Message, "error");

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        ////Copy2 Update No1
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("UPDATE TRN_XM_SCORE_COPY2 SET IS_COMPLETE = '1',UPDATE_BY = @updateby,UPDATE_DATETIME = getdate() WHERE STD_CODE = @stdCode;", conn);
            //command.Parameters.AddWithValue("@updateby", "iOui");
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@updateby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
                //showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
            }
            else
            {
                trans.Rollback();
                //showMessage("ข้อผิดพลาด!", "เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            trans.Rollback();
            //showMessage("ข้อผิดพลาด!", ex.Message, "error");
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        


        return new JavaScriptSerializer().Serialize(scoreSum);
    }

    //////***** No2 *****//////
    [WebMethod(EnableSession = true)]
    public static string recieve2(string recieveValue)
    {
        var query = JsonConvert.DeserializeObject<recieveValue32>(recieveValue);
        //string t = query.score3_2;

        decimal score11 = Convert.ToDecimal(query.score1_1.ToString());
        decimal score12 = Convert.ToDecimal(query.score1_2.ToString());
        decimal score21 = Convert.ToDecimal(query.score2_1.ToString());
        decimal score22 = Convert.ToDecimal(query.score2_2.ToString());
        decimal scoreSum = Convert.ToDecimal(query.sumScore.ToString());

        decimal scoreUse11 = Convert.ToDecimal(query.useScore1_1.ToString());
        decimal scoreUse12 = Convert.ToDecimal(query.useScore1_2.ToString());
        decimal scoreUse21 = Convert.ToDecimal(query.useScore1_3.ToString());
        decimal scoreUse22 = Convert.ToDecimal(query.useScore1_4.ToString());
        decimal useScoreSum = Convert.ToDecimal(query.useScoreSum.ToString());
        decimal QNOuse = Convert.ToDecimal(query.QNO.ToString());

        String studentCode = query.stdCode.ToString();
        string FpaperBarCode = studentCode.Substring(0, 5);
        string BpaperBarCode = studentCode.Substring(5, 8);
        string paperBarCode = FpaperBarCode + '3' + BpaperBarCode;

        SqlConnection conn = new SqlConnection(connStr);
        SqlTransaction trans = null;

        //SCORE Add For Tepa No2
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("INSERT INTO [TRN_XM_SCORE] ([STD_CODE],[QNO],[SCORE_TOTAL],[CRITERION1],[CRITERION2],[CRITERION3],[CRITERION4],[SCORE_TYPE],[CREATE_BY],[CREATE_DATETIME])  VALUES(@stdCode,@QNOuse,@scoreSum,@score11,@score12,@score21,@score22,@scoreType,@createby,getdate());", conn);
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@QNOuse", QNOuse);
            command.Parameters.AddWithValue("@scoreSum", useScoreSum) ;
            command.Parameters.AddWithValue("@score11", scoreUse11);
            command.Parameters.AddWithValue("@score12", scoreUse12);
            command.Parameters.AddWithValue("@score21", scoreUse21);
            command.Parameters.AddWithValue("@score22", scoreUse22);
            command.Parameters.AddWithValue("@scoreType", "RATER3");
            command.Parameters.AddWithValue("@createby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
            }
            else
            {
                trans.Rollback();
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            trans.Rollback();
            return new JavaScriptSerializer().Serialize(ex.Message);

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        //add to Copy3 No2
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("INSERT INTO [TRN_XM_SCORE_COPY3] ([OMR_SEQ],[STD_CODE],[PAPER_BARCODE],[EXAM_KEY],[IS_ROWSMIN],[SCR_CRIT1],[SCR_CRIT2],[SCR_CRIT3],[SCR_CRIT4],[SCR_SUM],[QNO],[COPYNO],[IS_DIFF],[IS_COMPLETE],[CREATE_BY],[CREATE_DATETIME])  VALUES(@omrSeq,@stdCode,@paperBarCode,@examKey,@isRowMin,@score11,@score12,@score21,@score22,@scoreSum,@QNOuse,@copyNo,@isDiff,@isComplete,@createby,getdate());", conn);
            command.Parameters.AddWithValue("@omrSeq", "");
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@paperBarCode", paperBarCode);
            command.Parameters.AddWithValue("@examKey", "");
            command.Parameters.AddWithValue("@isRowMin", "");
            command.Parameters.AddWithValue("@scoreSum", useScoreSum);
            command.Parameters.AddWithValue("@score11", scoreUse11);
            command.Parameters.AddWithValue("@score12", scoreUse12);
            command.Parameters.AddWithValue("@score21", scoreUse21);
            command.Parameters.AddWithValue("@score22", scoreUse22);
            command.Parameters.AddWithValue("@QNOuse", QNOuse);
            command.Parameters.AddWithValue("@copyNo", "3");
            command.Parameters.AddWithValue("@isDiff", "1");
            command.Parameters.AddWithValue("@isComplete", "1");
            command.Parameters.AddWithValue("@createby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
                //showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
                //return new JavaScriptSerializer().Serialize(ex.Message);
            }
            else
            {
                trans.Rollback();
                //showMessage("ข้อผิดพลาด!", "เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            return new JavaScriptSerializer().Serialize(ex.Message);
            trans.Rollback();
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }


        //Copy1 No2
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("UPDATE TRN_XM_SCORE_COPY1 SET IS_COMPLETE = '1',UPDATE_BY = @updateby,UPDATE_DATETIME = getdate() WHERE STD_CODE = @stdCode;", conn);
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@updateby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
                //showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
            }
            else
            {
                trans.Rollback();
                //showMessage("ข้อผิดพลาด!", "เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            trans.Rollback();

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        ////Copy2 No2
        try
        {

            conn.Open();
            trans = conn.BeginTransaction();

            SqlCommand command = new SqlCommand("UPDATE TRN_XM_SCORE_COPY2 SET IS_COMPLETE = '1',UPDATE_BY = @updateby,UPDATE_DATETIME = getdate() WHERE STD_CODE = @stdCode;", conn);
            command.Parameters.AddWithValue("@stdCode", studentCode);
            command.Parameters.AddWithValue("@updateby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result == 1)
            {
                trans.Commit();
            }
            else
            {
                trans.Rollback();
            }

            conn.Close();

        }
        catch (Exception ex)
        {
            trans.Rollback();
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }




        return new JavaScriptSerializer().Serialize(scoreSum);
    }


}
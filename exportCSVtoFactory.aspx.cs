using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Default2 : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void ButtonExport_Click(object sender, EventArgs e)
    {
        SqlConnection conn = new SqlConnection(connStr);
        //StringBuilder sb = new StringBuilder();
        //SqlTransaction trans = null;

        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_SCORE WHERE IS_EXPORT = '0'";
            SqlCommand command = new SqlCommand(query, conn);
            //command.Parameters.AddWithValue("@boxcode", boxcode);
            SqlDataReader reader = command.ExecuteReader();
            //String bstatus = "";
            //String bseq = "";
            var dtNow = DateTime.Now.ToString("yyyy-MM-dd--HH-mm-ss");

            using (StreamWriter sw = new StreamWriter(@"D:\ExportData\DataExport-" + dtNow + ".csv"))
            {
                StringBuilder sb = new StringBuilder();
                int lines = 0;

                while (reader.Read())
                {
                    //for (int i = 0; i < dr.FieldCount; i++)
                    //{
                    //    sb.Append(dr[i].ToString() + ';');
                    //}
                    //sb.AppendLine();
                    if (lines == 0 )
                    {
                        sb.Append(reader.GetName(0).ToString() + ",");
                        sb.Append(reader.GetName(1).ToString() + ",");
                        sb.Append(reader.GetName(2).ToString() + ",");
                        sb.Append(reader.GetName(3).ToString() + ",");
                        sb.Append(reader.GetName(4).ToString() + ",");
                        sb.Append(reader.GetName(5).ToString() + ",");
                        sb.Append(reader.GetName(6).ToString() + ",");
                        sb.Append(reader.GetName(7).ToString() + ",");
                        sb.Append(reader.GetName(8).ToString() + ",");
                        sb.Append(reader.GetName(9).ToString() + ",");
                        sb.Append(reader.GetName(10).ToString() + ",");
                        sb.Append(reader.GetName(11).ToString() + ",");
                        sb.Append(reader.GetName(12).ToString() + ",");
                        sb.Append(reader.GetName(13).ToString() + ",");
                        sb.Append(reader.GetName(14).ToString() + ",");
                        sb.Append(reader.GetName(15).ToString() + ",");
                        sb.Append(reader.GetName(16).ToString() + ",");
                        sb.AppendLine();
                    }
                    sb.Append(reader["SCORE_SEQ"].ToString() + ",");
                    sb.Append(reader["STD_CODE"].ToString() + ",");
                    sb.Append(reader["SCORE_TOTAL"].ToString() + ",");
                    sb.Append(reader["CRITERION1"].ToString() + ",");
                    sb.Append(reader["CRITERION2"].ToString() + ",");
                    sb.Append(reader["CRITERION3"].ToString() + ",");
                    sb.Append(reader["CRITERION4"].ToString() + ",");
                    sb.Append(reader["CRITERION5"].ToString() + ",");
                    sb.Append(reader["CRITERION6"].ToString() + ",");
                    sb.Append(reader["CRITERION7"].ToString() + ",");
                    sb.Append(reader["CRITERION8"].ToString() + ",");
                    sb.Append(reader["IS_EXPORT"].ToString() + ",");
                    sb.Append(reader["SCORE_TYPE"].ToString() + ",");
                    sb.Append(reader["CREATE_BY"].ToString() + ",");
                    sb.Append(reader["CREATE_DATETIME"].ToString() + ",");
                    sb.Append(reader["EXPORT_BY"].ToString() + ",");
                    sb.Append(reader["EXPORT_DATETIME"].ToString() + ",");
                    sb.AppendLine();
                    //sb.Append("\r\n");
                    if (lines % 10 == 0) // %10000
                    {
                        sw.Write(sb.ToString());
                        sb = new StringBuilder();
                    }
                    lines++;
                }
                reader.Close();


                if (sw.BaseStream != null)
                {
                    Response.Write("Valid");
                    //Update is_export=1
                }else
                {
                    Response.Write("InValid");
                }
                    
                    //try
                //{

                //    SqlCommand command2 = new SqlCommand("UPDATE TRN_XM_SCORE SET IS_EXPORT = '1',EXPORT_BY = @exportby,EXPORT_DATETIME = getdate() WHERE IS_EXPORT = '0';", conn);
                //    //command.Parameters.AddWithValue("@stdCode", studentCode);
                //    command2.Parameters.AddWithValue("@exporteby", HttpContext.Current.Session["USER_ID"].ToString());
                //    command2.Transaction = trans;
                //    int result = command2.ExecuteNonQuery();
                //    if (result == 1)
                //    {
                //        trans.Commit();
                //        //showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
                //        Response.Write("Update Done.");
                //    }
                //    else
                //    {
                //        trans.Rollback();
                //        //showMessage("ข้อผิดพลาด!", "เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
                //        Response.Write("Update Fail.");
                //    }

                //    //conn.Close();

                //}
                //catch (Exception ex)
                //{
                //    trans.Rollback();

                //}
                //finally
                //{
                //    if (conn != null && conn.State == ConnectionState.Open)
                //    {
                //        conn.Close();
                //    }
                //}
                
            }
            conn.Close();
            Response.Write("111");
            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'คำเตือน!',   text: 'กรุณาเลือกประเภทไฟล์ที่ต้องการนำเข้า',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'คำเตือน!',   text: 'กรุณาเลือกประเภทไฟล์ที่ต้องการนำเข้า',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
            Response.Write(ex);
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                Response.Write("333");
                conn.Close();
            }
        }

        //return StatusBox;

    }


}
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Web.Services;

public partial class exportToFactory : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
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
            SqlDataReader reader = command.ExecuteReader();
            var dtNow = DateTime.Now.ToString("yyyy-MM-dd--HH-mm-ss");
            string exportName = @"C:\Users\Public\ExportData\\DataExport-" + dtNow + ".csv";
            string exportNameShow = "C:\\Users\\Public\\ExportData\\DataExport-" + dtNow + ".csv";
            SqlTransaction trans = null;

            Response.Write(HttpContext.Current.Session["USER_ID"].ToString()); 
            using (StreamWriter sw = new StreamWriter(exportName))
            {
                StringBuilder sb = new StringBuilder();
                int lines = 0;
                List<int> seqUpdate = new List<int>();

                while (reader.Read())
                {
                    if (lines == 0)
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
                        sb.Append(reader.GetName(17).ToString() + ",");
                        sb.AppendLine();
                    }
                    sb.Append(reader["SCORE_SEQ"].ToString() + ",");
                    sb.Append(reader["STD_CODE"].ToString() + ",");
                    sb.Append(reader["QNO"].ToString() + ",");
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
                    seqUpdate.Add(Convert.ToInt32(reader["SCORE_SEQ"]));
                    if (lines % 10 == 0) // %10000
                    {
                        sw.Write(sb.ToString());
                        sb = new StringBuilder();
                    }
                    lines++;
                }
                reader.Close();
                if (sw.BaseStream != null) //Valid
                {
                    try
                    {
                        trans = conn.BeginTransaction();
                        SqlCommand command2 = new SqlCommand("UPDATE TRN_XM_SCORE SET IS_EXPORT = '1',EXPORT_BY = @exportby,EXPORT_DATETIME = getdate() WHERE SCORE_SEQ = @seqUpdate;", conn);
                        //command.Parameters.AddWithValue("@stdCode", studentCode);
                        command2.Parameters.AddWithValue("@exportby", HttpContext.Current.Session["USER_ID"].ToString());
                        command2.Parameters.AddWithValue("@seqUpdate", "");
                        Boolean AllOK = true;

                        foreach (int element in seqUpdate)
                        {
                            try
                            {
                                //Response.Write(element);
                                //Response.Write("B");
                                command2.Parameters["@seqUpdate"].Value = element;
                                command2.Transaction = trans;
                                command2.ExecuteNonQuery();
                                //result = command2.ExecuteNonQuery();
                                //Response.Write(" " + result);
                            }
                            catch (Exception ex)
                            {
                                AllOK = false;
                                break;
                            }
                        }

                        if (AllOK)
                        {
                            trans.Commit();
                        }
                        else
                        {
                            trans.Rollback();
                        }

                        conn.Close();
                        ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'Export Done.',   text: 'File Location: "+ exportName + "',   type: 'success',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
                    }
                    catch (Exception ex)
                    {
                        //Response.Write("Error 2");
                        //Response.Write(ex);
                        trans.Rollback();
                    }
                    finally
                    {
                        if (conn != null && conn.State == ConnectionState.Open)
                        {
                            conn.Close();
                        }
                    }
                }
                else
                {
                    //Response.Write("InValid");
                }

                

            }
            conn.Close();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'คำเตือน!',   text: 'Error!',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
            //Response.Write(ex);
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        //return StatusBox;

    }
}
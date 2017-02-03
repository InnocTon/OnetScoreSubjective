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

public partial class deletefileimport : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public class recieveValueimpseq
    {
        public string filecode { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public static string delfile(string fcode)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(fcode);


        String FILE_CODE = param.filecode.ToString();
        String delete_result = "";

        if (FILE_CODE != "")
        {
            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;
            String FILE_TYPE = "";
            String FILE_NAME = "";
            try
            {
                conn.Open();
                //trans = conn.BeginTransaction();
                String query = "SELECT * FROM [TRN_FAC_IMPORT] WHERE IMP_SEQ = @filecode";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@filecode", FILE_CODE);
                //  command.Transaction = trans;
                SqlDataReader reader;
                reader = command.ExecuteReader();
                while (reader.Read())
                {
                    FILE_TYPE = reader["IMPTYPE_CODE"].ToString();
                    FILE_NAME = reader["OLD_FILE_NAME"].ToString();
                }
                reader.Close();

                if (FILE_TYPE != "")
                {

                    switch (FILE_TYPE)
                    {
                        case "BOX": delete_result = deleteBox(FILE_CODE); break;
                        case "PACKAGE": delete_result = deletePackage(FILE_CODE); break;
                        case "PAPER": delete_result = deletePaper(FILE_CODE); break;
                        default: break;
                    }


                    if (delete_result == "")
                    {
                        
                        trans = conn.BeginTransaction();
                        query = "UPDATE [TRN_FAC_IMPORT] SET [IMP_STATUS] = 'C',UPDATE_BY = @uby, UPDATE_DATETIME = getdate() WHERE [IMP_SEQ] = @filecode ";
                        command = new SqlCommand(query, conn);
                        command.Parameters.AddWithValue("@filecode", FILE_CODE);
                        command.Parameters.AddWithValue("@uby", HttpContext.Current.Session["USER_ID"].ToString());
                        command.Transaction = trans;
                        int result = command.ExecuteNonQuery();
                        if (result == 1)
                        {

                            query = "INSERT INTO SYS_LOG([LOG_NAME],[LOG_DESC],[LOG_DATE],[LOG_TYPE],[LOG_CODE]) values(@logname , @logdesc, getdate() , @logtype , @logcode)";
                            command = new SqlCommand(query, conn);
                            command.Parameters.AddWithValue("@logname", "Delete Data "+ FILE_TYPE + " Success");
                            command.Parameters.AddWithValue("@logtype", "DELETE" + FILE_TYPE);
                            command.Parameters.AddWithValue("@logcode", HttpContext.Current.Session["USER_ID"].ToString());
                            command.Parameters.AddWithValue("@logdesc", "ยกเลิกการนำเข้าไฟล์ " + FILE_NAME + " สำเร็จ");
                            command.Transaction = trans;
                            result = command.ExecuteNonQuery();
                            if (result == 1)
                            {
                                trans.Commit();
                                delete_result = "1";
                            }
                            else
                            {
                                trans.Rollback();
                                delete_result = "ไม่สามารถบันทึกข้อมูล log กรุณาลองใหม่อีกครั้ง";
                            }

                         
                        }
                        else
                        {
                            trans.Rollback();
                            delete_result = "ไม่สามารถลบข้อมูลได้ กรุณาลองใหม่อีกครั้ง";
                        }
                    }
                }
                else
                {
                    delete_result = "ไม่สามารถลบข้อมูลได้ เนื่องากไม่มีไฟล์นี้ในฐานข้อมูล";
                }


                conn.Close();
            }
            catch (Exception ex)
            {
                delete_result = ex.Message.ToString();
            }
            finally
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }

        }

        //  Response.Redirect("reportimportomr.aspx?type=delete&result=" + delete_result);


        return new JavaScriptSerializer().Serialize(delete_result);

        // return recieveValue;
    }


    public static String deleteBox(String FILE_CODE)
    {
        String delete_result = "";
        SqlConnection conn = new SqlConnection(connStr);
        SqlTransaction trans = null;
        try
        {
            conn.Open();
            trans = conn.BeginTransaction();
            String query = "UPDATE [TRN_XM_BOX] SET [BOX_STATUS] = 'C',[UPDATE_BY] = @uby,[UPDATE_DATETIME] = getdate() WHERE [IMP_SEQ] = @filecode";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@filecode", FILE_CODE);
            command.Parameters.AddWithValue("@uby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result > 0)
            {
                trans.Commit();
                delete_result = "";
            }
            else
            {
                trans.Rollback();
                delete_result = "ไม่สามารถลบข้อมูลใน TRN_XM_BOX ได้";
            }

            conn.Close();
        }
        catch (Exception ex)
        {
            
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return delete_result;
    }

    public static String deletePackage(String FILE_CODE)
    {
        String delete_result = "";
        SqlConnection conn = new SqlConnection(connStr);
        SqlTransaction trans = null;
        try
        {
            conn.Open();
            trans = conn.BeginTransaction();
            String query = "UPDATE [TRN_XM_PACKAGE] SET [PACKAGE_STATUS] = 'C',[UPDATE_BY] = @uby,[UPDATE_DATETIME] = getdate() WHERE [IMP_SEQ] = @filecode";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@filecode", FILE_CODE);
            command.Parameters.AddWithValue("@uby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result > 0)
            {
                trans.Commit();
                delete_result = "";
            }
            else
            {
                trans.Rollback();
                delete_result = "ไม่สามารถลบข้อมูลใน TRN_XM_PACKAGE ได้";
            }

            conn.Close();
        }
        catch (Exception ex)
        {

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return delete_result;
    }

    public static String deletePaper(String FILE_CODE)
    {
        String delete_result = "";
        SqlConnection conn = new SqlConnection(connStr);
        SqlTransaction trans = null;
        try
        {
            conn.Open();
            trans = conn.BeginTransaction();
            String query = "UPDATE [TRN_XM_PAPER] SET [PAPER_STATUS] = 'C',[UPDATE_BY] = @uby,[UPDATE_DATETIME] = getdate() WHERE [IMP_SEQ] = @filecode";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@filecode", FILE_CODE);
            command.Parameters.AddWithValue("@uby", HttpContext.Current.Session["USER_ID"].ToString());
            command.Transaction = trans;
            int result = command.ExecuteNonQuery();
            if (result > 0)
            {
                trans.Commit();
                delete_result = "";
            }
            else
            {
                trans.Rollback();
                delete_result = "ไม่สามารถลบข้อมูลใน TRN_XM_PAPER ได้";
            }

            conn.Close();
        }
        catch (Exception ex)
        {

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return delete_result;
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
}
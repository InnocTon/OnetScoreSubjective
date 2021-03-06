﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
       // login_username.Text = WebConfigurationManager.AppSettings["AppName"].ToString();
    }

    protected void signbtn_Click(object sender, EventArgs e)
    {
        String user = login_username.Text;
        String pass = login_password.Text;
        SqlConnection conn = new SqlConnection(connStr);
        String query = "SELECT [USER_ID],[USER_NAME],[USER_TYPE] FROM [SYS_USER] WHERE [USER_ID] = @user AND [USER_PASS] = @pass ";
        SqlCommand command = new SqlCommand(query, conn);
        command.Parameters.AddWithValue("@user", user);
        command.Parameters.AddWithValue("@pass", pass);
       
        try
        {
            conn.Open();
            String USER_NAME = String.Empty;
            String USER_TYPE = String.Empty;
            String USER_ID = String.Empty;
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                USER_NAME = reader["USER_NAME"].ToString();
                USER_TYPE = reader["USER_TYPE"].ToString();
                USER_ID = reader["USER_ID"].ToString();
            }

            conn.Close();
            reader.Close();

            if (USER_NAME != String.Empty)
            {
                //ADD TO SYS_LOG
                SqlTransaction trans = null;
                query = "INSERT INTO SYS_LOG([LOG_NAME],[LOG_DESC],[LOG_DATE],[LOG_TYPE],[LOG_CODE]) values(@logname , @logdesc, getdate() , @logtype , @logcode)";
                command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@logname","Login Success");
                command.Parameters.AddWithValue("@logtype", "LOGIN");
                command.Parameters.AddWithValue("@logcode", USER_ID);
                command.Parameters.AddWithValue("@logdesc", USER_NAME + " เข้าใช้งานระบบสำเร็จ");
                conn.Open();
                trans = conn.BeginTransaction();
                command.Transaction = trans;
                int result = command.ExecuteNonQuery();
                
                if(result == 1)
                {
                    trans.Commit();
                    Session.Add("USER_ID", USER_ID);
                    Session.Add("USER_NAME", USER_NAME);
                    Session.Add("USER_TYPE", USER_TYPE);
                    conn.Close();
                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    trans.Rollback();
                    conn.Close();
                    ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'เกิดความผิดพลาด!',   text: 'ไม่สามารถบันทึก log ได้. กรุณาลองใหม่อีกครั้ง',   type: 'error',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
                }

                

            }else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'เกิดความผิดพลาด!',   text: 'ข้อมูลผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง.  กรุณาลองใหม่อีกครั้ง',   type: 'error',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
            }


            

            

        }
        catch(Exception ex)
        {
            Response.Write(ex.Message);
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }
}
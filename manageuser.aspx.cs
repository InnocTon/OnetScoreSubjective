using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class manageuser : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void adddatabtn_Click(object sender, EventArgs e)
    {
        String user_code = usercodetxt.Value.ToString();
        String user_name = nametxt.Value.ToString();
        String user_type = typeaction.Value.ToString();
        String user_pass = passwordtxt.Value.ToString();

        Boolean StatusUser = CheckUserDuplicate(user_code);

        if (StatusUser)
        {

            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;
            try
            {
                conn.Open();
                trans = conn.BeginTransaction();

                String query = "INSERT INTO [dbo].[SYS_USER] ([USER_ID],[USER_NAME],[USER_TYPE],[USER_STATUS],[USER_PASS]) VALUES (@USER_ID,@USER_NAME,@USER_TYPE,'N',@USER_PASS)";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@USER_ID", user_code);
                command.Parameters.AddWithValue("@USER_NAME", user_name);
                command.Parameters.AddWithValue("@USER_TYPE", user_type);
                command.Parameters.AddWithValue("@USER_PASS", user_pass);
                command.Transaction = trans;
                int result = command.ExecuteNonQuery();

                if (result == 1)
                {
                    trans.Commit();
                    showMessage("สำเร็จ", "เพิ่มข้อมูลผู้ใช้งานเรียบร้อยแล้ว", "success");


                    usercodetxt.Value = "";
                    nametxt.Value = "";
                    typeaction.Value = "";
                    passwordtxt.Value = "";


                }
                else
                {
                    trans.Rollback();
                    showMessage("ผิดพลาด", "ไม่สามารถเพิ่มข้อมูลผู้ใช้งานได้", "error");
                }


            }
            catch (Exception ex)
            {
                trans.Rollback();
                showMessage("ข้อผิดพลาด!", ex.Message, "error");

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
            showMessage("คำเตือน!", "มีข้อมูลผู้ใช้งาน " + user_code + "นี้อยู่ในฐานข้อมูลแล้ว", "warning");
        }


    }

    private Boolean CheckUserDuplicate(String user_code)
    {
        Boolean StatusRater = false;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM SYS_USER WHERE USER_ID  = @user AND USER_STATUS = 'N' ";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@user", user_code);
            SqlDataReader reader = command.ExecuteReader();
            String username = "";
            while (reader.Read())
            {
                username = reader["USER_NAME"].ToString();
            }


            if (username != "")
            {
                StatusRater = false;
            }
            else
            {
                StatusRater = true;
            }

            reader.Close();
            conn.Close();
        }
        catch (Exception ex)
        {
            showMessage("ข้อผิดพลาด!", ex.Message, "error");
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return StatusRater;
    }


    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }
}
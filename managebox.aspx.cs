using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class managebox : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void listdirectorybtn_Click(object sender, EventArgs e)
    {
        
    }

    protected void adddatabtn_Click(object sender, EventArgs e)
    {
        //  Label1.Text = "1TON";
        //  showMessage("test", boxcodetxt.Value.ToString(), "error");
        String boxcode = boxcodetxt.Value.ToString();
        String usercode = usercodetxt.Value.ToString();

        // CHECK BOX CODE in DB
        Boolean StatusBox = CheckBoxStatus(boxcode);
        Boolean StatusUser = CheckUserStatus(usercode);

        if(StatusBox && StatusUser)
        {

            SqlConnection conn = new SqlConnection(connStr);
            try
            {
                conn.Open();
                String query = "UPDATE TRN_XM_BOX SET [OWNER_BY] = @usercode, [OWNER_DATETIME] = getdate() WHERE [BOX_CODE] = @boxcode";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@boxcode", boxcode);
                command.Parameters.AddWithValue("@usercode", usercode);
                int result = command.ExecuteNonQuery();
                if(result == 1)
                {
                    showMessage("สำเร็จ", "บันทึกข้อมูลการรับกล่องเรียบร้อยแล้ว", "success");
                }
                else
                {
                    showMessage("ข้อผิดพลาด!","เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
                }
            }
            catch(Exception ex)
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
               

        }

    }

    private Boolean CheckBoxStatus(String boxcode)
    {
        Boolean StatusBox = true;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_BOX WHERE BOX_CODE = @boxcode AND BOX_STATUS = 'N'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@boxcode", boxcode);
            SqlDataReader reader = command.ExecuteReader();
            String owner = "";
            String boxseq = "";
            while (reader.Read())
            {
                owner = reader["OWNER_BY"].ToString();
                boxseq = reader["BOX_SEQ"].ToString();
            }



            if (boxseq == "")
            {
                showMessage("คำเตือน!", "ไม่พบกล่องใบนี้ในฐานข้อมูล", "warning");
                StatusBox = false;
            }
            else if (owner != "")
            {
                showMessage("คำเตือน!", "กล่องใบนี้ได้ถูกนำออกจากห้องมั่นคงเรียบร้อยแล้ว โดย " + owner, "warning");
                StatusBox = false;
            }
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

        return StatusBox;
    }
    private Boolean CheckUserStatus(String usercode)
    {
        Boolean StatusUser = true;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM SYS_USER WHERE USER_ID = @usercode AND USER_STATUS = 'N'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@usercode", usercode);
            SqlDataReader reader = command.ExecuteReader();
            String username = "";
            while (reader.Read())
            {
                username = reader["USER_NAME"].ToString();
            }

            if (username == "")
            {
                showMessage("คำเตือน!", "ไม่พบรายชื่อเจ้าหน้าที่ในฐานข้อมูล", "warning");
                StatusUser = false;
            }
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

        return StatusUser;
    }
    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }

}
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
        String actionstatus = boxaction.Value.ToString();


        // CHECK BOX CODE in DB
        Boolean StatusBox = CheckBoxStatus(boxcode, actionstatus);
        Boolean StatusUser = CheckUserStatus(usercode);

        if(StatusBox && StatusUser)
        {

            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;
            try
            {

                String box_status = "N";

                switch (actionstatus)
                {
                    case "borrow": box_status = "B"; break;
                    case "return": box_status = "N"; break;
                }

                conn.Open();
                trans = conn.BeginTransaction();

                String query = "UPDATE TRN_XM_BOX SET BOX_STATUS = @boxstatus,UPDATE_BY = @updateby,UPDATE_DATETIME = getdate() WHERE [BOX_CODE] = @boxcode;";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@boxcode", boxcode);
                command.Parameters.AddWithValue("@boxstatus", box_status);
                command.Parameters.AddWithValue("@updateby", Session["USER_ID"].ToString());
                command.Transaction = trans;
                int result = command.ExecuteNonQuery();
                if(result == 1)
                {

                    query = "INSERT INTO[TRN_XM_BOX_ACTION]([BOX_CODE],[OWNER_BY],[OWNER_DATETIME],[ACT_STATUS],[CREATE_BY],[CREATE_DATETIME])  VALUES(@boxcode,@ownerby,getdate(),@actstatus,@createby,getdate());";
                    command = new SqlCommand(query, conn);
                    command.Parameters.AddWithValue("@boxcode", boxcode);
                    command.Parameters.AddWithValue("@ownerby", usercode);
                    command.Parameters.AddWithValue("@actstatus", actionstatus);
                    command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                    command.Transaction = trans;
                    result = command.ExecuteNonQuery();

                    if(result == 1)
                    {
                        trans.Commit();
                        showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งกล่องเรียบร้อยแล้ว", "success");
                        boxcodetxt.Value = "";
                        usercodetxt.Value = "";
                        boxaction.Value = "";
                    }
                    else
                    {
                        trans.Rollback();
                        showMessage("ผิดพลาด", "ไม่สามารถบันทึกข้อมูลการรับ-ส่งกล่องได้", "error");
                    }

                   


                    
                }
                else
                {
                    trans.Rollback();
                    showMessage("ข้อผิดพลาด!","เกิดความผิดพลาดในการรับกล่อง. กรุณาลองใหม่อีกครั้ง!", "error");
                }


                conn.Close();

            }
            catch(Exception ex)
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

    }

    private Boolean CheckBoxStatus(String boxcode,String actionstatus)
    {
        Boolean StatusBox = true;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_BOX WHERE BOX_CODE = @boxcode AND BOX_STATUS != 'C'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@boxcode", boxcode);
            SqlDataReader reader = command.ExecuteReader();
            String bstatus = "";
            String bseq = "";
            while (reader.Read())
            {
                bstatus = reader["BOX_STATUS"].ToString();
                bseq = reader["BOX_SEQ"].ToString();

            }




            if (bseq == "")
            {
                showMessage("คำเตือน!", "ไม่พบกล่องใบนี้ในฐานข้อมูล", "warning");
                StatusBox = false;
            }
            else
            {
                if(actionstatus == "borrow" && bstatus != "N")
                {
                    showMessage("คำเตือน!", "สถานะกล่องใบนี้ไม่อยู่ในห้องมั่นคง", "warning");
                    StatusBox = false;
                }

                if(actionstatus == "return" && bstatus != "B")
                {
                    showMessage("คำเตือน!", "สถานะกล่องใบนี้อยู่ในห้องมั่นคงอยู่แล้ว", "warning");
                    StatusBox = false;
                }
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

        return StatusUser;
    }
    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }

}
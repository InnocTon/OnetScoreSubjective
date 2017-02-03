using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Worktime : System.Web.UI.Page
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void adddatabtn_Click(object sender, EventArgs e)
    {
        String ratercode = ratercodetxt.Value.ToString();

        String ratername = CheckRaterStatus(ratercode);

        if (ratername == "")
        {
            showMessage("คำเตือน!", "ไม่พบรายชื่อผู้ตรวจในฐานข้อมูล", "warning");
        }else
        {
            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;

            try
            {
                conn.Open();
                trans = conn.BeginTransaction();
                String query = "INSERT INTO TRN_XM_WORKDATE(RATER_CODE,WORK_DATE,CREATE_BY,CREATE_DATETIME) VALUES(@ratercode,getdate(), @createby,getdate())";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@ratercode", ratercode);
                command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                command.Transaction = trans;
                int result = command.ExecuteNonQuery();
                if (result == 1)
                {
                    trans.Commit();
                    showMessage("สำเร็จ", "บันทึกข้อมูลปฏิบัติงานเรียบร้อยแล้ว", "success");
                    ratercodetxt.Value = "";
                }
                else
                {
                    trans.Rollback();
                    showMessage("ผิดพลาด", "ไม่สามารถบันทึกข้อมูลปฏิบัติงานได้", "error");
                }
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


    private String CheckRaterStatus(String ratercode)
    {
      //  Boolean StatusUser = true;
        SqlConnection conn = new SqlConnection(connStr);
        String ratername = "";
        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_RATER WHERE RATER_CODE = @ratercode AND RATER_STATUS = 'N' AND RATER_TYPE = 'NORMAL'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@ratercode", ratercode);
            SqlDataReader reader = command.ExecuteReader();
           
            while (reader.Read())
            {
                ratername = reader["RATER_FNAME"].ToString();
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

        return ratername;
    }

    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }

}
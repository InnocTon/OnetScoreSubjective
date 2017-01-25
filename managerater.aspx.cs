using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class managerater : System.Web.UI.Page
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void adddatabtn_Click(object sender, EventArgs e)
    {
        String rater_code = ratercodetxt.Value.ToString();
        String rater_prename = prenametxt.Value.ToString();
        String rater_fname = fnametxt.Value.ToString();
        String rater_lname = lnametxt.Value.ToString();
        String rater_citizenid = citizentxt.Value.ToString();
        String rater_place = placeaction.Value.ToString();

        Boolean StatusRater = CheckRaterDuplicate(rater_citizenid);

        if (StatusRater)
        {

            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;
            try
            {
                conn.Open();
                trans = conn.BeginTransaction();

                String query = "INSERT INTO [dbo].[TRN_XM_RATER] ([RATER_CODE],[RATER_PRENAME],[RATER_FNAME],[RATER_LNAME],[RATER_CITIZENID],[RATER_PLACE],[RATER_STATUS],[RATER_TYPE],[CREATE_BY],[CREATE_DATETIME]) VALUES (@RATER_CODE,@RATER_PRENAME,@RATER_FNAME,@RATER_LNAME,@RATER_CITIZENID,@RATER_PLACE,@RATER_STATUS,@RATER_TYPE,@CREATE_BY, getdate())";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@RATER_CODE", rater_code);
                command.Parameters.AddWithValue("@RATER_PRENAME", rater_prename);
                command.Parameters.AddWithValue("@RATER_FNAME", rater_fname);
                command.Parameters.AddWithValue("@RATER_LNAME", rater_lname);
                command.Parameters.AddWithValue("@RATER_CITIZENID", rater_citizenid);
                command.Parameters.AddWithValue("@RATER_PLACE", rater_place);
                command.Parameters.AddWithValue("@RATER_STATUS", "N");
                command.Parameters.AddWithValue("@RATER_TYPE", "NORMAL");
                command.Parameters.AddWithValue("@CREATE_BY", Session["USER_ID"].ToString());
                command.Transaction = trans;
                int result = command.ExecuteNonQuery();

                if (result == 1)
                {
                    trans.Commit();
                    showMessage("สำเร็จ", "เพิ่มข้อมูลผู้ตรวจเรียบร้อยแล้ว", "success");


                    ratercodetxt.Value = "";
                    prenametxt.Value = "";
                    fnametxt.Value = "";
                    lnametxt.Value = "";
                    citizentxt.Value = "";
                    placeaction.Value = "";


                }
                else
                {
                    trans.Rollback();
                    showMessage("ผิดพลาด", "ไม่สามารถเพิ่มข้อมูลผู้ตรวจได้", "error");
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
            showMessage("คำเตือน!", "มีข้อมูลเลขบัตรประาชน " + rater_citizenid + "นี้อยู่ในฐานข้อมูลผู้ตรวจแล้ว", "warning");
        }

        

    }


    private Boolean CheckRaterDuplicate(String rater_citizenid)
    {
        Boolean StatusRater = false;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_RATER WHERE RATER_CITIZENID = @citizenid AND RATER_STATUS = 'N'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@citizenid", rater_citizenid);
            SqlDataReader reader = command.ExecuteReader();
            String raterseq = "";
            while (reader.Read())
            {
                raterseq = reader["RATER_SEQ"].ToString();
            }


            if (raterseq != "")
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
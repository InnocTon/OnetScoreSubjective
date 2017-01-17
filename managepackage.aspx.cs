using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class managepackage : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void adddatabtn_Click(object sender, EventArgs e)
    {
        String packagecode = packagecodetxt.Value.ToString();
        String ratercode = ratercodetxt.Value.ToString();
        String actionstatus = boxaction.Value.ToString();


        // CHECK PACKAGE CODE in DB
        Boolean StatusBox = CheckPackageStatus(packagecode, actionstatus);

    }

    private Boolean CheckPackageStatus(String packagecode, String actionstatus)
    {
        Boolean StatusBox = true;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_PACKAGE WHERE PACKAGE_CODE = @packagecode AND PACKAGE_STATUS != 'C'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@packagecode", packagecode);
            SqlDataReader reader = command.ExecuteReader();
            String pstatus = "";
            String pseq = "";
            while (reader.Read())
            {
                pstatus = reader["PACKAGE_STATUS"].ToString();
                pseq = reader["PACKAGE_SEQ"].ToString();

            }


           

            if (pseq == "")
            {
                showMessage("คำเตือน!", "ไม่พบซองนี้ในฐานข้อมูล", "warning");
                StatusBox = false;
            }
            else
            {
                if (actionstatus == "rater" && (pstatus != "N" && pstatus != "S"))
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถแจกได้", "warning");
                    StatusBox = false;
                }

                if (actionstatus == "return" && pstatus != "R")
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถนำส่งคืนได้", "warning");
                    StatusBox = false;
                }

                if(actionstatus == "omr" && pstatus != "S")
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถนำส่งห้อง OMR ได้", "warning");
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

    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }
}
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class managescorediff : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void listdirectorybtn_Click(object sender, EventArgs e)
    {
        SqlConnection conn = new SqlConnection(connStr);
        try
        {

            conn.Open();
            SqlCommand command = new SqlCommand("[CHECKDIFFNO2]", conn);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@createby", SqlDbType.VarChar).Value = Session["USER_ID"].ToString();
            command.ExecuteNonQuery();


            command = new SqlCommand("[CHECKDIFFNO1]", conn);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@createby", SqlDbType.VarChar).Value = Session["USER_ID"].ToString();
            command.ExecuteNonQuery();


            conn.Close();
            showMessage("สำเร็จ!", "ประมวลผลค่า DIFF เรียบร้อยแล้ว", "success");
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

    }




    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ window.location = 'managescorediff.aspx'; });", true);
    }


}
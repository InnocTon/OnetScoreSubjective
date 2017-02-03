using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class logout : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {

        String user_name = Session["USER_NAME"].ToString();
        String user_id = Session["USER_ID"].ToString();

        SqlConnection conn = new SqlConnection(connStr);
        SqlTransaction trans = null;
        String query = "INSERT INTO SYS_LOG([LOG_NAME],[LOG_DESC],[LOG_DATE],[LOG_TYPE],[LOG_CODE]) values(@logname , @logdesc, getdate() , @logtype , @logcode)";
        SqlCommand command = new SqlCommand(query, conn);
        command.Parameters.AddWithValue("@logname", "Logout Success");
        command.Parameters.AddWithValue("@logtype", "LOGOUT");
        command.Parameters.AddWithValue("@logcode", user_id);
        command.Parameters.AddWithValue("@logdesc", user_name + " เข้าใช้งานระบบสำเร็จ");
        conn.Open();
        trans = conn.BeginTransaction();
        command.Transaction = trans;
        int result = command.ExecuteNonQuery();

        if (result == 1)
        {
            trans.Commit();          
            conn.Close();
            Session.RemoveAll();
            Response.Redirect("default.aspx");
        }
        else
        {
            trans.Rollback();
            conn.Close();
            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'เกิดความผิดพลาด!',   text: 'ไม่สามารถบันทึก log ได้. กรุณาลองใหม่อีกครั้ง',   type: 'error',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ window.location='dashboard.aspx'; });", true);
        }

        
    }
}
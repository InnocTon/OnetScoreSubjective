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

public partial class deleteuser : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public class recieveValueimpseq
    {
        public string usercode { get; set; }

    }


    [WebMethod(EnableSession = true)]
    public static string deluser(string ucode)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(ucode);


        String USER_CODE = param.usercode.ToString();
        String delete_result = "";

        if (USER_CODE != "")
        {
            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;

            try
            {
                conn.Open();
                trans = conn.BeginTransaction();
                String query = "UPDATE SYS_USER SET USER_STATUS = 'C',UPDATE_BY = @upby, UPDATE_DATETIME = getdate() WHERE USER_ID = @uid";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@uid", USER_CODE);
                command.Parameters.AddWithValue("@upby", HttpContext.Current.Session["USER_ID"].ToString());
                command.Transaction = trans;
                int result = command.ExecuteNonQuery();
                if (result == 1)
                {
                    trans.Commit();
                    delete_result = "1";
                }
                else
                {
                    trans.Rollback();
                    delete_result = "ไม่สามารถลบข้อมูลผู้ใช้งานได้";
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

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}
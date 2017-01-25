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

public partial class deleterater : System.Web.UI.Page
{


    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    public class recieveValueimpseq
    {
        public string raterseq { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public static string delrater(string rseq)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(rseq);


        String RATER_SEQ = param.raterseq.ToString();
        String delete_result = "";

        if (RATER_SEQ != "")
        {
            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;

            try
            {
                conn.Open();
                trans = conn.BeginTransaction();
                String query = "UPDATE TRN_XM_RATER SET RATER_STATUS = 'C',UPDATE_BY = @upby, UPDATE_DATETIME = getdate() WHERE RATER_SEQ = @rseq";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@rseq", RATER_SEQ);
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
                    delete_result = "ไม่สามารถลบข้อมูลผู้ตรวจได้";
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
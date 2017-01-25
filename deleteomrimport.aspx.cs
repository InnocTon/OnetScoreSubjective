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


public partial class deleteomrimport : System.Web.UI.Page
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public class recieveValueimpseq
    {
        public string omrimpseq { get; set; }

    }

    [WebMethod(EnableSession = true)]
    public static string deleteomr(string impseq)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(impseq);
        

        String IMP_SEQ = param.omrimpseq.ToString();
        String delete_result = "";

        if (IMP_SEQ != "")
        {
            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;

            try
            {


                conn.Open();
                String NRECORD = "";
                String query = "select COUNT(*) as NRECORD from trn_xm_batch_detail where IMP_SEQ = @impseq  AND IS_CHECK = '1'";
                SqlCommand command = new SqlCommand(query, conn);
                // CHECK ว่า ข้อมูลไม่ได้ถูกคำนวรไปแล้ว
                command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    NRECORD = reader["NRECORD"].ToString();
                }

                reader.Close();

                if (NRECORD == "0")
                {
                    trans = conn.BeginTransaction();
                    query = "UPDATE TRN_OMR_IMPORT SET IMP_STATUS = 'C',UPDATE_BY = @upby,UPDATE_DATETIME = getdate() WHERE IMP_SEQ = @impseq";
                    command = new SqlCommand(query, conn);
                    command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                    command.Parameters.AddWithValue("@upby", HttpContext.Current.Session["USER_ID"].ToString());
                    command.Transaction = trans;
                    int result = command.ExecuteNonQuery();
                    if (result == 1)
                    {
                        result = 0;
                        query = "UPDATE trn_xm_batch_detail SET SHEET_STATUS = 'C',UPDATE_BY = @upby,UPDATE_DATETIME = getdate() WHERE IMP_SEQ = @impseq";
                        command = new SqlCommand(query, conn);
                        command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                        command.Parameters.AddWithValue("@upby", HttpContext.Current.Session["USER_ID"].ToString());
                        command.Transaction = trans;
                        result = command.ExecuteNonQuery();
                        if (result > 0)
                        {
                            trans.Commit();
                            delete_result = "1";
                        }
                        else
                        {
                            trans.Rollback();
                            delete_result = "ไม่สามารถแก้ไขข้อมูล OMR ได้";
                        }
                    }
                    else
                    {
                        trans.Rollback();
                        delete_result = "ไม่สามารถแก้ไขข้อมูลไฟล์ที่นำเข้าได้";
                    }
                }
                else
                {
                    delete_result = "ไม่สามารถแก้ไขข้อมูลไฟล์ที่นำเข้าได้ เนื่องจากข้อมูลที่นำเข้าได้ถูกคำนวณไปแล้ว";
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
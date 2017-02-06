using CrystalDecisions.CrystalReports.Engine;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class papercopy3report : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["papercode"] != null)
        {
            

            ReportDocument crystalReport = new ReportDocument();
            DataTable dt = new DataTable("PAPERTABLE");
            dt.Columns.Add(new DataColumn("PAPERCODE", typeof(string)));
            dt.Columns.Add(new DataColumn("IMGURL", typeof(string)));

            if (Request.QueryString["papercode"].ToString() != "all")
            {

                if (Request.QueryString["qno"].ToString() == "1")
                {
                    crystalReport.Load(Server.MapPath("~/singlepapercopy3no1.rpt"));
                }
                else
                {
                    crystalReport.Load(Server.MapPath("~/singlepapercopy3no2.rpt"));
                }

                String imgfilename = Request.QueryString["papercode"].ToString().Substring(0, 5) + "3" + Request.QueryString["papercode"].ToString().Substring(5, 8);

                String packagename = Request.QueryString["papercode"].ToString().Substring(0, 5) + "3" + Request.QueryString["papercode"].ToString().Substring(5, 5);

                String imgurl = @"D:\paperimg\" + packagename + "\\" + imgfilename + ".jpg";

              

                DataRow dr = dt.NewRow();
                dr["PAPERCODE"] = Request.QueryString["papercode"].ToString();


                dr["IMGURL"] = imgurl;
                dt.Rows.Add(dr);

                crystalReport.SetDataSource(dt);
                CrystalReportViewer1.ReportSource = crystalReport;
                CrystalReportViewer1.RefreshReport();

            }else
            {


                String query = "SELECT  ROW_NUMBER() OVER(ORDER BY QNO,OMR_SEQ ASC) AS Row# ,STD_CODE,QNO,SUBSTRING(STD_CODE,1,5) + '3' + SUBSTRING(STD_CODE,6,8) AS PAPERCODE FROM TRN_XM_SCORE_COPY1 WHERE IS_DIFF = '1' AND IS_COMPLETE = '0'  AND QNO = @QNO  ORDER BY STD_CODE";
                SqlConnection conn = new SqlConnection(connStr);
                

                try
                {

                    if (Request.QueryString["qno"].ToString() == "1")
                    {
                        crystalReport.Load(Server.MapPath("~/allpapercopy3no1.rpt"));
                    }
                    else
                    {
                        crystalReport.Load(Server.MapPath("~/allpapercopy3no2.rpt"));
                    }

                    String imgfilename = "";
                    String packagename = "";
                    String imgurl = "";
                    conn.Open();
                    SqlCommand command = new SqlCommand(query, conn);
                    command.Parameters.AddWithValue("@QNO", Request.QueryString["qno"].ToString());
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                         imgfilename = reader["STD_CODE"].ToString().Substring(0, 5) + "3" + reader["STD_CODE"].ToString().Substring(5, 8);

                         packagename = reader["STD_CODE"].ToString().Substring(0, 5) + "3" + reader["STD_CODE"].ToString().Substring(5, 5);

                         imgurl = @"D:\paperimg\" + packagename + "\\" + imgfilename + ".jpg";

                        DataRow dr = dt.NewRow();
                        dr["PAPERCODE"] = reader["STD_CODE"].ToString();
                        dr["IMGURL"] = imgurl;
                        dt.Rows.Add(dr);
                    }

                    reader.Close();
                    conn.Close();
                    conn = null;

                    crystalReport.SetDataSource(dt);
                    CrystalReportViewer1.ReportSource = crystalReport;
                    CrystalReportViewer1.RefreshReport();

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
    }


    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }
}
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

public partial class agentnametag : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["rater_seq"] != null)
        {

            SqlConnection conn = new SqlConnection(connStr);
            DataSet ds = new DataSet();
            DataTable dt = null;
            SqlDataAdapter dtAdapter = new SqlDataAdapter();

            try
            {
                conn.Open();


                String query = "SELECT [USER_NAME] AS RATER_NAME,[USER_CITIZENID] AS RATER_PID,[USER_ID] AS  RATER_CODE, [USER_PLACE] AS RATER_PLACE,CASE WHEN [USER_TYPE] = 'rater3' THEN 'วิทยากรแกนนำ' ELSE 'เจ้าหน้าที่' END AS RATER_GROUP, '' AS RATER_SEATNO FROM [SYS_USER] WHERE[USER_ID] = @seq";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@seq", Request.QueryString["rater_seq"].ToString());
                dtAdapter.SelectCommand = command;
                dtAdapter.Fill(ds, "DataTable1");
                dt = ds.Tables[0];

                dtAdapter = null;
                conn.Close();
                conn = null;


                ReportDocument crystalReport = new ReportDocument();
                crystalReport.Load(Server.MapPath("~/agenttag.rpt"));
                crystalReport.SetDataSource(dt);
                CrystalReportViewer1.ReportSource = crystalReport;
                CrystalReportViewer1.RefreshReport();

            }
            catch (Exception ex)
            {

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
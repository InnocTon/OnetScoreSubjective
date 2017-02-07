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

public partial class nametag : System.Web.UI.Page
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


                String query = "select RATER_PRENAME + ' ' + RATER_FNAME + ' ' + RATER_LNAME AS RATER_NAME,RATER_CITIZENID AS RATER_PID,RATER_CODE,RATER_PLACE,[GROUPID] AS RATER_GROUP,[SECTNO] AS RATER_SEATNO from trn_xm_rater inner join [dbo].[TRN_XM_SEATNO] on trn_xm_rater.RATER_CODE = [TRN_XM_SEATNO].BARCODE where RATER_STATUS = 'N' and RATER_SEQ = @seq";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@seq", Request.QueryString["rater_seq"].ToString());
                dtAdapter.SelectCommand = command;
                dtAdapter.Fill(ds, "DataTable1");
                dt = ds.Tables[0];

                dtAdapter = null;
                conn.Close();
                conn = null;


                ReportDocument crystalReport = new ReportDocument();
                crystalReport.Load(Server.MapPath("~/raternametag.rpt"));
                crystalReport.SetDataSource(dt);
                CrystalReportViewer1.ReportSource = crystalReport;
                CrystalReportViewer1.RefreshReport();

            }catch(Exception ex)
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
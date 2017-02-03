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

public partial class reportstatusbox : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        SqlConnection conn = new SqlConnection(connStr);
        BoxDataSet ds = new BoxDataSet();
        DataTable dt = null;
        SqlDataAdapter dtAdapter = new SqlDataAdapter();


        conn.Open();


        String query = "SELECT ROW_NUMBER() OVER(ORDER BY bx.BOX_SEQ ASC) AS[NO], bx.BOX_CODE, bx.PACKAGE_NUM, bxs.BSTATUS_NAME as BOX_STATUS FROM TRN_XM_BOX bx inner join [dbo].[MST_BOX_STATUS] bxs on bx.BOX_STATUS = bxs.BSTATUS_CODE  WHERE bx.BOX_STATUS != 'C'";


        SqlCommand command = new SqlCommand(query, conn);
        dtAdapter.SelectCommand = command;
        dtAdapter.Fill(ds, "BOXTABLE");
        dt = ds.Tables[0];

        dtAdapter = null;
        conn.Close();
        conn = null;

        foreach (DataRow dr in dt.Rows)
        {
            dr["PRINTBY"] = Session["USER_NAME"].ToString(); //change the name 
        }


        ReportDocument crystalReport = new ReportDocument();
        crystalReport.Load(Server.MapPath("~/statusboxreport.rpt"));
        crystalReport.SetDataSource(dt);
        CrystalReportViewer1.ReportSource = crystalReport;
        CrystalReportViewer1.RefreshReport();


    }
}
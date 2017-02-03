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

public partial class reportstatuspackage : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {
        SqlConnection conn = new SqlConnection(connStr);
        PackageDataSet ds = new PackageDataSet();
        DataTable dt = null;
        SqlDataAdapter dtAdapter = new SqlDataAdapter();


        conn.Open();


        String query = "SELECT ROW_NUMBER() OVER(ORDER BY PACKAGE_SEQ ASC) AS [NO],PACK.BOX_CODE AS BOXCODE,PACKAGE_CODE AS PACKAGECODE,PAPER_NUM,PSTATUS_NAME AS PACKAGE_STATUS FROM [dbo].[TRN_XM_PACKAGE] PACK INNER JOIN  [dbo].MST_PACKAGE_STATUS PSTATUS ON PACK.PACKAGE_STATUS = PSTATUS.PSTATUS_CODE INNER JOIN [dbo].[TRN_XM_BOX] BOX ON BOX.BOX_CODE = PACK.BOX_CODE";


        SqlCommand command = new SqlCommand(query, conn);
        dtAdapter.SelectCommand = command;
        dtAdapter.Fill(ds, "PACKAGETABLE");
        dt = ds.Tables[0];

        dtAdapter = null;
        conn.Close();
        conn = null;

        foreach (DataRow dr in dt.Rows) 
        {
           dr["PRINTBY"] = Session["USER_NAME"].ToString(); //change the name 
        }


        ReportDocument crystalReport = new ReportDocument();
        crystalReport.Load(Server.MapPath("~/statuspackagereport.rpt"));
        crystalReport.SetDataSource(dt);
        CrystalReportViewer1.ReportSource = crystalReport;
        CrystalReportViewer1.RefreshReport();

    }
}
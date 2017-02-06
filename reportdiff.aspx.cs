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

public partial class reportdiff : System.Web.UI.Page
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {
        ReportDocument crystalReport = new ReportDocument();
        DataTable dt = new DataTable("DIFFTABLE");
        dt.Columns.Add(new DataColumn("NO", typeof(string)));
        dt.Columns.Add(new DataColumn("STDCODE", typeof(string)));
        dt.Columns.Add(new DataColumn("QNO", typeof(string)));
        dt.Columns.Add(new DataColumn("PAPERCODE", typeof(string)));
        dt.Columns.Add(new DataColumn("CREATEDATE", typeof(string)));
        dt.Columns.Add(new DataColumn("PRINTBY", typeof(string)));

        SqlConnection conn = new SqlConnection(connStr);

        try
        {
            String qno = Request.QueryString["qno"].ToString();
            crystalReport.Load(Server.MapPath("~/summaryreportdiff.rpt"));
            conn.Open();
            String query = "SELECT  ROW_NUMBER() OVER(ORDER BY QNO,OMR_SEQ ASC) AS Row# ,STD_CODE,QNO,SUBSTRING(STD_CODE,1,5) + '3' + SUBSTRING(STD_CODE,6,8) AS PAPERCODE, CREATE_DATETIME FROM TRN_XM_SCORE_COPY1 WHERE IS_DIFF = '1' AND IS_COMPLETE = '0'  AND QNO = @QNO ";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@QNO", Request.QueryString["qno"].ToString());
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
               

                DataRow dr = dt.NewRow();
                dr["NO"] = reader["Row#"].ToString();
                dr["STDCODE"] = reader["STD_CODE"].ToString();
                dr["QNO"] = reader["QNO"].ToString();
                dr["PAPERCODE"] = reader["PAPERCODE"].ToString();
                dr["CREATEDATE"] = reader["CREATE_DATETIME"].ToString();
                dr["PRINTBY"] = Session["USER_NAME"].ToString();
                dt.Rows.Add(dr);
            }

            reader.Close();
            conn.Close();
            conn = null;

            crystalReport.SetDataSource(dt);
            CrystalReportViewer1.ReportSource = crystalReport;
            CrystalReportViewer1.RefreshReport();

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
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }
}
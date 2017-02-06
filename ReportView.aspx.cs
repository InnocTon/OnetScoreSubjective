using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ReportView : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        ReportBind(TextBox1.Text);
    }
    private void ReportBind(string userid)
    {
        
        var rs = new Report1().GetUserReportData(userid);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/App_Code/ReportDataSource/UserReport.rdlc");

        ReportViewer1.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("UserData", rs));
        ReportViewer1.LocalReport.Refresh();

        this.ReportViewer1.Visible = true;
        this.ReportViewer1.ShowBackButton = false;
        this.ReportViewer1.ShowFindControls = false;
        this.ReportViewer1.ShowParameterPrompts = false;
        this.ReportViewer1.ShowPrintButton = true;
        this.ReportViewer1.ShowZoomControl = true;
        this.ReportViewer1.ShowRefreshButton = false;
        ReportViewer1.SizeToReportContent = true;
        ReportViewer1.ZoomMode = ZoomMode.FullPage;
        //string deviceInfo =
        //                     "<DeviceInfo>" +
        //                     "  <OutputFormat>EMF</OutputFormat>" +
        //                     "  <PageWidth>21cm</PageWidth>" +
        //                     "  <PageHeight>29.7cm</PageHeight>" +
        //                     "  <MarginTop>0.25in</MarginTop>" +
        //                     "  <MarginLeft>0.25in</MarginLeft>" +
        //                     "  <MarginRight>0.25in</MarginRight>" +
        //                     "  <MarginBottom>0.25in</MarginBottom>" +
        //                     "</DeviceInfo>";

        this.ReportViewer1.DataBind();


    }
}
<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="reportstatuspackage.aspx.cs" Inherits="reportstatuspackage" %>


<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <script lang="javaScript" type="text/javascript" src="aspnet_client/system_web/4_0_30319/crystalreportviewers13/js/crviewer/crv.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <form id="form1" runat="server">
    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <h1><i class="material-icons md-24">&#xE415;</i> ซองบรรจุใบบันทึกคะแนนอัตนัย</h1>
        <span class="uk-text-upper uk-text-small">รายงานสถานะซองบรรจุใบบันทึกคะแนนอัตนัย</span>
    </div>

    <div id="page_content_inner">

             <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="True" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" ToolPanelView="None" Width="881px" GroupTreeImagesFolderUrl="" Height="1269px" ToolbarImagesFolderUrl="" ToolPanelWidth="200px" />

    </div>

    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
</asp:Content>


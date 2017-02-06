<%@ Page Language="C#" AutoEventWireup="true" CodeFile="diffReportView.aspx.cs" Inherits="ReportView" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server"> 
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    <div>
        test
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button" />
    </div>
    <div>
    
       
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="500"> 
        </rsweb:ReportViewer>
    
    </div>
    </form>
</body>
</html>

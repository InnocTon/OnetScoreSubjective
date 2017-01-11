<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="importomr.aspx.cs" Inherits="importomr" %>
<%@ MasterType TypeName="MainMasterPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <form id="form1" runat="server">
    <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click"/>
    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
         <asp:Label ID="Label2" runat="server" Text="Label2"></asp:Label>
         </form>
</asp:Content>


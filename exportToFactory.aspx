<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="exportToFactory.aspx.cs" Inherits="exportToFactory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server">
        <div id="page_content_inner">
            <div class="md-card">
                <div class="md-card-content">
                    <div class="uk-grid uk-grid-divider" data-uk-grid-margin>
                        <div class="uk-width-large-2-2 uk-width-medium-2-2">
                            <h2><i class="material-icons">&#xE3EA;</i> Export Data</h2>
                            <span class="uk-text-upper uk-text-small">Export ข้อมูลส่งให้ศูนย์กลาง <br />Click ที่ปุ่มเพื่อ Export ไฟล์</span>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin="">
                            <div class="uk-width-medium-1-10 uk-text-center">
                                <asp:button ID="btnExport" runat="server" text="Export To Factory" OnClick="ButtonExport_Click" CssClass="uk-form-file md-btn md-btn-primary" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>


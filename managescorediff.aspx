<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="managescorediff.aspx.cs" Inherits="managescorediff" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server">
        <div id="page_content_inner">
            <div class="md-card">
                <div class="md-card-content">
                    <div class="uk-grid uk-grid-divider" data-uk-grid-margin>
                        <div class="uk-width-large-2-2 uk-width-medium-2-2">
                            <h2><i class="material-icons">&#xE3EA;</i> ประมวลผลค่า Diff</h2>
                            <span class="uk-text-upper uk-text-small">ประมวลผลคะแนนหาค่าผลต่าของคะแนนเกิน 15%</span>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin="">
                            <div class="uk-width-medium-1-10 uk-text-center">
                                <!-- <input type="file" multiple webkitdirectory id="fileURL" /> -->
                                <asp:Button ID="listdirectorybtn" runat="server" Text="ประมวลผล" OnClick="listdirectorybtn_Click" CssClass="uk-form-file md-btn md-btn-primary" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="md-card uk-margin-medium-bottom">
                <div class="md-card-content">
                    <div class="uk-overflow-container">
                        <asp:Table ID="ListFileTable" runat="server" class="uk-table">
                            <asp:TableHeaderRow>
                                <asp:TableCell>ลำดับที่</asp:TableCell>
                                <asp:TableCell>รหัสบาร์โค้ต</asp:TableCell>
                                <asp:TableCell>ผลต่างคะแนน</asp:TableCell>
                                <asp:TableCell>สถานะ</asp:TableCell>
                            </asp:TableHeaderRow>
                        </asp:Table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>


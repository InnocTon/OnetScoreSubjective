<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="importomr.aspx.cs" Inherits="importomr" %>
<%@ MasterType TypeName="MainMasterPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <form id="form1" runat="server">
        <div id="page_content_inner">
            <div class="md-card">
                <div class="md-card-content">
                    <div class="uk-grid" data-uk-grid-margin="">
                        <div class="uk-width-medium-2-10">
                            <div class="uk-margin-top uk-text-nowrap">
                                <input type="checkbox" name="checkduprecord" id="checkduprecord" data-md-icheck />
                                <label for="product_search_active" class="inline-label">ตรวจสอบข้อมูลซ้ำ</label>
                            </div>
                        </div>
                        <div class="uk-width-medium-2-10">
                            <div class="uk-margin-top uk-text-nowrap">
                                <input type="checkbox" name="checknumfile" id="checknumfile" data-md-icheck />
                                <label for="product_search_active" class="inline-label">ตรวจสอบจำนวน</label>
                            </div>
                        </div>
                        <div class="uk-width-medium-2-10">
                            <div class="uk-margin-top uk-text-nowrap">
                                <input type="checkbox" name="checklithocode" id="checklithocode" data-md-icheck />
                                <label for="product_search_active" class="inline-label">ตรวจสอบเลขที่ใบบันทึกคะแนน</label>
                            </div>
                        </div>
                        <div class="uk-width-medium-2-10 uk-text-center">
                            <!-- <input type="file" multiple webkitdirectory id="fileURL" /> -->
                            <asp:Button ID="listdirectorybtn" runat="server" Text="แสดงไฟล์" OnClick="listdirectorybtn_Click" CssClass="uk-form-file md-btn md-btn-primary" />
                        </div>
                        <div class="uk-width-medium-2-10 uk-text-center">
                            <!-- <input type="file" multiple webkitdirectory id="fileURL" /> -->
                            <asp:Button ID="importbtn" runat="server" Text="นำเข้าไฟล์" CssClass="uk-form-file md-btn md-btn-primary" OnClick="importbtn_Click" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="md-card uk-margin-medium-bottom">
                <div class="md-card-content">
                    <div class="uk-overflow-container">
                        <asp:GridView ID="GridViewListFile" CssClass="uk-table" runat="server" AutoGenerateColumns="false" EmptyDataText="ไม่มีไฟล์ที่ต้องนำเข้า">
                            <Columns>
                                <asp:BoundField DataField="Text" HeaderText="File Name" />
                            </Columns>
                        </asp:GridView>
                        <asp:Table ID="ListFileTable" runat="server" class="uk-table">
                            <asp:TableHeaderRow>
                                <asp:TableCell>ลำดับที่</asp:TableCell>
                                <asp:TableCell>ชื่อไฟล์</asp:TableCell>
                                <asp:TableCell>สถานะ</asp:TableCell>
                            </asp:TableHeaderRow>
                        </asp:Table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>


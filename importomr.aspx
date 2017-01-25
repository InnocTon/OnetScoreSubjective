<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="importomr.aspx.cs" Inherits="importomr" %>

<%@ MasterType TypeName="MainMasterPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server">
        <div id="page_content_inner">
            <div class="md-card">
                <div class="md-card-content">
                    <div class="uk-grid uk-grid-divider" data-uk-grid-margin>
                        <div class="uk-width-large-1-2 uk-width-medium-1-2">
                            <ul class="md-list md-list-addon">
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE001;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">ตรวจสอบข้อมูลซ้ำ</span>
                                        <span class="uk-text-small uk-text-muted">ตรวจสอบข้อมูลเลขที่ใบบันทึกคะแนนซ้ำกันในไฟล์</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE001;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">ตรวจสอบจำนวน</span>
                                        <span class="uk-text-small uk-text-muted">ตรวจสอบจำนวนรายการในไฟล์กับจำนวนรายการในฐานข้อมูล</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE001;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">ตรวจสอบเลขที่ใบบันทึกคะแนน</span>
                                        <span class="uk-text-small uk-text-muted">ตรวจสอบความถูกต้องของเลขที่ใบบันทึกคะแนน (SeatNo Vs LithoCode)</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="uk-width-large-1-2 uk-width-medium-1-2">
                            <ul class="md-list md-list-addon">
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE001;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">ตรวจสอบเลขที่ใบบันทึกคะแนนกับฐานข้อมูล</span>
                                        <span class="uk-text-small uk-text-muted">ตรวจสอบความถูกต้องของเลขที่ใบบันทึกคะแนนกับข้อมูลในฐานข้อมูล</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE001;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">ตรวจสอบการบันทึกคะแนนเป็นค่าว่าง</span>
                                        <span class="uk-text-small uk-text-muted">ตรวจสอบความถูกต้องของคะแนนที่บันทึกเป็นค่าว่าง</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE001;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">ตรวจสอบการบันทึกคะแนนเป็นดอกจัน</span>
                                        <span class="uk-text-small uk-text-muted">ตรวจสอบความถูกต้องของคะแนนที่บันทึกเป็นดอกจัน</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="uk-grid" data-uk-grid-margin="">
                            <div class="uk-width-medium-10-10">
                                 
                                <asp:DropDownList ID="importqnoddl" runat="server" data-md-selectize Height="29px" Style="margin-right: 28px" Width="241px">
                                    <asp:ListItem Value="0">กรุณาเลือกข้อที่ต้องการนำเข้า</asp:ListItem>
                                    <asp:ListItem Value="1">ข้อที่ 1 การเขียนเล่าเรื่องจากภาพ</asp:ListItem>
                                    <asp:ListItem Value="2">ข้อท่ 2 การเขียนสรุปใจความสำคัญ</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="uk-width-medium-1-10 uk-text-center">
                                <asp:Button ID="listdirectorybtn" runat="server" Text="นำเข้าไฟล์" OnClick="listdirectorybtn_Click" CssClass="uk-form-file md-btn md-btn-primary" />
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
                                <asp:TableCell>ชื่อไฟล์</asp:TableCell>
                                <asp:TableCell>จำนวนข้อมูล</asp:TableCell>
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


     <!-- page specific plugins -->

    <script>
        // load parsley config (altair_admin_common.js)
    
    </script>

</asp:Content>




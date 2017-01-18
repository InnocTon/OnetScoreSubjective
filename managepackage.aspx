<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="managepackage.aspx.cs" Inherits="managepackage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รายงาน"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="พิมพ์"><i class="md-icon material-icons">&#xE8AD;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รับ-ส่ง" id="sendrecivebtn" data-uk-modal="{target:'#modal_send_recive'}"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>
        <h1><i class="material-icons">&#xE80D;</i> รับ-ส่ง ซองบรรจุใบบันทึกคะแนนอัตนัย</h1>
        <span class="uk-text-upper uk-text-small">ข้อมูลรับ-ส่งซองบรรจุใบบันทึกคะแนนอัตนัย</span>
    </div>


    <div id="page_content_inner">
        <div class="md-card">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">
                    <table class="uk-table uk-table-align-vertical uk-table-nowrap tablesorter tablesorter-altair" id="ts_issues">
                        <thead>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>รหัสกล่อง</th>
                                <th>รหัสซอง</th>
                                <th>จำนวนกระดาษ</th>
                                <th>สถานะซอง</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%

                                string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);

                                try
                                {
                                    String query = "  SELECT PACKAGE_CODE,PACK.BOX_CODE,PAPER_NUM,PSTATUS_NAME,PACKAGE_STATUS FROM [dbo].[TRN_XM_PACKAGE] PACK INNER JOIN  [dbo].MST_PACKAGE_STATUS PSTATUS ON PACK.PACKAGE_STATUS = PSTATUS.PSTATUS_CODE INNER JOIN [dbo].[TRN_XM_BOX] BOX ON BOX.BOX_CODE = PACK.BOX_CODE";

                                    System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                                    conn.Open();
                                    System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                                    int i = 0;
                                    while (reader.Read())
                                    {

                                        String status_style = "";

                                        if (reader["PACKAGE_STATUS"].ToString() == "F") status_style = "uk-badge uk-badge-primary";
                                        else status_style = "uk-badge uk-badge-warning";
                                      

                                        i++;
                            %>
                            <tr>
                                <td class="uk-text-center"><span class="uk-text-small uk-text-muted uk-text-nowrap"><% Response.Write(i.ToString()); %></span></td>
                                <td><% Response.Write(reader["BOX_CODE"].ToString()); %></td>
                                <td><% Response.Write(reader["PACKAGE_CODE"].ToString()); %></td>
                                <td><% Response.Write(reader["PAPER_NUM"].ToString()); %></td>
                                <td><span class="<% Response.Write(status_style); %>"><% Response.Write(reader["PSTATUS_NAME"].ToString()); %></span></td>
                            </tr>
                            <%
                                    }

                                    reader.Close();
                                    conn.Close();
                                }
                                catch (Exception ex)
                                {

                                }
                                finally
                                {
                                    if (conn != null && conn.State == System.Data.ConnectionState.Open)
                                    {
                                        conn.Close();
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <ul class="uk-pagination ts_pager">
                    <li data-uk-tooltip title="Select Page">
                        <select class="ts_gotoPage ts_selectize"></select>
                    </li>
                    <li class="first"><a href="javascript:void(0)"><i class="uk-icon-angle-double-left"></i></a></li>
                    <li class="prev"><a href="javascript:void(0)"><i class="uk-icon-angle-left"></i></a></li>
                    <li><span class="pagedisplay"></span></li>
                    <li class="next"><a href="javascript:void(0)"><i class="uk-icon-angle-right"></i></a></li>
                    <li class="last"><a href="javascript:void(0)"><i class="uk-icon-angle-double-right"></i></a></li>
                    <li data-uk-tooltip title="Page Size">
                        <select class="pagesize ts_selectize">
                            <option value="5">5</option>
                            <option value="10">10</option>
                            <option value="25">25</option>
                            <option value="50">50</option>
                        </select>
                    </li>
                </ul>
            </div>
        </div>
    </div>


    <div class="uk-modal" id="modal_send_recive">
        <div class="uk-modal-dialog">
            <div class="uk-modal-header">
                <h3 class="uk-modal-title">แบบฟอร์ม รับ-ส่ง ซองใบบันทึกคะแนนอัตนัย</h3>
            </div>
            <form id="form_validation" class="uk-form-stacked" runat="server" autocomplete="off">
                <div class="uk-width-medium-3-3">
                    <div class="uk-form-row">

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="boxcodetxt">รหัสซอง</label>
                                    <input type="text" name="packagecodetxt" id="packagecodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสกล่อง" parsley-error-message="กรุณากรอกรหัสกล่อง" runat="server" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="ratercodetxt">รหัสผู้ตรวจ/รหัสเจ้าหน้าที่</label>
                                    <input type="text" name="ratercodetxt" id="ratercodetxt" required class="md-input" runat="server" data-required-message="กรุณากรอกรหัสผู้ตรวจ/รหัสเจ้าหน้าที่" parsley-error-message="กรุณากรอกรหัสผู้ตรวจ/รหัสเจ้าหน้าที่" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <select id="boxaction" name="boxaction" runat="server" required class="md-input" data-required-message="กรุณาเลือกสถานะซอง" parsley-error-message="กรุณาเลือกสถานะซอง">
                                        <option value="">กรุณาเลือกสถานะซอง</option>
                                        <option value="rater">ผู้ตรวจรับซอง</option>
                                        <option value="return">ผู้ตรวจส่งซองคืน</option>
                                        <option value="omr">ส่งห้องอ่าน OMR</option>
                                        <option value="modify">ส่งแก้ไขข้อมูล</option>
                                        <option value="final">ดำเนินการเสร็จเรียบร้อย</option>
                                    </select>
                                </div>
                            </div>
                        </div>


                        <div class="uk-modal-footer uk-text-right">
                            <button type="button" class="md-btn md-btn-flat uk-modal-close">ยกเลิก</button>
                            <asp:Button ID="adddatabtn" runat="server" Text="บันทึก" CssClass="md-btn md-btn-flat md-btn-flat-primary" OnClick="adddatabtn_Click"></asp:Button>
                        </div>
                    </div>
            </form>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">


     <!-- page specific plugins -->
    <!-- tablesorter -->
    <script src="bower_components/tablesorter/dist/js/jquery.tablesorter.min.js"></script>
    <script src="bower_components/tablesorter/dist/js/jquery.tablesorter.widgets.min.js"></script>
    <script src="bower_components/tablesorter/dist/js/widgets/widget-alignChar.min.js"></script>
    <script src="bower_components/tablesorter/dist/js/extras/jquery.tablesorter.pager.min.js"></script>


    <script>
        // load parsley config (altair_admin_common.js)
        altair_forms.parsley_validation_config();
        //Modal
        $('.uk-modal').on({

            'show.uk.modal': function () {
              //  console.log("Modal is visible.");
            },

            'hide.uk.modal': function () {
               // console.log("Element is not visible.");
                $("#<%=packagecodetxt.ClientID%>").val('');
                $("#<%=ratercodetxt.ClientID%>").val('');
                $("#<%=boxaction.ClientID%>").val('');
                $('#form_validation').parsley().reset();


            }
        });



    </script>
    <script src="bower_components/parsleyjs/dist/parsley.js"></script>
    <!--  issues list functions -->
    <script src="assets/js/pages/managepackage.js"></script>




</asp:Content>


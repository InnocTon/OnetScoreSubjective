<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="importdatafactory.aspx.cs" Inherits="importdatafactory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server">
        <div id="page_content_inner">
            <div class="md-card">
                <div class="md-card-content">
                    <div class="uk-grid uk-grid-divider" data-uk-grid-margin>
                        <div class="uk-width-large-2-4 uk-width-medium-2-4">
                            <ul class="md-list md-list-addon">
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE88F;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">นำเข้าข้อมูลกล่อง</span>
                                        <span class="uk-text-small uk-text-muted">ข้อมูลกล่องบรรจุซองบรรจุใบบันทึกคะแนนอัตนัย</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE88F;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">นำเข้าข้อมูลซอง</span>
                                        <span class="uk-text-small uk-text-muted">ข้อมูลซองบรรจุใบบันทึกคะแนนอัตนัย</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE88F;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">นำเข้าข้อมูลใบบันทึกคะแนน</span>
                                        <span class="uk-text-small uk-text-muted">รายละเอียดข้อมูลใบบันทึกคะแนน</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="uk-width-large-2-4 uk-width-medium-2-4">
                            <div class="uk-width-medium-1-3">
                                <h3 class="heading_a" style="width: 300px; margin-bottom: 10px;"><i class="material-icons">&#xE0AF;</i> นำเข้าข้อมูลจากโรงงาน </h3>
                            </div>
                            <div class="uk-width-medium-1-3">
                                <asp:DropDownList ID="importtypeddl" runat="server" data-md-selectize Height="29px" Style="margin-right: 28px" Width="241px">
                                    <asp:ListItem Value="0">ประเภทไฟล์</asp:ListItem>
                                    <asp:ListItem Value="box">ข้อมูลกล่อง (BOX)</asp:ListItem>
                                    <asp:ListItem Value="package">ข้อมูลซอง (PACKAGE)</asp:ListItem>
                                    <asp:ListItem Value="paper">ข้อมูลใบบันทึกคะแนน (PAPER)</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="uk-width-medium-1-3" style="width: 240px; margin-bottom: 10px;">
                                <asp:FileUpload ID="FileUpload1" runat="server" />
                            </div>
                            <div class="uk-width-medium-1-3">
                                <asp:Button ID="listdirectorybtn" runat="server" Text="นำเข้าไฟล์" OnClick="listdirectorybtn_Click" CssClass="uk-form-file md-btn md-btn-primary" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="md-card uk-margin-medium-bottom">
                <div class="md-card-content">
                    <table id="dt_individual_search" class="uk-table" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>ลำดับที่</th>
                                <th>ชื่อไฟล์</th>
                                <th>สถานะ</th>
                                <th>ประเภท</th>
                                <th>ผู้นำเข้า</th>
                                <th>วันที่นำเข้า</th>
                            </tr>
                        </thead>

                        <tfoot>
                            <tr>
                                <th>ลำดับที่</th>
                                <th>ชื่อไฟล์</th>
                                <th>สถานะ</th>
                                <th>ประเภท</th>
                                <th>ผู้นำเข้า</th>
                                <th>วันที่นำเข้า</th>
                            </tr>
                        </tfoot>

                        <tbody>
                            <%
                                string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);

                                try
                                {
                                    String query = "SELECT * FROM TRN_FAC_IMPORT imp INNER JOIN SYS_IMPTYPE typ on imp.IMPTYPE_CODE = typ.IMPTYPE_CODE   INNER JOIN SYS_USER usr on usr.USER_ID = imp.IMP_BY   ORDER BY IMP_SEQ";
                                    System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                                    conn.Open();
                                    System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                                    int i = 0;
                                    while (reader.Read())
                                    {
                                        String impstatus = (reader["IMP_STATUS"].ToString() == "N") ? "ปกติ" : "ยกเลิก";
                                        i++;
                            %>
                            <tr>
                                <td><% Response.Write(i.ToString()); %></td>
                                <td><% Response.Write(reader["OLD_FILE_NAME"]); %></td>
                                <td><% Response.Write(impstatus); %></td>
                                <td><% Response.Write(reader["IMPTYPE_NAME"]); %></td>
                                <td><% Response.Write(reader["USER_NAME"]); %></td>
                                <td><% Response.Write(reader["IMP_DATETIME"]); %></td>
                            </tr>

                            <%
                                }
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
            </div>

        </div>
    </form>




</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">


    <!-- page specific plugins -->
    <!-- datatables -->
    <script src="bower_components/datatables/media/js/jquery.dataTables.min.js"></script>
    <!-- datatables colVis-->
    <script src="bower_components/datatables-colvis/js/dataTables.colVis.js"></script>
    <!-- datatables tableTools-->
    <script src="bower_components/datatables-tabletools/js/dataTables.tableTools.js"></script>
    <!-- datatables custom integration -->
    <script src="assets/js/custom/datatables_uikit.min.js"></script>


    <!--  datatables functions -->

    <script src="assets/js/pages/importdatafactory.js"></script>

</asp:Content>

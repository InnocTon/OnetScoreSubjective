<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="manageuser.aspx.cs" Inherits="manageuser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รายงาน"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="พิมพ์"><i class="md-icon material-icons">&#xE8AD;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="เพิ่มรายชื่อ" id="addnewbtn" data-uk-modal="{target:'#modal_send_recive'}"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>
        <h1><i class="material-icons md-24">&#xE8B9;</i> ตั้งค่าผู้ใช้งานระบบ</h1>
        <span class="uk-text-upper uk-text-small">ข้อมูลรายละเอียดผู้ใช้งานระบบ</span>
    </div>

    <div id="page_content_inner">
        <div class="md-card">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">

                    <table class="uk-table uk-table-align-vertical uk-table-nowrap tablesorter tablesorter-altair" id="ts_issues">
                        <thead>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>ชื่อ - นามสกุล</th>
                                <th>รหัสผู้ใช้งาน</th>
                                <th>ประเภทผู้ใช้งาน</th>
                                <th>รหัสผ่าน</th>
                                <th>เครื่องมือ</th>
                            </tr>
                        </thead>
                        <tbody>
                              <%

                                string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);

                                try
                                {
                                    String query = " SELECT * FROM [dbo].[SYS_USER] WHERE USER_STATUS = 'N' ";
                                    System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                                    conn.Open();
                                    System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                                    int i = 1;
                                    while (reader.Read())
                                    {
                                       
                                 %>
                            <tr>
                                <td class="uk-text-center"><span class="uk-text-small uk-text-muted uk-text-nowrap"><% Response.Write(i.ToString()); %></span></td>
                                <td><% Response.Write(reader["USER_NAME"].ToString()); %></td>
                                <td><% Response.Write(reader["USER_ID"].ToString()); %></td>
                                <td><% Response.Write(reader["USER_TYPE"].ToString()); %></td>
                                <td><% Response.Write(reader["USER_PASS"].ToString()); %></td>
                                <td> 
                                    <% if (reader["USER_TYPE"].ToString() != "admin")
                                        { %>
                                    <a href="#" title="ยกเลิกข้อมูล" onclick="UIkit.modal.confirm('กรุณายืนยันการลบข้อมูลของ <% Response.Write(reader["USER_NAME"].ToString()); %>', function(){ 
                                            
                                           
                                        var parms = { usercode : '<% Response.Write(reader["USER_ID"].ToString()); %>' };

            $.ajax({
                type: 'POST',
                url: 'deleteuser.aspx/deluser',
               
                data: '{\'ucode\':\'' + JSON.stringify(parms) + '\'}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: true,
                success: function (msg) {
                      var msgReturn =$.parseJSON(msg.d);
                      
                      if( msgReturn == '1'){
                              swal({
                                title: 'สำเร็จ',
                                text: 'ลบข้อมูลผู้ใช้งานเรียบร้อย',
                                type: 'success',
                                confirmButtonText: 'ตกลง',
                                closeOnConfirm: true
                            },
                               function () {
                                        window.location = 'manageuser.aspx';
                               });
                      }else{
                            swal({
                                title: 'ผิดพาด!',
                                text: msgReturn,
                                type: 'error',
                                confirmButtonText: 'ตกลง',
                                closeOnConfirm: true
                            },
                               function () {

                               });
                     }


                }

                
            });

                                         });"><i class="md-icon material-icons uk-text-danger">&#xE872;</i></a>
                                    <% }  %>
                                </td>
                            </tr>
                            <%

                                        i++;
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
                <h3 class="uk-modal-title">เพิ่มรายชื่อผู้ตรวจ</h3>
            </div>
            <form id="form_validation" class="uk-form-stacked" runat="server" autocomplete="off">
                <div class="uk-width-medium-3-3">
                    <div class="uk-form-row">

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="usercodetxt">รหัสผู้ใช้งาน</label>
                                    <input type="text" name="usercodetxt" id="usercodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสผู้ตรวจ" parsley-error-message="กรุณากรอกรหัสผู้ตรวจ" runat="server" data-parsley-minlength="13" data-parsley-maxlength="13" maxlength="13" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="nametxt">ชื่อ - นามสกุล</label>
                                    <input type="text" name="nametxt" id="nametxt" required class="md-input" runat="server" data-required-message="ชื่อ - นามสกุล" parsley-error-message="ชื่อ - นามสกุล" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="passwordtxt">รหัสผ่าน</label>
                                    <input type="text" name="passwordtxt" id="passwordtxt" required class="md-input" runat="server" data-required-message="กรุณากรอกเลขบัตรประชาชน" parsley-error-message="กรุณากรอกเลขบัตรประชาชน" data-parsley-minlength="4" data-parsley-maxlength="8" maxlength="8"/>
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <select id="typeaction" name="typeaction" runat="server" required class="md-input" data-required-message="กรุณาเลือกประเภทผู้ใช้งาน" parsley-error-message="กรุณาเลือกประเภทผู้ใช้งาน">
                                        <option value="">กรุณาเลือกประเภทผู้ใช้งาน</option>
                                        <option value="rater3">Rater คนที่ 3</option>
                                        <option value="user">เจ้าหน้าที่</option>
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
                //        console.log("Element is not visible.");
                $("#<%=usercodetxt.ClientID%>").val('');
                $("#<%=nametxt.ClientID%>").val('');
                $("#<%=passwordtxt.ClientID%>").val('');
                $("#<%=typeaction.ClientID%>").val('');
                $('#form_validation').parsley().reset();

            }
        });



    </script>

     <script src="bower_components/parsleyjs/dist/parsley.js"></script>
    <!--  issues list functions -->
    <script src="assets/js/pages/managerater.js"></script>

</asp:Content>


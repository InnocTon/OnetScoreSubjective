<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="managerater.aspx.cs" Inherits="managerater" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รายงาน"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="พิมพ์"><i class="md-icon material-icons">&#xE8AD;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="เพิ่มรายชื่อ" id="addnewbtn" data-uk-modal="{target:'#modal_send_recive'}"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>
        <h1><i class="material-icons md-24">&#xE8B9;</i> ตั้งค่าผู้ตรวจ</h1>
        <span class="uk-text-upper uk-text-small">ข้อมูลรายละเอียดครูผู้ตรวจ</span>
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
                                <th>รหัสผู้ตรวจ</th>
                                <th>เลขบัตรประชาชน</th>
                                <th>สถานที่ตรวจ</th>
                                <th>เครื่องมือ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%

                                string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);

                                try
                                {
                                    String query = " SELECT * FROM [ONET_SUBJECTIVE].[dbo].[TRN_XM_RATER] WHERE RATER_STATUS = 'N' ";
                                    System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                                    conn.Open();
                                    System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                                    int i = 1;
                                    while (reader.Read())
                                    {
                                        String rater_name = reader["RATER_PRENAME"].ToString() + " " + reader["RATER_FNAME"].ToString() +  " " + reader["RATER_LNAME"].ToString();
                                 %>
                            <tr>
                                <td class="uk-text-center"><span class="uk-text-small uk-text-muted uk-text-nowrap"><% Response.Write(i.ToString()); %></span></td>
                                <td><% Response.Write(rater_name); %></td>
                                <td><% Response.Write(reader["RATER_CODE"].ToString()); %></td>
                                <td><% Response.Write(reader["RATER_CITIZENID"].ToString()); %></td>
                                <td><% Response.Write(reader["RATER_PLACE"].ToString()); %></td>
                                <td class="uk-text-center">
                                    <a href="#" title="ยกเลิกข้อมูล" onclick="UIkit.modal.confirm('กรุณายืนยันการลบข้อมูลของ <% Response.Write(rater_name); %>', function(){ 
                                            
                                           
                                        var parms = { raterseq : '<% Response.Write(reader["RATER_SEQ"].ToString()); %>' };

            $.ajax({
                type: 'POST',
                url: 'deleterater.aspx/delrater',
               
                data: '{\'rseq\':\'' + JSON.stringify(parms) + '\'}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: true,
                success: function (msg) {
                      var msgReturn =$.parseJSON(msg.d);
                      
                      if( msgReturn == '1'){
                              swal({
                                title: 'สำเร็จ',
                                text: 'ลบข้อมูลผู้ตรวจเรียบร้อย',
                                type: 'success',
                                confirmButtonText: 'ตกลง',
                                closeOnConfirm: true
                            },
                               function () {
                                        window.location = 'managerater.aspx';
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
                                    <a href="nametag.aspx?rater_seq=<% Response.Write(reader["RATER_SEQ"].ToString()); %>" title="พิมพ์บัตรประจำตัว"><i class="md-icon material-icons uk-text-success">&#xE416;</i></a>
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
                                    <label for="boxcodetxt">รหัสผู้ตรวจ (11 หลัก)</label>
                                    <input type="text" name="ratercodetxt" id="ratercodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสผู้ตรวจ" parsley-error-message="กรุณากรอกรหัสผู้ตรวจ" runat="server" data-parsley-minlength="11" data-parsley-maxlength="11" maxlength="11" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="ratercodetxt">คำนำหน้า</label>
                                    <input type="text" name="prenametxt" id="prenametxt" required class="md-input" runat="server" data-required-message="กรุณากรอกคำนำหน้า" parsley-error-message="กรุณากรอกคำนำหน้า" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="ratercodetxt">ชื่อ</label>
                                    <input type="text" name="fnametxt" id="fnametxt" required class="md-input" runat="server" data-required-message="กรุณากรอกชื่อ" parsley-error-message="กรุณากรอกชื่อ"/>
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="ratercodetxt">นามสกุล</label>
                                    <input type="text" name="lnametxt" id="lnametxt" required class="md-input" runat="server" data-required-message="กรุณากรอกนามสกุล" parsley-error-message="กรุณากรอกนามสกุล" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="ratercodetxt">เลขบัตรประชาชน</label>
                                    <input type="text" name="citizentxt" id="citizentxt" required class="md-input" runat="server" data-required-message="กรุณากรอกเลขบัตรประชาชน" parsley-error-message="กรุณากรอกเลขบัตรประชาชน" data-parsley-minlength="13" data-parsley-maxlength="13" maxlength="13"/>
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <select id="placeaction" name="placeaction" runat="server" required class="md-input" data-required-message="กรุณาเลือกสถานที่ตรวจ" parsley-error-message="กรุณาเลือกสถานที่ตรวจ">
                                        <option value="">กรุณาเลือกสถานที่ตรวจ</option>
                                        <option value="ม.บูรพา">ม.บูรพา</option>
                                        <option value="ม.ศิลปากร">ม.ศิลปากร</option>
                                        <option value="ม.สุโขทัยธรรมาธิราช">ม.สุโขทัยธรรมาธิราช</option>
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
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">

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
                $("#<%=ratercodetxt.ClientID%>").val('');
                $("#<%=prenametxt.ClientID%>").val('');
                $("#<%=fnametxt.ClientID%>").val('');
                $("#<%=lnametxt.ClientID%>").val('');
                $("#<%=citizentxt.ClientID%>").val('');
                $("#<%=placeaction.ClientID%>").val('');
                $('#form_validation').parsley().reset();

            }
        });



    </script>
    <script src="bower_components/parsleyjs/dist/parsley.js"></script>
    <!--  issues list functions -->
    <script src="assets/js/pages/managerater.js"></script>

</asp:Content>


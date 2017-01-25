<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="reportimportomr.aspx.cs" Inherits="reportimportomr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รายงาน"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="พิมพ์"><i class="md-icon material-icons">&#xE8AD;</i></a>
        </div>
        <h1><i class="material-icons md-24">&#xE3EA;</i> รายงานการนำเข้าข้อมูล OMR</h1>
        <span class="uk-text-upper uk-text-small">รายละเอียดการนำข้อมูล OMR เข้าสู่ระบบ</span>
    </div>

    <div id="page_content_inner">
        <div class="md-card">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">
                    <table class="uk-table uk-table-align-vertical uk-table-nowrap tablesorter tablesorter-altair" id="ts_issues">
                        <thead>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>ชื่อไฟล์</th>
                                <th>จำนวนข้อมูล</th>
                                <th>สถานะการนำเข้า</th>
                                <th>ผู้นำเข้า</th>
                                <th>วันที่นำเข้า</th>
                                <th>เครื่องมือ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);

                                try
                                {
                                    String query = "   SELECT IMP.IMP_SEQ,IMP.IMP_FILENAME,IMP.IMP_DATETIME,US.USER_NAME,DETAIL.NUM_RECORD,IMP.IMP_STATUS " +
 "  FROM [dbo].[TRN_OMR_IMPORT] IMP LEFT JOIN SYS_USER US ON US.USER_ID = IMP.IMP_BY LEFT JOIN ( " +
"	SELECT COUNT(*) AS NUM_RECORD ,DT.IMP_SEQ FROM [dbo].[TRN_XM_BATCH_DETAIL]  DT WHERE DT.SHEET_STATUS = 'N' GROUP BY IMP_SEQ  " +
 "  ) AS DETAIL ON DETAIL.IMP_SEQ = IMP.IMP_SEQ WHERE IMP.IMP_STATUS  = 'N'";
                                    System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                                    conn.Open();
                                    System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                                    int i = 0;
                                    while (reader.Read())
                                    {

                                        String status_style = "";
                                        if (reader["IMP_STATUS"].ToString() == "N") status_style = "<span class='uk-badge uk-badge-success'>ปกติ</span>";
                                        else status_style = "<span class='uk-badge uk-badge-warning'>ยกเลิก</span>";
                                        i++;
                            %>
                            <tr>
                                <td class="uk-text-center"><span class="uk-text-small uk-text-muted uk-text-nowrap"><% Response.Write(i.ToString()); %></span></td>
                                <td><% Response.Write(reader["IMP_FILENAME"].ToString()); %></td>
                                <td><% Response.Write(reader["NUM_RECORD"].ToString()); %></td>
                                <td><% Response.Write(status_style); %></td>
                                <td><% Response.Write(reader["USER_NAME"].ToString()); %></td>
                                <td><% Response.Write(reader["IMP_DATETIME"].ToString()); %></td>
                                <td class="uk-text-center">
                                    <a href="#" onclick="UIkit.modal.confirm('กรุณายืนยัน ยกเลิกการนำเข้าไฟล์ <% Response.Write(reader["IMP_FILENAME"].ToString()); %>', function(){ 
                                            
                                           
                                        var parms = { omrimpseq : '<% Response.Write(reader["IMP_SEQ"].ToString()); %>' };

            $.ajax({
                type: 'POST',
                url: 'deleteomrimport.aspx/deleteomr',
               
                data: '{\'impseq\':\'' + JSON.stringify(parms) + '\'}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: true,
                success: function (msg) {
                      var msgReturn =$.parseJSON(msg.d);
                     // console.log(msgReturn);
                        
                      if( msgReturn == '1'){
                              swal({
                                title: 'สำเร็จ',
                                text: 'ยกเลิกการนำเข้าไฟล์ OMR เรียบร้อย',
                                type: 'success',
                                confirmButtonText: 'ตกลง',
                                closeOnConfirm: true
                            },
                               function () {
                                        window.location = 'reportimportomr.aspx';
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

                                </td>
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

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <!-- page specific plugins -->
    <!-- tablesorter -->
    <script src="bower_components/tablesorter/dist/js/jquery.tablesorter.min.js"></script>
    <script src="bower_components/tablesorter/dist/js/jquery.tablesorter.widgets.min.js"></script>
    <script src="bower_components/tablesorter/dist/js/widgets/widget-alignChar.min.js"></script>
    <script src="bower_components/tablesorter/dist/js/extras/jquery.tablesorter.pager.min.js"></script>

    <!--  issues list functions -->
    <script src="assets/js/pages/reportimportomr.js"></script>

    <script>

        $(function () {

            

              




       });

    </script>

</asp:Content>


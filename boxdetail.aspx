<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="boxdetail.aspx.cs" Inherits="boxdetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="page_heading">
        <h1>รายละเอียดกล่องบรรจุใบบันทึกคะแนนอัตนัย</h1>
        <span class="uk-text-muted uk-text-upper uk-text-small">ข้อมูลกล่อง ข้อมูลซอง ข้อมูลประวัติการรับ - ส่ง</span>
    </div>
    <div id="page_content_inner">
        <div class="uk-grid uk-grid-medium" data-uk-grid-margin>
            <div class="uk-width-xLarge-2-10 uk-width-large-3-10">
                <div class="md-card">
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">ข้อมูลกล่อง
                            </h3>
                    </div>
                    <%

                        string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                        System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);
                        String BOX_CODE = "";
                        String PACKAGE_NUM = "";
                        String BOX_STATUS = "";
                        try
                        {
                            String BOX_SEQ = Request.QueryString["seq"].ToString();

                            String query = "SELECT ROW_NUMBER() OVER(ORDER BY bx.BOX_SEQ ASC) AS[NO], bx.BOX_CODE, bx.PACKAGE_NUM, bxs.BSTATUS_NAME as BOX_STATUS FROM TRN_XM_BOX bx inner join [dbo].[MST_BOX_STATUS] bxs on bx.BOX_STATUS = bxs.BSTATUS_CODE  WHERE bx.BOX_STATUS != 'C' AND bx.BOX_SEQ = @boxseq";

                            System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                            conn.Open();
                            command.Parameters.AddWithValue("@boxseq", BOX_SEQ);
                            System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                            while (reader.Read())
                            {
                                BOX_CODE = reader["BOX_CODE"].ToString();
                                PACKAGE_NUM = reader["PACKAGE_NUM"].ToString();
                                BOX_STATUS = reader["BOX_STATUS"].ToString();
                            }
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

                    <div class="md-card-content">
                        <ul class="md-list">
                            <li>
                                <div class="md-list-content">
                                    <span class="uk-text-small uk-text-muted uk-display-block">รหัสกล่อง</span>
                                    <span class="md-list-heading uk-text-large uk-text-success"><%=BOX_CODE %></span>
                                    <input id="boxcode" type="hidden" name="boxcode" value="<% Response.Write(BOX_CODE); %>" />
                                </div>
                            </li>
                            <li>
                                <div class="md-list-content">
                                    <span class="uk-text-small uk-text-muted uk-display-block">จำนวนซอง</span>
                                    <span class="md-list-heading uk-text-large uk-text-success"><%=PACKAGE_NUM %></span>
                                </div>
                            </li>
                            <li>
                                <div class="md-list-content">
                                    <span class="uk-text-small uk-text-muted uk-display-block">สถานะกล่อง</span>
                                    <span class="md-list-heading uk-text-large uk-text-success"><%=BOX_STATUS %></span>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="uk-width-xLarge-8-10  uk-width-large-7-10">
                <div class="md-card">
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">รายละเอียดกล่อง</h3>
                    </div>
                    <div class="md-card-content large-padding">
                        <div class="md-card-content">
                            <div class="uk-overflow-container uk-margin-bottom">
                                <table class="uk-table" id="dt_individual_search">
                                    <thead>
                                        <tr>
                                            <th class="uk-text-center">ลำดับที่</th>
                                            <th>รหัสกล่อง</th>
                                            <th>รหัสซอง</th>
                                            <th>จำนวนกระดาษ</th>
                                            <th>สถานะซอง</th>
                                            <th>เครื่องมือ</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
                                        <tr>
                                            <th></th>
                                            <th>รหัสกล่อง</th>
                                            <th>รหัสซอง</th>
                                            <th>จำนวนกระดาษ</th>
                                            <th>สถานะซอง</th>
                                            <th></th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="md-card">
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">ประวัติการรับ-ส่ง กล่อง</h3>
                    </div>
                    <div class="md-card-content large-padding">
                        <table class="uk-table" id="dt_boxaction_search">
                                    <thead>
                                        <tr>
                                            <th class="uk-text-center">ลำดับที่</th>
                                            <th>ผู้ดูแล</th>
                                            <th>การดำเดินการ</th>
                                            <th>วันที่</th>
                                        </tr>
                                    </thead>
                                </table>
                    </div>
                </div>
            </div>
        </div>

    </div>
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


    <script>

        $(document).ready(function () {

            var boxcode = $("#boxcode").val().toString();
            var parms = { "boxcode": boxcode };

            //  console.log('{\'rater\':\'' + JSON.stringify(parms) + '\'}');

            //  console.log(parms);

            $.ajax({
                type: "POST",
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
                url: "DataboxService.asmx/GetDataBoxDetail",
                data: '{\'box\':\'' + JSON.stringify(parms) + '\'}',
                success: function (data) {
                    //   console.log(data.d);
                    var datatableVariable = $('#dt_individual_search').DataTable({

                        oLanguage: {
                            sLengthMenu: "แสดง _MENU_ รายการต่อหน้า",
                            sZeroRecords: "ไม่พบข้อมูล",
                            sInfo: "แสดงรายการที่ _START_ ถึง _END_ จากทั้งหมด _TOTAL_ รายการ",
                            sInfoEmpty: "แสดง 0 ถึง 0 ของทั้งหมด 0 รายการ",
                            sInfoFiltered: "(จากเร็คคอร์ดทั้งหมด _MAX_ เร็คคอร์ด)",
                            sSearch: "ค้นหา :",
                            oPaginate: {
                                sFirst: "หน้าแรก",// ปุ่มกลับมาหน้าแรก
                                sLast: "หน้าสุดท้าย",//ปุ่มไปหน้าสุดท้าย
                                sNext: "ถัดไป",//ปุ่มหน้าถัดไป
                                sPrevious: "ก่อนหน้า" // ปุ่ม กลับ
                            }
                        },
                        columnDefs: [
                           { searchable: false, orderable: false, "aTargets": [5] },
                           { className: "dt-center", "targets": [0, 3, 4, 5] },
                           { className: "dt-left", "targets": "1" },
                           { width: "8%", "targets": 0 }
                        ],
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        data: data.d,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'boxcode' },
                            { 'data': 'packagecode' },
                            { 'data': 'papernum' },
                            { 'data': 'packagestatus' },
                            {
                                'data': 'packagetools', 'render': function (data, type, full) {
                                    return "<a href='packagedetail.aspx?seq=" + data + "'><i class='material-icons uk-text-success md-24'>&#xE417;</i></a>";
                                }
                            }

                        ]
                    });
                    $('#dt_individual_search tfoot th').each(function () {
                        if ($(this).index() != 0 && $(this).index() != 5) {
                            var placeHolderTitle = $('#dt_individual_search thead th').eq($(this).index()).text();
                            $(this).html('<input type="text" class="form-control input input-sm" placeholder = "ค้นหา ' + placeHolderTitle + '" />');
                        }
                    });
                    datatableVariable.columns().every(function () {
                        var column = this;
                        $(this.footer()).find('input').on('keyup change', function () {
                            column.search(this.value).draw();
                        });
                    });
                }, error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.responseText);
                    console.log(thrownError);
                }
            });


            $.ajax({
                type: "POST",
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
                url: "DataboxService.asmx/GetDataBoxAction",
                data: '{\'box\':\'' + JSON.stringify(parms) + '\'}',
                success: function (data) {
                    //   console.log(data.d);
                    var datatableVariable = $('#dt_boxaction_search').DataTable({

                        oLanguage: {
                            sLengthMenu: "แสดง _MENU_ รายการต่อหน้า",
                            sZeroRecords: "ไม่พบข้อมูล",
                            sInfo: "แสดงรายการที่ _START_ ถึง _END_ จากทั้งหมด _TOTAL_ รายการ",
                            sInfoEmpty: "แสดง 0 ถึง 0 ของทั้งหมด 0 รายการ",
                            sInfoFiltered: "(จากเร็คคอร์ดทั้งหมด _MAX_ เร็คคอร์ด)",
                            sSearch: "ค้นหา :",
                            oPaginate: {
                                sFirst: "หน้าแรก",// ปุ่มกลับมาหน้าแรก
                                sLast: "หน้าสุดท้าย",//ปุ่มไปหน้าสุดท้าย
                                sNext: "ถัดไป",//ปุ่มหน้าถัดไป
                                sPrevious: "ก่อนหน้า" // ปุ่ม กลับ
                            }
                        },
                        columnDefs: [
                           { className: "dt-center", "targets": [0, 3] },
                           { className: "dt-left", "targets": "1" },
                           { width: "8%", "targets": 0 }
                        ],
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        data: data.d,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'ownername' },
                            {
                                 'data': 'owneraction', 'render': function (data, type, full) {
                                     if (data == 'borrow') return "กล่องถูกเบิกออกจากห้องมั่นคง";
                                     else if (data == 'omr') return "กล่องอยู่ในห้อง OMR";
                                     else if (data == 'return') return "ส่งกล่องคืนให้ห้องมั่นคง";
                                     else return '';
                                 }
                             },

                            { 'data': 'ownerdate' }
                        ]
                    });
                }, error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.responseText);
                    console.log(thrownError);
                }
            });
        });


    </script>

</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="packagedetail.aspx.cs" Inherits="packagedetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <div id="page_heading">
        <h1>รายละเอียดซองบรรจุใบบันทึกคะแนนอัตนัย</h1>
        <span class="uk-text-muted uk-text-upper uk-text-small">ข้อมูลซอง ข้อมูลประวัติการรับ - ส่ง</span>
    </div>
    <div id="page_content_inner">
        <div class="uk-grid uk-grid-medium" data-uk-grid-margin>
            <div class="uk-width-xLarge-2-10 uk-width-large-3-10">
                <div class="md-card">
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">ข้อมูลซอง
                            </h3>
                    </div>
                    <%

                        string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                        System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);
                        String PACKAGE_CODE = "";
                        String PAPER_NUM = "";
                        String PACKAGE_STATUS = "";
                        try
                        {
                            String PACKAGE_SEQ = Request.QueryString["seq"].ToString();

                            String query = "  SELECT PACKAGE_SEQ,PACKAGE_CODE,PACK.BOX_CODE,PAPER_NUM,PSTATUS_NAME,PACKAGE_STATUS FROM [dbo].[TRN_XM_PACKAGE] PACK INNER JOIN  [dbo].MST_PACKAGE_STATUS PSTATUS ON PACK.PACKAGE_STATUS = PSTATUS.PSTATUS_CODE INNER JOIN [dbo].[TRN_XM_BOX] BOX ON BOX.BOX_CODE = PACK.BOX_CODE WHERE PACK.PACKAGE_SEQ = @packageseq";

                            System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                            conn.Open();
                            command.Parameters.AddWithValue("@packageseq", PACKAGE_SEQ);
                            System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                            while (reader.Read())
                            {
                                PACKAGE_CODE = reader["PACKAGE_CODE"].ToString();
                                PAPER_NUM = reader["PAPER_NUM"].ToString();
                                PACKAGE_STATUS = reader["PSTATUS_NAME"].ToString();
                            }
                        }
                        catch (Exception ex)
                        {
                            Response.Write(ex.Message);
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
                                    <span class="uk-text-small uk-text-muted uk-display-block">รหัสซอง</span>
                                    <span class="md-list-heading uk-text-large uk-text-success"><%=PACKAGE_CODE %></span>
                                    <input id="packagecode" type="hidden" name="packagecode" value="<% Response.Write(PACKAGE_CODE); %>" />
                                </div>
                            </li>
                            <li>
                                <div class="md-list-content">
                                    <span class="uk-text-small uk-text-muted uk-display-block">จำนวนกระดาษ</span>
                                    <span class="md-list-heading uk-text-large uk-text-success"><%=PAPER_NUM %></span>
                                </div>
                            </li>
                            <li>
                                <div class="md-list-content">
                                    <span class="uk-text-small uk-text-muted uk-display-block">สถานะซอง</span>
                                    <span class="md-list-heading uk-text-large uk-text-success"><%=PACKAGE_STATUS %></span>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="uk-width-xLarge-8-10  uk-width-large-7-10">
                <div class="md-card">
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">รายละเอียดซอง</h3>
                    </div>
                    <div class="md-card-content large-padding">
                        <div class="md-card-content">
                            <div class="uk-overflow-container uk-margin-bottom">
                                <table class="uk-table" id="dt_package_search">
                                    <thead>
                                        <tr>
                                            <th class="uk-text-center">ลำดับที่</th>
                                            <th>รหัสซอง</th>
                                            <th>รหัสกระดาษ</th>
                                            <th>เลขที่ใบบันทึกคะแนน</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
                                        <tr>
                                            <th></th>
                                            <th>รหัสซอง</th>
                                            <th>รหัสกระดาษ</th>
                                            <th>เลขที่ใบบันทึกคะแนน</th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="md-card">
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">ประวัติการรับ-ส่ง ซอง</h3>
                    </div>
                    <div class="md-card-content large-padding">
                        <table class="uk-table" id="dt_packageaction_search">
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
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">

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

            var packagecode = $("#packagecode").val().toString();
            var parms = { "packagecode": packagecode };

            //  console.log('{\'rater\':\'' + JSON.stringify(parms) + '\'}');

            //  console.log(parms);

            $.ajax({
                type: "POST",
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
                url: "DatapackageService.asmx/GetDataPackageDetail",
                data: '{\'package\':\'' + JSON.stringify(parms) + '\'}',
                success: function (data) {
                    //   console.log(data.d);
                    var datatableVariable = $('#dt_package_search').DataTable({

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
                            { 'data': 'packagecode' },
                            { 'data': 'papercode' },
                            { 'data': 'lithocode' }

                        ]
                    });
                    $('#dt_package_search tfoot th').each(function () {
                        if ($(this).index() != 0 && $(this).index() != 5) {
                            var placeHolderTitle = $('#dt_package_search thead th').eq($(this).index()).text();
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
                url: "DatapackageService.asmx/GetDataPackageAction",
                data: '{\'package\':\'' + JSON.stringify(parms) + '\'}',
                success: function (data) {
                    //   console.log(data.d);
                    var datatableVariable = $('#dt_packageaction_search').DataTable({

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
                                    if (data == 'rater') return "ผู้ตรวจรับซอง";
                                    else if (data == 'return') return "ผู้ตรวจส่งคืนซอง";
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


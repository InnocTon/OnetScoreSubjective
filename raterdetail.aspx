<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="raterdetail.aspx.cs" Inherits="raterdetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%
        String RATER_NAME = "";
        String RATER_CODE = "";
        String RATER_AGE = "";
        String RATER_CITIZENID = "";
        String RATER_SCHOOL = "";
        String RATER_PROVICE = "";
        String RATER_DISEASE = "";
        String RATER_ALLERGIC = "";
        String RATER_FOOD = "";
        String RATER_EMAIL = "";
        String RATER_TEL = "";
        String RATER_MOBILE = "";
        String RATER_FAX = "";
        String RATER_SEQ = "";

        if (Request.QueryString["seq"] != null)
        {
            RATER_SEQ = Request.QueryString["seq"].ToString();


            string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
            System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);
            try
            {

                string query = "SELECT * FROM TRN_XM_RATER WHERE RATER_SEQ = @raterseq";
                System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                conn.Open();
                command.Parameters.AddWithValue("@raterseq", RATER_SEQ);
                System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    RATER_NAME = reader["RATER_PRENAME"].ToString() + " " + reader["RATER_FNAME"].ToString() + " " + reader["RATER_LNAME"].ToString();
                    RATER_CODE = reader["RATER_CODE"].ToString();
                    RATER_AGE = reader["RATER_AGE"].ToString();
                    RATER_CITIZENID = reader["RATER_CITIZENID"].ToString();
                    RATER_SCHOOL = reader["RATER_SCHOOL"].ToString();
                    RATER_PROVICE = reader["RATER_PROVICE"].ToString();
                    RATER_DISEASE = reader["RATER_DISEASE"].ToString();
                    RATER_ALLERGIC = reader["RATER_ALLERGIC"].ToString();
                    RATER_FOOD = reader["RATER_FOOD"].ToString();
                    RATER_EMAIL = reader["RATER_EMAIL"].ToString();
                    RATER_TEL = reader["RATER_TEL"].ToString();
                    RATER_MOBILE = reader["RATER_MOBILE"].ToString();
                    RATER_FAX = reader["RATER_FAX"].ToString();
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
        }




    %>

    <div id="page_content">
        <div id="page_content_inner">
            <div class="uk-grid" data-uk-grid-margin data-uk-grid-match id="user_profile">
                <div class="uk-width-large-8-10">
                    <div class="md-card">
                        <div class="user_heading">
                            <div class="user_heading_menu" data-uk-dropdown="{pos:'left-top'}">
                                <i class="md-icon material-icons md-icon-light">&#xE5D4;</i>
                                <div class="uk-dropdown uk-dropdown-small">
                                    <ul class="uk-nav">
                                        <li><a href="#" onclick="confirmdelete('<% Response.Write(RATER_SEQ); %>','<% Response.Write(RATER_NAME); %>');">ลบข้อมูลผู้ตรวจ</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="user_heading_avatar">
                                <img src="<% Response.Write("raterimages/" + RATER_CITIZENID + ".png"); %>" alt="user avatar" />
                            </div>
                            <div class="user_heading_content">
                                <h2 class="heading_b uk-margin-bottom">
                                    <span class="uk-text-truncate"><% Response.Write(RATER_NAME);  %></span>
                                    <span class="sub-heading"><% Response.Write(RATER_CODE); %></span></h2>
                                <ul class="user_stats">
                                    <li>
                                        <h4 class="heading_a">2391 <span class="sub-heading">จำนวนตรวจ</span></h4>
                                    </li>
                                    <li>
                                        <h4 class="heading_a">120 <span class="sub-heading">จำนวนที่ต่าง</span></h4>
                                    </li>
                                </ul>
                            </div>
                            <a class="md-fab md-fab-small md-fab-accent" href="#" title="พิมพ์บัตรประจำตัว">
                                <i class="material-icons">&#xE8A3;</i>
                            </a>
                        </div>
                        <div class="user_content">
                            <ul id="user_profile_tabs" class="uk-tab" data-uk-tab="{connect:'#user_profile_tabs_content', animation:'slide-horizontal'}" data-uk-sticky="{ top: 48, media: 960 }">
                                <li class="uk-active"><a href="#">ประวัติบุคคล</a></li>
                                <li><a href="#">ประวัติการตรวจข้อสอบ</a></li>
                            </ul>
                            <ul id="user_profile_tabs_content" class="uk-switcher uk-margin">
                                <li>
                                    <div class="uk-grid uk-margin-medium-top uk-margin-large-bottom" data-uk-grid-margin>
                                        <div class="uk-width-large-1-2">
                                            <h4 class="heading_c uk-margin-small-bottom">ข้อมูลส่วนบุคคล</h4>
                                            <ul class="md-list md-list-addon">
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE87C;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><%Response.Write(RATER_AGE); %></span>
                                                        <span class="uk-text-small uk-text-muted">อายุ</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon uk-icon-credit-card"></i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_CITIZENID); %></span>
                                                        <span class="uk-text-small uk-text-muted">เลขบัตรประชาชน</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE88A;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_SCHOOL); %> (<% Response.Write(RATER_PROVICE); %>)</span>
                                                        <span class="uk-text-small uk-text-muted">โรงเรียน</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon uk-icon-ambulance"></i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_DISEASE); %></span>
                                                        <span class="uk-text-small uk-text-muted">โรคประจำตัว</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon uk-icon-medkit"></i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_ALLERGIC); %></span>
                                                        <span class="uk-text-small uk-text-muted">แพ้ยา</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon uk-icon-coffee"></i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_FOOD); %></span>
                                                        <span class="uk-text-small uk-text-muted">อาหาร</span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="uk-width-large-1-2">
                                            <h4 class="heading_c uk-margin-small-bottom">ข้อมูลติดต่อ</h4>
                                            <ul class="md-list  md-list-addon">
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE158;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_EMAIL); %></span>
                                                        <span class="uk-text-small uk-text-muted">Email</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE0CD;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_TEL); %></span>
                                                        <span class="uk-text-small uk-text-muted">เบอร์บ้าน</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE325;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_MOBILE); %></span>
                                                        <span class="uk-text-small uk-text-muted">มือถือ</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon uk-icon-fax"></i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(RATER_FAX); %></span>
                                                        <span class="uk-text-small uk-text-muted">แฟ็กส์</span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <ul class="md-list">
                                        <!-- ประวัติการตรวจข้อสอบ -->
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
                                                                    <th>วันที่</th>
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


                                    </ul>
                                </li>
                            </ul>
                        </div>
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

            var raterid = "1";
            var parms = { raterseq: raterid };

            console.log('{\'rseq\':\'' + JSON.stringify(parms) + '\'}');

            $.ajax({
                type: "POST",
                dataType: "json",
                url: "DatapackageService.asmx/GetDataRater",
                data: '{\'rseq\':\'' + JSON.stringify(parms) + '\'}',
                success: function (data) {
                    var datatableVariable = $('#dt_individual_search').DataTable({

                        oLanguage: {
                            sLengthMenu: "แสดง _MENU_ รายการต่อหน้า",
                            sZeroRecords: "ไม่เจอข้อมูลที่ค้นหา",
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
                        lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'boxcode' },
                            { 'data': 'packagecode' },
                            { 'data': 'papernum' },
                            {
                                'data': 'packagestatus', 'render': function (status) {
                                    if (status == 'F') return "<span class='uk-badge uk-badge-success'>สำเร็จแล้ว</span>";
                                    else return "<span class='uk-badge uk-badge-warning'>อยู่ระหว่างดำเนินการ</span>";
                                }
                            },
                            { 'data': 'packagetools' }
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
                }
            });

        });


        function confirmdelete(raterid, ratername) {
            UIkit.modal.confirm('กรุณายืนยันการลบข้อมูลของ ' + ratername, function () {


                var parms = { raterseq: raterid };

                console.log('{\'rseq\':\'' + JSON.stringify(parms) + '\'}');

                $.ajax({
                    type: 'POST',
                    url: 'deleterater.aspx/delrater',

                    data: '{\'rseq\':\'' + JSON.stringify(parms) + '\'}',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    async: true,
                    success: function (msg) {
                        var msgReturn = $.parseJSON(msg.d);

                        if (msgReturn == '1') {
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
                        } else {
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

            });
        }

    </script>

</asp:Content>


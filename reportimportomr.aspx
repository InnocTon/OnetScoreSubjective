<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="reportimportomr.aspx.cs" Inherits="reportimportomr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <h1><i class="material-icons md-24">&#xE3EA;</i> รายงานการนำเข้าข้อมูล OMR</h1>
        <span class="uk-text-upper uk-text-small">รายละเอียดการนำข้อมูล OMR เข้าสู่ระบบ</span>
    </div>

    <div id="page_content_inner">
        <div class="md-card">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">
                     <table class="uk-table" id="dt_individual_search">
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
                        <tfoot>
                             <tr>
                                <th class="uk-text-center"></th>
                                <th>ชื่อไฟล์</th>
                                <th>จำนวนข้อมูล</th>
                                <th>สถานะการนำเข้า</th>
                                <th>ผู้นำเข้า</th>
                                <th>วันที่นำเข้า</th>
                                <th></th>
                            </tr>
                        </tfoot>
                    </table>
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
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "ImportomrService.asmx/GetDats",
                success: function (data) {
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
                            { searchable: false, orderable: false, "aTargets": [6] },
                            { className: "dt-center", "targets": [0, 6] },
                            { className: "dt-left", "targets": [1] },
                            { width: "8%", "targets": 0 }
                        ],
                        lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'impfilename' },
                            { 'data': 'imprecord' },
                            {
                                'data': 'impstatus', 'render': function (status) {
                                    if (status == 'N') return "<span class='uk-badge uk-badge-success'>ปกติ</span>";
                                    else return "<span class='uk-badge uk-badge-warning'>ยกเลิก</span>";
                                }
                            },
                            { 'data': 'impby' },
                            { 'data': 'impdate' },
                            {
                                'data': 'imptools', 'render': function (status, type, full) {
                                    return "<a href='#' onclick='confirmdelete(" + status + ",\"" + full.impfilename + "\");'><i class='md-icon material-icons uk-text-danger'>&#xE872;</i></a>";
                                   
                                 }
                             }
                        ]
                    });
                    $('#dt_individual_search tfoot th').each(function () {
                        if ($(this).index() != 0 && $(this).index() != 6) {
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

        function confirmdelete(impseq,impfilename) {
            UIkit.modal.confirm("กรุณายืนยันการลบข้อมูลของ " + impfilename, function () {
                
                var parms = { omrimpseq: impseq};

                //console.log(parms);

                $.ajax({
                    type: 'POST',
                    url: 'deleteomrimport.aspx/deleteomr',

                    data: '{\'impseq\':\'' + JSON.stringify(parms) + '\'}',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    async: true,
                    success: function (msg) {
                        var msgReturn = $.parseJSON(msg.d);
                        // console.log(msgReturn);

                        if (msgReturn == '1') {
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


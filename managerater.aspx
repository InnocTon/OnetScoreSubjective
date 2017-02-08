<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="managerater.aspx.cs" Inherits="managerater" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รายงาน"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="เพิ่มรายชื่อ" id="addnewbtn"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>
        <h1><i class="material-icons md-24">&#xE8B9;</i> ตั้งค่าผู้ตรวจ</h1>
        <span class="uk-text-upper uk-text-small">ข้อมูลรายละเอียดครูผู้ตรวจ</span>
    </div>

    <div id="page_content_inner">
        <div class="md-card">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">
                    <table class="uk-table" id="dt_individual_search">
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
                        <tfoot>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>ชื่อ - นามสกุล</th>
                                <th>รหัสผู้ตรวจ</th>
                                <th>เลขบัตรประชาชน</th>
                                <th>สถานที่ตรวจ</th>
                                <th>เครื่องมือ</th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                
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
                                    <label for="boxcodetxt">รหัสผู้ตรวจ (7 หลัก)</label>
                                    <input type="text" name="ratercodetxt" id="ratercodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสผู้ตรวจ" parsley-error-message="กรุณากรอกรหัสผู้ตรวจ" runat="server" data-parsley-minlength="7" data-parsley-maxlength="7" maxlength="7" />
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
                                    <input type="text" name="fnametxt" id="fnametxt" required class="md-input" runat="server" data-required-message="กรุณากรอกชื่อ" parsley-error-message="กรุณากรอกชื่อ" />
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
                                    <input type="text" name="citizentxt" id="citizentxt" required class="md-input" runat="server" data-required-message="กรุณากรอกเลขบัตรประชาชน" parsley-error-message="กรุณากรอกเลขบัตรประชาชน" data-parsley-minlength="13" data-parsley-maxlength="13" maxlength="13" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="grouptxt">กลุ่มที่ตรวจ</label>
                                    <input type="text" name="grouptxt" id="grouptxt" required class="md-input" runat="server" data-required-message="กรุณากรอกกลุ่มที่ตรวจ" parsley-error-message="กรุณากรอกกลุ่มที่ตรวจ" />
                                </div>
                            </div>
                        </div>

                         <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="grouptxt">เลขที่นั่งตรวจ</label>
                                    <input type="text" name="seattxt" id="seattxt" required class="md-input" runat="server" data-required-message="กรุณากรอกเลขที่นั่งตรวจ" parsley-error-message="กรุณากรอกเลขที่นั่งตรวจ" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <select id="placeaction" name="placeaction" runat="server" required class="md-input" data-required-message="กรุณาเลือกสถานที่ตรวจ" parsley-error-message="กรุณาเลือกสถานที่ตรวจ">
                                        <option value="">กรุณาเลือกสถานที่ตรวจ</option>
                                        <option value="มบ.">ม.บูรพา</option>
                                        <option value="มศก.">ม.ศิลปากร</option>
                                        <option value="มสธ.">ม.สุโขทัยธรรมาธิราช</option>
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
    <!-- datatables -->
    <script src="bower_components/datatables/media/js/jquery.dataTables.min.js"></script>
    <!-- datatables colVis-->
    <script src="bower_components/datatables-colvis/js/dataTables.colVis.js"></script>
    <!-- datatables tableTools-->
    <script src="bower_components/datatables-tabletools/js/dataTables.tableTools.js"></script>
    <!-- datatables custom integration -->
    <script src="assets/js/custom/datatables_uikit.min.js"></script>

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
                $("#<%=seattxt.ClientID%>").val('');
                $("#<%=grouptxt.ClientID%>").val('');
                $('#form_validation').parsley().reset();

            }
        });



    </script>
    <script src="bower_components/parsleyjs/dist/parsley.js"></script>


    <script>

        $(document).ready(function () {

            $("#addnewbtn").click(function () {
                UIkit.modal.confirm('คำเตือน : ก่อนทำการเพิ่มรายชื่อจะต้องได้รับความเห็นชอบจาก ผอ. หรือ รอง ผอ. ก่อนเท่านั้น!', function () {
                    // UIkit.modal.alert('Confirmed!');
                    UIkit.modal("#modal_send_recive").show();
                });
            });

            $.ajax({
                type: "POST",
                dataType: "json",
                url: "DataraterService.asmx/GetDats",
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
                            { className: "dt-center", "targets": [0, 5] },
                            { className: "dt-left", "targets": "1" },
                            { width: "8%", "targets": 0 }
                        ],
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'ratername' },
                            { 'data': 'ratercode' },
                            { 'data': 'raterpid' },
                            { 'data': 'raterplace' },
                            {
                                'data': 'ratertools', 'render': function (status, type, full) {
                                    return "<a href='raterdetail.aspx?seq=" + status + "'><i class='material-icons uk-text-success md-24'>&#xE417;</i></a> <a href='#' onclick='confirmdelete(" + status + ",\"" + full.ratername + "\");'><i class='md-icon material-icons uk-text-danger md-24'>&#xE872;</i></a> ";
                                    
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

                }
            });

        });

        function confirmdelete(raterid, ratername) {
            UIkit.modal.confirm('กรุณายืนยันการลบข้อมูลของ ' + ratername, function () {


                var parms = { raterseq: raterid };

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


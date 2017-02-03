<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Worktime.aspx.cs" Inherits="Worktime" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รายงาน"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รับ-ส่ง" id="sendrecivebtn" data-uk-modal="{target:'#modal_send_recive'}"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>
        <h1><i class="material-icons md-24">&#xE855;</i> บันทึกเวลาปฏิบัติงาน</h1>
        <span class="uk-text-upper uk-text-small">ลงเวลาเข้า-ออก ปฏิบัติงานตรวจกระดาษคำตอบอัตนัยของครูผู้ตรวจ (Rater)</span>
    </div>

     <div id="page_content_inner">
        <div class="md-card">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">
                    <table class="uk-table" id="dt_worktime_search">
                        <thead>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>ชื่อผู้ตรวจ</th>
                                <th>วันที่ปฏิบัติงาน</th>
                            </tr>
                        </thead>
                        <tfoot>
                             <tr>
                                <th></th>
                                <th>ชื่อผู้ตรวจ</th>
                                <th>วันที่ปฏิบัติงาน</th>
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
                <h3 class="uk-modal-title">แบบฟอร์ม ลงเวลาปฏิบัติงาน</h3>
            </div>
            <form id="form_validation" class="uk-form-stacked" runat="server" autocomplete="off">
                <div class="uk-width-medium-3-3">
                    <div class="uk-form-row">

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="ratercodetxt">รหัสผู้ตรวจ</label>
                                    <input type="text" name="ratercodetxt" id="ratercodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสผู้ตรวจ" parsley-error-message="กรุณากรอกรหัสผู้ตรวจ" runat="server" />
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
                $('#form_validation').parsley().reset();


            }
        });



    </script>
        <script src="bower_components/parsleyjs/dist/parsley.js"></script>
    <!--  issues list functions -->


    <script>

        $(document).ready(function () {
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "DataworkService.asmx/GetDats",
                success: function (data) {
                    var datatableVariable = $('#dt_worktime_search').DataTable({

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
                          { className: "dt-center", "targets": [0, 2] },
                          { className: "dt-left", "targets": "1" },
                          { width: "8%", "targets": 0 }
                        ],
                        lengthMenu: [[5,10, 25, 50, -1], [5,10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'ratername' },
                            { 'data': 'workdate' }
                            ]
                    });
                    $('#dt_worktime_search tfoot th').each(function () {
                        if ($(this).index() != 0 && $(this).index() != 5) {
                            var placeHolderTitle = $('#dt_worktime_search thead th').eq($(this).index()).text();
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

    </script>


</asp:Content>


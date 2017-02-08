<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="rater3managediff.aspx.cs" Inherits="rater3managediff" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">

        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="บันทึกคะแนน" id="sendrecivebtn" data-uk-modal="{target:'#modal_send_recive'}"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>

        <h1><i class="uk-icon-keyboard-o uk-icon-small"></i> &nbsp;บันทึกคะแนน Diff</h1>
        <span class="uk-text-upper uk-text-small">บันทึกคะแนนของการประมวลหาค่าผลต่าของคะแนนเกิน 15%</span>
        <input type="hidden" value="" id="usercode" />


    </div>

    <div id="page_content_inner">
        <div class="md-card uk-margin-medium-bottom">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">
                    <table class="uk-table" id="dt_scorediff_search">
                        <thead>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>รหัสกระดาษ</th>
                                <th>ข้อที่</th>
                                <th>วันที่ตรวจ</th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th class="uk-text-center"></th>
                                <th>รหัสกระดาษ</th>
                                <th>ข้อที่</th>
                                <th>วันที่ตรวจ</th>
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
                <h3 class="uk-modal-title">บันทึกคะแนน Diff</h3>
            </div>
            <form id="form_validation" class="uk-form-stacked" autocomplete="off">
                <div class="uk-width-medium-3-3">
                    <div class="uk-form-row">

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="boxcodetxt">รหัสกระดาษ</label>
                                    <input type="text" name="papercodetxt" id="papercodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสกระดาษ" parsley-error-message="กรุณากรอกรหัสกระดาษ"/>
                                </div>
                            </div>
                        </div>


                        <div class="uk-modal-footer uk-text-right">
                            <button type="button" class="md-btn md-btn-flat uk-modal-close">ยกเลิก</button>
                            <button type="submit" id="addscore" class="md-btn md-btn-flat md-btn-flat-primary">บันทึก</button>
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
                $("#papercodetxt").val('');
                $('#form_validation').parsley().reset();
            }
        });



    </script>

    <script>
        $(document).ready(function () {


            $("#addscore").click(function () {
                // window.location = "papercopy3report.aspx?papercode=" + $("#papercodetxt").val() + "&qno=" + $("#questionno").val();

                var papercode = $("#papercodetxt").val();
                var qno = papercode.substr(4, 1);

              //  alert(qno);
                if (qno == '1') {
                    window.location = "Rater3No1.aspx?stdcode=" + papercode.substring(0, 5) + papercode.substring(6, 14);
                } else {
                    window.location = "Rater3No2.aspx?stdcode=" + papercode.substring(0, 5) + papercode.substring(6, 14);
                }

                return false;
               
                //alert(555);
            });

            var boxcode = "3240200322527";
            var parms = { "boxcode": boxcode };



            $.ajax({
                type: "POST",
                dataType: "json",
                contentType: 'application/json; charset=utf-8',
                url: "DiffScoreService.asmx/GetDataScoreDiffDetail",
                data: '{\'box\':\'' + JSON.stringify(parms) + '\'}',
                success: function (data) {
                    //   console.log(data.d);
                    var datatableVariable = $('#dt_scorediff_search').DataTable({

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
                           { searchable: false, orderable: false, "aTargets": [0] },
                           { className: "dt-center", "targets": [0, 3] },
                           { className: "dt-left", "targets": "1" },
                           { width: "8%", "targets": 0 }
                        ],
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        data: data.d,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'papercode' },
                            { 'data': 'qno' },
                            { 'data': 'scoredate' }

                        ]
                    });
                    $('#dt_scorediff_search tfoot th').each(function () {
                        if ($(this).index() != 0) {
                            var placeHolderTitle = $('#dt_scorediff_search thead th').eq($(this).index()).text();
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

        });

    </script>
</asp:Content>


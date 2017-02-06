<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="managescorediff.aspx.cs" Inherits="managescorediff" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server">

        <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
            <h1><i class="material-icons md-24">&#xE3EA;</i> ประมวลผลค่า Diff</h1>
            <span class="uk-text-upper uk-text-small">ประมวลผลคะแนนหาค่าผลต่าของคะแนนเกิน 15%</span>
        </div>

        <div id="page_content_inner">
            <div class="md-card uk-margin-medium-bottom">
                <div class="md-card-content">
                    <div class="uk-overflow-container uk-margin-bottom">
                        <table class="uk-table" id="dt_scorediff_search">
                            <thead>
                                <tr>
                                    <th class="uk-text-center">ลำดับที่</th>
                                    <th>รหัสผู้สอบ</th>
                                    <th>รหัสกระดาษ</th>
                                    <th>ข้อที่</th>
                                    <th>เครื่องมือ</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th class="uk-text-center"></th>
                                    <th>รหัสผู้สอบ</th>
                                    <th>รหัสกระดาษ</th>
                                    <th>ข้อที่</th>
                                    <th></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>




        <div class="md-fab-wrapper">
            <div class="md-fab md-fab-toolbar md-fab-accent">
                <i class="material-icons">&#xE8BE;</i>
                <div class="md-fab-toolbar-actions">
                    <button type="button" id="processdiff" runat="server" onserverclick="listdirectorybtn_Click" data-uk-tooltip="{cls:'uk-tooltip-small',pos:'bottom'}" title="ประมวลผลค่า Diff"><i class="material-icons md-color-white">&#xE627;</i></button>
                    <button type="button" id="printdiffall" data-uk-tooltip="{cls:'uk-tooltip-small',pos:'bottom'}" title="พิมพ์ใบบันทึกคะแนน ชุดที่ 3 (ทั้งหมด)"><i class="material-icons md-color-white">&#xE555;</i></button>
                    <button type="button" id="reportdiff" data-uk-tooltip="{cls:'uk-tooltip-small',pos:'bottom'}" title="รายงานการประมวลผลคะแนน"><i class="material-icons md-color-white">&#xE415;</i></button>
                </div>
            </div>
        </div>

    </form>
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
                url: "DiffService.asmx/GetDats",
                success: function (data) {
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
                            { searchable: false, orderable: false, "aTargets": [0, 4] },
                            { className: "dt-center", "targets": [0, 1, 2, 3, 4] },
                            { width: "8%", "targets": [0, 3, 4] }
                        ],
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'stdcode' },
                            { 'data': 'papercode' },
                            { 'data': 'qno' },
                            {
                                'data': 'difftools', 'render': function (value, type, full) {

                                    if (full.qno == '1') {
                                        return "<a href='papercopy3report.aspx?papercode=" + value + "&qno=" + full.qno + "'><i class='md-icon material-icons uk-text-danger'>&#xE8AD;</i></a> <a href='Rater3No1.aspx?stdcode=" + full.stdcode + "'><i class='md-icon material-icons uk-text-primary material-icons'>&#xE150;</i></a>";
                                    } else {
                                        return "<a href='papercopy3report.aspx?papercode=" + value + "&qno=" + full.qno + "'><i class='md-icon material-icons uk-text-danger'>&#xE8AD;</i></a> <a href='Rater3No2.aspx?stdcode=" + full.stdcode + "'><i class='md-icon material-icons uk-text-primary material-icons'>&#xE150;</i></a>";
                                    }
                                    

                                   
                                }
                            }
                        ]
                    });
                    $('#dt_scorediff_search tfoot th').each(function () {
                        if ($(this).index() != 0 && $(this).index() != 4) {
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
                }
            });

        });


        $("#printdiffall").click(function () {
            // alert("printall");
            UIkit.modal.prompt('ข้อที่ต้องการพิมพ์ :', '', function (val) {
                //    alert(val || '1');
                //     UIkit.modal.alert('Hello ' + (val || 'Mr noname') + '!');
                window.location = "papercopy3report.aspx?papercode=all&qno=" + (val || '1');
            });
        });

        $("#reportdiff").click(function () {

            UIkit.modal.prompt('ข้อที่ต้องการพิมพ์ :', '', function (val) {
                //    alert(val || '1');
                //     UIkit.modal.alert('Hello ' + (val || 'Mr noname') + '!');
                window.location = "reportdiff.aspx?qno=" + (val || '1');
            });


            
        });

    </script>

</asp:Content>


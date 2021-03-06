﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="managebox.aspx.cs" Inherits="managebox" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="reportstatusbox.aspx" data-uk-tooltip="{pos:'bottom'}" title="รายงานสถานะกล่อง"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รับ-ส่ง" id="sendrecivebtn" data-uk-modal="{target:'#modal_send_recive'}"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>
        <h1><i class="material-icons">&#xE80D;</i> รับ-ส่ง กล่องบรรจุใบบันทึกคะแนนอัตนัย</h1>
        <span class="uk-text-upper uk-text-small">ข้อมูลรับ-ส่งกล่องบรรจุใบบันทึกคะแนนอัตนัย</span>
    </div>

    <div id="page_content_inner">
        <div class="md-card">
            <div class="md-card-content">
                <div class="uk-overflow-container uk-margin-bottom">
                    <table class="uk-table" id="dt_individual_search">
                        <thead>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>รหัสกล่อง</th>
                                <th>จำนวนซองทั้งหมด</th>
                                <th>จำนวนซองที่ตรวจเสร็จ</th>
                                <th>สถานะกล่อง</th>
                                <th>เครื่องมือ</th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th>รหัสกล่อง</th>
                                <th>จำนวนซองทั้งหมด</th>
                                <th>จำนวนซองที่ตรวจเสร็จ</th>
                                <th>สถานะกล่อง</th>
                                <th></th>
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
                <h3 class="uk-modal-title">แบบฟอร์ม รับ-ส่ง กล่องบรรจุใบบันทึกคะแนนอัตนัย</h3>
            </div>
            <form id="form_validation" class="uk-form-stacked" runat="server" autocomplete="off">
                <div class="uk-width-medium-3-3">
                    <div class="uk-form-row">

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="boxcodetxt">รหัสกล่อง</label>
                                    <input type="text" name="boxcodetxt" id="boxcodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสกล่อง" parsley-error-message="กรุณากรอกรหัสกล่อง" runat="server" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="ratercodetxt">รหัสเจ้าหน้าที่</label>
                                    <input type="text" name="usercodetxt" id="usercodetxt" required class="md-input" runat="server" data-required-message="กรุณากรอกรหัสเจ้าหน้าที่" parsley-error-message="กรุณากรอกรหัสเจ้าหน้าที่" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <select id="boxaction" name="boxaction" runat="server" required class="md-input" data-required-message="กรุณาเลือกสถานะกล่อง" parsley-error-message="กรุณาเลือกสถานะกล่อง">
                                        <option value="">กรุณาเลือกสถานะกล่อง</option>
                                        <option value="borrow">เบิกกล่องส่งตรวจ</option>
                                        <option value="omr">ส่งกล่องอ่าน OMR</option>
                                        <option value="return">ส่งกล่องคืนห้องมั่นคง</option>

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
                $("#<%=boxcodetxt.ClientID%>").val('');
                $("#<%=usercodetxt.ClientID%>").val('');
                $("#<%=boxaction.ClientID%>").val('');
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
                url: "DataboxService.asmx/GetDats",
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
                          { searchable: false, orderable: false, "aTargets": [0, 5] },
                          { className: "dt-center", "targets": [0, 3, 4] },
                          { className: "dt-left", "targets": "1" },
                          { width: "8%", "targets": [0, 2, 3] }
                        ],
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'boxcode' },
                            { 'data': 'packagenum' },
                            { 'data': 'packagenums' },
                            {
                                'data': 'boxstatusname', 'render': function (value, type, full) {
                                    if (full.packagenum == full.packagenums) {
                                        return "<span class='uk-badge uk-badge-success'>" + value + "</span>";
                                    } else if (full.packagenums != 0) {
                                        return "<span class='uk-badge uk-badge-warning'>" + value + "</span>";
                                    } else {
                                        return value;
                                    }
                                }
                            },
                            {
                                'data': 'boxtools', 'render': function (value, type, full) {
                                    return "<a href='boxdetail.aspx?seq=" + value + "'><i class='material-icons uk-text-success md-24'>&#xE417;</i></a>";
                                }
                            }
                        ]
                        /*
                                                    {
                                                        'data': 'dateOfBirth', 'render': function (date) {
                                                            var date = new Date(parseInt(date.substr(6)));
                                                            var month = date.getMonth() + 1;
                                                            return date.getDate() + "/" + month + "/" + date.getFullYear();
                                                        }
                                                    }*/
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

    </script>






</asp:Content>


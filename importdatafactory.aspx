﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="importdatafactory.aspx.cs" Inherits="importdatafactory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server">
        <div id="page_content_inner">
            <div class="md-card">
                <div class="md-card-content">
                    <div class="uk-grid uk-grid-divider" data-uk-grid-margin>
                        <div class="uk-width-large-2-4 uk-width-medium-2-4">
                            <ul class="md-list md-list-addon">
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE88F;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">นำเข้าข้อมูลกล่อง</span>
                                        <span class="uk-text-small uk-text-muted">ข้อมูลกล่องบรรจุซองบรรจุใบบันทึกคะแนนอัตนัย</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE88F;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">นำเข้าข้อมูลซอง</span>
                                        <span class="uk-text-small uk-text-muted">ข้อมูลซองบรรจุใบบันทึกคะแนนอัตนัย</span>
                                    </div>
                                </li>
                                <li>
                                    <div class="md-list-addon-element">
                                        <i class="md-list-addon-icon material-icons uk-text-success">&#xE88F;</i>
                                    </div>
                                    <div class="md-list-content">
                                        <span class="md-list-heading">นำเข้าข้อมูลใบบันทึกคะแนน</span>
                                        <span class="uk-text-small uk-text-muted">รายละเอียดข้อมูลใบบันทึกคะแนน</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="uk-width-large-2-4 uk-width-medium-2-4">
                            <div class="uk-width-medium-1-3">
                                <h3 class="heading_a" style="width: 300px; margin-bottom: 10px;"><i class="material-icons">&#xE0AF;</i> นำเข้าข้อมูลจากโรงงาน </h3>
                            </div>
                            <div class="uk-width-medium-1-3">
                                <asp:DropDownList ID="importtypeddl" runat="server" data-md-selectize Height="29px" Style="margin-right: 28px" Width="241px">
                                    <asp:ListItem Value="0">ประเภทไฟล์</asp:ListItem>
                                    <asp:ListItem Value="box">ข้อมูลกล่อง (BOX)</asp:ListItem>
                                    <asp:ListItem Value="package">ข้อมูลซอง (PACKAGE)</asp:ListItem>
                                    <asp:ListItem Value="paper">ข้อมูลใบบันทึกคะแนน (PAPER)</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="uk-width-medium-1-3" style="width: 240px; margin-bottom: 10px;">
                                <asp:FileUpload ID="FileUpload1" runat="server" />
                            </div>
                            <div class="uk-width-medium-1-3">
                                <asp:Button ID="listdirectorybtn" runat="server" Text="นำเข้าไฟล์" OnClick="listdirectorybtn_Click" CssClass="uk-form-file md-btn md-btn-primary" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="md-card uk-margin-medium-bottom">
                <div class="md-card-content">
                    <table id="dt_individual_search" class="uk-table" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th>ลำดับที่</th>
                                <th>ชื่อไฟล์</th>
                                <th>สถานะ</th>
                                <th>ประเภท</th>
                                <th>ผู้นำเข้า</th>
                                <th>วันที่นำเข้า</th>
                                <th>เครื่องมือ</th>
                            </tr>
                        </thead>

                        <tfoot>
                            <tr>
                                <th></th>
                                <th>ชื่อไฟล์</th>
                                <th>สถานะ</th>
                                <th>ประเภท</th>
                                <th>ผู้นำเข้า</th>
                                <th>วันที่นำเข้า</th>
                                <th></th>
                            </tr>
                        </tfoot>
                    </table>
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


    <!--  datatables functions -->



    <script>

        $(document).ready(function () {

      //      ScriptManager.RegisterStartupScript(this, GetType(), "login", "altair_helpers.content_preloader_show();", true);

            $("#<%=listdirectorybtn.ClientID%>").click(function () {
                altair_helpers.content_preloader_show();
            });

          

            $.ajax({
                type: "POST",
                dataType: "json",
                url: "FactoryService.asmx/GetDats",
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
                           { searchable: false, orderable: false, "aTargets": [0,6] },
                           { className: "dt-center", "targets": [0, 6] },
                           { className: "dt-left", "targets": "1" },
                           { width: "8%", "targets": 0 }
                        ],
                        lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'filename' },           
                           {
                               'data': 'filestatus', 'render': function (type) {
                                   if (type == 'N') return "ปกติ";
                                   else return "ยกเลิก";
                               }
                           },
                            { 'data': 'filetype' },
                            { 'data': 'fileimport' },
                            { 'data': 'filedate' },
                             {
                                 'data': 'filetools', 'render': function (status, type, full) {
                                    
                                     return "<a href='#' onclick='confirmdelete(" + status + ",\"" + full.filename + "\");'><i class='md-icon material-icons uk-text-danger md-24'>&#xE872;</i></a> ";
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
            UIkit.modal.confirm('กรุณายืนยันการลบข้อมูลของ ' + impfilename , function () {


                var parms = { filecode: impseq };

                $.ajax({
                    type: 'POST',
                    url: 'deletefileimport.aspx/delfile',

                    data: '{\'fcode\':\'' + JSON.stringify(parms) + '\'}',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    async: true,
                    success: function (msg) {
                        var msgReturn = $.parseJSON(msg.d);

                        if (msgReturn == '1') {
                            swal({
                                title: 'สำเร็จ',
                                text: 'ลบข้อมูล ' + impfilename + ' เรียบร้อย',
                                type: 'success',
                                confirmButtonText: 'ตกลง',
                                closeOnConfirm: true
                            },
                             function () {
                                 window.location = 'importdatafactory.aspx';
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

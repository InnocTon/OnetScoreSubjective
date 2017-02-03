<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="manageuser.aspx.cs" Inherits="manageuser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="page_heading" data-uk-sticky="{ top: 48, media: 960 }">
        <div class="heading_actions">
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="รายงาน"><i class="md-icon material-icons">&#xE415;</i></a>
            <a href="#" data-uk-tooltip="{pos:'bottom'}" title="เพิ่มรายชื่อ" id="addnewbtn" data-uk-modal="{target:'#modal_send_recive'}"><i class="md-icon material-icons">&#xE03C;</i></a>
        </div>
        <h1><i class="material-icons md-24">&#xE8B9;</i> ตั้งค่าผู้ใช้งานระบบ</h1>
        <span class="uk-text-upper uk-text-small">ข้อมูลรายละเอียดผู้ใช้งานระบบ</span>
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
                                <th>รหัสผู้ใช้งาน</th>
                                <th>ประเภทผู้ใช้งาน</th>
                                <th>รหัสผ่าน</th>
                                <th>เครื่องมือ</th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th class="uk-text-center">ลำดับที่</th>
                                <th>ชื่อ - นามสกุล</th>
                                <th>รหัสผู้ใช้งาน</th>
                                <th>ประเภทผู้ใช้งาน</th>
                                <th>รหัสผ่าน</th>
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
                                    <label for="usercodetxt">รหัสผู้ใช้งาน</label>
                                    <input type="text" name="usercodetxt" id="usercodetxt" required="required" class="md-input" data-required-message="กรุณากรอกรหัสผู้ตรวจ" parsley-error-message="กรุณากรอกรหัสผู้ตรวจ" runat="server" data-parsley-minlength="11" data-parsley-maxlength="11" maxlength="11" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="nametxt">ชื่อ - นามสกุล</label>
                                    <input type="text" name="nametxt" id="nametxt" required class="md-input" runat="server" data-required-message="ชื่อ - นามสกุล" parsley-error-message="ชื่อ - นามสกุล" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="passwordtxt">รหัสผ่าน</label>
                                    <input type="text" name="passwordtxt" id="passwordtxt" required class="md-input" runat="server" data-required-message="กรุณากรอกรหัสผ่าน" parsley-error-message="กรุณากรอกรหัสผ่าน" data-parsley-minlength="4" data-parsley-maxlength="13" maxlength="13" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="citizenidtxt">รหัสประชาชน</label>
                                    <input type="text" name="citizenidtxt" id="citizenidtxt" required class="md-input" runat="server" data-required-message="กรุณากรอกเลขบัตรประชาชน" parsley-error-message="กรุณากรอกเลขบัตรประชาชน" data-parsley-minlength="13" data-parsley-maxlength="13" maxlength="13" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <label for="passwordtxt">ศูนย์ตรวจ</label>
                                    <input type="text" name="placetxt" id="placetxt" required class="md-input" runat="server" data-required-message="กรุณากรอกศูนย์ตรวจ" parsley-error-message="กรุณากรอกศูนย์ตรวจ" />
                                </div>
                            </div>
                        </div>

                        <div class="uk-grid" data-uk-grid-margin>
                            <div class="uk-width-medium-2-2">
                                <div class="parsley-row">
                                    <select id="typeaction" name="typeaction" runat="server" required class="md-input" data-required-message="กรุณาเลือกประเภทผู้ใช้งาน" parsley-error-message="กรุณาเลือกประเภทผู้ใช้งาน">
                                        <option value="">กรุณาเลือกประเภทผู้ใช้งาน</option>
                                        <option value="rater3">ผู้ตรวจคนที่ 3</option>
                                        <option value="user">เจ้าหน้าที่</option>
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
                $("#<%=usercodetxt.ClientID%>").val('');
                $("#<%=nametxt.ClientID%>").val('');
                $("#<%=passwordtxt.ClientID%>").val('');
                $("#<%=typeaction.ClientID%>").val('');
                $("#<%=citizenidtxt.ClientID%>").val('');
                $("#<%=placetxt.ClientID%>").val('');
                $('#form_validation').parsley().reset();
                
            }
        });



    </script>

    <script src="bower_components/parsleyjs/dist/parsley.js"></script>


    <script>
        $(document).ready(function () {
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "DatauserService.asmx/GetDats",
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
                        lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                        data: data,
                        columns: [
                            { 'data': 'no' },
                            { 'data': 'username' },
                            { 'data': 'usercode' },
                            {
                                'data': 'usertype', 'render': function (status) {
                                    var type = "";
                                    switch (status) {
                                        case "admin": type = "ผู้ดูแลระบบ"; break;
                                        case "rater3": type = "ผู้ตรวจคนที่ 3"; break;
                                        case "user": type = "เจ้าหน้าที่"; break;
                                    }
                                    return type;
                                }
                            },
                            { 'data': 'userpass' },
                            {
                                'data': 'usertools', 'render': function (status, type, full) {
                                    if (full.usertype != "admin") {
                                        return "<a href='userdetail.aspx?seq=" + status + "'><i class='material-icons uk-text-success md-24'>&#xE417;</i></a> <a href='#' onclick='confirmdelete(" + full.usercode + ",\"" + full.username + "\");'><i class='md-icon material-icons uk-text-danger md-24'>&#xE872;</i></a> ";
                                    } else {
                                        return "<a href='userdetail.aspx?seq=" + status + "'><i class='material-icons uk-text-success md-24'>&#xE417;</i></a>";
                                    }
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

        function confirmdelete(userid, username) {
            UIkit.modal.confirm('กรุณายืนยันการลบข้อมูลของ' + username, function () {


                var parms = { usercode: userid };

                $.ajax({
                    type: 'POST',
                    url: 'deleteuser.aspx/deluser',

                    data: '{\'ucode\':\'' + JSON.stringify(parms) + '\'}',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    async: true,
                    success: function (msg) {
                        var msgReturn = $.parseJSON(msg.d);

                        if (msgReturn == '1') {
                            swal({
                                title: 'สำเร็จ',
                                text: 'ลบข้อมูลผู้ใช้งานเรียบร้อย',
                                type: 'success',
                                confirmButtonText: 'ตกลง',
                                closeOnConfirm: true
                            },
                             function () {
                                 window.location = 'manageuser.aspx';
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


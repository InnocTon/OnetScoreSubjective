<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Rater3No1.aspx.cs" Inherits="Rater3No1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>ระบบบริหารจัดการการตรวจกระดาษคำตอบอัตนัย สถาบันทดสอบทางการศึกษาแห่งชาติ (องค์การมหาชน)- Rater 3</title>
    <style>
        .uk-table th,td{
            border:1px solid #e0e0e0;
            padding: 0px!important;
        }
        .stripRow{
            background: rgba(0, 0, 0, 0.085);
            font-size:15px;
        }
        .stripRowNone{
            background: rgba(250, 250, 250, 0.35);
        }
        .rowPadLeft{
            padding-left:15px!important;
        }
        .imgWidth{
            width: 60%;
        }
        .imgHide{
            visibility: hidden;
        }
        @media print {
          body * {
            visibility: hidden;
          }
          #section-to-print, #section-to-print * {
            visibility: visible;
            width: 100%;
          }
          #section-to-print {
            position: absolute;
            left: 0;
            top: 0;
          }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    @serverinfo.gethtml()
    <div class="md-card uk-margin-medium-bottom">
                <div class="md-card-content">
                    <div id="vmaps_world_connected" class="vm_wrapper uk-text-center main-print">
                        <a href="omrimages/166123/16612300001/16612300001002.jpg" data-uk-lightbox="{group:'gallery'}">
                        <img src="omrimages/166123/16612300001/16612300001002.jpg" class="imgWidth" id="section-to-print"/>
                        </a>
                    </div>
                </div>
        <div class="md-card-toolbar">
            <div class="md-card-toolbar-actions hidden-print" onclick="setTimeout(function () {window.print();}, 300)">
                <i class="md-icon material-icons" id="invoice_print">&#xE8ad;</i>
            </div>
        </div>
    </div>

    <div>
    <table class="uk-table uk-table-hover uk-table-nowrap">
                            <thead>
                            <tr>
                                <th class="uk-width-2-10 uk-text-center">เกณฑ์การตรวจ</th>
                                <th class="uk-width-8-10 uk-text-center" colspan="6">ช่วงคะแนน</th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr class="stripRow">
                                    <td>๑. เขียนตรงตามคำสั่ง (๑ คะแนน)</td>
                                    <td class="uk-text-center">๐</td>
                                    <td class="uk-text-center">๐.๕</td>
                                    <td class="uk-text-center">๑.๐</td>
                                    <td class="uk-text-center">๑.๕</td>
                                    <td class="uk-text-center">๒.๐</td>
                                    <td class="uk-text-center">๒.๕</td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๑.๑ ความยาว</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score1_1" id="score1_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score1_1" id="score1_1_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๑.๒ เขียนเรื่อง</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score1_2" id="score1_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score1_2" id="score1_2_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                </tr>
                                <tr class="stripRow">
                                    <td>๒. เนื้อหา (๔ คะแนน)</td>
                                    <td class="uk-text-center">๐</td>
                                    <td class="uk-text-center">๐.๕</td>
                                    <td class="uk-text-center">๑.๐</td>
                                    <td class="uk-text-center">๑.๕</td>
                                    <td class="uk-text-center">๒.๐</td>
                                    <td class="uk-text-center">๒.๕</td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๒.๑ แนวคิด</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score2_1" id="score2_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score2_1" id="score2_1_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score2_1" id="score2_1_20" value="2" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score2_1" id="score2_1_25" value="2.5" data-md-icheck /></td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๒.๒ ลำดับ</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score2_2" id="score2_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score2_2" id="score2_2_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score2_2" id="score2_2_15" value="1.5" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                </tr>
                                <tr class="stripRow">
                                    <td>๓. ภาษา (๕ คะแนน)</td>
                                    <td class="uk-text-center">๐</td>
                                    <td class="uk-text-center">๐.๕</td>
                                    <td class="uk-text-center">๑.๐</td>
                                    <td class="uk-text-center">๑.๕</td>
                                    <td class="uk-text-center">๒.๐</td>
                                    <td class="uk-text-center">๒.๕</td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๓.๑ สะกด</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_1" id="score3_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_1" id="score3_1_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_1" id="score3_1_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๓.๒ การใช้คำ</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_2" id="score3_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_2" id="score3_2_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_2" id="score3_2_20" value="2" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_2" id="score3_2_25" value="2.5" data-md-icheck /></td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๓.๓ ประโยค</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_3" id="score3_3_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_3" id="score3_3_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                </tr>
                                <tr>
                                    <td class="stripRowNone rowPadLeft">๓.๔ วรรคตอน</td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_4" id="score3_4_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"><input type="radio" name="score3_4" id="score3_4_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                    <td class="uk-text-center"></td>
                                </tr>
                                </tbody>
     </table>
        </div>
     <!--<img src="omrimages/166123/16612300001/16612300001002.jpg" class="imgHide" id="section-to-print"/>-->
     <!--  invoices functions -->
    <script src="assets/js/pages/page_invoices.min.js"></script>
    <!-- handlebars.js -->
    <script src="bower_components/handlebars/handlebars.min.js"></script>
    <script src="assets/js/custom/handlebars_helpers.min.js"></script>
</asp:Content>


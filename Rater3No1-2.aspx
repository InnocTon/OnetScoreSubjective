<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Rater3No1-2.aspx.cs" Inherits="Rater3No1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>ระบบบริหารจัดการการตรวจกระดาษคำตอบอัตนัย สถาบันทดสอบทางการศึกษาแห่งชาติ (องค์การมหาชน)- Rater 3</title>
    <style>
        .uk-table th,td{
            border:1px solid #e0e0e0;
            padding: 4px!important;
        }
        .stripRow{
            background: rgba(0, 0, 0, 0.085);
            font-size:15px;
        }
        .stripRowNone{
            background: rgba(0, 0, 0, 0.04);
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
          .section-to-print, .section-to-print * {
            visibility: visible;
            width: 100%;
          }
          .section-to-print {
            position: absolute;
            left: 0;
            top: 0;
          }
          .itemHide{
            visibility: hidden;
          }
        }
    </style>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
        <div id="page_heading">
            <h1>ระบบบันทึกคะแนนอัตนัย วิชาภาษาไทย ข้อที่ ๑. การเขียนเล่าเรื่องจากภาพ</h1>
            <span class="uk-text-muted uk-text-upper uk-text-small">ชื่อผู้ตรวจ :</span>
        </div>
        <div id="page_content_inner">

            <div class="uk-grid uk-grid-medium section-to-print" data-uk-grid-margin>
                <div class="uk-width-xLarge-1-2 uk-width-large-1-2"><!-- Left -->
                    <div class="md-card">
                        <div class="md-card-toolbar">
                            <h3 class="md-card-toolbar-heading-text">
                                คำตอบ
                            </h3>
                            <div class="md-card-toolbar">
                                <div class="md-card-toolbar-actions hidden-print" onclick="setTimeout(function () {window.print();}, 300)">
                                    <i class="md-icon material-icons" id="invoice_print">&#xE8ad;</i>
                                </div>
                            </div>
                        </div>
                        <div class="md-card-content">
                            <div class="uk-margin-bottom uk-text-center">
                                <a href="omrimages/166123/16612300001/16612300001002.jpg" data-uk-lightbox="{group:'gallery'}" class="itemHide">
                                    <img src="omrimages/166123/16612300001/16612300001002.jpg" alt="" class=""/>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="uk-width-xLarge-1-2  uk-width-large-1-2">
                    <div class="md-card"><!-- Right -->
                        <div class="md-card-toolbar">
                            <h3 class="md-card-toolbar-heading-text">
                                คะแนน
                            </h3>
                        </div>
                        <form action="" class="uk-form-stacked" id="score_form"> 
                        <div class="md-card-content large-padding">
                            <div class="uk-grid uk-grid-divider uk-grid-medium">
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
                                    <td class="rowPadLeft">๑.๑ ความยาว</td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๑.๒ เขียนเรื่อง</td>
                                    <td class="uk-text-center"><input type="radio" name="score1_2" id="score1_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_2" id="score1_2_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
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
                                    <td class="rowPadLeft">๒.๑ แนวคิด</td>
                                    <td class="uk-text-center"><input type="radio" name="score2_1" id="score2_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_1" id="score2_1_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_1" id="score2_1_20" value="2" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_1" id="score2_1_25" value="2.5" data-md-icheck /></td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๒.๒ ลำดับ</td>
                                    <td class="uk-text-center"><input type="radio" name="score2_2" id="score2_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_2" id="score2_2_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_2" id="score2_2_15" value="1.5" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
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
                                    <td class="rowPadLeft">๓.๑ สะกด</td>
                                    <td class="uk-text-center"><input type="radio" name="score3_1" id="score3_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_1" id="score3_1_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_1" id="score3_1_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_1" id="score3_1_15" value="1.5" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๓.๒ การใช้คำ</td>
                                    <td class="uk-text-center"><input type="radio" name="score3_2" id="score3_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_2" id="score3_2_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_2" id="score3_2_15" value="1.5" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_2" id="score3_2_20" value="2" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๓.๓ ประโยค</td>
                                    <td class="uk-text-center"><input type="radio" name="score3_3" id="score3_3_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_3" id="score3_3_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_3" id="score3_3_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๓.๔ วรรคตอน</td>
                                    <td class="uk-text-center"><input type="radio" name="score3_4" id="score3_4_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score3_4" id="score3_4_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                </tr>
                                </tbody>
                            </table>
                            </div>
                        </div>
                      </form>
                    </div>
                    
                </div>
            </div>

        </div>

    <div class="md-fab-wrapper">
        <a class="md-fab md-fab-primary" href="#" id="score_submit">
            <i class="material-icons">&#xE161;</i>
        </a>
    </div>
    
 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <script>
        // submit form
        /*$(function () {
            // Handler for .ready() called.
            //alert('1');
        });
        $(function () {
            $("#score_submit").on('click', function (e) {
                e.preventDefault();
                var form_serialized = JSON.stringify($product_edit_form.serializeObject(), null, 2);
                UIkit.modal.alert('<p>Product data:</p><pre>' + form_serialized + '</pre>');
                alert('2');
            });
        });*/

        $("#score_submit").click(function (e) {
            e.preventDefault();
            var form_serialized = JSON.stringify($("#score_form").serializeObject(), null, 2);
            UIkit.modal.alert('<p>Product data:</p><pre>' + form_serialized + '</pre>');
            //UIkit.modal.alert('<p>Product data:</p><pre>xx</pre>');
            //alert('1');
            //UIkit.modal.alert('Attention!');
        });
    </script>
</asp:Content>
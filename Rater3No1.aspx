<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Rater3No1.aspx.cs" Inherits="Rater3No1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>ระบบบริหารจัดการการตรวจกระดาษคำตอบอัตนัย สถาบันทดสอบทางการศึกษาแห่งชาติ (องค์การมหาชน)- Rater 3</title>
    <style>
        .uk-table th, td {
            border: 1px solid #e0e0e0;
            padding: 4px !important;
        }

        .stripRow {
            background: rgba(0, 0, 0, 0.085);
            font-size: 15px;
        }

        .stripRowNone {
            background: rgba(0, 0, 0, 0.04);
        }

        .rowPadLeft {
            padding-left: 15px !important;
        }

        .imgWidth {
            width: 60%;
        }

        .imgHide {
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

            .itemHide {
                visibility: hidden;
            }
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <% 
        String paperURLName = "";
        String paperURLFolder = "";
        String paperURL = "";
        String stdCode = "";
        String reserve = "";
        decimal totalScoreC1 = 0;
        decimal totalScoreC2 = 0;
        decimal totalScoreC1Cri1 = 0;
        decimal totalScoreC1Cri2 = 0;
        decimal totalScoreC1Cri3 = 0;
        decimal totalScoreC1Cri4 = 0;
        decimal totalScoreC1Cri5 = 0;
        decimal totalScoreC1Cri6 = 0;
        decimal totalScoreC1Cri7 = 0;
        decimal totalScoreC1Cri8 = 0;
        decimal totalScoreC2Cri1 = 0;
        decimal totalScoreC2Cri2 = 0;
        decimal totalScoreC2Cri3 = 0;
        decimal totalScoreC2Cri4 = 0;
        decimal totalScoreC2Cri5 = 0;
        decimal totalScoreC2Cri6 = 0;
        decimal totalScoreC2Cri7 = 0;
        decimal totalScoreC2Cri8 = 0;
        decimal QNO = 1;
    %>

    <div id="page_heading">
        <h1>ระบบบันทึกคะแนนอัตนัย วิชาภาษาไทย ข้อที่ ๑. การเขียนเล่าเรื่องจากภาพ</h1>
        <span class="uk-text-muted uk-text-upper uk-text-small">ชื่อผู้ตรวจ : <% Response.Write(HttpContext.Current.Session["USER_NAME"].ToString()); %></span>
    </div>

    <div id="page_content_inner">
        <div class="uk-grid uk-grid-medium section-to-print" data-uk-grid-margin>
            <%
                string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);
                Boolean chkNodiff = true;
                string stdCodeSelect = Request.QueryString["stdcode"].ToString();//"0161100071044";

                try
                {
                    String query2 = "select cp1.SCR_SUM as Total1,cp1.scr_crit1 as c1cri1,cp1.scr_crit2 as c1cri2,cp1.scr_crit3 as c1cri3,cp1.scr_crit4 as c1cri4,cp1.scr_crit5 as c1cri5,cp1.scr_crit6 as c1cri6,cp1.scr_crit7 as c1cri7,cp1.scr_crit8 as c1cri8, cp2.SCR_SUM as Total2,cp2.scr_crit1 as c2cri1,cp2.scr_crit2 as c2cri2,cp2.scr_crit3 as c2cri3,cp2.scr_crit4 as c2cri4,cp2.scr_crit5 as c2cri5,cp2.scr_crit6 as c2cri6,cp2.scr_crit7 as c2cri7,cp2.scr_crit8 as c2cri8,* from [ONET_SUBJECTIVE].[dbo].[TRN_XM_SCORE_COPY1] cp1 inner join [ONET_SUBJECTIVE].[dbo].[TRN_XM_SCORE_COPY2] cp2 ON cp1.std_code=cp2.std_code AND cp1.QNO = cp2.QNO WHERE cp1.STD_CODE =@stdCode";
                    System.Data.SqlClient.SqlCommand command2 = new System.Data.SqlClient.SqlCommand(query2, conn);
                    conn.Open();
                    command2.Parameters.AddWithValue("@stdCode", stdCodeSelect);
                    System.Data.SqlClient.SqlDataReader reader2 = command2.ExecuteReader();

                    while (reader2.Read())
                    {
                        stdCode = reader2["STD_CODE"].ToString();
                        totalScoreC1 = Convert.ToDecimal(reader2["Total1"].ToString());
                        totalScoreC1Cri1 = Convert.ToDecimal(reader2["c1cri1"].ToString());
                        totalScoreC1Cri2 = Convert.ToDecimal(reader2["c1cri2"].ToString());
                        totalScoreC1Cri3 = Convert.ToDecimal(reader2["c1cri3"].ToString());
                        totalScoreC1Cri4 = Convert.ToDecimal(reader2["c1cri4"].ToString());
                        totalScoreC1Cri5 = Convert.ToDecimal(reader2["c1cri5"].ToString());
                        totalScoreC1Cri6 = Convert.ToDecimal(reader2["c1cri6"].ToString());
                        totalScoreC1Cri7 = Convert.ToDecimal(reader2["c1cri7"].ToString());
                        totalScoreC1Cri8 = Convert.ToDecimal(reader2["c1cri8"].ToString());

                        totalScoreC2 = Convert.ToDecimal(reader2["Total2"].ToString());
                        totalScoreC2Cri1 = Convert.ToDecimal(reader2["c2cri1"].ToString());
                        totalScoreC2Cri2 = Convert.ToDecimal(reader2["c2cri2"].ToString());
                        totalScoreC2Cri3 = Convert.ToDecimal(reader2["c2cri3"].ToString());
                        totalScoreC2Cri4 = Convert.ToDecimal(reader2["c2cri4"].ToString());
                        totalScoreC2Cri5 = Convert.ToDecimal(reader2["c2cri5"].ToString());
                        totalScoreC2Cri6 = Convert.ToDecimal(reader2["c2cri6"].ToString());
                        totalScoreC2Cri7 = Convert.ToDecimal(reader2["c2cri7"].ToString());
                        totalScoreC2Cri8 = Convert.ToDecimal(reader2["c2cri8"].ToString());
                        //StringBuilder sb = new StringBuilder(reader2["PAPER_BARCODE"].ToString());
                        //sb[5] = '3';
                        //paperURLName = sb.ToString();
                        //paperURLFolder = paperURLName.Substring(0, 11);

                        String imgfilename = stdCode.ToString().Substring(0, 5) + "3" + stdCode.ToString().Substring(5, 8);

                        String packagename = stdCode.Substring(0, 5) + "3" + stdCode.ToString().Substring(5, 5);

                       // paperURL = "/fac" + packagename + "\\" + imgfilename + ".jpg";

                        paperURL = "factoryfile/image/" + packagename+ "/" + imgfilename+ ".jpg";
                        //Response.Write(paperURL);

                        //paperURL = @"D:\paperimg\" + paperURLFolder + "\\" + paperURLName + ".jpg";
                        //   Response.Write(totalScoreC1);
                        //   Response.Write(" ");
                        //   Response.Write(totalScoreC2);

                    }

                    reader2.Close();
                }
                catch (Exception ex)
                {
                    Response.Write(ex.Message);

                }
                finally
                {
                    if (conn != null && conn.State == System.Data.ConnectionState.Open)
                    {
                        conn.Close();
                    }
                }

            %>

            <div class="uk-width-xLarge-1-2 uk-width-large-1-2">
                <!-- Left -->
                <div class="md-card">
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">คำตอบ
                        </h3>
                        <div class="md-card-toolbar">
                            <div class="md-card-toolbar-actions hidden-print" onclick="setTimeout(function () {window.print();}, 300)">
                                <i class="md-icon material-icons" id="invoice_print">&#xE8ad;</i>
                            </div>
                        </div>
                    </div>
                    <div class="md-card-content">
                        <div class="uk-margin-bottom uk-text-center">
                            <a href="<% Response.Write(paperURL); %>" data-uk-lightbox="{group:'gallery'}" class="itemHide">
                                <img src="<% Response.Write(paperURL); %>" alt="" class="" />
                            </a>
                            <% if (!chkNodiff) { Response.Write("ไม่มีผลต่างคะแนนกันเกินค่าที่กำหนด"); } %>
                        </div>
                    </div>
                </div>
            </div>

            <div class="uk-width-xLarge-1-2  uk-width-large-1-2">
                <div class="md-card">
                    <!-- Right -->
                    <div class="md-card-toolbar">
                        <h3 class="md-card-toolbar-heading-text">คะแนน
                        </h3>
                    </div>
                    <form action="" class="uk-form-stacked" id="score_form">
                        <div class="md-card-content large-padding">
                            <div class="uk-grid uk-grid-divider uk-grid-medium">
                                <table class="uk-table uk-table-hover uk-table-nowrap">
                                    <thead>
                                        <tr>
                                            <div class="uk-width-xLarge-5-10  uk-width-large-5-10">กรณีเขียนความยาวไม่ตรงตามคำสั่ง :<br />
                                                (ต่ำกว่า 4 บรรทัด)</div>
                                            <div class="uk-width-xLarge-5-10  uk-width-large-5-10">
                                                <input type="radio" name="isRowsMin" id="isRowsMin1" value="1" data-md-icheck />
                                                เขียน 1 ประโยค<br />
                                                <input type="radio" name="isRowsMin" id="isRowsMin2" value="2" data-md-icheck />
                                                เขียนมากกว่า 1 ประโยค
                                    <span style="visibility: hidden;">
                                        <input type="radio" name="isRowsMin" id="isRowsMin0" value="0" checked data-md-icheck />
                                        เขียน 1 ประโยค<br />
                                    </span>
                                            </div>
                                        </tr>
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
                                            <td class="uk-text-center">
                                                <input type="radio" name="score1_1" id="score1_1_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score1_1" id="score1_1_05" value="0.5" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                        </tr>
                                        <tr>
                                            <td class="rowPadLeft">๑.๒ เขียนเรื่อง</td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score1_2" id="score1_2_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score1_2" id="score1_2_05" value="0.5" data-md-icheck /></td>
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
                                            <td class="uk-text-center">
                                                <input type="radio" name="score2_1" id="score2_1_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score2_1" id="score2_1_10" value="1" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score2_1" id="score2_1_20" value="2" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score2_1" id="score2_1_25" value="2.5" data-md-icheck /></td>
                                        </tr>
                                        <tr>
                                            <td class="rowPadLeft">๒.๒ ลำดับ</td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score2_2" id="score2_2_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score2_2" id="score2_2_10" value="1" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score2_2" id="score2_2_15" value="1.5" data-md-icheck /></td>
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
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_1" id="score3_1_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_1" id="score3_1_05" value="0.5" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_1" id="score3_1_10" value="1" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_1" id="score3_1_15" value="1.5" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                        </tr>
                                        <tr>
                                            <td class="rowPadLeft">๓.๒ การใช้คำ</td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_2" id="score3_2_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_2" id="score3_2_10" value="1" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_2" id="score3_2_15" value="1.5" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_2" id="score3_2_20" value="2" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                        </tr>
                                        <tr>
                                            <td class="rowPadLeft">๓.๓ ประโยค</td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_3" id="score3_3_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_3" id="score3_3_05" value="0.5" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_3" id="score3_3_10" value="1" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                        </tr>
                                        <tr>
                                            <td class="rowPadLeft">๓.๔ วรรคตอน</td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_4" id="score3_4_00" value="0" data-md-icheck /></td>
                                            <td class="uk-text-center">
                                                <input type="radio" name="score3_4" id="score3_4_05" value="0.5" data-md-icheck /></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                            <td class="uk-text-center stripRowNone"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <input type="hidden" value="<% Response.Write(stdCode); %>" name="stdCode" id="stdCode" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1); %>" name="totalScoreC1" id="totalScoreC1" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2); %>" name="totalScoreC2" id="totalScoreC2" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri1); %>" name="totalScoreC1Cri1" id="totalScoreC1Cri1" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri2); %>" name="totalScoreC1Cri2" id="totalScoreC1Cri2" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri3); %>" name="totalScoreC1Cri3" id="totalScoreC1Cri3" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri4); %>" name="totalScoreC1Cri4" id="totalScoreC1Cri4" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri5); %>" name="totalScoreC1Cri5" id="totalScoreC1Cri5" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri6); %>" name="totalScoreC1Cri6" id="totalScoreC1Cri6" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri7); %>" name="totalScoreC1Cri7" id="totalScoreC1Cri7" />
                        <input type="hidden" value="<% Response.Write(totalScoreC1Cri8); %>" name="totalScoreC1Cri8" id="totalScoreC1Cri8" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri1); %>" name="totalScoreC2Cri1" id="totalScoreC2Cri1" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri2); %>" name="totalScoreC2Cri2" id="totalScoreC2Cri2" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri3); %>" name="totalScoreC2Cri3" id="totalScoreC2Cri3" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri4); %>" name="totalScoreC2Cri4" id="totalScoreC2Cri4" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri5); %>" name="totalScoreC2Cri5" id="totalScoreC2Cri5" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri6); %>" name="totalScoreC2Cri6" id="totalScoreC2Cri6" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri7); %>" name="totalScoreC2Cri7" id="totalScoreC2Cri7" />
                        <input type="hidden" value="<% Response.Write(totalScoreC2Cri8); %>" name="totalScoreC2Cri8" id="totalScoreC2Cri8" />
                        <input type="hidden" value="<% Response.Write(QNO); %>" name="QNO" id="QNO" />

                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="md-fab-wrapper" <% if (!chkNodiff) { Response.Write("style='visibility:hidden'"); } %>>
        <a class="md-fab md-fab-primary" href="#" id="score_submit">
            <i class="material-icons">&#xE161;</i>
        </a>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <script>
        $("#score_submit").click(function (e) {
            e.preventDefault();
            // if radio hv checked
            var ischeck = 0;
            if ($('input:radio[name=score1_1]').is(':checked')) {
                ischeck++;
            }
            if ($('input:radio[name=score1_2]').is(':checked')) {
                ischeck++;
            }
            if ($('input:radio[name=score2_1]').is(':checked')) {
                ischeck++;
            }
            if ($('input:radio[name=score2_2]').is(':checked')) {
                ischeck++;
            }
            if ($('input:radio[name=score3_1]').is(':checked')) {
                ischeck++;
            }
            if ($('input:radio[name=score3_2]').is(':checked')) {
                ischeck++;
            }
            if ($('input:radio[name=score3_3]').is(':checked')) {
                ischeck++;
            }
            if ($('input:radio[name=score3_4]').is(':checked')) {
                ischeck++;
            }

            //alert(ischeck);
            if (ischeck == 8) {
                var chk4Min = '';
                var scoreValue = $("#score_form").serializeObject();
                var scoreCalNo22;
                var scoreCalNo22Text;
                var scoreCalNo3;
                var scoreCalSumNo3 = Number(scoreValue.score3_1) + Number(scoreValue.score3_2) + Number(scoreValue.score3_3) + Number(scoreValue.score3_4);
                var scoreCalNo31Text;
                var scoreCalNo32Text;
                var scoreCalNo33Text;
                var scoreCalNo34Text;
                var scoreCalSumNo3Text = '';

                //Check Condition
                if (scoreValue.isRowsMin == '0') {
                    chk4MinScore = '0';
                    chk4MinText = '';

                    //2.2
                    scoreCalNo22Text = scoreCalNo22 = Number(scoreValue.score2_2);

                    //3
                    scoreCalNo3 = scoreCalSumNo3;
                    scoreCalNo31Text = Number(scoreValue.score3_1);
                    scoreCalNo32Text = Number(scoreValue.score3_2);
                    scoreCalNo33Text = Number(scoreValue.score3_3);
                    scoreCalNo34Text = Number(scoreValue.score3_4);
                }
                else if (scoreValue.isRowsMin == '1') {
                    chk4MinScore = '1';
                    chk4Min = '<span style="font-size:14px;">เขียน 1 ประโยค (ต่ำกว่า 4 บรรทัด)</span>';

                    //2.2
                    if (Number(scoreValue.score2_2) > 0) {
                        scoreCalNo22 = 0;
                        scoreCalNo22Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score2_2) + '</span> <span style= "color: red;">' + scoreCalNo22 + '</span>';
                    } else {
                        scoreCalNo22Text = scoreCalNo22 = 0;
                    }

                    //3
                    if (scoreCalSumNo3 > 2.5) {
                        scoreCalNo3 = 2.5;
                        scoreCalNo31Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_1) + '</span>';
                        scoreCalNo32Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_2) + '</span>';
                        scoreCalNo33Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_3) + '</span>';
                        scoreCalNo34Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_4) + '</span> <span style= "color: red;">' + scoreCalNo3 + '</span>';
                    } else {
                        scoreCalNo3 = scoreCalSumNo3;
                        scoreCalNo31Text = Number(scoreValue.score3_1);
                        scoreCalNo32Text = Number(scoreValue.score3_2);
                        scoreCalNo33Text = Number(scoreValue.score3_3);
                        scoreCalNo34Text = Number(scoreValue.score3_4);
                    }
                }
                else if (scoreValue.isRowsMin == '2') {
                    chk4MinScore = '2';
                    chk4Min = '<span style="font-size:14px;">เขียนมากกว่า 1 ประโยค (ต่ำกว่า 4 บรรทัด)</span>';

                    //2.2
                    if (Number(scoreValue.score2_2) > 1) {
                        scoreCalNo22 = 1;
                        scoreCalNo22Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score2_2) + '</span> <span style= "color: red;">' + scoreCalNo22 + '</span>';
                    } else {
                        scoreCalNo22Text = scoreCalNo22 = Number(scoreValue.score2_2);
                    }

                    //3
                    if (scoreCalSumNo3 > 2.5) {
                        scoreCalNo3 = 2.5;
                        scoreCalNo31Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_1) + '</span>';
                        scoreCalNo32Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_2) + '</span>';
                        scoreCalNo33Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_3) + '</span>';
                        scoreCalNo34Text = '<span style= "text-decoration: line-through;">' + Number(scoreValue.score3_4) + '</span> <span style= "color: red;">' + scoreCalNo3 + '</span>';
                    } else {
                        scoreCalNo3 = scoreCalSumNo3;
                        scoreCalNo31Text = Number(scoreValue.score3_1);
                        scoreCalNo32Text = Number(scoreValue.score3_2);
                        scoreCalNo33Text = Number(scoreValue.score3_3);
                        scoreCalNo34Text = Number(scoreValue.score3_4);
                    }
                }

                var sumScore = Number(scoreValue.score1_1) + Number(scoreValue.score1_2) + Number(scoreValue.score2_1) + scoreCalNo22 + scoreCalNo3;

                //alert(scoreValue.totalScoreC1);
                //alert(scoreValue.totalScoreC2);
                var compare1 = Math.abs(scoreValue.totalScoreC1 - sumScore);
                var compare2 = Math.abs(scoreValue.totalScoreC2 - sumScore);

                if (compare1 < compare2) {
                    alert('is C1  = ' + compare1);
                    if (compare1 <= 1.5) {
                        //C1+R3 /2
                        //alert('C1 < 1.5 Do it');
                        //alert('C1= ' + scoreValue.totalScoreC1);
                        //alert('sumScore= ' + sumScore);
                        scoreValue.useScoreSum = (sumScore + Number(scoreValue.totalScoreC1)) / 2;
                        scoreValue.useScore1_1 = (Number(scoreValue.score1_1) + Number(scoreValue.totalScoreC1Cri1)) / 2;
                        scoreValue.useScore1_2 = (Number(scoreValue.score1_2) + Number(scoreValue.totalScoreC1Cri2)) / 2;
                        scoreValue.useScore1_3 = (Number(scoreValue.score2_1) + Number(scoreValue.totalScoreC1Cri3)) / 2;
                        scoreValue.useScore1_4 = (Number(scoreValue.score2_2) + Number(scoreValue.totalScoreC1Cri4)) / 2;
                        scoreValue.useScore1_5 = (Number(scoreValue.score3_1) + Number(scoreValue.totalScoreC1Cri5)) / 2;
                        scoreValue.useScore1_6 = (Number(scoreValue.score3_2) + Number(scoreValue.totalScoreC1Cri6)) / 2;
                        scoreValue.useScore1_7 = (Number(scoreValue.score3_3) + Number(scoreValue.totalScoreC1Cri7)) / 2;
                        scoreValue.useScore1_8 = (Number(scoreValue.score3_4) + Number(scoreValue.totalScoreC1Cri8)) / 2;

                        //alert(scoreValue.useScore1_1);
                    } else {
                        alert('คะแนนนี้ยังไม่ผ่านเงื่อนไข ระบบจะไม่บันทึกคะแนน ไปหน้าต้น : C1');
                    }
                } else if (compare2 < compare1) {
                    alert('is C2  = ' + compare2);
                    if (compare2 <= 1.5) {
                        //C2+R3 /2
                        //alert('C2 < 1.5 Do it');
                        scoreValue.useScoreSum = (sumScore + Number(scoreValue.totalScoreC2)) / 2;
                        scoreValue.useScore1_1 = (Number(scoreValue.score1_1) + Number(scoreValue.totalScoreC2Cri1)) / 2;
                        scoreValue.useScore1_2 = (Number(scoreValue.score1_2) + Number(scoreValue.totalScoreC2Cri2)) / 2;
                        scoreValue.useScore1_3 = (Number(scoreValue.score2_1) + Number(scoreValue.totalScoreC2Cri3)) / 2;
                        scoreValue.useScore1_4 = (Number(scoreValue.score2_2) + Number(scoreValue.totalScoreC2Cri4)) / 2;
                        scoreValue.useScore1_5 = (Number(scoreValue.score3_1) + Number(scoreValue.totalScoreC2Cri5)) / 2;
                        scoreValue.useScore1_6 = (Number(scoreValue.score3_2) + Number(scoreValue.totalScoreC2Cri6)) / 2;
                        scoreValue.useScore1_7 = (Number(scoreValue.score3_3) + Number(scoreValue.totalScoreC2Cri7)) / 2;
                        scoreValue.useScore1_8 = (Number(scoreValue.score3_4) + Number(scoreValue.totalScoreC2Cri8)) / 2;
                    } else {
                        alert('คะแนนนี้ยังไม่ผ่านเงื่อนไข ระบบจะไม่บันทึกคะแนน ไปหน้าต้น : C2');
                    }
                } else if (compare2 == compare1) {
                    alert('C1 = C2');

                    if (compare1 <= 1.5) {
                        //C1+C2+R3 /3
                        //alert('C1,C2 < 1.5 Do it');
                        scoreValue.useScoreSum = (sumScore + Number(scoreValue.totalScoreC1) + Number(scoreValue.totalScoreC2)) / 3;
                        scoreValue.useScore1_1 = (Number(scoreValue.score1_1) + Number(scoreValue.totalScoreC1Cri1) + Number(scoreValue.totalScoreC2Cri1)) / 3;
                        scoreValue.useScore1_2 = (Number(scoreValue.score1_2) + Number(scoreValue.totalScoreC1Cri2) + Number(scoreValue.totalScoreC2Cri2)) / 3;
                        scoreValue.useScore1_3 = (Number(scoreValue.score2_1) + Number(scoreValue.totalScoreC1Cri3) + Number(scoreValue.totalScoreC2Cri3)) / 3;
                        scoreValue.useScore1_4 = (Number(scoreValue.score2_2) + Number(scoreValue.totalScoreC1Cri4) + Number(scoreValue.totalScoreC2Cri4)) / 3;
                        scoreValue.useScore1_5 = (Number(scoreValue.score3_1) + Number(scoreValue.totalScoreC1Cri5) + Number(scoreValue.totalScoreC2Cri5)) / 3;
                        scoreValue.useScore1_6 = (Number(scoreValue.score3_2) + Number(scoreValue.totalScoreC1Cri6) + Number(scoreValue.totalScoreC2Cri6)) / 3;
                        scoreValue.useScore1_7 = (Number(scoreValue.score3_3) + Number(scoreValue.totalScoreC1Cri7) + Number(scoreValue.totalScoreC2Cri7)) / 3;
                        scoreValue.useScore1_8 = (Number(scoreValue.score3_4) + Number(scoreValue.totalScoreC1Cri8) + Number(scoreValue.totalScoreC2Cri8)) / 3;
                    } else {
                        //alert('C1,C2 > 1.5 Error!');
                        alert('คะแนนนี้ยังไม่ผ่านเงื่อนไข ระบบจะไม่บันทึกคะแนน ไปหน้าต้น : C1=C2');
                    }
                }

                scoreValue.sumScore = sumScore;
                console.log(scoreValue);

                UIkit.modal.confirm('<div><p>ยืนยันการให้คะแนน : <br>' + chk4Min + '</p><pre><table style="border:0px; font-size:18px;" align="center">' +
                    '<tr><td>๑.๑ ความยาว </td><td>' + scoreValue.score1_1 +
                    '</td><tr><td>๑.๒ เขียนเรื่อง </td><td>' + scoreValue.score1_2 +
                    '</td><tr><td>๒.๑ แนวคิด </td><td>' + scoreValue.score2_1 +
                    '</td><tr><td>๒.๒ ลำดับ </td><td>' + scoreCalNo22Text +
                    '</td><tr><td>๓.๑ สะกด </td><td>' + scoreCalNo31Text +
                    '</td><tr><td>๓.๒ การใช้คำ </td><td>' + scoreCalNo32Text +
                    '</td><tr><td>๓.๓ ประโยค </td><td>' + scoreCalNo33Text +
                    '</td><tr><td>๓.๔ วรรคตอน </td><td>' + scoreCalNo34Text +
                    '</td><tr><td><strong>คะแนนรวม :<strong></td><td><strong>' + sumScore +
                    '</strong></td></tr></table></pre></div>',
                    function () {
                        $.ajax({
                            type: "POST",
                            url: "rater31data.aspx/recieve",
                            data: "{'recieveValue':'" + JSON.stringify(scoreValue) + "'}",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: true,
                            success: function (msg) {
                                var msgReturn = $.parseJSON(msg.d);
                                console.log(msgReturn);
                                UIkit.modal.confirm('<p> บันทึกคะแนนเรียบร้อย ต้องการตรวจต่อหรือไม่?</p>',
                                function () { location.reload(); }
                                );

                            }
                        });
                    }
                    );
            } else {
                UIkit.modal.alert('<p> กรุณาให้คะแนนให้ครบ ทุกเกณฑ์การตรวจ !!</p>');

            }
        });
    </script>
</asp:Content>

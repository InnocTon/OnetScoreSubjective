﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Rater3No2.aspx.cs" Inherits="Rater3No1" %>

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
            <% 
                String paperURLName = "";
                String paperURLFolder = "";
                String paperURL = "";
                String stdCode = "";
                String reserve = "";
            %>
    
        <div id="page_heading">
            <h1>ระบบบันทึกคะแนนอัตนัย วิชาภาษาไทย ข้อที่ ๒. การเขียนสรุปใจความสำคัญของบทอ่าน</h1>
            <span class="uk-text-muted uk-text-upper uk-text-small">ชื่อผู้ตรวจ : <% Response.Write(HttpContext.Current.Session["USER_NAME"].ToString()); %></span>
        </div>

        <div id="page_content_inner">
            <div class="uk-grid uk-grid-medium section-to-print" data-uk-grid-margin>
                <%
                    string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
                    System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);

                    try
                    {
                        String query = "SELECT TOP 1 * FROM [dbo].[TRN_XM_SCORE_COPY1] WHERE IS_DIFF='1' AND IS_COMPLETE='0'  AND QNO='2' AND RESERVE=@reserveID ORDER BY SCR_SEQ";

                        System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                        conn.Open();
                        command.Parameters.AddWithValue("@reserveID", HttpContext.Current.Session["USER_ID"].ToString() );
                        System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                        if (reader.HasRows)
                        {
                            //Response.Write("HasRows");
                        }else
                        {
                            reader.Close();
                            try
                            {
                                String query2 = "SELECT TOP 1 * FROM [dbo].[TRN_XM_SCORE_COPY1] WHERE IS_DIFF='1' AND IS_COMPLETE='0' AND QNO='2' AND RESERVE IS NULL ORDER BY SCR_SEQ";
                                System.Data.SqlClient.SqlCommand command2 = new System.Data.SqlClient.SqlCommand(query2, conn);
                                System.Data.SqlClient.SqlDataReader reader2 = command2.ExecuteReader();

                                while (reader2.Read())
                                {
                                    stdCode = reader2["STD_CODE"].ToString();
                                    reserve = reader2["RESERVE"].ToString();
                                    StringBuilder sb = new StringBuilder(reader2["PAPER_BARCODE"].ToString());
                                    sb[5] = '3';
                                    paperURLName = sb.ToString();
                                    paperURLFolder = paperURLName.Substring(0, 11);
                                    paperURL = "factoryfile/image/" + paperURLFolder+ "/" + paperURLName+ ".jpg";

                                }
                            }
                            catch(Exception ex)
                            {
                                Response.Write(ex.Message);
                            }
                            finally
                            {

                            }
                        }

                        while (reader.Read())
                        {
                            stdCode = reader["STD_CODE"].ToString();
                            reserve = reader["RESERVE"].ToString();
                            StringBuilder sb = new StringBuilder(reader["PAPER_BARCODE"].ToString());
                            sb[5] = '3';
                            paperURLName = sb.ToString();
                            paperURLFolder = paperURLName.Substring(0, 11);
                            paperURL = "factoryfile/image/" + paperURLFolder+ "/" + paperURLName+ ".jpg";
                            Response.Write("<br>");

                        }
                        reader.Close();
                        conn.Close();
                    }
                    catch (Exception ex)
                    {

                    }
                    finally
                    {
                        if (conn != null && conn.State == System.Data.ConnectionState.Open)
                        {
                            conn.Close();
                        }
                    }

                    //Update Reserve
                    try
                    {

                        String query = "UPDATE TRN_XM_SCORE_COPY1 SET RESERVE = @reserveby,RESERVE_DATETIME = getdate() WHERE STD_CODE = @stdCode;";

                        System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                        conn.Open();
                        command.Parameters.AddWithValue("@stdCode", stdCode );
                        command.Parameters.AddWithValue("@reserveby", HttpContext.Current.Session["USER_ID"].ToString());

                        int result = command.ExecuteNonQuery();
                        if (result == 1)
                        {
                            //Response.Write("Success");
                        }
                        else
                        {
                            ///Response.Write(" ไม่มีผลคะแนนต่างเกิน 15%");
                        }

                        conn.Close();
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

                <div class="uk-width-xLarge-2-5 uk-width-large-2-5"><!-- Left -->
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
                                <a href="<% Response.Write(paperURL); %>" data-uk-lightbox="{group:'gallery'}" class="itemHide">
                                    <img src="<% Response.Write(paperURL); %>" alt="" class=""/>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="uk-width-xLarge-3-5  uk-width-large-3-5">
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
                                <th class="uk-width-8-10 uk-text-center" colspan="9">ช่วงคะแนน</th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr class="stripRow">
                                    <td>๑. เนื้อหา (๘ คะแนน)</td>
                                    <td class="uk-text-center">๐</td>
                                    <td class="uk-text-center">๐.๕</td>
                                    <td class="uk-text-center">๑.๐</td>
                                    <td class="uk-text-center">๑.๕</td>
                                    <td class="uk-text-center">๒.๐</td>
                                    <td class="uk-text-center">๓.๐</td>
                                    <td class="uk-text-center">๔.๐</td>
                                    <td class="uk-text-center">๕.๐</td>
                                    <td class="uk-text-center">๖.๐</td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๑.๑ ประเด็น</td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_20" value="2" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_30" value="3" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_40" value="4" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_50" value="5" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_1" id="score1_1_60" value="6" data-md-icheck /></td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๑.๒ กลวิธีสรุปความ</td>
                                    <td class="uk-text-center"><input type="radio" name="score1_2" id="score1_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_2" id="score1_2_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score1_2" id="score1_2_20" value="2" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                </tr>
                                <tr class="stripRow">
                                    <td>๒. ภาษา (๒ คะแนน)</td>
                                    <td class="uk-text-center">๐</td>
                                    <td class="uk-text-center">๐.๕</td>
                                    <td class="uk-text-center">๑.๐</td>
                                    <td class="uk-text-center">๑.๕</td>
                                    <td class="uk-text-center">๒.๐</td>
                                    <td class="uk-text-center">๓.๐</td>
                                    <td class="uk-text-center">๔.๐</td>
                                    <td class="uk-text-center">๕.๐</td>
                                    <td class="uk-text-center">๖.๐</td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๒.๑ การันต์และเครื่องหมาย</td>
                                    <td class="uk-text-center"><input type="radio" name="score2_1" id="score2_1_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_1" id="score2_1_05" value="0.5" data-md-icheck /></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_1" id="score2_1_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                </tr>
                                <tr>
                                    <td class="rowPadLeft">๒.๒ ประโยค</td>
                                    <td class="uk-text-center"><input type="radio" name="score2_2" id="score2_2_00" value="0" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center"><input type="radio" name="score2_2" id="score2_2_10" value="1" data-md-icheck /></td>
                                    <td class="uk-text-center stripRowNone"></td>
                                    <td class="uk-text-center stripRowNone"></td>
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

            //alert(ischeck);
            if (ischeck == 4) {
                var scoreValue = $("#score_form").serializeObject();
                var sumScore = Number(scoreValue.score1_1) + Number(scoreValue.score1_2) + Number(scoreValue.score2_1) + Number(scoreValue.score2_2);
                UIkit.modal.confirm('<div><p>ยืนยันการให้คะแนน :</p><pre><table style="border:0px;" align="center">' +
                    '<tr><td>๑.๑ ประเด็น :</td><td>' + scoreValue.score1_1 +
                    '</td><tr><td>๑.๒ กลวิธีสรุปความ :</td><td>' + scoreValue.score1_2 +
                    '</td><tr><td>๒.๑ การันต์และเครื่องหมาย :</td><td>' + scoreValue.score2_1 +
                    '</td><tr><td>๒.๒ ประโยค :</td><td>' + scoreValue.score2_2 +
                    '</td><tr><td><strong>คะแนนรวม :<strong></td><td><strong>' + sumScore +
                    '</strong></td></tr></table></pre></div>',
                    function () {
                        $.ajax({
                            type: "POST",
                            url: "rater31data.aspx/recieve2",
                            data: "{'recieveValue':'" + JSON.stringify(scoreValue) + "'}",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: true,
                            success: function (msg) {
                                var msgReturn =$.parseJSON(msg.d);
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
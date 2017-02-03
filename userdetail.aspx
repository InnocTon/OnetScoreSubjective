<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="userdetail.aspx.cs" Inherits="userdetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%
        String USER_NAME = "";
        String USER_ID = "";
        String USER_TYPE = "";
        String USER_PASS = "";
        String USER_PLACE = "";
        String USER_MOBILE = "";
        String USER_EMAIL = "";

        String REATER_IMG = "";

        string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
        System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connStr);

        if (Request.QueryString["seq"] != null)
        {
            USER_ID = Request.QueryString["seq"].ToString();



            try
            {

                string query = "SELECT * FROM SYS_USER WHERE USer_ID = @userid";
                System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                conn.Open();
                command.Parameters.AddWithValue("@userid", USER_ID);
                System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    USER_NAME = reader["USER_NAME"].ToString();
                    USER_TYPE = reader["USER_TYPE"].ToString();
                    USER_PASS = reader["USER_PASS"].ToString();
                    USER_PLACE = reader["USER_PLACE"].ToString();
                    USER_MOBILE = reader["USER_MOBILE"].ToString();
                    USER_EMAIL = reader["USER_EMAIL"].ToString();
                }

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
        }




    %>

    <div id="page_content">
        <div id="page_content_inner">
            <div class="uk-grid" data-uk-grid-margin data-uk-grid-match id="user_profile">
                <div class="uk-width-large-8-10">
                    <div class="md-card">
                        <div class="user_heading">
                            <div class="user_heading_menu" data-uk-dropdown="{pos:'left-top'}">
                                <i class="md-icon material-icons md-icon-light">&#xE5D4;</i>
                                <div class="uk-dropdown uk-dropdown-small">
                                    <ul class="uk-nav">
                                        <li><a href="#" onclick="">ลบข้อมูล</a></li>
                                        <li><a href="#">แก้ไขข้อมูล</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="user_heading_avatar">
                                <%
                                    if (System.IO.File.Exists(Server.MapPath("~/raterimages/" + USER_ID + ".png")))
                                    {
                                        REATER_IMG = "raterimages/" + USER_ID + ".png";
                                    }
                                    else
                                    {
                                        REATER_IMG = "raterimages/avatar_01.png";
                                    }
                                %>
                                <img src="<% Response.Write(REATER_IMG); %>" alt="รูปผู้ใช้งาน" />
                            </div>
                            <div class="user_heading_content">
                                <h2 class="heading_b uk-margin-bottom">
                                    <span class="uk-text-truncate"><% Response.Write(USER_NAME);  %></span>
                                    <span class="sub-heading">
                                        <% Response.Write(USER_ID); %>
                                        <input id="usercode" type="hidden" value="<% Response.Write(USER_ID); %>" />
                                    </span></h2>
                                <!--  <ul class="user_stats">
                                    <li>
                                        <h4 class="heading_a">2391 <span class="sub-heading">จำนวนตรวจ</span></h4>
                                    </li>
                                    <li>
                                        <h4 class="heading_a">120 <span class="sub-heading">จำนวนที่ต่าง</span></h4>
                                    </li>
                                </ul> -->
                            </div>
                            <a class="md-fab md-fab-small md-fab-accent" href="agentnametag.aspx?rater_seq=<%=Request.QueryString["seq"].ToString() %>" title="พิมพ์บัตรประจำตัว">
                                <i class="material-icons">&#xE8A3;</i>
                            </a>
                        </div>
                        <div class="user_content">
                            <ul id="user_profile_tabs" class="uk-tab" data-uk-tab="{connect:'#user_profile_tabs_content', animation:'slide-horizontal'}" data-uk-sticky="{ top: 48, media: 960 }">
                                <li class="uk-active"><a href="#">ประวัติบุคคล</a></li>
                                <li><a href="#">ประวัติการใช้งาน</a></li>
                            </ul>
                            <ul id="user_profile_tabs_content" class="uk-switcher uk-margin">
                                <li>
                                    <div class="uk-grid uk-margin-medium-top uk-margin-large-bottom" data-uk-grid-margin>
                                        <div class="uk-width-large-1-2">
                                            <h4 class="heading_c uk-margin-small-bottom">ข้อมูลส่วนบุคคล</h4>
                                            <ul class="md-list md-list-addon">
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE0DA;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(USER_PASS); %></span>
                                                        <span class="uk-text-small uk-text-muted">รหัสผ่าน</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE8A6;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% 
                                                                                          String typename = "";
                                                                                          switch (USER_TYPE)
                                                                                          {
                                                                                              case "admin": typename = "ผู้ดูแลระบบ"; break;
                                                                                              case "user": typename = "เจ้าหน้าที่"; break;
                                                                                              case "rater3": typename = "ผู้ตรวจคนที่ 3"; break;
                                                                                          }
                                                                                          Response.Write(typename);
                                                        %></span>
                                                        <span class="uk-text-small uk-text-muted">ประเภทผู้ใช้งาน</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE88A;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(USER_PLACE); %></span>
                                                        <span class="uk-text-small uk-text-muted">สถานที่ปฏิบัติงาน</span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="uk-width-large-1-2">
                                            <h4 class="heading_c uk-margin-small-bottom">ข้อมูลติดต่อ</h4>
                                            <ul class="md-list  md-list-addon">
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE158;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(USER_EMAIL); %></span>
                                                        <span class="uk-text-small uk-text-muted">อีเมล์</span>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="md-list-addon-element">
                                                        <i class="md-list-addon-icon material-icons">&#xE325;</i>
                                                    </div>
                                                    <div class="md-list-content">
                                                        <span class="md-list-heading"><% Response.Write(USER_MOBILE); %></span>
                                                        <span class="uk-text-small uk-text-muted">มือถือ</span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <ul class="md-list">
                                        <!-- ประวัติการเข้าใช้งาน -->
                                        <h4 class="heading_c uk-margin-bottom">แสดง 10 รายการล่าสุด </h4>
                                        <div class="timeline">
                                            <%
                                                String timeline_icon_color = "";
                                                String timeline_icon = "";


                                                try
                                                {
                                                    String query = "SELECT TOP 10 * FROM [dbo].[SYS_LOG] WHERE LOG_CODE = @logcode ORDER BY LOG_DATE DESC ";
                                                    System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, conn);
                                                    conn.Open();
                                                    command.Parameters.AddWithValue("@logcode", USER_ID);
                                                    System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
                                                    while (reader.Read())
                                                    {
                                                        DateTime dt = Convert.ToDateTime(reader["LOG_DATE"].ToString());
                                                        String LOG_NAME = reader["LOG_NAME"].ToString();
                                                        String LOG_DESC = reader["LOG_DESC"].ToString();
                                                        String LOG_TYPE = reader["LOG_TYPE"].ToString();
                                                        switch (LOG_TYPE)
                                                        {
                                                            case "LOGIN":
                                                                timeline_icon_color = "timeline_icon_success";
                                                                timeline_icon = "&#xE0DA;";
                                                                break;
                                                            case "LOGOUT":
                                                                timeline_icon_color = "timeline_icon_warning";
                                                                timeline_icon = "&#xE0DA;";
                                                                break;
                                                            case "IMPORTBOX":
                                                                timeline_icon_color = "timeline_icon_success";
                                                                timeline_icon = "&#xE2BF;";
                                                                break;
                                                            case "DELETEBOX":
                                                                timeline_icon_color = "timeline_icon_warning";
                                                                timeline_icon = "&#xE2C1;";
                                                                break;
                                                            case "IMPORTPACKAGE":
                                                                timeline_icon_color = "timeline_icon_success";
                                                                timeline_icon = "&#xE2BF;";
                                                                break;
                                                            case "DELETEPACKAGE":
                                                                timeline_icon_color = "timeline_icon_warning";
                                                                timeline_icon = "&#xE2C1;";
                                                                break;
                                                            case "IMPORTPAPER":
                                                                timeline_icon_color = "timeline_icon_success";
                                                                timeline_icon = "&#xE2BF;";
                                                                break;
                                                            case "DELETEPAPER":
                                                                timeline_icon_color = "timeline_icon_warning";
                                                                timeline_icon = "&#xE2C1;";
                                                                break;
                                                            default:
                                                                timeline_icon_color = "timeline_icon_warning";
                                                                timeline_icon = "&#xE14C;";
                                                                break;
                                                        }
                                                 %>
                                            <div class="timeline_item">

                                                <div class="timeline_icon <%=timeline_icon_color %> "><i class="material-icons"><%=timeline_icon %></i></div>
                                                <div class="timeline_date">
                                                    <%=dt.ToString("dd MMM yyyy", System.Globalization.CultureInfo.CreateSpecificCulture("th")) %> <span>
                                                        <%=dt.ToString("HH:mm tt", System.Globalization.CultureInfo.CreateSpecificCulture("th")) %> 
                                                    </span>
                                                </div>
                                                <div class="timeline_content"><a href="#"><strong><%=LOG_NAME %></strong></a> <%=LOG_DESC %></div>
                                            </div>
                                            <%
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
                                             %>
                                        </div>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
</asp:Content>


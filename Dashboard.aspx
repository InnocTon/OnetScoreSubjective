<%@ Page Title="" Language="C#" MasterPageFile="~/MainMasterPage.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>ระบบบริหารจัดการการตรวจกระดาษคำตอบอัตนัย สถาบันทดสอบทางการศึกษาแห่งชาติ (องค์การมหาชน)- หน้าหลัก</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="page_content_inner">
     <!-- statistics (small charts) -->
        <div class="uk-grid uk-grid-width-large-1-1 uk-grid-medium uk-sortable sortable-handler hierarchical_show" data-uk-grid-margin>
            <div class="uk-width-large-1-1">
                        <div class="md-card">
                            <div class="md-card-content">
                                
                            </div>
                        </div>
                    </div>
            </div>
        </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

<!-- page specific plugins -->
        <!-- d3 -->
        <script src="bower_components/d3/d3.min.js"></script>
        <!-- metrics graphics (charts) -->
        <script src="bower_components/metrics-graphics/dist/metricsgraphics.min.js"></script>
        <!-- chartist (charts) -->
        <script src="bower_components/chartist/dist/chartist.min.js"></script>
        <!-- peity (small charts) -->
        <script src="bower_components/peity/jquery.peity.min.js"></script>
        <!-- easy-pie-chart (circular statistics) -->
        <script src="bower_components/jquery.easy-pie-chart/dist/jquery.easypiechart.min.js"></script>
        <!-- countUp -->
        <script src="bower_components/countUp.js/countUp.min.js"></script>
        <!-- handlebars.js -->
        <script src="bower_components/handlebars/handlebars.min.js"></script>
        <script src="assets/js/custom/handlebars_helpers.min.js"></script>
        <!-- CLNDR -->
        <script src="bower_components/clndr/src/clndr.js"></script>
        <!-- fitvids -->
        <script src="bower_components/fitvids/jquery.fitvids.js"></script>

        <!--  dashbord functions -->
        <script src="assets/js/pages/dashboard.js"></script>


</asp:Content>




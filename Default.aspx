<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!doctype html>
<!--[if lte IE 9]> <html class="lte-ie9" lang="en"> <![endif]-->
<!--[if gt IE 9]><!--> <html lang="en"> <!--<![endif]-->
<head  runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="initial-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Remove Tap Highlight on Windows Phone IE -->
    <meta name="msapplication-tap-highlight" content="no"/>

    <link rel="icon" type="image/png" href="assets/img/favicon-16x16.png" sizes="16x16">
    <link rel="icon" type="image/png" href="assets/img/favicon-32x32.png" sizes="32x32">

    <title>ระบบบริหารจัดการการตรวจกระดาษคำตอบอัตนัย สถาบันทดสอบทางการศึกษาแห่งชาติ (องค์การมหาชน)- เข้าสู่ระบบ</title>

    <link href='http://fonts.googleapis.com/css?family=Roboto:300,400,500' rel='stylesheet' type='text/css'>

    <!-- uikit -->
    <link rel="stylesheet" href="bower_components/uikit/css/uikit.almost-flat.min.css"/>

    <!-- altair admin login page -->
    <link rel="stylesheet" href="assets/css/login_page.min.css" />

    <!-- Sweet Alert -->
    <link href="bower_components/sweetalert/sweetalert.css" rel="stylesheet" />
    <script src="bower_components/sweetalert/sweetalert.min.js"></script>


</head>

<body  class="login_page">
     <div class="login_page_wrapper">
        <div class="md-card" id="login_card">
            <div class="md-card-content large-padding" id="login_form">
                <div class="login_heading">
                    <div class="user_avatar"></div>
                </div>
                <form id="form1" runat="server">
                    <div class="uk-form-row">
                        <label for="login_username">Username</label>
                        <asp:TextBox ID="login_username" runat="server" class="md-input" name="login_username"></asp:TextBox>
                    </div>
                    <div class="uk-form-row">
                        <label for="login_password">Password</label>
                        <asp:TextBox ID="login_password" runat="server" TextMode="Password" name="login_username" class="md-input"></asp:TextBox>
                    </div>
                    <div class="uk-margin-medium-top">
                        <asp:Button ID="signbtn" runat="server" Text="เข้าสู่ระบบ" class="md-btn md-btn-primary md-btn-block md-btn-large" OnClick="signbtn_Click"/>
                    </div>
                </form>
            </div>
        </div>
        <div class="uk-margin-top uk-text-center">
           
        </div>
    </div>

    <!-- common functions -->
    <script src="assets/js/common.js"></script>
    <!-- altair core functions -->
    <script src="assets/js/altair_admin_common.js"></script>

    <!-- altair login page functions -->
    <script src="assets/js/pages/login.js"></script>

    
</body>
</html>

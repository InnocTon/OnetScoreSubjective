using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class managepackage : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void adddatabtn_Click(object sender, EventArgs e)
    {
        String packagecode = packagecodetxt.Value.ToString();
        String ratercode = ratercodetxt.Value.ToString();
        String actionstatus = boxaction.Value.ToString();


        // CHECK PACKAGE CODE in DB
        Boolean StatusPackage = CheckPackageStatus(packagecode, actionstatus);
        Boolean StatusRater = false;


        if (actionstatus == "rater" || actionstatus == "return")
        {
            StatusRater = CheckRaterStatus(ratercode);
        }
        else if(actionstatus == "omr" || actionstatus == "modify" || actionstatus == "final")
        {
            StatusRater = CheckUserStatus(ratercode);
        }

        

        if (StatusPackage && StatusRater)
        {
            SqlConnection conn = new SqlConnection(connStr);
            SqlTransaction trans = null;

            try
            {
                String package_status = "N";

                switch (actionstatus)
                {
                    case "rater": package_status = "R"; break; //ส่งให้ rater ตรวจ
                    case "return": package_status = "S"; break; // rater ส่งคืน
                    case "omr": package_status = "O"; break; // ส่งเข้าห้องอ่าน OMR
                    case "modify": package_status = "N"; break; // ส่งแก้ไขข้อมูล
                    case "final": package_status = "F"; break; // ดำเนินการเสร็จเรียบร้อย
                }

                conn.Open();
                trans = conn.BeginTransaction();

                String query = "UPDATE TRN_XM_PACKAGE SET PACKAGE_STATUS = @packagetatus,UPDATE_BY = @updateby,UPDATE_DATETIME = getdate() WHERE [PACKAGE_CODE] = @packagecode;";
                SqlCommand command = new SqlCommand(query, conn);
                command.Parameters.AddWithValue("@packagecode", packagecode);
                command.Parameters.AddWithValue("@packagetatus", package_status);
                command.Parameters.AddWithValue("@updateby", Session["USER_ID"].ToString());
                command.Transaction = trans;
                int result = command.ExecuteNonQuery();
                if (result == 1)
                {
                    query = "INSERT INTO [TRN_XM_PACKAGE_ACTION] ([PACKAGE_CODE],[OWNER_BY],[OWNER_DATETIME],[ACT_STATUS],[CREATE_BY],[CREATE_DATETIME])  VALUES(@packagecode,@ownerby,getdate(),@actstatus,@createby,getdate());";
                    command = new SqlCommand(query, conn);
                    command.Parameters.AddWithValue("@packagecode", packagecode);
                    command.Parameters.AddWithValue("@ownerby", ratercode);
                    command.Parameters.AddWithValue("@actstatus", actionstatus);
                    command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                    command.Transaction = trans;
                    result = command.ExecuteNonQuery();

                    if (result == 1)
                    {
                        trans.Commit();
                        showMessage("สำเร็จ", "บันทึกข้อมูลการรับ-ส่งซองเรียบร้อยแล้ว", "success");
                        packagecodetxt.Value = "";
                        ratercodetxt.Value = "";
                        boxaction.Value = "";
                    }
                    else
                    {
                        trans.Rollback();
                        showMessage("ผิดพลาด", "ไม่สามารถบันทึกข้อมูลการรับ-ส่งซองได้", "error");
                    }

                 


                }
                else
                {
                    trans.Rollback();
                    showMessage("ผิดพลาด", "ไม่สามารถบันทึกข้อมูลการรับ-ส่งซองได้", "error");
                }

                conn.Close();


            }
            catch (Exception ex)
            {
                trans.Rollback();
                showMessage("ข้อผิดพลาด!", ex.Message, "error");

            }
            finally
            {
                if (conn != null && conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }


        }

    }


    private Boolean CheckUserStatus(String usercode)
    {
        Boolean StatusUser = true;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM SYS_USER WHERE USER_ID = @usercode AND USER_STATUS = 'N'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@usercode", usercode);
            SqlDataReader reader = command.ExecuteReader();
            String username = "";
            while (reader.Read())
            {
                username = reader["USER_NAME"].ToString();
            }

            if (username == "")
            {
                showMessage("คำเตือน!", "ไม่พบรายชื่อเจ้าหน้าที่ในฐานข้อมูล", "warning");
                StatusUser = false;
            }

            reader.Close();
            conn.Close();
        }
        catch (Exception ex)
        {
            showMessage("ข้อผิดพลาด!", ex.Message, "error");
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return StatusUser;
    }

    private Boolean CheckRaterStatus(String ratercode)
    {
        Boolean StatusUser = true;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_RATER WHERE RATER_CODE = @ratercode AND RATER_STATUS = 'N' AND RATER_TYPE = 'NORMAL'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@ratercode", ratercode);
            SqlDataReader reader = command.ExecuteReader();
            String ratername = "";
            while (reader.Read())
            {
                ratername = reader["RATER_FNAME"].ToString();
            }

            if (ratername == "")
            {
                showMessage("คำเตือน!", "ไม่พบรายชื่อผู้ตรวจในฐานข้อมูล", "warning");
                StatusUser = false;
            }

            reader.Close();
            conn.Close();
        }
        catch (Exception ex)
        {
            showMessage("ข้อผิดพลาด!", ex.Message, "error");
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return StatusUser;
    }

    private Boolean CheckPackageStatus(String packagecode, String actionstatus)
    {
        Boolean StatusBox = true;
        SqlConnection conn = new SqlConnection(connStr);
        try
        {
            conn.Open();
            String query = "SELECT * FROM TRN_XM_PACKAGE package INNER JOIN TRN_XM_BOX box on box.BOX_CODE = package.BOX_CODE WHERE package.PACKAGE_CODE = @packagecode AND package.PACKAGE_STATUS != 'C' AND box.BOX_STATUS = 'B'";
            SqlCommand command = new SqlCommand(query, conn);
            command.Parameters.AddWithValue("@packagecode", packagecode);
            SqlDataReader reader = command.ExecuteReader();
            String pstatus = "";
            String pseq = "";
            while (reader.Read())
            {
                pstatus = reader["PACKAGE_STATUS"].ToString();
                pseq = reader["PACKAGE_SEQ"].ToString();

            }




            if (pseq == "")
            {
                showMessage("คำเตือน!", "ไม่พบซองนี้ในฐานข้อมูล หรือ กล่องที่บรรจุซองนี้ยังอยู่ในห้องมั่นคง", "warning");
                StatusBox = false;
            }
            else
            {
                if (actionstatus == "rater" && (pstatus != "N" && pstatus != "S"))
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถแจกได้", "warning");
                    StatusBox = false;
                }

                if (actionstatus == "return" && pstatus != "R")
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถนำส่งคืนได้", "warning");
                    StatusBox = false;
                }

                if (actionstatus == "omr" && pstatus != "S")
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถนำส่งห้อง OMR ได้", "warning");
                    StatusBox = false;
                }


                if (actionstatus == "final" && pstatus != "O")
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถกำหนดสถานะเสร็จเรียบร้อยได้", "warning");
                    StatusBox = false;
                }

                if (actionstatus == "modify" && pstatus != "O")
                {
                    showMessage("คำเตือน!", "ซองนี้ไม่สามารถส่งแก้ไขข้อมูลได้", "warning");
                    StatusBox = false;
                }


            }

            reader.Close();
            conn.Close();

        }
        catch (Exception ex)
        {
            showMessage("ข้อผิดพลาด!", ex.Message, "error");
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return StatusBox;
    }

    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }
}
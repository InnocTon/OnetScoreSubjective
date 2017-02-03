using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class importdatafactory : System.Web.UI.Page
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {




    }

    protected void listdirectorybtn_Click(object sender, EventArgs e)
    {
        String filetype = importtypeddl.SelectedValue.ToString();
        if (filetype == "0")
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'คำเตือน!',   text: 'กรุณาเลือกประเภทไฟล์ที่ต้องการนำเข้า',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
        }
        else
        {
            switch (filetype)
            {
                case "box": inportBox(FileUpload1); break;
                case "package": importPackage(FileUpload1); break;
                case "paper": importPaper(FileUpload1); break;
                default: break;
            }
        }
    }

    private void importPaper(FileUpload fileupload)
    {
        FileUpload fu = fileupload;
        if (fileupload.HasFile)
        {
            string filepath = Server.MapPath("factoryfile/paper/");
            String fileExtension = System.IO.Path.GetExtension(fu.FileName).ToLower();
            String[] allowedExtensions = { ".txt" };
            for (int i = 0; i < allowedExtensions.Length; i++)
            {
                if (fileExtension == allowedExtensions[i])
                {
                    SqlConnection conn = new SqlConnection(connStr);
                    try
                    {
                        //CHECK FILE NAME
                        string s_oldfilename = System.IO.Path.GetFileName(fileupload.FileName);
                        if (s_oldfilename.Contains("PAPER"))
                        {
                            //IMPORT FILE
                            string s_newfilename = "PAPER_" + DateTime.Now.Year.ToString() +
                                DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() +
                                DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + fileExtension;
                            fu.PostedFile.SaveAs(filepath + s_newfilename);

                            if (File.Exists(Server.MapPath("~/factoryfile/paper/" + s_newfilename)))
                            {
                                //INSERT TRN_FACTORY_IMPORT
                                String query = "INSERT INTO [TRN_FAC_IMPORT]([NEW_FILE_NAME],[IMPTYPE_CODE],[IMP_BY],[IMP_DATETIME],[IMP_STATUS],[OLD_FILE_NAME]) VALUES( '" + s_newfilename + "', 'PAPER' , '" + Session["USER_ID"].ToString() + "', getdate(), 'N', '" + s_oldfilename + "')";
                                //Label1.Text = query;
                                SqlCommand command = new SqlCommand(query, conn);
                                conn.Open();
                                int result = command.ExecuteNonQuery();
                                conn.Close();
                                if (result > 0)
                                {
                                    String IMP_SEQ = "";
                                    query = "SELECT IMP_SEQ FROM TRN_FAC_IMPORT WHERE NEW_FILE_NAME = '" + s_newfilename + "'";
                                    command = new SqlCommand(query, conn);
                                    conn.Open();
                                    SqlDataReader reader = command.ExecuteReader();
                                    while (reader.Read())
                                    {
                                        IMP_SEQ = reader["IMP_SEQ"].ToString();
                                    }

                                    reader.Close();
                                    conn.Close();

                                    //READ FILE
                                    String line;
                                    string path = Server.MapPath("~/factoryfile/paper/" + s_newfilename);
                                    StreamReader filereader = File.OpenText(path);
                                    int countline = 0;
                                    result = 0;
                                    conn.Open();
                                    while ((line = filereader.ReadLine()) != null)
                                    {
                                        String[] sline = line.Split(',');
                                        String PACKAGE_CODE = sline[0];
                                        String PAPER_BARCODE = sline[1];
                                        String PAPER_LITHOCODE = sline[2];

                                        query = "INSERT INTO [TRN_XM_PAPER](IMP_SEQ,PACKAGE_CODE,PAPER_BARCODE,PAPER_LITHOCODE,PAPER_STATUS,CREATE_BY,CREATE_DATETIME) VALUES(@impseq, @packagecode, @paperbarcode, @paperlithocode, 'N', @createby , getdate())";
                                        command = new SqlCommand(query, conn);
                                        command.Parameters.AddWithValue("@paperbarcode", PAPER_BARCODE);
                                        command.Parameters.AddWithValue("@packagecode", PACKAGE_CODE);
                                        command.Parameters.AddWithValue("@paperlithocode", PAPER_LITHOCODE);
                                        command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                                        command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                                        result += command.ExecuteNonQuery();
                                        countline++;
                                    }
                                    conn.Close();


                                    //ADD TO SYS_LOG
                                    SqlTransaction trans = null;
                                    query = "INSERT INTO SYS_LOG([LOG_NAME],[LOG_DESC],[LOG_DATE],[LOG_TYPE],[LOG_CODE]) values(@logname , @logdesc, getdate() , @logtype , @logcode)";
                                    command = new SqlCommand(query, conn);
                                    command.Parameters.AddWithValue("@logname", "Import Data Paper Success");
                                    command.Parameters.AddWithValue("@logtype", "IMPORTPAPER");
                                    command.Parameters.AddWithValue("@logcode", Session["USER_ID"].ToString());
                                    command.Parameters.AddWithValue("@logdesc", "นำเข้าไฟล์ " + s_oldfilename + " สำเร็จ");
                                    conn.Open();
                                    trans = conn.BeginTransaction();
                                    command.Transaction = trans;
                                    result = command.ExecuteNonQuery();
                                    if (result == 1)
                                    {
                                        trans.Commit();
                                        conn.Close();
                                        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: 'สำเร็จ',   text: 'นำเข้าข้อมูลใบบันทึกคะแนนจากโรงงานเรียบร้อยแล้ว',   type: 'success',  confirmButtonText: 'ตกลง',   closeOnConfirm: false }, function(){ window.location = 'importdatafactory.aspx'; });", true);
                                    }
                                    else
                                    {
                                        trans.Rollback();
                                        conn.Close();
                                        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: 'ผิดพลาด',   text: 'ไม่สามารถนำเข้าข้อมูลใบบันทึกคะแนนจากโรงงาน กรุณาลองใหม่อีกครั้ง',   type: 'error',  confirmButtonText: 'ตกลง',   closeOnConfirm: false }, function(){ window.location = 'importdatafactory.aspx'; });", true);
                                    }

                               
                                }


                            }
                            else
                            {
                                showMessage("ผิดพลาด!", "ไม่สามารถอัพโหลดไฟล์ที่เลือกได้", "error");
                            }



                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'คำเตือน!',   text: 'ชื่อไฟล์ไม่ถูกต้อง',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
                        }

                    }
                    catch (Exception ex)
                    {
                        showMessage("ข้อผิดพลาดจากระบบ!", ex.Message, "error");
                    }
                    finally
                    {
                        if (conn != null && conn.State == ConnectionState.Open)
                        {
                            conn.Close();
                        }
                    }
                }
                else
                {
                    showMessage("คำเตือน!", "นามสกุลไฟล์ไม่ถูกต้อง", "warning");
                }
            }
        }
        else
        {
            showMessage("คำเตือน!", "กรุณาเลือกไฟล์ที่ต้องการนำเข้า", "warning");
        }
    }


    private void importPackage(FileUpload fileupload)
    {
        FileUpload fu = fileupload;
        if (fileupload.HasFile)
        {
            string filepath = Server.MapPath("factoryfile/package/");
            String fileExtension = System.IO.Path.GetExtension(fu.FileName).ToLower();
            String[] allowedExtensions = { ".txt" };
            for (int i = 0; i < allowedExtensions.Length; i++)
            {
                if (fileExtension == allowedExtensions[i])
                {
                    SqlConnection conn = new SqlConnection(connStr);
                    try
                    {
                        //CHECK FILE NAME
                        string s_oldfilename = System.IO.Path.GetFileName(fileupload.FileName);
                        if (s_oldfilename.Contains("PACKAGE"))
                        {
                            //IMPORT FILE
                            string s_newfilename = "PACKAGE_" + DateTime.Now.Year.ToString() +
                                DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() +
                                DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + fileExtension;
                            fu.PostedFile.SaveAs(filepath + s_newfilename);

                            if (File.Exists(Server.MapPath("~/factoryfile/package/" + s_newfilename)))
                            {
                                //INSERT TRN_FACTORY_IMPORT
                                String query = "INSERT INTO [TRN_FAC_IMPORT]([NEW_FILE_NAME],[IMPTYPE_CODE],[IMP_BY],[IMP_DATETIME],[IMP_STATUS],[OLD_FILE_NAME]) VALUES( '" + s_newfilename + "', 'PACKAGE' , '" + Session["USER_ID"].ToString() + "', getdate(), 'N', '" + s_oldfilename + "')";
                                //Label1.Text = query;
                                SqlCommand command = new SqlCommand(query, conn);
                                conn.Open();
                                int result = command.ExecuteNonQuery();
                                conn.Close();
                                if (result > 0)
                                {
                                    String IMP_SEQ = "";
                                    query = "SELECT IMP_SEQ FROM TRN_FAC_IMPORT WHERE NEW_FILE_NAME = '" + s_newfilename + "'";
                                    command = new SqlCommand(query, conn);
                                    conn.Open();
                                    SqlDataReader reader = command.ExecuteReader();
                                    while (reader.Read())
                                    {
                                        IMP_SEQ = reader["IMP_SEQ"].ToString();
                                    }

                                    reader.Close();
                                    conn.Close();

                                    //READ FILE
                                    String line;
                                    string path = Server.MapPath("~/factoryfile/package/" + s_newfilename);
                                    StreamReader filereader = File.OpenText(path);
                                    int countline = 0;
                                    result = 0;
                                    conn.Open();
                                    while ((line = filereader.ReadLine()) != null)
                                    {
                                        String[] sline = line.Split(',');
                                        String BOX_CODE = sline[0];
                                        String PACKAGE_CODE = sline[1];
                                        String PACKAGE_NUM = sline[2];

                                        query = "INSERT INTO [TRN_XM_PACKAGE](PACKAGE_CODE,PAPER_NUM,IMP_SEQ,BOX_CODE,CREATE_BY,CREATE_DATETIME,PACKAGE_STATUS) VALUES(@packagecode,@papernum,@impseq,@boxcode,@createby, getdate(), 'N')";
                                        command = new SqlCommand(query, conn);
                                        command.Parameters.AddWithValue("@boxcode", BOX_CODE);
                                        command.Parameters.AddWithValue("@packagecode", PACKAGE_CODE);
                                        command.Parameters.AddWithValue("@papernum", PACKAGE_NUM);
                                        command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                                        command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                                        result += command.ExecuteNonQuery();
                                        countline++;
                                    }
                                    conn.Close();

                                    //ADD TO SYS_LOG
                                    SqlTransaction trans = null;
                                    query = "INSERT INTO SYS_LOG([LOG_NAME],[LOG_DESC],[LOG_DATE],[LOG_TYPE],[LOG_CODE]) values(@logname , @logdesc, getdate() , @logtype , @logcode)";
                                    command = new SqlCommand(query, conn);
                                    command.Parameters.AddWithValue("@logname", "Import Data Package Success");
                                    command.Parameters.AddWithValue("@logtype", "IMPORTPACKAGE");
                                    command.Parameters.AddWithValue("@logcode", Session["USER_ID"].ToString());
                                    command.Parameters.AddWithValue("@logdesc", "นำเข้าไฟล์ " + s_oldfilename + " สำเร็จ");
                                    conn.Open();
                                    trans = conn.BeginTransaction();
                                    command.Transaction = trans;
                                    result = command.ExecuteNonQuery();
                                    if (result == 1)
                                    {
                                        trans.Commit();
                                        conn.Close();
                                        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: 'สำเร็จ',   text: 'นำเข้าข้อมูลซองจากโรงงานเรียบร้อยแล้ว',   type: 'success',  confirmButtonText: 'ตกลง',   closeOnConfirm: false }, function(){ window.location = 'importdatafactory.aspx'; });", true);
                                    }
                                    else
                                    {
                                        trans.Rollback();
                                        conn.Close();
                                        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: 'ผิดพลาด',   text: 'ไม่สามารถนำเข้าข้อมูลซองจากโรงงาน กรุณาลองใหม่อีกครั้ง',   type: 'error',  confirmButtonText: 'ตกลง',   closeOnConfirm: false }, function(){ window.location = 'importdatafactory.aspx'; });", true);
                                    }
                                    
                                }


                            }
                            else
                            {
                                showMessage("ผิดพลาด!", "ไม่สามารถอัพโหลดไฟล์ที่เลือกได้", "error");
                            }



                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'คำเตือน!',   text: 'ชื่อไฟล์ไม่ถูกต้อง',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
                        }

                    }
                    catch (Exception ex)
                    {
                        showMessage("ข้อผิดพลาดจากระบบ!", ex.Message, "error");
                    }
                    finally
                    {
                        if (conn != null && conn.State == ConnectionState.Open)
                        {
                            conn.Close();
                        }
                    }
                }
                else
                {
                    showMessage("คำเตือน!", "นามสกุลไฟล์ไม่ถูกต้อง", "warning");
                }
            }
        }
        else
        {
            showMessage("คำเตือน!", "กรุณาเลือกไฟล์ที่ต้องการนำเข้า", "warning");
        }
    }

    private void inportBox(FileUpload fileupload)
    {
        FileUpload fu = fileupload;
        if (fileupload.HasFile)
        {
            string filepath = Server.MapPath("factoryfile/box/");
            String fileExtension = System.IO.Path.GetExtension(fu.FileName).ToLower();
            String[] allowedExtensions = { ".txt" };
            for (int i = 0; i < allowedExtensions.Length; i++)
            {
                if (fileExtension == allowedExtensions[i])
                {
                    SqlConnection conn = new SqlConnection(connStr);
                    try
                    {
                        //CHECK FILE NAME
                        string s_oldfilename = System.IO.Path.GetFileName(fileupload.FileName);
                        if (s_oldfilename.Contains("BOX"))
                        {


                            //IMPORT FILE
                            string s_newfilename = "BOX_" + DateTime.Now.Year.ToString() +
                                DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() +
                                DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + fileExtension;
                            fu.PostedFile.SaveAs(filepath + s_newfilename);


                            if (File.Exists(Server.MapPath("~/factoryfile/box/" + s_newfilename)))
                            {
                                //INSERT TRN_FACTORY_IMPORT
                                String query = "INSERT INTO [TRN_FAC_IMPORT]([NEW_FILE_NAME],[IMPTYPE_CODE],[IMP_BY],[IMP_DATETIME],[IMP_STATUS],[OLD_FILE_NAME]) VALUES( '" + s_newfilename + "', 'BOX' , '" + Session["USER_ID"].ToString() + "', getdate(), 'N', '" + s_oldfilename + "')";
                                //Label1.Text = query;
                                SqlCommand command = new SqlCommand(query, conn);
                                conn.Open();
                                int result = command.ExecuteNonQuery();
                                conn.Close();


                                if (result > 0)
                                {
                                    String IMP_SEQ = "";
                                    query = "SELECT IMP_SEQ FROM TRN_FAC_IMPORT WHERE NEW_FILE_NAME = '" + s_newfilename + "'";
                                    command = new SqlCommand(query, conn);
                                    conn.Open();
                                    SqlDataReader reader = command.ExecuteReader();
                                    while (reader.Read())
                                    {
                                        IMP_SEQ = reader["IMP_SEQ"].ToString();
                                    }

                                    reader.Close();
                                    conn.Close();

                                    //READ FILE
                                    String line;
                                    string path = Server.MapPath("~/factoryfile/box/" + s_newfilename);
                                    StreamReader filereader = File.OpenText(path);
                                    int countline = 0;
                                    result = 0;
                                    conn.Open();
                                    while ((line = filereader.ReadLine()) != null)
                                    {
                                        String[] sline = line.Split(',');
                                        String BOX_CODE = sline[0];
                                        String BOX_NUM = sline[1];

                                        query = "INSERT INTO [TRN_XM_BOX](BOX_CODE,PACKAGE_NUM,IMP_SEQ,CREATE_BY,CREATE_DATETIME,BOX_STATUS) VALUES(@boxcode, @boxnum, @impseq , @createby , getdate(), 'N')";
                                        command = new SqlCommand(query, conn);
                                        command.Parameters.AddWithValue("@boxcode", BOX_CODE);
                                        command.Parameters.AddWithValue("@boxnum", BOX_NUM);
                                        command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                                        command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                                        result += command.ExecuteNonQuery();
                                        countline++;
                                    }
                                    conn.Close();


                                    //ADD TO SYS_LOG
                                    SqlTransaction trans = null;
                                    query = "INSERT INTO SYS_LOG([LOG_NAME],[LOG_DESC],[LOG_DATE],[LOG_TYPE],[LOG_CODE]) values(@logname , @logdesc, getdate() , @logtype , @logcode)";
                                    command = new SqlCommand(query, conn);
                                    command.Parameters.AddWithValue("@logname", "Import Data Box Success");
                                    command.Parameters.AddWithValue("@logtype", "IMPORTBOX");
                                    command.Parameters.AddWithValue("@logcode", Session["USER_ID"].ToString());
                                    command.Parameters.AddWithValue("@logdesc", "นำเข้าไฟล์ "+ s_oldfilename + " สำเร็จ");
                                    conn.Open();
                                    trans = conn.BeginTransaction();
                                    command.Transaction = trans;
                                    result = command.ExecuteNonQuery();
                                    if (result == 1)
                                    {
                                        trans.Commit();
                                        conn.Close();
                                        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: 'สำเร็จ',   text: 'นำเข้าข้อมูลกล่องจากโรงงานเรียบร้อยแล้ว',   type: 'success',  confirmButtonText: 'ตกลง',   closeOnConfirm: false }, function(){ window.location = 'importdatafactory.aspx'; });", true);
                                    }
                                    else
                                    {
                                        trans.Rollback();
                                        conn.Close();
                                        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: 'ผิดพลาด',   text: 'ไม่สามารถนำเข้าข้อมูลกล่องจากโรงงาน กรุณาลองใหม่อีกครั้ง',   type: 'error',  confirmButtonText: 'ตกลง',   closeOnConfirm: false }, function(){ window.location = 'importdatafactory.aspx'; });", true);
                                    }
                                    //  showMessage("สำเร็จ", "นำเข้าข้อมูลกล่องจากโรงงานเรียบร้อยแล้ว", "success");
                                   
                                }
                            }
                            else
                            {
                                showMessage("ผิดพลาด!", "ไม่สามารถอัพโหลดไฟล์ที่เลือกได้", "error");
                            }



                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "login", "swal({   title: 'คำเตือน!',   text: 'ชื่อไฟล์ไม่ถูกต้อง',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
                        }

                    }
                    catch (Exception ex)
                    {
                        showMessage("ข้อผิดพลาดจากระบบ!", ex.Message, "error");
                    }
                    finally
                    {
                        if (conn != null && conn.State == ConnectionState.Open)
                        {
                            conn.Close();
                        }
                    }

                }
                else
                {
                    showMessage("คำเตือน!", "นามสกุลไฟล์ไม่ถูกต้อง", "warning");
                }

            }

        }
        else
        {
            showMessage("คำเตือน!", "กรุณาเลือกไฟล์ที่ต้องการนำเข้า", "warning");
        }
    }


    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }

}
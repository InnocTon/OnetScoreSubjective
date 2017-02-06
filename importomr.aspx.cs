using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

public partial class importomr : System.Web.UI.Page
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    protected void Page_Load(object sender, EventArgs e)
    {

    }


    private void importomrno1()
    {
        TableRow row;
        TableCell cellNo;
        TableCell cellName;
        TableCell cellNum;
        TableCell cellStatus;


        int ispass = 0;

        string[] filePaths = System.IO.Directory.GetFiles(Server.MapPath("~/omrfile/"));
        List<ListItem> files = new List<ListItem>();
        int countfile = 1;
        String ErrorMessage = "";

        foreach (string filePath in filePaths)
        {
            String BatchNo = "";
            String SerialNo = "";
            String SeatNo = "";
            String ExamKey = "";
            String LithoCode = "";
            String MachineName = "";

            var LithoCodeArray = new List<string>();
            var LithoCodeDict = new Dictionary<string, int>();


            row = new TableRow();
            cellNo = new TableCell();
            cellName = new TableCell();
            cellNum = new TableCell();
            cellStatus = new TableCell();

            // READ TEXT FILE
            string line;
            string filename = Path.GetFileName(filePath);
            string path = Server.MapPath("omrfile\\" + filename);

            String qno = filename.Substring(4, 1);

            if (qno == "1")
            {


                //ตรวจสอบไฟล์ว่าเคยถูก import หรือไม่
                Boolean hasDuplicate = CheckPackageDuplicate(filename);

                int countline = 0;

                if (!hasDuplicate)
                {


                    StreamReader reader = File.OpenText(path);


                    ispass = 0;
                    ErrorMessage = "";

                    try
                    {
                        while ((line = reader.ReadLine()) != null)
                        {
                            BatchNo = line.Substring(0, 11);
                            SerialNo = line.Substring(11, 4);
                            SeatNo = line.Substring(16, 7);
                            ExamKey = line.Substring(24, 9);
                            LithoCode = line.Substring(34, 7);
                            MachineName = line.Substring(42, 5);


                            //ตรวจสอบเลขที่ใบบันทึกคะแนน
                            if (LithoCode != SeatNo)
                            {
                                ispass++;
                                ErrorMessage += "- พบข้อมูล Seatno กับ LithoCode ไม่ตรงกัน ลำดับที่ : " + SerialNo + " <br/>";
                            }

                            //ตรวจสอบข้อมูลคะแนนเป็นดอกจัน
                            /*    if (ExamKey.Contains("*"))
                               {
                                   ispass++;
                                   ErrorMessage += "- พบข้อมูลดอกจัน ลำดับที่ : " + SerialNo + " <br/>";
                               } */

                               //ตรวจสอบข้อมูลคะแนนเป็นค่าว่าง
                           /*    if (ExamKey.Contains(" "))
                               {
                                   //  ispass++;
                                   ErrorMessage += "- พบข้อมูลค่าว่าง ลำดับที่ : " + SerialNo + " <br/>";
                               } */

                            LithoCodeArray.Add(LithoCode);
                            countline++;
                        }

                        reader.Close();
                        reader.Dispose();


                    }
                    catch (Exception ex)
                    {
                        showMessage("ข้อผิดพลาด!", ex.Message, "error");
                    }
                    finally
                    {

                    }

                    // ตรวจสอบจำนวน
                    int numpaper = CheckPackagePaperNumber(filename);
                    if (numpaper != countline)
                    {
                        ispass++;
                        ErrorMessage += "- จำนวนรายการในไฟล์ไม่ตรงกับฐานข้อมูล (ฐาน:" + countline.ToString() + " / ไฟล์:" + numpaper.ToString() + ") <br/>";
                    }

                    // ตรวจสอบข้อมูลซ้ำ
                    foreach (var value in LithoCodeArray)
                    {
                        if (LithoCodeDict.ContainsKey(value))
                            LithoCodeDict[value]++;
                        else
                            LithoCodeDict[value] = 1;
                    }
                    foreach (var pair in LithoCodeDict)
                    {
                        if (pair.Value != 1)
                        {
                            ispass++;
                            ErrorMessage += "- พบข้อมูลซ้ำที่ " + pair.Key.ToString() + " <br/>";
                        }
                    }


                    if (ispass == 0)
                    {
                        // cellStatus.Text = "<button class=\"md-btn md-btn-success\" data-uk-tooltip=\"{cls:'long-text'}\" title=\"" + ErrorMessage + "\">นำเข้าสำเร็จ</button>";


                        int result = 0;


                        SqlConnection conn = new SqlConnection(connStr);
                        SqlTransaction trans = null;

                        try
                        {

                            conn.Open();
                            trans = conn.BeginTransaction();

                            filename = Path.GetFileName(filePath);
                            path = Server.MapPath("omrfile\\" + filename);

                            //INSERT INTO TRN_OMR_IMPORT
                            String query = "INSERT INTO TRN_OMR_IMPORT([IMP_FILENAME],[IMP_STATUS],[IMP_BY],[IMP_DATETIME]) VALUES(@filename,'N',@impby,getdate())";
                            SqlCommand command = new SqlCommand(query, conn);
                            command.Parameters.AddWithValue("@filename", filename);
                            command.Parameters.AddWithValue("@impby", Session["USER_ID"].ToString());
                            command.Transaction = trans;
                            command.ExecuteNonQuery();


                            query = "SELECT IMP_SEQ FROM TRN_OMR_IMPORT WHERE IMP_FILENAME = @filename AND IMP_STATUS = 'N' AND IMP_BY = @impby";
                            SqlCommand readercommand = new SqlCommand(query, conn);
                            readercommand.Parameters.AddWithValue("@filename", filename);
                            readercommand.Parameters.AddWithValue("@impby", Session["USER_ID"].ToString());
                            readercommand.Transaction = trans;
                            SqlDataReader sqlreader = readercommand.ExecuteReader();
                            String IMP_SEQ = "";
                            while (sqlreader.Read())
                            {
                                IMP_SEQ = sqlreader["IMP_SEQ"].ToString();
                            }
                            sqlreader.Close();
                            readercommand.Dispose();


                            if (IMP_SEQ != "")
                            {
                                reader = File.OpenText(path);


                                while ((line = reader.ReadLine()) != null)
                                {

                                    BatchNo = line.Substring(0, 11);
                                    SerialNo = line.Substring(11, 4);
                                    SeatNo = line.Substring(16, 7);
                                    ExamKey = line.Substring(24, 9);
                                    LithoCode = line.Substring(34, 7);
                                    MachineName = line.Substring(42, 5);


                                    // INSERT INTO TRN_XM_BATCH_DETAIL
                                    query = "INSERT INTO TRN_XM_BATCH_DETAIL(IMP_SEQ,BATCH_NO,SERIAL_NO,SEAT_NO,LITHO_CODE,EXAM_KEY,OMR_MACHINE,CREATE_BY,CREATE_DATETIME,SHEET_STATUS) VALUES(@impseq,@batchno,@serialno,@seatno,@lithocode,@examkey,@machine,@createby,getdate(),'N')";


                                    command = new SqlCommand(query, conn);
                                    command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                                    command.Parameters.AddWithValue("@batchno", BatchNo);
                                    command.Parameters.AddWithValue("@serialno", SerialNo);
                                    command.Parameters.AddWithValue("@seatno", SeatNo);
                                    command.Parameters.AddWithValue("@lithocode", LithoCode);
                                    command.Parameters.AddWithValue("@examkey", ExamKey);
                                    command.Parameters.AddWithValue("@machine", MachineName);
                                    command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                                    command.Transaction = trans;
                                    result += command.ExecuteNonQuery();

                                }

                                reader.Close();
                                reader.Dispose();

                                if (result == numpaper)
                                {
                                    trans.Commit();

                                    string sourceFile = Server.MapPath("omrfile\\" + filename);
                                    string destinationFile = Server.MapPath("omrfile\\success\\" + filename);

                                    // MOVE FILE TO FOLDER SUCCESS
                                    File.Move(sourceFile, destinationFile);

                                    cellStatus.Text = "<span class='uk-badge uk-badge-success'>นำเข้าสำเร็จ</span>";
                                }
                                else
                                {
                                    trans.Rollback();
                                    cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\" ไม่สามารถบันทึกลงฐานข้อมูลได้ \">นำเข้าผิดพลาด</span>";
                                }
                            }
                            else
                            {
                                trans.Rollback();
                                cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\" ไม่สามารถบันทึกลงฐานข้อมูลได้  \">นำเข้าผิดพลาด</span>";
                            }




                        }
                        catch (Exception ex)
                        {
                            //trans.Rollback();
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
                    else
                    {
                        // cellStatus.Text = "<button class=\"md-btn md-btn-danger\" data-uk-tooltip=\"{cls:'long-text'}\" title=\"" + ErrorMessage + "\">นำเข้าผิดพลาด</button>";
                        cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\"" + ErrorMessage + "\">นำเข้าผิดพลาด</span>";
                    }

                }// End check File Duplicate
                else
                {
                    cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\"มีไฟล์นี้แล้วในฐานข้อมูล\">นำเข้าผิดพลาด</span>";
                }


                cellNo.Text = countfile.ToString();
                cellName.Text = filename;
                cellNum.Text = countline.ToString();


                row.Cells.Add(cellNo);
                row.Cells.Add(cellName);
                row.Cells.Add(cellNum);
                row.Cells.Add(cellStatus);
                ListFileTable.Rows.Add(row);

                countfile++;

            }
            else
            {
                //ไม่ใช่ไฟล์ ข้อ 1
            }

        }
    }


    private void importomrno2()
    {
        TableRow row;
        TableCell cellNo;
        TableCell cellName;
        TableCell cellNum;
        TableCell cellStatus;


        int ispass = 0;

        string[] filePaths = System.IO.Directory.GetFiles(Server.MapPath("~/omrfile/"));
        List<ListItem> files = new List<ListItem>();
        int countfile = 1;
        String ErrorMessage = "";

        foreach (string filePath in filePaths)
        {
            String BatchNo = "";
            String SerialNo = "";
            String SeatNo = "";
            String ExamKey = "";
            String LithoCode = "";
            String MachineName = "";

            var LithoCodeArray = new List<string>();
            var LithoCodeDict = new Dictionary<string, int>();


            row = new TableRow();
            cellNo = new TableCell();
            cellName = new TableCell();
            cellNum = new TableCell();
            cellStatus = new TableCell();

            // READ TEXT FILE
            string line;
            string filename = Path.GetFileName(filePath);
            string path = Server.MapPath("omrfile\\" + filename);

            String qno = filename.Substring(4, 1);

            if (qno == "2")
            {



                //ตรวจสอบไฟล์ว่าเคยถูก import หรือไม่
                Boolean hasDuplicate = CheckPackageDuplicate(filename);

                int countline = 0;

                if (!hasDuplicate)
                {



                    StreamReader reader = File.OpenText(path);


                    ispass = 0;
                    ErrorMessage = "";

                    try
                    {

                        while ((line = reader.ReadLine()) != null)
                        {

                            BatchNo = line.Substring(0, 11);
                            SerialNo = line.Substring(11, 4);
                            SeatNo = line.Substring(16, 7);
                            ExamKey = line.Substring(24, 4);
                            LithoCode = line.Substring(34, 7);
                            MachineName = line.Substring(42, 5);


                            //ตรวจสอบเลขที่ใบบันทึกคะแนน
                            if (LithoCode != SeatNo)
                            {
                                ispass++;
                                ErrorMessage += "- พบข้อมูล Seatno กับ LithoCode ไม่ตรงกัน ลำดับที่ : " + SerialNo + " <br/>";
                            }

                            //ตรวจสอบข้อมูลคะแนนเป็นดอกจัน
                            if (ExamKey.Contains("*"))
                            {
                                ispass++;
                                ErrorMessage += "- พบข้อมูลดอกจัน ลำดับที่ : " + SerialNo + " <br/>";
                            }

                            //ตรวจสอบข้อมูลคะแนนเป็นค่าว่าง
                            if (ExamKey.Contains(" "))
                            {
                                //  ispass++;
                                ErrorMessage += "- พบข้อมูลค่าว่าง ลำดับที่ : " + SerialNo + " <br/>";
                            }

                            LithoCodeArray.Add(LithoCode);
                            countline++;


                        }
                        reader.Close();
                        reader.Dispose();

                    }
                    catch (Exception ex)
                    {
                        showMessage("ข้อผิดพลาด!", ex.Message, "error");
                    }
                    finally
                    {

                    }





                    // ตรวจสอบจำนวน
                    int numpaper = CheckPackagePaperNumber(filename);
                    if (numpaper != countline)
                    {
                        ispass++;
                        ErrorMessage += "- จำนวนรายการในไฟล์ไม่ตรงกับฐานข้อมูล (ฐาน:" + countline.ToString() + " / ไฟล์:" + numpaper.ToString() + ") <br/>";
                    }

                    // ตรวจสอบข้อมูลซ้ำ
                    foreach (var value in LithoCodeArray)
                    {
                        if (LithoCodeDict.ContainsKey(value))
                            LithoCodeDict[value]++;
                        else
                            LithoCodeDict[value] = 1;
                    }
                    foreach (var pair in LithoCodeDict)
                    {
                        if (pair.Value != 1)
                        {
                            ispass++;
                            ErrorMessage += "- พบข้อมูลซ้ำที่ " + pair.Key.ToString() + " <br/>";
                        }
                    }

                    if (ispass == 0)
                    {
                        // cellStatus.Text = "<button class=\"md-btn md-btn-success\" data-uk-tooltip=\"{cls:'long-text'}\" title=\"" + ErrorMessage + "\">นำเข้าสำเร็จ</button>";


                        int result = 0;


                        SqlConnection conn = new SqlConnection(connStr);
                        SqlTransaction trans = null;

                        try
                        {

                            conn.Open();
                            trans = conn.BeginTransaction();

                            filename = Path.GetFileName(filePath);
                            path = Server.MapPath("omrfile\\" + filename);

                            //INSERT INTO TRN_OMR_IMPORT
                            String query = "INSERT INTO TRN_OMR_IMPORT([IMP_FILENAME],[IMP_STATUS],[IMP_BY],[IMP_DATETIME]) VALUES(@filename,'N',@impby,getdate())";
                            SqlCommand command = new SqlCommand(query, conn);
                            command.Parameters.AddWithValue("@filename", filename);
                            command.Parameters.AddWithValue("@impby", Session["USER_ID"].ToString());
                            command.Transaction = trans;
                            command.ExecuteNonQuery();


                            query = "SELECT IMP_SEQ FROM TRN_OMR_IMPORT WHERE IMP_FILENAME = @filename AND IMP_STATUS = 'N' AND IMP_BY = @impby";
                            SqlCommand readercommand = new SqlCommand(query, conn);
                            readercommand.Parameters.AddWithValue("@filename", filename);
                            readercommand.Parameters.AddWithValue("@impby", Session["USER_ID"].ToString());
                            readercommand.Transaction = trans;
                            SqlDataReader sqlreader = readercommand.ExecuteReader();
                            String IMP_SEQ = "";
                            while (sqlreader.Read())
                            {
                                IMP_SEQ = sqlreader["IMP_SEQ"].ToString();
                            }
                            sqlreader.Close();
                            readercommand.Dispose();

                            if (IMP_SEQ != "")
                            {
                                reader = File.OpenText(path);


                                while ((line = reader.ReadLine()) != null)
                                {

                                    BatchNo = line.Substring(0, 11);
                                    SerialNo = line.Substring(11, 4);
                                    SeatNo = line.Substring(16, 7);
                                    ExamKey = line.Substring(24, 4);
                                    LithoCode = line.Substring(34, 7);
                                    MachineName = line.Substring(42, 5);

                                    // INSERT INTO TRN_XM_BATCH_DETAIL
                                    query = "INSERT INTO TRN_XM_BATCH_DETAIL(IMP_SEQ,BATCH_NO,SERIAL_NO,SEAT_NO,LITHO_CODE,EXAM_KEY,OMR_MACHINE,CREATE_BY,CREATE_DATETIME,SHEET_STATUS) VALUES(@impseq,@batchno,@serialno,@seatno,@lithocode,@examkey,@machine,@createby,getdate(),'N')";


                                    command = new SqlCommand(query, conn);
                                    command.Parameters.AddWithValue("@impseq", IMP_SEQ);
                                    command.Parameters.AddWithValue("@batchno", BatchNo);
                                    command.Parameters.AddWithValue("@serialno", SerialNo);
                                    command.Parameters.AddWithValue("@seatno", SeatNo);
                                    command.Parameters.AddWithValue("@lithocode", LithoCode);
                                    command.Parameters.AddWithValue("@examkey", ExamKey);
                                    command.Parameters.AddWithValue("@machine", MachineName);
                                    command.Parameters.AddWithValue("@createby", Session["USER_ID"].ToString());
                                    command.Transaction = trans;
                                    result += command.ExecuteNonQuery();

                                }

                                reader.Close();
                                reader.Dispose();

                                if (result == numpaper)
                                {
                                    trans.Commit();

                                    string sourceFile = Server.MapPath("omrfile\\" + filename);
                                    string destinationFile = Server.MapPath("omrfile\\success\\" + filename);

                                    // MOVE FILE TO FOLDER SUCCESS
                                    File.Move(sourceFile, destinationFile);

                                    cellStatus.Text = "<span class='uk-badge uk-badge-success'>นำเข้าสำเร็จ</span>";
                                }
                                else
                                {
                                    trans.Rollback();
                                    cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\" ไม่สามารถบันทึกลงฐานข้อมูลได้ \">นำเข้าผิดพลาด</span>";
                                }
                            }
                            else
                            {
                                trans.Rollback();
                                cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\" ไม่สามารถบันทึกลงฐานข้อมูลได้  \">นำเข้าผิดพลาด</span>";
                            }


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




                    }
                    else
                    {
                        cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\"" + ErrorMessage + "\">นำเข้าผิดพลาด</span>";
                    }

                }// End check File Duplicate
                else
                {
                    cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\"มีไฟล์นี้แล้วในฐานข้อมูล\">นำเข้าผิดพลาด</span>";
                }

                cellNo.Text = countfile.ToString();
                cellName.Text = filename;
                cellNum.Text = countline.ToString();


                row.Cells.Add(cellNo);
                row.Cells.Add(cellName);
                row.Cells.Add(cellNum);
                row.Cells.Add(cellStatus);
                ListFileTable.Rows.Add(row);

                countfile++;

            }
            else
            {
                // ไม่ใช่ไฟล์ข้อ 2
            }


        }// End foreach file in filepath
    }

    protected void listdirectorybtn_Click(object sender, EventArgs e)
    {


        String questionno = importqnoddl.SelectedValue.ToString();

        if (questionno == "0")
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "importomr", "swal({   title: 'คำเตือน!',   text: 'กรุณาเลือกข้อที่ต้องการนำเข้า',   type: 'warning',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
        }
        else
        {

            if (questionno == "1")
            {
                importomrno1();
            }
            else if (questionno == "2")
            {
                importomrno2();

            }



        }



    }


    private Boolean CheckPackageDuplicate(String filename)
    {
        Boolean hasfile = true;
        string impseq = "";
        SqlConnection conn = new SqlConnection(connStr);
        String query = "SELECT IMP_SEQ FROM [TRN_OMR_IMPORT] WHERE [IMP_FILENAME] = @filename AND IMP_STATUS = 'N'";
        SqlCommand command = new SqlCommand(query, conn);
        command.Parameters.AddWithValue("@filename", filename);
        conn.Open();
        try
        {
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                impseq = reader["IMP_SEQ"].ToString();
            }

            reader.Close();
            conn.Close();


            if (impseq == "") hasfile = false;
            else hasfile = true;

            // showMessage("error", impseq.ToString(), "error");

        }
        catch (Exception ex)
        {
            Response.Write("CheckPackageDuplicate :" + ex.Message);

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        return hasfile;
    }

    private int CheckPackagePaperNumber(string filename)
    {
        int total = 0;
        string packagecode = filename.Substring(0, filename.IndexOf('.'));
        SqlConnection conn = new SqlConnection(connStr);
        String query = "SELECT PAPER_NUM FROM TRN_XM_PACKAGE WHERE PACKAGE_CODE = @packagecode";
        SqlCommand command = new SqlCommand(query, conn);
        command.Parameters.AddWithValue("@packagecode", packagecode);
        conn.Open();
        try
        {
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                total = Convert.ToInt32(reader["PAPER_NUM"].ToString());
            }

            reader.Close();
            conn.Close();
        }
        catch (Exception ex)
        {
            Response.Write("CheckPackagePaperNumber :" + ex.Message);

        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }



        return total;

    }

    private void showMessage(String title, String text, String type)
    {
        ScriptManager.RegisterStartupScript(this, GetType(), "message", "swal({   title: '" + title + "',   text: '" + text + "',   type: '" + type + "',  confirmButtonText: 'ตกลง',   closeOnConfirm: true }, function(){ });", true);
    }

}
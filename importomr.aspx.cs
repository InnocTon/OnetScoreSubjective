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


    protected void listdirectorybtn_Click(object sender, EventArgs e)
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
            StreamReader reader = File.OpenText(path);
            int countline = 0;

            ispass = 0;
            ErrorMessage = "";

            while ((line = reader.ReadLine()) != null)
            {

                BatchNo = line.Substring(0, 10);
                SerialNo = line.Substring(11, 4);
                SeatNo = line.Substring(16, 7);
                ExamKey = line.Substring(24, 8);
                LithoCode = line.Substring(33, 7);
                MachineName = line.Substring(41, 5);


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
                    ErrorMessage += "- พบข้อมูลคะแนนเป็นดอกจัน ลำดับที่ : " + SerialNo + " <br/>";
                }

                //ตรวจสอบข้อมูลคะแนนเป็นค่าว่าง
                if (ExamKey.Contains(" "))
                {
                    //  ispass++;
                    ErrorMessage += "- พบข้อมูลคะแนนเป็นค่าว่าง ลำดับที่ : " + SerialNo + " <br/>";
                }

                LithoCodeArray.Add(LithoCode);
                countline++;
            }

            reader.Close();
            reader.Dispose();

            // ตรวจสอบจำนวน
            int numpaper = CheckPackagePaperNumber(filename);
            if (numpaper != countline)
            {
                ispass++;
                ErrorMessage += "- จำนวนรายการในไฟล์ไม่ตรงกับจำนวนในฐานข้อมูล (ฐาน:" + countline.ToString() + " / ไฟล์:" + numpaper.ToString() + ") <br/>";
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
                    ErrorMessage += "- พบข้อมูลเลขที่ใบบันทึกคะแนนซ้ำที่ " + pair.Key.ToString() + " <br/>";
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
                    reader = File.OpenText(path);

                    while ((line = reader.ReadLine()) != null)
                    {

                        BatchNo = line.Substring(0, 10);
                        SerialNo = line.Substring(11, 4);
                        SeatNo = line.Substring(16, 7);
                        ExamKey = line.Substring(24, 8);
                        LithoCode = line.Substring(33, 7);
                        MachineName = line.Substring(41, 5);
                        // INSERT INTO TRN_XM_BATCH_DETAIL
                        String query = "INSERT INTO TRN_XM_BATCH_DETAIL(BATCH_NO,SERIAL_NO,SEAT_NO,LITHO_CODE,EXAM_KEY,OMR_MACHINE,CREATE_BY,CREATE_DATETIME) VALUES(@batchno,@serialno,@seatno,@lithocode,@examkey,@machine,@createby,getdate())";


                        SqlCommand command = new SqlCommand(query, conn);
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
                        cellStatus.Text = "<span class='uk-badge uk-badge-danger'data-uk-tooltip=\"{cls:'long-text'}\" title=\" ไม่สามารถบันทึกลงฐานข้อมูลได้ " + result + " \">นำเข้าผิดพลาด</span>";
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
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);

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
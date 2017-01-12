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
            while((line = reader.ReadLine()) != null)
            {

                BatchNo = line.Substring(0, 10);
                SerialNo = line.Substring(11, 4);
                SeatNo = line.Substring(16, 7);
                ExamKey = line.Substring(24, 8);
                LithoCode = line.Substring(33,7);
                MachineName = line.Substring(41, 5);


                //ตรวจสอบเลขที่ใบบันทึกคะแนน
                if(LithoCode != SeatNo)
                {
                    ispass++;
                    ErrorMessage += "- พบข้อมูล Seatno กับ LithoCode ไม่ตรงกัน ลำดับที่ : " + SerialNo + " <br/>";
                }

                //ตรวจสอบข้อมูลคะแนนเป็นดอกจัน
                if(ExamKey.Contains("*"))
                {
                    ispass++;
                    ErrorMessage += "- พบข้อมูลคะแนนเป็นดอกจัน ลำดับที่ : " + SerialNo + " <br/>";
                }

                //ตรวจสอบข้อมูลคะแนนเป็นค่าว่าง
                if (ExamKey.Contains(" "))
                {
                    ispass++;
                    ErrorMessage += "- พบข้อมูลคะแนนเป็นค่าว่าง ลำดับที่ : " + SerialNo + " <br/>";
                }

                LithoCodeArray.Add(LithoCode);
                countline++;
            }


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
                if(pair.Value != 1)
                {
                    ispass++;
                    ErrorMessage += "- พบข้อมูลเลขที่ใบบันทึกคะแนนซ้ำที่ " + pair.Key.ToString() + " <br/>";
                }
            }


            if (ispass == 0)
            {
                cellStatus.Text = "<button class=\"md-btn md-btn-success\" data-uk-tooltip=\"{cls:'long-text'}\" title=\"" + ErrorMessage + "\">นำเข้าสำเร็จ</button>";
            }
            else
            {
                cellStatus.Text = "<button class=\"md-btn md-btn-danger\" data-uk-tooltip=\"{cls:'long-text'}\" title=\"" + ErrorMessage + "\">นำเข้าผิดพลาด</button>";
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
            reader.Close();


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

}
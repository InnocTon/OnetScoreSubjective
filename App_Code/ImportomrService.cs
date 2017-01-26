using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

/// <summary>
/// Summary description for ImportomrService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class ImportomrService : System.Web.Services.WebService
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public ImportomrService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void GetDats()
    {

        var omrs = new List<ClassDataOmr>();
        using (var con = new SqlConnection(connStr))
        {
            String query = " SELECT ROW_NUMBER() OVER(ORDER BY IMP.IMP_SEQ ASC) AS Row#,IMP.IMP_SEQ,IMP.IMP_FILENAME,IMP.IMP_DATETIME,US.USER_NAME,DETAIL.NUM_RECORD,IMP.IMP_STATUS " +
"  FROM [dbo].[TRN_OMR_IMPORT] IMP LEFT JOIN SYS_USER US ON US.USER_ID = IMP.IMP_BY LEFT JOIN ( " +
"	SELECT COUNT(*) AS NUM_RECORD ,DT.IMP_SEQ FROM [dbo].[TRN_XM_BATCH_DETAIL]  DT WHERE DT.SHEET_STATUS = 'N' GROUP BY IMP_SEQ  " +
"  ) AS DETAIL ON DETAIL.IMP_SEQ = IMP.IMP_SEQ WHERE IMP_STATUS = 'N'";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var omr = new ClassDataOmr
                {
                    no = dr["Row#"].ToString(),
                    impfilename = dr["IMP_FILENAME"].ToString(),
                    imprecord = dr["NUM_RECORD"].ToString(),
                    impstatus = dr["IMP_STATUS"].ToString(),
                    impby = dr["USER_NAME"].ToString(),
                    impdate = dr["IMP_DATETIME"].ToString(),
                    imptools = dr["IMP_SEQ"].ToString()
                };
                omrs.Add(omr);
            }
            dr.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(omrs));
    }

}

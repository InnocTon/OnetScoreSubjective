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
/// Summary description for DiffService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DiffService : System.Web.Services.WebService
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public DiffService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void GetDats()
    {

        var diffs = new List<ClassDataDiff>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "SELECT  ROW_NUMBER() OVER(ORDER BY QNO,OMR_SEQ ASC) AS Row# ,STD_CODE,QNO,SUBSTRING(STD_CODE,1,5) + '3' + SUBSTRING(STD_CODE,6,8) AS PAPERCODE FROM TRN_XM_SCORE_COPY1 WHERE IS_DIFF = '1' AND IS_COMPLETE = '0'";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var diff = new ClassDataDiff
                {
                    no = dr["Row#"].ToString(),
                    stdcode = dr["STD_CODE"].ToString(),
                    papercode = dr["PAPERCODE"].ToString(),
                    qno = dr["QNO"].ToString(),
                    difftools = dr["STD_CODE"].ToString()
                };
                diffs.Add(diff);
            }
            dr.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(diffs));
    }


}

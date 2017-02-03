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
/// Summary description for DataworkService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DataworkService : System.Web.Services.WebService
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public DataworkService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    [WebMethod]
    public void GetDats()
    {

        var boxs = new List<ClassDataWork>();
        using (var con = new SqlConnection(connStr))
        {
            String query = " SELECT ROW_NUMBER() OVER(ORDER BY WORK_SEQ ASC) AS Row#,RATER_CODE,WORK_DATE FROM TRN_XM_WORKDATE";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var box = new ClassDataWork
                {
                    no = dr["Row#"].ToString(),
                    ratername = dr["RATER_CODE"].ToString(),
                    workdate = dr["WORK_DATE"].ToString()
                };
                boxs.Add(box);
            }
            dr.Close();
            con.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(boxs));
    }

}

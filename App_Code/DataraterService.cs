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
/// Summary description for DataraterService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DataraterService : System.Web.Services.WebService
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;



    public DataraterService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void GetDats()
    {

        var rates = new List<ClassDataRater>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "SELECT ROW_NUMBER() OVER(ORDER BY RATER_SEQ ASC) AS Row#,RATER_SEQ,RATER_CODE,(RATER_PRENAME + ' ' + RATER_FNAME + ' ' + RATER_LNAME)  AS RATER_NAME,RATER_CITIZENID,RATER_PLACE FROM TRN_XM_RATER WHERE RATER_STATUS = 'N'";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var rater = new ClassDataRater
                {
                    no = dr["Row#"].ToString(),
                    ratername = dr["RATER_NAME"].ToString(),
                    ratercode = dr["RATER_CODE"].ToString(),
                    raterpid = dr["RATER_CITIZENID"].ToString(),
                    raterplace = dr["RATER_PLACE"].ToString(),
                    ratertools = dr["RATER_SEQ"].ToString()
                };
                rates.Add(rater);
            }
            dr.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(rates));
    }

}

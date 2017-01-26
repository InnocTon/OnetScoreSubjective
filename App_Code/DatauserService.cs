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
/// Summary description for DatauserService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]

// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DatauserService : System.Web.Services.WebService
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public DatauserService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void GetDats()
    {

        var users = new List<ClassDataUser>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "SELECT ROW_NUMBER() OVER(ORDER BY USER_ID ASC) AS Row#,* FROM [dbo].[SYS_USER] WHERE USER_STATUS = 'N'";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var user = new ClassDataUser
                {
                    no = dr["Row#"].ToString(),
                    username = dr["USER_NAME"].ToString(),
                    usercode = dr["USER_ID"].ToString(),
                    usertype = dr["USER_TYPE"].ToString(),
                    userpass = dr["USER_PASS"].ToString(),
                    usertools = "1"
                };
                users.Add(user);
            }
            dr.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(users));
    }

}

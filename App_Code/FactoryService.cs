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
/// Summary description for FactoryService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class FactoryService : System.Web.Services.WebService
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    public FactoryService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void GetDats()
    {

        var factorys = new List<ClassDataFactory>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "SELECT * FROM TRN_FAC_IMPORT imp INNER JOIN SYS_IMPTYPE typ on imp.IMPTYPE_CODE = typ.IMPTYPE_CODE   INNER JOIN SYS_USER usr on usr.USER_ID = imp.IMP_BY";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var factory = new ClassDataFactory
                {
                  
                    no = dr["IMP_SEQ"].ToString(),
                    filename = dr["OLD_FILE_NAME"].ToString(),
                    filestatus = dr["IMP_STATUS"].ToString(),
                    filetype = dr["IMPTYPE_NAME"].ToString(),
                    fileimport = dr["USER_NAME"].ToString(),
                    filedate = dr["IMP_DATETIME"].ToString()
                };
                factorys.Add(factory);
            }
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(factorys));
    }

}

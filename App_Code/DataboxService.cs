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
/// Summary description for DataboxService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DataboxService : System.Web.Services.WebService
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;


    public DataboxService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void GetDats()
    {

        var boxs = new List<ClassDataBox>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "  SELECT ROW_NUMBER() OVER(ORDER BY bx.BOX_SEQ ASC) AS Row#,bx.*,bstatus.BSTATUS_NAME,PSTATUS.NUMP FROM [TRN_XM_BOX] bx  " +
"  INNER JOIN [dbo].[MST_BOX_STATUS] bstatus ON bstatus.[BSTATUS_CODE] = bx.BOX_STATUS " +
"  LEFT JOIN (  " +
"	  SELECT BOX_CODE,  " +
"	  SUM(CASE WHEN PACKAGE_STATUS = 'F' THEN 1 ELSE 0 END) AS NUMP  " +
"	  FROM TRN_XM_PACKAGE  " +
"	  GROUP BY BOX_CODE  " +
"  )PSTATUS ON PSTATUS.BOX_CODE = bx.BOX_CODE";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var box = new ClassDataBox
                {
                    no = dr["Row#"].ToString(),
                    boxcode = dr["BOX_CODE"].ToString(),
                    packagenum = dr["PACKAGE_NUM"].ToString(),
                    boxstatus = dr["BSTATUS_NAME"].ToString(),
                    packagestatus = dr["NUMP"].ToString(),
                    boxtools = dr["BOX_SEQ"].ToString()
                };
                boxs.Add(box);
            }
                dr.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(boxs));
    }

}

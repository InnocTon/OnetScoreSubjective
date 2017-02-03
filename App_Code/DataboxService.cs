using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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

    public class recieveValueimpseq
    {
        public string boxcode { get; set; }

    }


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
            String query = " SELECT ROW_NUMBER() OVER(ORDER BY bx.BOX_SEQ ASC) AS Row#,bx.*,bxs.BSTATUS_NAME FROM TRN_XM_BOX bx inner join [dbo].[MST_BOX_STATUS] bxs on bx.BOX_STATUS = bxs.BSTATUS_CODE WHERE bx.BOX_STATUS != 'C'";
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
                    boxtools = dr["BOX_SEQ"].ToString()
                };
                boxs.Add(box);
            }
            dr.Close();
            con.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(boxs));
    }

    [WebMethod(EnableSession = true)]
    public List<ClassDataPackage> GetDataBoxDetail(String box)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(box);


        String BOX_CODE = param.boxcode.ToString();

        var packages = new List<ClassDataPackage>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "  SELECT ROW_NUMBER() OVER(ORDER BY PACKAGE_SEQ ASC) AS Row#,PACKAGE_SEQ,PACKAGE_CODE,PACK.BOX_CODE,PAPER_NUM,PSTATUS_NAME,PACKAGE_STATUS FROM [dbo].[TRN_XM_PACKAGE] PACK INNER JOIN  [dbo].MST_PACKAGE_STATUS PSTATUS ON PACK.PACKAGE_STATUS = PSTATUS.PSTATUS_CODE INNER JOIN [dbo].[TRN_XM_BOX] BOX ON BOX.BOX_CODE = PACK.BOX_CODE WHERE PACK.BOX_CODE = @boxcode";

            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            cmd.Parameters.AddWithValue("@boxcode", BOX_CODE);
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var package = new ClassDataPackage
                {
                    no = dr["Row#"].ToString(),
                    boxcode = dr["BOX_CODE"].ToString(),
                    packagecode = dr["PACKAGE_CODE"].ToString(),
                    papernum = dr["PAPER_NUM"].ToString(),
                    packagestatus = dr["PSTATUS_NAME"].ToString(),
                    packagetools = dr["PACKAGE_SEQ"].ToString()
                };
                packages.Add(package);

            }
            dr.Close();
            con.Close();
        }

        return packages;

    }



    [WebMethod(EnableSession = true)]
    public List<ClassDataAction> GetDataBoxAction(String box)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(box);


        String BOX_CODE = param.boxcode.ToString();

        var actions = new List<ClassDataAction>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "    SELECT ROW_NUMBER() OVER(ORDER BY [OWNER_DATETIME] DESC) AS Row#,usr.USER_NAME AS OWNER_NAME,baction.ACT_STATUS,baction.OWNER_DATETIME FROM[dbo].[TRN_XM_BOX_ACTION] baction INNER JOIN[dbo].[SYS_USER] usr ON baction.OWNER_BY = usr.USER_ID WHERE baction.BOX_CODE = @boxcode ORDER BY baction.OWNER_DATETIME DESC";

            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            cmd.Parameters.AddWithValue("@boxcode", BOX_CODE);
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var action = new ClassDataAction
                {
                    no = dr["Row#"].ToString(),
                    ownername = dr["OWNER_NAME"].ToString(),
                    owneraction = dr["ACT_STATUS"].ToString(),
                    ownerdate = dr["OWNER_DATETIME"].ToString(),
                };
                actions.Add(action);
            }
            dr.Close();
            con.Close();
        }

        return actions;

    }


}

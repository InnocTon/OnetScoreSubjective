using Newtonsoft.Json;
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
/// Summary description for DatapackageService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DatapackageService : System.Web.Services.WebService
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    public class recieveValueimpseq
    {
        public string ratercode { get; set; }

    }
    public class reciveValuepackageCode
    {
        public string packagecode { get; set;  }
    }




    public DatapackageService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void GetDats()
    {

        var packages = new List<ClassDataPackage>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "SELECT ROW_NUMBER() OVER(ORDER BY PACKAGE_SEQ ASC) AS Row#,PACKAGE_SEQ,PACKAGE_CODE,PACK.BOX_CODE,PAPER_NUM,PSTATUS_NAME,PACKAGE_STATUS FROM [dbo].[TRN_XM_PACKAGE] PACK INNER JOIN  [dbo].MST_PACKAGE_STATUS PSTATUS ON PACK.PACKAGE_STATUS = PSTATUS.PSTATUS_CODE INNER JOIN [dbo].[TRN_XM_BOX] BOX ON BOX.BOX_CODE = PACK.BOX_CODE";
            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var package = new ClassDataPackage
                {
                    no = dr["Row#"].ToString(),
                    boxcode = dr["BOX_CODE"].ToString(),
                    packagecode = dr["PACKAGE_CODE"].ToString(),
                    papernum = dr["PAPER_NUM"].ToString(),
                    packagestatus = dr["PACKAGE_STATUS"].ToString(),
                    packagetools = dr["PACKAGE_SEQ"].ToString()
                };
                packages.Add(package);
            }
            dr.Close();
        }
        var js = new JavaScriptSerializer();
        Context.Response.Write(js.Serialize(packages));
    }

    [WebMethod(EnableSession = true)]
    public List<ClassDataPackage> GetDataRater(String rater)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(rater);


        String RATER_SEQ = param.ratercode.ToString();

        var packages = new List<ClassDataPackage>();
          using (var con = new SqlConnection(connStr))
          {
              String query = "SELECT ROW_NUMBER() OVER(ORDER BY pck.PACKAGE_SEQ ASC) AS Row#,pck.*,pstatus.PSTATUS_NAME FROM [dbo].[TRN_XM_PACKAGE] pck INNER JOIN ( SELECT DISTINCT(PACKAGE_CODE) FROM[ONET_SUBJECTIVE].[dbo].[TRN_XM_PACKAGE_ACTION] WHERE OWNER_BY = @rater ) pact on pact.PACKAGE_CODE = pck.PACKAGE_CODE INNER JOIN[dbo].[MST_PACKAGE_STATUS] pstatus on pstatus.PSTATUS_CODE = pck.PACKAGE_STATUS";

              var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
              con.Open();
              cmd.Parameters.AddWithValue("@rater", RATER_SEQ);
              var dr = cmd.ExecuteReader();
              while (dr.Read())
              {
                  var package = new ClassDataPackage
                  {
                      no = dr["Row#"].ToString(),
                      boxcode = dr["BOX_CODE"].ToString(),
                      packagecode = dr["PACKAGE_CODE"].ToString(),
                      papernum = dr["PAPER_NUM"].ToString(),
                      packagestatus = dr["PACKAGE_STATUS"].ToString(),
                      packagetools = dr["UPDATE_DATETIME"].ToString()
                  };
                  packages.Add(package);
              }
              dr.Close();
          }

        return packages;

    }


    [WebMethod(EnableSession = true)]
    public List<ClassDataPaper> GetDataPackageDetail(String package)
    {
        var param = JsonConvert.DeserializeObject<reciveValuepackageCode>(package);


        String PACKAGE_CODE = param.packagecode.ToString();

        var papers = new List<ClassDataPaper>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "  SELECT ROW_NUMBER() OVER(ORDER BY [PAPER_BARCODE] ASC) AS Row#,[PACKAGE_CODE],[PAPER_BARCODE],[PAPER_LITHOCODE],[PAPER_STATUS] FROM[dbo].[TRN_XM_PAPER] WHERE[PACKAGE_CODE] = @packagecode";

            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            cmd.Parameters.AddWithValue("@packagecode", PACKAGE_CODE);
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var paper = new ClassDataPaper
                {
                    no = dr["Row#"].ToString(),
                    packagecode = dr["PACKAGE_CODE"].ToString(),
                    papercode = dr["PAPER_BARCODE"].ToString(),
                    lithocode = dr["PAPER_LITHOCODE"].ToString()
                };
                papers.Add(paper);
            }
            dr.Close();
        }

        return papers;

    }


    [WebMethod(EnableSession = true)]
    public List<ClassDataAction> GetDataPackageAction(String package)
    {
        var param = JsonConvert.DeserializeObject<reciveValuepackageCode>(package);


        String PACKAGE_CODE = param.packagecode.ToString();

        var actions = new List<ClassDataAction>();
        using (var con = new SqlConnection(connStr))
        {
            String query = "SELECT ROW_NUMBER() OVER(ORDER BY [OWNER_DATETIME] DESC) AS Row#,rater.[RATER_PRENAME] + ' ' + rater.[RATER_FNAME] + ' ' + rater.[RATER_LNAME] as OWNER_NAME,paction.ACT_STATUS,paction.OWNER_DATETIME FROM [dbo].[TRN_XM_PACKAGE_ACTION] paction INNER JOIN [dbo].[TRN_XM_RATER] rater ON rater.[RATER_CODE] = paction.OWNER_BY WHERE paction.PACKAGE_CODE = @packagecode";

            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            cmd.Parameters.AddWithValue("@packagecode", PACKAGE_CODE);
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

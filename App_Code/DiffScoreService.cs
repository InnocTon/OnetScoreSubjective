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
/// Summary description for DiffScoreService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[System.Web.Script.Services.ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class DiffScoreService : System.Web.Services.WebService
{

    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    public class recieveValueimpseq
    {
        public string boxcode { get; set; }

    }


    public DiffScoreService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    [WebMethod(EnableSession = true)]
    public List<ClassDataScoreDiff> GetDataScoreDiffDetail(String box)
    {
        var param = JsonConvert.DeserializeObject<recieveValueimpseq>(box);


        String BOX_CODE = param.boxcode.ToString();

        var packages = new List<ClassDataScoreDiff>();
        using (var con = new SqlConnection(connStr))
        {
            String query = " SELECT ROW_NUMBER() OVER(ORDER BY [CREATE_DATETIME] DESC) AS Row#,SCR_SEQ,PAPER_BARCODE,QNO,CREATE_DATETIME FROM [TRN_XM_SCORE_COPY3]  WHERE CREATE_BY = @USERCODE";

            var cmd = new SqlCommand(query, con) { CommandType = CommandType.Text };
            con.Open();
            cmd.Parameters.AddWithValue("@USERCODE", BOX_CODE);
            var dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var package = new ClassDataScoreDiff
                {
                    no = dr["Row#"].ToString(),
                    papercode = dr["PAPER_BARCODE"].ToString(),
                    qno = dr["QNO"].ToString(),
                    scoredate = dr["CREATE_DATETIME"].ToString(),
                    difftools = dr["SCR_SEQ"].ToString()
                };
                packages.Add(package);

            }
            dr.Close();
            con.Close();
        }

        return packages;

    }





}

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Report1
/// </summary>
public class DiffReport
{
    public DiffReport()
    {
       
    }
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
    public object GetDiffReportData(string stdCode)
    {
        using (var dbconn = new SqlConnection(connStr))
        {
            dbconn.Open();
            String query = "SELECT * FROM[dbo].[TRN_XM_SCORE_COPY1] WHERE IS_DIFF='1'";
            query += String.IsNullOrEmpty(stdCode) ? "" : " WHERE STD_CODE = '" + stdCode + "'";
            SqlCommand command = new SqlCommand(query, dbconn);
            var result = new DataTable();
            result.Load(command.ExecuteReader());
            return result;
        }
    }
}
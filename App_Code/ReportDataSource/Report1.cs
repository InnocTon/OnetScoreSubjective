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
public class Report1
{
    public Report1()
    {
       
    }
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
    public object GetUserReportData(string userid)
    {
        using (var dbconn = new SqlConnection(connStr))
        {
            dbconn.Open();
            String query = "select * from [dbo].[SYS_USER] ";
            query += String.IsNullOrEmpty(userid) ? "" : " WHERE USER_ID = '" + userid + "'";
            SqlCommand command = new SqlCommand(query, dbconn);
            var result = new DataTable();
            result.Load(command.ExecuteReader());
            return result;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Configuration;

public partial class rater31data : System.Web.UI.Page
{
    static string connStr = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
       
    }
    public class recieveValue31
    {
        public string score1_1 { get; set; }
        public string score1_2 { get; set; }
        public string score2_1 { get; set; }
        public string score2_2 { get; set; }
        public string score3_1 { get; set; }
        public string score3_2 { get; set; }
        public string score3_3 { get; set; }
        public string score3_4 { get; set; }
        public string scoreSum { get; set; }
        
    }
    [WebMethod]
    public static string recieve(string recieveValue)
    {
        var query = JsonConvert.DeserializeObject<recieveValue31>(recieveValue);
        //string t = query.score3_2;
        
        decimal score11 = Convert.ToDecimal(query.score1_1.ToString());
        decimal score12 = Convert.ToDecimal(query.score1_2.ToString());
        decimal score21 = Convert.ToDecimal(query.score2_1.ToString());
        decimal score22 = Convert.ToDecimal(query.score2_2.ToString());
        decimal score31 = Convert.ToDecimal(query.score3_1.ToString());
        decimal score32 = Convert.ToDecimal(query.score3_2.ToString());
        decimal score33 = Convert.ToDecimal(query.score3_3.ToString());
        decimal score34 = Convert.ToDecimal(query.score3_4.ToString());
        decimal scoreSum = score11 + score12 + score21 + score22 + score31 + score32 + score33 + score34;
        //List<object> json = new List<object>();
        //List<object> jsonObject = new List<object>();
        //json.Add(new { value = t });
        //jsonObject.Add(new { result = json });
        return new JavaScriptSerializer().Serialize(scoreSum);
    }
   
}
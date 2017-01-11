using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class importomr : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    protected void listdirectorybtn_Click(object sender, EventArgs e)
    {
        /*   DataTable dt = new DataTable();
           DataColumn dc_no = new DataColumn("NO", typeof(String));
           DataColumn dc_name = new DataColumn("NAME", typeof(String));
           DataColumn dc_status = new DataColumn("STATUS", typeof(String));

           dt.Columns.Add(dc_no);
           dt.Columns.Add(dc_name);
           dt.Columns.Add(dc_status);

           for (int i = 0; i < 15; i++)
           {
               DataRow dr = dt.NewRow();
               dr["NO"] = i;
               dt.Rows.Add(dr);

           }
           GridViewListFile.DataSource = dt;
           GridViewListFile.DataBind();*/

        TableRow row = new TableRow();
        TableCell cell1 = new TableCell();
        TableCell cell2 = new TableCell();
        TableCell cell3 = new TableCell();
        cell1.Text = "blah blah blah1";
        cell2.Text = "blah blah blah2";
        cell3.Text = "blah blah blah3";
        row.Cells.Add(cell1);
        row.Cells.Add(cell2);
        row.Cells.Add(cell3);
        ListFileTable.Rows.Add(row);


        string[] filePaths = System.IO.Directory.GetFiles(Server.MapPath("~/omrfile/"));
        List<ListItem> files = new List<ListItem>();
        foreach (string filePath in filePaths)
        {
            files.Add(new ListItem(Path.GetFileName(filePath), filePath));
        }
        GridViewListFile.DataSource = files;
        GridViewListFile.DataBind();

    }

    protected void importbtn_Click(object sender, EventArgs e)
    {

    }
}
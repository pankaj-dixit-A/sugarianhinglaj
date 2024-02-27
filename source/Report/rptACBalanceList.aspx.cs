using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Globalization;
using System.Net;
using System.IO;
using System.Text;
using System.Net.Mail;


public partial class Report_rptACBalanceList : System.Web.UI.Page
{
    string tblPrefix = string.Empty;
    string tblHead = "";
    string qryCommon = "";
    string f = "../GSReports/DetailBalnce_" + clsGV.user + ".htm";
    string f_Main = "../Report/rptACBalanceList";
    string email = string.Empty;
    IFormatProvider ifrDT = CultureInfo.CreateSpecificCulture("en-GB");


    double Op_debit = 0.00;
    double Op_credit = 0.00;
    double Tran_debit = 0.00;
    double Tran_credit = 0.00;
    protected void Page_Load(object sender, EventArgs e)
    {
        qryCommon = "dbo.qryGledgernew";
        tblPrefix = Session["tblPrefix"].ToString();

        ViewState["fromDt"] = Request.QueryString["fromDt"];
        ViewState["ToDt"] = Request.QueryString["ToDt"];
        ViewState["whr1"] = Request.QueryString["whr1"];

        if (!Page.IsPostBack)
        {
            lblCompany.Text = Session["Company_Name"].ToString();
            lblCompanyAddr.Text = clsGV.CompanyAddress;
            string groupcode = Request.QueryString["whr1"];
            string accode2 = groupcode.Replace(" and Group_Code=", "");
            string groupcodename = clsCommon.getString("select group_Name_E from NT_1_BSGroupMaster where group_Code='"
                + accode2 + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            lblgroupcodename.Text = groupcodename;
            lblfrmdt.Text = DateTime.Parse(ViewState["fromDt"].ToString(), ifrDT).ToString("dd/MM/yyyy");
            lbltodt.Text = DateTime.Parse(ViewState["ToDt"].ToString(), ifrDT).ToString("dd/MM/yyyy");
            this.bindData();
        }
    }

    private void bindData()
    {
        try
        {
            string qry = "";
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            DataTable dtBind = new DataTable();
            dtBind.Columns.Add("Ac_Code", typeof(Int32));
            dtBind.Columns.Add("Ac_Name", typeof(string));
            dtBind.Columns.Add("Op_Debit", typeof(double));
            dtBind.Columns.Add("Op_Credit", typeof(double));
            dtBind.Columns.Add("Tran_Debit", typeof(double));
            dtBind.Columns.Add("Tran_Credit", typeof(double));
            dtBind.Columns.Add("Closing_Debit", typeof(double));
            dtBind.Columns.Add("Closing_Credit", typeof(double));

            if (ViewState["fromDt"] != null && ViewState["ToDt"] != null)
            {
                string fromdt = DateTime.Parse(ViewState["fromDt"].ToString(), ifrDT).ToString("yyyy/MM/dd");
                string todt = DateTime.Parse(ViewState["ToDt"].ToString(), ifrDT).ToString("yyyy/MM/dd");

                //qry = "select AC_CODE,Ac_Name_E,group_Type,SUM(case drcr when 'D' then AMOUNT when 'C' then -amount end) as Op_Balance "
                //    + " from qryGledgernew  "
                //    + " where  Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and DOC_DATE<'" + fromdt + "' " + ViewState["whr1"].ToString() + ""
                //    + " group by AC_CODE,Ac_Name_E,group_Type ";

                qry = "select AC_CODE,Ac_Name_E,group_Type,SUM(case drcr when 'D' then AMOUNT when 'C' then -amount end) as Op_Balance "
                    + " from qryGledgernew  "
                    + " where  Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "  " + ViewState["whr1"].ToString() + ""
                    + " group by AC_CODE,Ac_Name_E,group_Type ";
                ds = clsDAL.SimpleQuery(qry);
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        dt = ds.Tables[0];
                        if (dt.Rows.Count > 0)
                        {
                            double Tran_Balance = 0.00;
                            double Op_Balance = 0.00;
                            double Closing_Balance = 0.00;
                            //Fill Grid
                            //Calculate opening Balance
                            string myopbal = "";

                            for (int i = 0; i < dt.Rows.Count; i++) 
                            {
                                qry = " select SUM(case drcr when 'D' then AMOUNT when 'C' then -AMOUNT end) as Tran_Balance"
                                  + " from qryGledgernew  "
                                  + " where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "  and DOC_DATE<'"
                                  + fromdt + "' " + ViewState["whr1"].ToString() + " and AC_CODE=" + dt.Rows[i]["AC_CODE"].ToString() + ""
                                  + " group by AC_CODE,Ac_Name_E ";
                                 myopbal = clsCommon.getString(qry);
                                 Op_Balance = 0;
                                 if (myopbal != string.Empty)
                                {
                                    Op_Balance = Convert.ToDouble(myopbal);
                                    
                                }


                                // Assign zero to openig balance when account group type is trading or profit loss
                                //if (dt.Rows[i]["group_Type"].ToString() == "B")
                                //{
                                //    Op_Balance = Convert.ToDouble(dt.Rows[i]["Op_Balance"].ToString());
                                //}
                                //else
                                //{
                                //    Op_Balance = 0;
                                //}
                                //                                                                                                                                                                                                               }
                                // Assigning opening balance to opening drbit and openng credit lables
                                if (Op_Balance != 0 && dt.Rows[i]["group_Type"].ToString() == "B" )
                                {
                                    if (Op_Balance > 0)
                                    {

                                        Op_debit = Op_Balance;
                                        Op_credit = 0.00;
                                    }
                                    else if (Op_Balance < 0)
                                    {

                                        Op_debit = 0.00;
                                        Op_credit =Math.Abs( Op_Balance);
                                    }
                                }
                                else
                                {
                                    Op_debit = 0.00;
                                    Op_credit = 0.00;
                                }


                                // Calulate tran debit values 
                                qry = " select SUM(case drcr when 'D' then AMOUNT when 'C' then 0 end) as Tran_Balance"
                                  + " from qryGledgernew  "
                                  + " where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and DOC_DATE between '"
                                  + fromdt + "' and '" + todt + "' and AC_CODE=" + dt.Rows[i]["AC_CODE"].ToString() + ""
                                  + " group by AC_CODE,Ac_Name_E ";
                                string str = clsCommon.getString(qry);


                                if (str != string.Empty)
                                {
                                    Tran_Balance = Convert.ToDouble(str);
                                    Tran_debit = Tran_Balance;
                                }


                                // Calculate tran credit values
                                qry = " select SUM(case drcr when 'C' then AMOUNT when 'D' then 0 end) as Tran_Balance"
                                  + " from qryGledgernew  "
                                  + " where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and DOC_DATE between '"
                                  + fromdt + "' and '" + todt + "' and AC_CODE=" + dt.Rows[i]["AC_CODE"].ToString() + ""
                                  + " group by AC_CODE,Ac_Name_E ";
                                string str1 = clsCommon.getString(qry);


                                if (str1 != string.Empty)
                                {
                                    Tran_Balance = Convert.ToDouble(str1);
                                    Tran_credit = Tran_Balance;
                                }

                                //Calculate Closing Debit/Credit
                                Closing_Balance = (Op_debit + Tran_debit) - (  Op_credit
                                    + Tran_credit);
                                if (Tran_debit == 0 && Tran_credit==0 && Op_credit  == 0 && Op_debit== 0)
                                {
                                }
                                else
                                {
                                    // Assign values to grid
                                    DataRow dr = dtBind.NewRow();
                                    dr["Ac_Code"] = dt.Rows[i]["AC_CODE"].ToString();
                                    dr["Ac_Name"] = dt.Rows[i]["Ac_Name_E"].ToString();
                                    dr["Op_Debit"] = Op_debit ;
                                    dr["Op_Credit"] = Math.Abs(Op_credit );
                                    dr["Tran_Debit"] = Tran_debit;
                                    dr["Tran_Credit"] = Tran_credit;
                                    if (Closing_Balance > 0)
                                    {
                                        dr["Closing_Debit"] = Closing_Balance;
                                        dr["Closing_Credit"] = 0.00;
                                    }
                                    else if (Closing_Balance < 0)
                                    {
                                        dr["Closing_Debit"] = 0.00;
                                        dr["Closing_Credit"] = -Closing_Balance;
                                    }
                                    else
                                    {
                                        dr["Closing_Debit"] = 0.00;
                                        dr["Closing_Credit"] = 0.00;
                                    }
                                    dtBind.Rows.Add(dr);
                                    // Initilizing varibles
                                    Op_Balance = 0;
                                    Op_credit = 0;
                                    Op_debit = 0;
                                    Tran_credit = 0;
                                    Tran_debit = 0;
                                    Closing_Balance = 0;
                                }
                            }//end for loop
                            dtl_AccountBalance.DataSource = dtBind;
                            dtl_AccountBalance.DataBind();
                        }
                    }
                }
            }
        }
        catch (Exception eex)
        {
            Response.Write(eex.Message);
        }
    }

    protected void dtl_AccountBalance_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        try
        {
            Label lblOp_Debit = (Label)e.Item.FindControl("lblOp_Debit");
            Label lblOp_Credit = (Label)e.Item.FindControl("lblOp_Credit");
            Label lblTran_Debit = (Label)e.Item.FindControl("lblTran_Debit");
            Label lblTran_Credit = (Label)e.Item.FindControl("lblTran_Credit");
            Label lblClosing_Debit = (Label)e.Item.FindControl("lblClosing_Debit");
            Label lblClosing_Credit = (Label)e.Item.FindControl("lblClosing_Credit");
            if (lblOp_Debit.Text == "0")
            {
                lblOp_Debit.Text = "";
            }
            if (lblOp_Credit.Text == "0")
            {
                lblOp_Credit.Text = "";
            }
            if (lblTran_Debit.Text == "0")
            {
                lblTran_Debit.Text = "";
            }
            if (lblTran_Credit.Text == "0")
            {
                lblTran_Credit.Text = "";
            }
            if (lblClosing_Debit.Text == "0")
            {
                lblClosing_Debit.Text = "";
            }
            if (lblClosing_Credit.Text == "0")
            {
                lblClosing_Credit.Text = "";
            }
        }
        catch
        {

        }
    }

    protected void btnSendEmail_Click(object sender, EventArgs e)
    {
        try
        {
            email = txtEmail.Text.ToString();
            WebClient client = new WebClient();
            Stream data = client.OpenRead(HttpContext.Current.Request.Url.AbsoluteUri);
            StreamReader reader = new StreamReader(data);
            string s = reader.ReadToEnd();
            data.Close();
            reader.Close();
            try
            {
                using (FileStream fs = new FileStream(Server.MapPath(f), FileMode.Create))
                {
                    using (StreamWriter w = new StreamWriter(fs, Encoding.UTF8))
                    {
                        w.WriteLine(s);
                    }
                }
            }
            catch (Exception ee)
            {
                f = f_Main + ".htm";
                using (FileStream fs = new FileStream(Server.MapPath(f), FileMode.Create))
                {
                    using (StreamWriter w = new StreamWriter(fs, Encoding.UTF8))
                    {
                        w.WriteLine(s);
                    }
                }
            }
            string mailFrom = Session["EmailId"].ToString();
            string smtpPort = "587";
            string emailPassword = Session["EmailPassword"].ToString();
            MailMessage msg = new MailMessage();
            SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com", 587);
            msg.From = new MailAddress(mailFrom);
            msg.To.Add(email);
            msg.Body = "Detailed Balance";
            msg.Attachments.Add(new Attachment(Server.MapPath(f)));
            msg.IsBodyHtml = true;
            //msg.Body = "<html><body>" + txtEmail.Text.ToString() + "</body></html>";
            msg.Subject = "Detailed Balance Report " + " " + "ON" + " " + DateTime.Now.ToString("dd/MM/yyyy");
            msg.IsBodyHtml = true;
            if (smtpPort != string.Empty)
            {
                SmtpServer.Port = Convert.ToInt32(smtpPort);
            }
            SmtpServer.EnableSsl = true;
            SmtpServer.UseDefaultCredentials = false;
            SmtpServer.Credentials = new System.Net.NetworkCredential(mailFrom, emailPassword);
            SmtpServer.Send(msg);
        }
        catch (Exception e1)
        {
            //Response.Write("mail err:" + e1);
            Response.Write("<script>alert('Error sending Mail');</script>");
            return;
        }
        Response.Write("<script>alert('Mail sent successfully');</script>");
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        string Name = "Report";

        StringBuilder StrHtmlGenerate = new StringBuilder();
        StringBuilder StrExport = new StringBuilder();
        StrExport.Append(@"<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'><head><title>Time</title>");
        StrExport.Append(@"<body lang=EN-US style='mso-element:header' id=h1><span style='mso--code:DATE'></span><div class=Section1>");
        StrExport.Append("<DIV  style='font-size:12px;'>");
        StringWriter sw = new StringWriter();
        HtmlTextWriter tw = new HtmlTextWriter(sw);
        PrintPanel.RenderControl(tw);
        string sim = sw.ToString();
        StrExport.Append(sim);
        StrExport.Append("</div></body></html>");
        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment;filename=" + Name + ".xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.ms-excel";
        string style = @"<style> .textmode { } </style>";
        Response.Write(style);
        Response.Output.Write(StrExport.ToString());
        Response.Flush();
        Response.End();
    }
}
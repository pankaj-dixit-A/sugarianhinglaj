﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net.Mail;
using System.IO;
using System.Text;
using System.Net.Mime;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using iTextSharp.tool.xml.html;
using iTextSharp.tool.xml.parser;


public partial class Report_rptDeliveryOrderForGST : System.Web.UI.Page
{
    string f = "../GSReports/doprint_.htm";
    string f_Main = "../GSReports/DO_";

    string tblPrefix = string.Empty;
    string tblHead = string.Empty;
    string tblDetails = string.Empty;
    string qryCommon = string.Empty;
    string trnType = "DO";
    string GLedgerTable = string.Empty;
    string filterDoNo = string.Empty;
    string millEmail = string.Empty;
    string cityMasterTable = string.Empty;
    string mail = string.Empty;
    string prefix = string.Empty;
    string PO = string.Empty;
    string Email_Subject = "";
    string a = string.Empty;
    string Company_Name = string.Empty;

    string email = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["tblPrefix"] != null)
        {
            tblPrefix = Session["tblPrefix"].ToString();//"NT_1_";
        }
        else
        {
            prefix = clsCommon.getString("Select tblPrefix from tblPrefix");
            tblPrefix = prefix.ToString();
        }
        qryCommon = tblPrefix + "qryDeliveryOrderListReport";
        cityMasterTable = tblPrefix + "CityMaster";
        filterDoNo = Request.QueryString["do_no"];
        millEmail = Request.QueryString["email"];
        a = Request.QueryString["a"];
        mail = txtEmail.Text;
        PO = Request.QueryString["PO"];

        if (!Page.IsPostBack)
        {
            //Company_Name = clsCommon.getString("Select Company_Name_E from Company where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
            this.BindReport();
        }
    }

    private void BindReport()
    {
        try
        {
            txtEmail.Text = millEmail;
            //Response.Write("1");
            string qry = "select distinct(tran_type),*,Convert(varchar(10),doc_date,103) as doc_date1 from " + qryCommon + " where doc_no in (" + filterDoNo + ") and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + " and tran_type='" + trnType + "'";
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();

            DataTable dtBind = new DataTable();
            ds = clsDAL.SimpleQuery(qry);
            //  Response.Write("2");
            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    string purNo = ds.Tables[0].Rows[0]["purc_no"].ToString();
                    string Sell_Note_No = clsCommon.getString("Select Sell_Note_No from " + tblPrefix + "Tender where Tender_No=" + purNo + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + "");
                    string Resale = clsCommon.getString("Select type from " + tblPrefix + "Tender where Tender_No=" + purNo + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + "");
                    string TenderDO = string.Empty;
                    if (Resale == "R")
                    {
                        TenderDO = clsCommon.getString("Select Tender_DO from " + tblPrefix + "Tender where Tender_No=" + purNo + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + "");
                    }

                    dt = ds.Tables[0];
                    DataTable dt2 = new DataTable();
                    dt2 = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        if (a == "1")
                        {
                            ds.Tables[0].Rows[0]["narration1"] = "";
                        }
                        if (!string.IsNullOrWhiteSpace(ds.Tables[0].Rows[0]["Local_Lic_No"].ToString()))
                        {
                            ds.Tables[0].Rows[0]["Local_Lic_No"] = "LIC: " + ds.Tables[0].Rows[0]["Local_Lic_No"].ToString();
                        }
                        if (!string.IsNullOrWhiteSpace(ds.Tables[0].Rows[0]["Cst_no"].ToString()))
                        {
                            ds.Tables[0].Rows[0]["Cst_no"] = "CST: " + ds.Tables[0].Rows[0]["Cst_no"].ToString();
                        }
                        if (!string.IsNullOrWhiteSpace(ds.Tables[0].Rows[0]["ECC_No"].ToString()))
                        {
                            ds.Tables[0].Rows[0]["ECC_No"] = "ECC: " + ds.Tables[0].Rows[0]["ECC_No"].ToString();
                        }
                        if (!string.IsNullOrWhiteSpace(ds.Tables[0].Rows[0]["Tin_No"].ToString()))
                        {
                            ds.Tables[0].Rows[0]["Tin_No"] = "TIN: " + ds.Tables[0].Rows[0]["Tin_No"].ToString();
                        }
                        if (!string.IsNullOrWhiteSpace(ds.Tables[0].Rows[0]["Gst_No"].ToString()))
                        {
                            ds.Tables[0].Rows[0]["Gst_No"] = "GST: " + ds.Tables[0].Rows[0]["Gst_No"].ToString();
                        }
                        if (!string.IsNullOrWhiteSpace(ds.Tables[0].Rows[0]["PAN_No"].ToString()))
                        {
                            ds.Tables[0].Rows[0]["PAN_No"] = "PAN: " + ds.Tables[0].Rows[0]["PAN_No"].ToString();
                        }
                        if (!string.IsNullOrWhiteSpace(ds.Tables[0].Rows[0]["FSSAI"].ToString()))
                        {
                            ds.Tables[0].Rows[0]["FSSAI"] = "FSSAI No: " + ds.Tables[0].Rows[0]["FSSAI"].ToString();
                        }
                        string final_amount = ds.Tables[0].Rows[0]["final_amount"].ToString();
                        dt.Columns.Add(new DataColumn("InWords", typeof(string)));

                        dt.Columns.Add(new DataColumn("Sell_Note_No", typeof(string)));
                        dt.Columns.Add(new DataColumn("SaleNoteHead", typeof(string)));
                        dt.Columns.Add(new DataColumn("TenderDO", typeof(string)));
                        dt.Columns.Add(new DataColumn("Gst_Rate", typeof(string)));
                        dt.Columns.Add(new DataColumn("Net_Rate", typeof(string)));
                        dt.Columns.Add(new DataColumn("CompanyGSTStateCode", typeof(string)));
                        dt.Columns.Add(new DataColumn("CompanyGST", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoName", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoAddress", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoCityState", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoGST", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoPAN_No", typeof(string)));
                        dt.Columns.Add(new DataColumn("Salebillto_FSSAI", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoLocal_Lic_No", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoECC_No", typeof(string)));
                        dt.Columns.Add(new DataColumn("SalebilltoTin_No", typeof(string)));
                        dt.Columns.Add(new DataColumn("HSN", typeof(string)));

                        dt.Columns.Add(new DataColumn("TCSAmt", typeof(double)));
                        dt.Columns.Add(new DataColumn("TCS_NetAmt", typeof(double)));

                        dt.Columns.Add(new DataColumn("TDSAmt", typeof(double)));

                        string GSTRateCode = ds.Tables[0].Rows[0]["GstRateCode"].ToString();
                        string HSNCode_Name = clsCommon.getString("select Code_Name from " + tblPrefix + "qryGSTRateMaster where Doc_no=" + GSTRateCode + "");
                        dt.Rows[0]["HSN"] = HSNCode_Name;

                        string sbto = ds.Tables[0].Rows[0]["voucher_by"].ToString();
                        int salebillto = sbto != string.Empty ? Convert.ToInt32(sbto) : 0;

                        string SalebilltoName = clsCommon.getString("select Ac_Name_E from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string SalebilltoAddress = clsCommon.getString("select Address_E from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltocityname = clsCommon.getString("select CityName from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltopincode = clsCommon.getString("select Pincode from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltoStateName = clsCommon.getString("select StateName from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltoGSTStateCode = clsCommon.getString("select GSTStateCode from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltoGSTNumber = clsCommon.getString("select ISNULL('GST:'+NULLIF(Gst_No,''),'') from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltoPAN_No = clsCommon.getString("select ISNULL('PAN:'+NULLIF(CompanyPan,''),'') from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltoLocal_Lic_No = clsCommon.getString("select ISNULL('Sugar_Lic_No:'+NULLIF(Local_Lic_No,''),'') from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltoECC_No = clsCommon.getString("select ISNULL('ECC:'+NULLIF(ECC_No,''),'') from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string salebilltoTin_No = clsCommon.getString("select ISNULL('TIN:'+NULLIF(Tin_No,''),'') from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        string FSSAI = clsCommon.getString("select ISNULL('FSSAI_No:'+NULLIF(FSSAI,''),'') from " + tblPrefix + "qryAccountsList where Ac_Code=" + salebillto + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");

                        dt.Rows[0]["SalebilltoName"] = SalebilltoName;
                        dt.Rows[0]["SalebilltoAddress"] = SalebilltoAddress;
                        dt.Rows[0]["SalebilltoCityState"] = "City: <b>" + salebilltocityname + "</b> State: <b>" + salebilltoStateName + "</b> Pincode: <b>" + salebilltopincode + "</b>";
                        dt.Rows[0]["SalebilltoGST"] = "<b>" + salebilltoGSTNumber + "</b>";
                        dt.Rows[0]["SalebilltoPAN_No"] = "<b>" + salebilltoPAN_No + "</b>";
                        dt.Rows[0]["SalebilltoLocal_Lic_No"] = "<b>" + salebilltoLocal_Lic_No + "</b>";
                        dt.Rows[0]["SalebilltoECC_No"] = "<b>" + salebilltoECC_No + "</b>";
                        dt.Rows[0]["SalebilltoTin_No"] = "<b>" + salebilltoTin_No + "</b>";
                        dt.Rows[0]["Salebillto_FSSAI"] = "<b>" + FSSAI + "</b>";
                        dt.Rows[0]["SalebilltoGstStateCode"] = salebilltoGSTStateCode;
                        //string companyGST = clsCommon.getString("select GST from Company where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "");
                        //dt.Rows[0]["CompanyGST"] = "GST: <b>" + companyGST + "</b>";
                        //dt.Rows[0]["CompanyGSTStateCode"] = Session["CompanyGSTStateCode"].ToString();
                        if (Resale == "R")
                        {
                            if (TenderDO != "2")
                            {
                                string TenderDOName = clsCommon.getString("Select Ac_Name_E from " + tblPrefix + "AccountMaster where Ac_Code='" + TenderDO + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
                                dt.Rows[0]["TenderDO"] = "(A/c " + TenderDOName + " On DO)";
                            }
                        }
                        if (!string.IsNullOrWhiteSpace(Sell_Note_No))
                        {
                            dt.Rows[0]["SaleNoteHead"] = "Sell Note:";
                            dt.Rows[0]["Sell_Note_No"] = "No_ " + Sell_Note_No;
                        }

                        double millrate = Convert.ToDouble(dt.Rows[0]["mill_rate"].ToString());
                        double gstrate = Math.Round((millrate * 5 / 100), 2);
                        dt.Rows[0]["Gst_Rate"] = gstrate;
                        double netRate = millrate + gstrate;
                        dt.Rows[0]["Net_Rate"] = Math.Round(netRate, 2);

                        double quantal = Convert.ToDouble(dt.Rows[0]["quantal"].ToString());
                        double totalAmountWithgst = Math.Round((netRate * quantal), 2);
                        //string inwords = clsNoToWord.ctgword(totalAmountWithgst.ToString());
                        //ds.Tables[0].Rows[0]["InWords"] = inwords;

                        ds.Tables[0].Rows[0]["final_amount"] = totalAmountWithgst;
                        //string TenderNo = ds.Tables[0].Rows[0]["purc_no"].ToString();
                        //int TenNo = TenderNo != string.Empty ? Convert.ToInt32(TenderNo) : 0;
                        //string TenderNarr = clsCommon.getString("select Narration from NT_1_qryTenderList where  Tender_No=" + TenNo + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + " ");
                      
                        double TCSRate = Convert.ToDouble(dt.Rows[0]["TCS_Rate"].ToString());
                        double PTCSAmt = Math.Round((totalAmountWithgst * TCSRate) / 100, 2);

                        double NTCSAmt = totalAmountWithgst + PTCSAmt;

                        ds.Tables[0].Rows[0]["TCSAmt"] = PTCSAmt;
                        ds.Tables[0].Rows[0]["TCS_NetAmt"] = NTCSAmt;

                        double PSTDSRate = Convert.ToDouble(dt.Rows[0]["PSTDS_Rate"].ToString());                     
                        double PSTDSAmt = Math.Round(((millrate * quantal) * PSTDSRate / 100), 2);
                        ds.Tables[0].Rows[0]["TDSAmt"] = PSTDSAmt;

                        string inwords = clsNoToWord.ctgword(NTCSAmt.ToString());
                        ds.Tables[0].Rows[0]["InWords"] = inwords;

                        DataList1.DataSource = dt;
                        DataList1.DataBind();
                        DataList2.DataSource = dt2;
                        DataList2.DataBind();
                    }
                }
            }
        }
        catch (Exception ess)
        {
            Response.Write("exx1:" + ess.Message);
        }
    }

    protected void DataList1_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        try
        {
            string DOName = "";
            string docode = "";
            string getpasscode = "";

            System.Web.UI.WebControls.Image imgSign = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgSign");
            string imgurl = clsCommon.getString("Select ImagePath from tblSign where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            imgSign.ImageUrl = imgurl;

            Label lblCompany = (Label)e.Item.FindControl("lblCompany");
            lblCompany.Text = "M/S. " + Session["Company_Name"].ToString();
            Label lblAl1 = (Label)e.Item.FindControl("lblAl1");
            Label lblAl2 = (Label)e.Item.FindControl("lblAl2");
            Label lblAl3 = (Label)e.Item.FindControl("lblAl3");
            Label lblAl4 = (Label)e.Item.FindControl("lblAl4");
            Label lblOtherDetails = (Label)e.Item.FindControl("lblOtherDetails");

            #region Address
            string qry = "Select * from tblVoucherHeadAddress where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "";
            DataSet ds = new DataSet();
            ds = clsDAL.SimpleQuery(qry);
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add(new DataColumn("LeftAddress", typeof(string)));
                dt.Columns.Add(new DataColumn("MiddlePart", typeof(string)));
                dt.Columns.Add(new DataColumn("RightAddress", typeof(string)));

                string AL1 = ds.Tables[0].Rows[0]["AL1"].ToString();
                string AL2 = ds.Tables[0].Rows[0]["AL2"].ToString();
                string AL3 = ds.Tables[0].Rows[0]["AL3"].ToString();
                string AL4 = ds.Tables[0].Rows[0]["AL4"].ToString();
                string OtherDetails = ds.Tables[0].Rows[0]["Other"].ToString();

                string rnl = AL1.Replace("\n", "<br/>");
                var TabSpace = new String(' ', 4);
                string ab = rnl.Replace("\t", TabSpace);
                string la = ab.Replace(" ", "&nbsp;");
                lblAl1.Text = la;


                string rnl1 = AL2.Replace("\n", "<br/>");
                var TabSpace1 = new String(' ', 4);
                string ab1 = rnl1.Replace("\t", TabSpace1);
                string la1 = ab1.Replace(" ", "&nbsp;");
                lblAl2.Text = la1;

                string rnl2 = AL3.Replace("\n", "<br/>");
                var TabSpace2 = new String(' ', 4);
                string ab2 = rnl2.Replace("\t", TabSpace2);
                string la2 = ab2.Replace(" ", "&nbsp;");
                lblAl3.Text = la2;

                string rnl3 = AL4.Replace("\n", "<br/>");
                var TabSpace3 = new String(' ', 4);
                string ab3 = rnl3.Replace("\t", TabSpace2);
                string la3 = ab3.Replace(" ", "&nbsp;");
                lblAl4.Text = la3;

                string rnl4 = OtherDetails.Replace("\n", "<br/>");
                var TabSpace4 = new String(' ', 4);
                string ab4 = rnl4.Replace("\t", TabSpace2);
                string la4 = ab4.Replace(" ", "&nbsp;");
                lblOtherDetails.Text = la4;

            }
            #endregion


            Label lblDocNo = (Label)e.Item.FindControl("lblDocNo");
            Label lblCity = (Label)e.Item.FindControl("lblCity");
            string docno = lblDocNo.Text.ToString();
            qry = "select distinct *,Convert(varchar(10),doc_date,103) as doc_date1 from " + qryCommon + " where doc_no=" + docno + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + " and tran_type='" + trnType + "'";
            ds = new DataSet();
            ds = clsDAL.SimpleQuery(qry);
            if (ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    getpasscode = ds.Tables[0].Rows[0]["GETPASSCODE"].ToString();
                    DOName = ds.Tables[0].Rows[0]["DOName"].ToString();
                    if (!string.IsNullOrEmpty(DOName))
                    {
                        docode = clsCommon.getString("Select Ac_Code from " + tblPrefix + "AccountMaster where Ac_Name_E='" + DOName + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
                    }
                    //string TenderNo = ds.Tables[0].Rows[0]["purc_no"].ToString();
                    //int TenNo = TenderNo != string.Empty ? Convert.ToInt32(TenderNo) : 0;
                    //string TenderNarr = clsCommon.getString("select Narration from NT_1_qryTenderList where  Tender_No=" + TenNo + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + " ");
                    //Label lblTenderNar = (Label)e.Item.FindControl("lblTenderNar");
                }
            }
            //Label lblAddr = (Label)e.Item.FindControl("lblCompanyAddr");
            //Label lblName = (Label)e.Item.FindControl("lblCompanyName");
            //Label lblPhone = (Label)e.Item.FindControl("lblCompanyMobile");
            //if (DOName == "Self" || string.IsNullOrEmpty(DOName) || PO == "O")
            //{
            //    lblAddr.Text = clsGV.CompanyAddress;
            //    lblName.Text = Session["Company_Name"].ToString();
            //    lblPhone.Text = clsGV.CompanyPhone;
            //    lblCity.Text = clsCommon.getString("Select City_E from company where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //}
            //else
            //{
            //    lblName.Text = clsCommon.getString("Select Ac_Name_E from " + tblPrefix + "AccountMaster where Ac_Code='" + docode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string address = clsCommon.getString("Select Address_E from " + tblPrefix + "AccountMaster where Ac_Code='" + docode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string citycode = clsCommon.getString("Select City_Code from " + tblPrefix + "AccountMaster where Ac_Code='" + docode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string docity = clsCommon.getString("Select city_name_e from " + tblPrefix + "CityMaster where city_code='" + citycode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string dostate = clsCommon.getString("Select state from " + tblPrefix + "CityMaster where city_code='" + citycode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string parcity = clsCommon.getString("Select city_name_e from " + tblPrefix + "CityMaster where city_code='" + citycode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string pincode = clsCommon.getString("Select Pincode from " + tblPrefix + "AccountMaster where Ac_Code='" + docode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    lblCity.Text = "City: " + docity + " State: " + dostate + " Pin:&nbsp; " + pincode;
            //    lblAddr.Text = address + "<br/>" + docity;
            //    string phone = clsCommon.getString("Select OffPhone from " + tblPrefix + "AccountMaster where Ac_Code='" + docode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string mobile = clsCommon.getString("Select Mobile_No from " + tblPrefix + "AccountMaster where Ac_Code='" + docode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            //    string offPhone = string.Empty;
            //    string mob = string.Empty;
            //    if (!string.IsNullOrWhiteSpace(phone))
            //    {
            //        offPhone = "Office Ph.No:-" + phone;
            //    }
            //    if (!string.IsNullOrWhiteSpace(mobile))
            //    {
            //        mob = "Mobile:-" + mobile;
            //    }
            //    lblPhone.Text = offPhone + "  " + mob;
            //}
            Label lblWithExciseRate = (Label)e.Item.FindControl("lblWithExciseRate");
            Label lblExciseRate = (Label)e.Item.FindControl("lblExciseRate");
            Label lblGetpassCity = (Label)e.Item.FindControl("lblGetpassCity");
            string city = clsCommon.getString("select city_name_e from " + cityMasterTable + " where city_code=" + lblGetpassCity.Text + " and company_code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            string state = clsCommon.getString("select state from " + cityMasterTable + " where city_code=" + lblGetpassCity.Text + " and company_code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            string getpasspincode = clsCommon.getString("Select Pincode from " + tblPrefix + "AccountMaster where Ac_Code='" + getpasscode + "' and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()));
            lblGetpassCity.Text = "City: <b>" + city + "</b>&nbsp;&nbsp;&nbsp;State:<b>" + state + "</b>&nbsp;&nbsp;&nbsp;Pincode: <b>" + getpasspincode + "</b>";

            Label lblWithoutExcise = (Label)e.Item.FindControl("lblWithoutExcise");
            lblWithoutExcise.Text = (Convert.ToDouble(lblWithExciseRate.Text) - Convert.ToDouble(lblExciseRate.Text)).ToString();

            //Label lblMillEmail = (Label)e.Item.FindControl("lblMillEmail");
            //lblMillEmail.Text = millEmail;
            Label lblDOfrom = (Label)e.Item.FindControl("lblDOfrom");
            if (PO == "O")
            {
                lblDOfrom.Text = "<b>" + Session["Company_Name"].ToString() + "</b>";
            }
            else
            {
                lblDOfrom.Text = "<b>" + DOName + "</b>";
            }
            Label lblCompanyBottom = (Label)e.Item.FindControl("lblCompanyBottom");
            lblCompanyBottom.Text = "( " + Session["Company_Name"].ToString() + " )";

            string TenderNo = ds.Tables[0].Rows[0]["purc_no"].ToString();
            int TenNo = TenderNo != string.Empty ? Convert.ToInt32(TenderNo) : 0;
            string TenderNarr = clsCommon.getString("select Narration from NT_1_qryTenderList where  Tender_No=" + TenNo + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + " ");

            Label lblTenderNar = (Label)e.Item.FindControl("lblTenderNar");
            lblTenderNar.Text ="Tender Narration:"+ TenderNarr.ToString();
            string TenderDate = clsCommon.getString("select Tender_Date from NT_1_qryTenderList where  Tender_No=" + TenNo + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + " ");
            Label lblTenderDate = (Label)e.Item.FindControl("lblTenderDate");
            lblTenderDate.Text = "Tender Date:" + TenderDate.ToString();
        }
        catch (Exception ess1)
        {
            Response.Write("exx1:" + ess1.Message + " line=");
        }
    }

    protected void btnMail_Click(object sender, EventArgs e)
    {
        try
        {
            #region webclient
            //WebClient client = new WebClient();
            //Stream data = client.OpenRead(HttpContext.Current.Request.Url.AbsoluteUri);
            //StreamReader rd = new StreamReader(data);
            //string p = rd.ReadToEnd();

            //HttpWebRequest webReq = (HttpWebRequest)HttpWebRequest.Create(HttpContext.Current.Request.Url.AbsoluteUri);
            //try
            //{
            //    webReq.CookieContainer = new CookieContainer();
            //    webReq.Method = "GET";
            //    using (WebResponse response = webReq.GetResponse())
            //    {
            //        using (Stream stream = response.GetResponseStream())
            //        {
            //            StreamReader reader = new StreamReader(stream);
            //            string res = reader.ReadToEnd();
            //        }
            //    }
            //}
            //catch (Exception)
            //{
            //    throw;
            //}
            #endregion

            Label DoNo = (Label)DataList1.Items[0].FindControl("lblDocNo");
            Label Truck = (Label)DataList1.Items[0].FindControl("lblTruckNo");
            Label Qntl = (Label)DataList1.Items[0].FindControl("lblQntl");
            Label lblGetPassName = (Label)DataList1.Items[0].FindControl("lblGetPassName");
            string Do = Convert.ToString(DoNo.Text);
            string Truck_No = Convert.ToString(Truck.Text);
            string DOQntl = Convert.ToString(Qntl.Text);
            mail = txtEmail.Text;
            if (txtEmail.Text != string.Empty)
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    //StringBuilder sb = new StringBuilder();
                    //sb.Append("<!DOCTYPE html PUBLIC ?-//W3C//DTD XHTML 1.0 Transitional//EN? ?http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd?>");
                    //sb.Append("<html xmlns=?http://www.w3.org/1999/xhtml?><head runat=?server?>");
                    //sb.Append(clsGV.printcss);
                    //sb.Append("<script type=?text/javascript?>function print_invoice() {var printContents = document.getElementById(?pnl?).innerHTML;");
                    //sb.Append("var originalContents = document.body.innerHTML;document.body.innerHTML = printContents;window.print();");
                    //sb.Append("document.body.innerHTML = originalContents; }</script>");
                    //sb.Append("</head><body class=?printhalf?><form id=?form1? runat=?server?> <div align=?left?><input type=?button? onclick=?print_invoice();? id=?input? value=?Click Here For Print? /></div>");
                    //sb.Append("<div align=?center? style=?width:100%;?>");
                    //sb.Replace('?', '"');
                    //sb.Replace("../", "http://" + clsGV.Website + "/");
                    StringWriter sw = new StringWriter();
                    HtmlTextWriter tw = new HtmlTextWriter(sw);
                    pnl.RenderControl(tw);
                    string s = sw.ToString();
                    s = s.Replace("../Images", "http://" + clsGV.Website + "/Images");
                    //sb.Append(s);
                    //sb.Append("</div>");
                    //sb.Append("</form></body></html>");
                    //string a = sb.ToString();

                    byte[] array = Encoding.UTF8.GetBytes(s);
                    ms.Write(array, 0, array.Length);
                    ms.Seek(0, SeekOrigin.Begin);
                    ContentType contentType = new ContentType();
                    contentType.MediaType = MediaTypeNames.Application.Octet;
                    contentType.Name = "DeliveryOrder.htm";
                    Attachment attachment = new Attachment(ms, contentType);

                    string mailFrom = Session["EmailId"].ToString();
                    string smtpPort = "587";
                    string emailPassword = Session["EmailPassword"].ToString();
                    MailMessage msg = new MailMessage();
                    SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com", 587);
                    SmtpServer.Host = clsGV.Email_Address;
                    msg.From = new MailAddress(mailFrom);
                    msg.To.Add(mail);
                    msg.Body = "DO";
                    msg.Attachments.Add(attachment);
                    msg.IsBodyHtml = true;
                    msg.Subject = "DO.No:" + Do + " " + Truck_No + " Qt:" + DOQntl + " " + lblGetPassName.Text;
                    msg.IsBodyHtml = true;
                    if (smtpPort != string.Empty)
                    {
                        SmtpServer.Port = Convert.ToInt32(smtpPort);
                    }
                    SmtpServer.EnableSsl = true;
                    SmtpServer.DeliveryMethod = SmtpDeliveryMethod.Network;
                    SmtpServer.UseDefaultCredentials = false;
                    SmtpServer.Credentials = new System.Net.NetworkCredential(mailFrom, emailPassword);
                    System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate(object k,
                        System.Security.Cryptography.X509Certificates.X509Certificate certificate,
                        System.Security.Cryptography.X509Certificates.X509Chain chain,
                        System.Net.Security.SslPolicyErrors sslPolicyErrors)
                    {
                        return true;
                    };
                    SmtpServer.Send(msg);
                }
            }
        }
        catch (Exception e1)
        {
            Response.Write("mail err:" + e1);
            return;
        }
        Response.Write("<script>alert('Mail sent successfully');</script>");
    }

    private void CreateHtml()
    {
    }

    public void CreatePDFFromHTMLFile(string HtmlStream, string FileName)
    {

    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        StringBuilder StrHtmlGenerate = new StringBuilder();
        StringBuilder StrExport = new StringBuilder();
        StrExport.Append(@"<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'><head><title>Time</title>");
        StrExport.Append(@"<body lang=EN-US style='mso-element:header' id=h1><span style='mso--code:DATE'></span><div class=Section1>");
        StrExport.Append("<DIV  style='font-size:12px;'>");
        StringWriter sw = new StringWriter();
        HtmlTextWriter tw = new HtmlTextWriter(sw);
        pnl.RenderControl(tw);
        string sim = sw.ToString();
        StrExport.Append(sim);
        StrExport.Append("</div></body></html>");
        string strFile = "report.xls";
        string strcontentType = "application/excel";
        Response.ClearContent();
        Response.ClearHeaders();
        Response.BufferOutput = true;
        Response.ContentType = strcontentType;
        Response.AddHeader("Content-Disposition", "attachment; filename=" + strFile);
        Response.Write(StrExport.ToString());
        Response.Flush();
        Response.Close();
        Response.End();
    }

    protected void btnPrePrinted_Click(object sender, EventArgs e)
    {
        try
        {
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void btnPDfDownload_Click(object sender, EventArgs e)
    {
        //#region[comment]
        ////try
        ////{

        ////    Response.ContentType = "application/pdf";
        ////    Response.AddHeader("content-disposition", "attachment;filename=Panel.pdf");
        ////    Response.Cache.SetCacheability(HttpCacheability.NoCache);

        ////    StringWriter sw = new StringWriter();
        ////    HtmlTextWriter hw = new HtmlTextWriter(sw);
        ////    DataList1.RenderControl(hw);
        ////    string s1 = sw.ToString().Replace("font-size: medium", "font-size: x-small");
        ////    //StringReader sr = new StringReader(s1.ToString());
        ////    StringReader sr = new StringReader(s1.ToString().Replace("../Images", Server.MapPath("~/Images")));

        ////    Document pdfDoc = new Document(iTextSharp.text.PageSize.A4);
        ////    var writer = PdfWriter.GetInstance(pdfDoc, Response.OutputStream);

        ////    pdfDoc.Open();
        ////    XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
        ////    pdfDoc.Close();
        ////    Response.Write(pdfDoc);
        ////    Response.End();
        ////}
        ////catch
        ////{
        ////}
        //#endregion

        //#region[comment]
        ////try
        ////{
        ////    if (txtEmail.Text != string.Empty)
        ////    {
        ////        Label DoNo = (Label)DataList1.Items[0].FindControl("lblDocNo");
        ////        Label Truck = (Label)DataList1.Items[0].FindControl("lblTruckNo");
        ////        Label Qntl = (Label)DataList1.Items[0].FindControl("lblQntl");
        ////        Label lblGetPassName = (Label)DataList1.Items[0].FindControl("lblGetPassName");
        ////        string Do = Convert.ToString(DoNo.Text);
        ////        string Truck_No = Convert.ToString(Truck.Text);
        ////        string DOQntl = Convert.ToString(Qntl.Text);
        ////        mail = txtEmail.Text;
        ////        string fileName = "DeliveryOrder_" + Do + ".pdf";
        ////        string filepath = "~/PAN/" + fileName;
        ////        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        ////        StringWriter sw1 = new StringWriter();
        ////        HtmlTextWriter hw = new HtmlTextWriter(sw1);
        ////        DataList1.RenderControl(hw);
        ////        string s1 = sw1.ToString().Replace("font-size: medium", "font-size: x-small");
        ////        StringReader sr = new StringReader(s1.ToString().Replace("../Images", Server.MapPath("~/Images")));
        ////        Document pdfDoc = new Document(iTextSharp.text.PageSize.A4);
        ////        var writer = PdfWriter.GetInstance(pdfDoc, new FileStream(Server.MapPath(filepath), FileMode.Create));
        ////        Font tblfont = new Font();
        ////        pdfDoc.Open();
        ////        XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
        ////        pdfDoc.Close();

        ////        ContentType contentType = new ContentType();
        ////        contentType.MediaType = MediaTypeNames.Application.Pdf;
        ////        contentType.Name = "DeliveryOrder";
        ////        Attachment attachment = new Attachment(Server.MapPath(filepath), contentType);

        ////        string mailFrom = Session["EmailId"].ToString();
        ////        string smtpPort = "587";
        ////        string emailPassword = Session["EmailPassword"].ToString();
        ////        MailMessage msg = new MailMessage();
        ////        SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com", 587);
        ////        SmtpServer.Host = clsGV.Email_Address;
        ////        msg.From = new MailAddress(mailFrom);
        ////        msg.To.Add(mail);
        ////        msg.Body = "DO";
        ////        msg.Attachments.Add(attachment);
        ////        msg.IsBodyHtml = true;
        ////        msg.Subject = "DO.No:" + Do + " " + Truck_No + " Qt:" + DOQntl + " " + lblGetPassName.Text;
        ////        msg.IsBodyHtml = true;
        ////        if (smtpPort != string.Empty)
        ////        {
        ////            SmtpServer.Port = Convert.ToInt32(smtpPort);
        ////        }
        ////        SmtpServer.EnableSsl = true;
        ////        SmtpServer.DeliveryMethod = SmtpDeliveryMethod.Network;
        ////        SmtpServer.UseDefaultCredentials = false;
        ////        SmtpServer.Credentials = new System.Net.NetworkCredential(mailFrom, emailPassword);
        ////        System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate(object k,
        ////            System.Security.Cryptography.X509Certificates.X509Certificate certificate,
        ////            System.Security.Cryptography.X509Certificates.X509Chain chain,
        ////            System.Net.Security.SslPolicyErrors sslPolicyErrors)
        ////        {
        ////            return true;
        ////        };
        ////        SmtpServer.Send(msg);
        ////        attachment.Dispose();
        ////        if (File.Exists(Server.MapPath(filepath)))
        ////        {
        ////            File.Delete(Server.MapPath(filepath));
        ////        }
        ////    }
        ////}
        ////catch (Exception e1)
        ////{
        ////    Response.Write("mail err:" + e1);
        ////    return;
        ////}
        ////Response.Write("<script>alert('Mail sent successfully');</script>");
        //#endregion


        //#region[comment]
        //try
        //{
        //    if (txtEmail.Text != string.Empty)
        //    {
        //        Label DoNo = (Label)DataList1.Items[0].FindControl("lblDocNo");
        //        Label Truck = (Label)DataList1.Items[0].FindControl("lblTruckNo");
        //        Label Qntl = (Label)DataList1.Items[0].FindControl("lblQntl");
        //        Label lblGetPassName = (Label)DataList1.Items[0].FindControl("lblGetPassName");
        //        string Do = Convert.ToString(DoNo.Text);
        //        string Truck_No = Convert.ToString(Truck.Text);
        //        string DOQntl = Convert.ToString(Qntl.Text);

        //        //if (txttransportemilid.Text != string.Empty)
        //        //{
        //        //    email = txtEmail.Text.ToString() + "," + txttransportemilid.Text.ToString();
        //        //    email = email.TrimEnd(',');
        //        //    //email = email.Trim(',');
        //        //}
        //        //else
        //        //{
        //        //    email = txtEmail.Text.ToString();
        //        //    email = email.TrimEnd(',');
        //        //}

        //        email = txtEmail.Text;
        //        string fileName = "DeliveryOrder_" + Do + ".pdf";
        //        string filepath = "~/PAN/" + fileName;
        //        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        //        StringWriter sw1 = new StringWriter();
        //        HtmlTextWriter hw = new HtmlTextWriter(sw1);
        //        pnl.RenderControl(hw);
        //        string s1 = sw1.ToString().Replace("font-size: medium", "font-size: xx-small");
        //        StringReader sr = new StringReader(s1.ToString().Replace("../Images", Server.MapPath("~/Images")));
        //       // Document pdfDoc = new Document(iTextSharp.text.PageSize.A4);
        //        Document pdfDoc = new Document(iTextSharp.text.PageSize.A4, 30f, 10f, 30f, 20f);
        //        var writer = PdfWriter.GetInstance(pdfDoc, new FileStream(Server.MapPath(filepath), FileMode.Create));
        //        Font tblfont = new Font();
        //        pdfDoc.Open();
        //        XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
        //        pdfDoc.Close();

        //        ContentType contentType = new ContentType();
        //        contentType.MediaType = MediaTypeNames.Application.Pdf;
        //        contentType.Name = "DeliveryOrder";
        //        Attachment attachment = new Attachment(Server.MapPath(filepath), contentType);

        //        string mailFrom = Session["EmailId"].ToString();
        //        string smtpPort = "587";
        //        string emailPassword = Session["EmailPassword"].ToString();
        //        MailMessage msg = new MailMessage();
        //        SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com", 587);
        //        SmtpServer.Host = clsGV.Email_Address;
        //        msg.From = new MailAddress(mailFrom);
        //        msg.To.Add(email);
        //        msg.Body = "DO";
        //        msg.Attachments.Add(attachment);
        //        msg.IsBodyHtml = true;
        //        msg.Subject = "DO.No:" + Do + " " + Truck_No + " Qt:" + DOQntl + " " + lblGetPassName.Text;
        //        msg.IsBodyHtml = true;
        //        if (smtpPort != string.Empty)
        //        {
        //            SmtpServer.Port = Convert.ToInt32(smtpPort);
        //        }
        //        SmtpServer.EnableSsl = true;
        //        SmtpServer.DeliveryMethod = SmtpDeliveryMethod.Network;
        //        SmtpServer.UseDefaultCredentials = false;
        //        SmtpServer.Credentials = new System.Net.NetworkCredential(mailFrom, emailPassword);
        //        System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate(object k,
        //            System.Security.Cryptography.X509Certificates.X509Certificate certificate,
        //            System.Security.Cryptography.X509Certificates.X509Chain chain,
        //            System.Net.Security.SslPolicyErrors sslPolicyErrors)
        //        {
        //            return true;
        //        };
        //        SmtpServer.Send(msg);
        //        attachment.Dispose();
        //        if (File.Exists(Server.MapPath(filepath)))
        //        {
        //            File.Delete(Server.MapPath(filepath));
        //        }
        //    }
        //}
        //catch (Exception e1)
        //{
        //    Response.Write("mail err:" + e1);
        //    return;
        //}
        //Response.Write("<script>alert('Mail sent successfully');</script>");
        //#endregion


        try
        {
            if (txtEmail.Text != string.Empty)
            {
                Label DoNo = (Label)DataList1.Items[0].FindControl("lblDocNo");
                Label Truck = (Label)DataList1.Items[0].FindControl("lblTruckNo");
                Label Qntl = (Label)DataList1.Items[0].FindControl("lblQntl");
                Label lblGetPassName = (Label)DataList1.Items[0].FindControl("lblGetPassName");
                string Do = Convert.ToString(DoNo.Text);
                string Truck_No = Convert.ToString(Truck.Text);
                string DOQntl = Convert.ToString(Qntl.Text);

                mail = txtEmail.Text;
                string fileName = "DeliveryOrder_" + Do + ".pdf";
                string filepath = "~/PAN/" + fileName;
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                StringWriter sw1 = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw1);
                DataList1.RenderControl(hw);
                string s1 = sw1.ToString().Replace("font-size: medium", "font-size: xx-small");
                string s2 = s1.ToString().Replace("height:25%;", "height:80%;");
                StringReader sr = new StringReader(s2.ToString().Replace("../Images", Server.MapPath("~/Images")));
                Document pdfDoc = new Document(iTextSharp.text.PageSize.A4);
                var writer = PdfWriter.GetInstance(pdfDoc, new FileStream(Server.MapPath(filepath), FileMode.Create));
                Font tblfont = new Font();
                pdfDoc.Open();
                XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
                pdfDoc.Close();

                ContentType contentType = new ContentType();
                contentType.MediaType = MediaTypeNames.Application.Pdf;
                contentType.Name = "DeliveryOrder";
                Attachment attachment = new Attachment(Server.MapPath(filepath), contentType);

                string mailFrom = Session["EmailId"].ToString();
                string smtpPort = "587";
                string emailPassword = Session["EmailPassword"].ToString();
                MailMessage msg = new MailMessage();
                SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com", 587);
                SmtpServer.Host = clsGV.Email_Address;
                msg.From = new MailAddress(mailFrom);
                msg.To.Add(mail);
                msg.Body = "DO";
                msg.Attachments.Add(attachment);
                msg.IsBodyHtml = true;
                msg.Subject = "DO.No:" + Do + " " + Truck_No + " Qt:" + DOQntl + " " + lblGetPassName.Text;
                msg.IsBodyHtml = true;
                if (smtpPort != string.Empty)
                {
                    SmtpServer.Port = Convert.ToInt32(smtpPort);
                }
                SmtpServer.EnableSsl = true;
                SmtpServer.DeliveryMethod = SmtpDeliveryMethod.Network;
                SmtpServer.UseDefaultCredentials = false;
                SmtpServer.Credentials = new System.Net.NetworkCredential(mailFrom, emailPassword);
                System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate(object k,
                    System.Security.Cryptography.X509Certificates.X509Certificate certificate,
                    System.Security.Cryptography.X509Certificates.X509Chain chain,
                    System.Net.Security.SslPolicyErrors sslPolicyErrors)
                {
                    return true;
                };
                SmtpServer.Send(msg);
                attachment.Dispose();
                if (File.Exists(Server.MapPath(filepath)))
                {
                    File.Delete(Server.MapPath(filepath));
                }
            }
            Response.Write("<script>alert('Mail sent successfully');</script>");

        }
        catch (Exception e1)
        {
            Response.Write("mail err:" + e1);
            return;
        }
    }
}
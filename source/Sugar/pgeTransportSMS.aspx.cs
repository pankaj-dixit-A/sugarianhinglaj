﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text.RegularExpressions;

public partial class Sugar_pgeTransportSMS : System.Web.UI.Page
{
    string tblPrefix = string.Empty;
    string qry = string.Empty;
    DataSet ds;
    DataTable dt;
    string user = string.Empty;
    string isAuthenticate = string.Empty;
    int k = 0;
    static WebControl objAsp = null;
    string searchString = string.Empty;
    string strTextbox = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        tblPrefix = Session["tblPrefix"].ToString();
        user = Session["user"].ToString();
        if (!Page.IsPostBack)
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();

            isAuthenticate = Security.Authenticate(tblPrefix, user);
            string User_Type = clsCommon.getString("Select User_Type from tblUser WHERE User_Name='" + user + "'");
            if (isAuthenticate == "1" || User_Type == "A")
            {

            }
            else
            {
                Response.Redirect("~/UnAuthorized/Unauthorized_User.aspx", false);
            }
        }
    }

    protected void btnGetTransport_Click(object sender, EventArgs e)
    {
        qry = " select s.millname,a.CityName,s.balance from qrysugarBalancestock s  left outer join " + tblPrefix + "qryAccountsList a on s.Buyer=a.Ac_Code and s.Company_Code=a.Company_Code" +
           " where buyer!=2 and balance!=0 and s.Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and s.Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + "  group by s.millname,a.CityName,s.balance order by s.millname";
        ds = new DataSet();
        ds = clsDAL.SimpleQuery(qry);
        if (ds != null)
        {
            dt = new DataTable();
            dt.Columns.Add(new DataColumn("millname", typeof(string)));
            dt.Columns.Add(new DataColumn("CityName", typeof(string)));
            dt.Columns.Add(new DataColumn("balance", typeof(double)));
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    DataRow dr = dt.NewRow();
                    dr["millname"] = ds.Tables[0].Rows[i]["millname"].ToString();
                    dr["CityName"] = ds.Tables[0].Rows[i]["CityName"].ToString();
                    dr["balance"] = ds.Tables[0].Rows[i]["balance"].ToString();
                    dt.Rows.Add(dr);
                }
                if (dt.Rows.Count > 0)
                {
                    grdDetails.DataSource = dt;
                    grdDetails.DataBind();
                }
                else
                {
                    grdDetails.DataSource = null;
                    grdDetails.DataBind();
                }
            }
        }
        else
        {
            grdDetails.DataSource = null;
            grdDetails.DataBind();
        }
    }

    protected void chkAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkAll = (CheckBox)grdDetails.HeaderRow.Cells[3].FindControl("chkAll");
        if (chkAll.Checked == true)
        {
            foreach (GridViewRow gr in grdDetails.Rows)
            {
                CheckBox grdCB = (CheckBox)gr.Cells[3].FindControl("grdCB");
                grdCB.Checked = true;
            }
            grdCB_CheckedChanged(sender, e);
        }
        else
        {
            foreach (GridViewRow gr in grdDetails.Rows)
            {
                CheckBox grdCB = (CheckBox)gr.Cells[3].FindControl("grdCB");
                grdCB.Checked = false;
            }
            grdCB_CheckedChanged(sender, e);
        }
    }

    protected void grdCB_CheckedChanged(object sender, EventArgs e)
    {
        string msgText = "";
        CheckBox grdCB = (CheckBox)sender;
        GridViewRow row = (GridViewRow)grdCB.NamingContainer;
        SetFocus(grdCB);
        if (grdDetails.Rows.Count > 0)
        {
            for (int i = 0; i < grdDetails.Rows.Count; i++)
            {
                CheckBox chk = (CheckBox)grdDetails.Rows[i].Cells[3].FindControl("grdCB");
                if (chk.Checked == true)
                {
                    string mill = grdDetails.Rows[i].Cells[0].Text;
                    string city = Server.HtmlDecode(grdDetails.Rows[i].Cells[1].Text);
                    if (!msgText.Contains(mill))
                    {
                        k++;
                        if (!string.IsNullOrWhiteSpace(city))
                        {
                            msgText = msgText + " " + k + " " + mill + "-" + city;
                        }
                    }
                    else
                    {
                        if (!string.IsNullOrWhiteSpace(city))
                        {
                            msgText = msgText + "," + city;
                        }
                    }
                }
            }
            txtMessage.Text = msgText;
        }
    }

    public string displayMembers(List<String> message)
    {
        foreach (String s in message)
        {
            return s.ToString();
        }
        return null;
    }

    #region [txtSearchText_TextChanged]
    protected void txtSearchText_TextChanged(object sender, EventArgs e)
    {
        try
        {
            if (hdnfClosePopup.Value == "Close")
            {
                txtSearchText.Text = string.Empty;
                pnlPopup.Style["display"] = "none";
                grdPopup.DataSource = null;
                grdPopup.DataBind();
                if (objAsp != null)
                    System.Web.UI.ScriptManager.GetCurrent(this).SetFocus(objAsp);
            }
            else
            {
                pnlPopup.Style["display"] = "block";
                searchString = txtSearchText.Text;
                strTextbox = hdnfClosePopup.Value;
                setFocusControl(btnSearch);
            }
        }
        catch
        {
        }
    }
    #endregion
    protected void grdDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[0].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[1].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[2].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[3].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[3].Width = new Unit("30px");
        }
    }
    protected void grdAccounts_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Width = new Unit("100px");
                e.Row.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                e.Row.Cells[1].Width = new Unit("400px");
                e.Row.Cells[2].Width = new Unit("200px");
            }
        }
        catch (Exception)
        {
            throw;
        }
    }
    protected void btnClick_Click(object sender, EventArgs e)
    { }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            if (searchString != string.Empty && strTextbox == hdnfClosePopup.Value)
            {
                txtSearchText.Text = searchString;
            }
            else
            {
                txtSearchText.Text = txtSearchText.Text;
            }

            if (hdnfClosePopup.Value == "txtSmsGroup")
            {
                lblPopupHead.Text = "--Select Group--";
                string qry = "select System_Code as [Group Code], System_Name_E as [System Name] from " + tblPrefix + "SystemMaster  where (System_Code like '%" + txtSearchText.Text + "%' or System_Name_E like '%" + txtSearchText.Text + "%') and Company_Code='" + Convert.ToInt32(Session["Company_Code"].ToString()) + "' and Year_Code='" + Convert.ToInt32(Session["year"].ToString()) + "' and System_Type='G'";
                this.showPopup(qry);
            }
            if (hdnfClosePopup.Value == "txtAc_Code")
            {
                pnlPopup.Style["display"] = "block";
                lblPopupHead.Text = "--Select Account--";
                string qry = "";
                if (txtSmsGroup.Text != string.Empty)
                {
                    qry = "select a.Ac_Code,b.Ac_Name_E from " + tblPrefix + "AcGroups a left outer join " + tblPrefix + "AccountMaster b on a.Ac_Code=b.Ac_Code and a.Company_Code=b.Company_Code" +
                        " where (a.Ac_Code like '%" + txtSearchText.Text + "%' or b.Ac_Name_E like '%" + txtSearchText.Text + "%') and a.Group_Code=" + txtSmsGroup.Text + " and a.Company_Code='" + Convert.ToInt32(Session["Company_Code"].ToString()) + "'";
                }
                else
                {
                    qry = "select Ac_Code as [Account Code], Ac_Name_E as [Account Name],Short_Name as [Short Name] from " + tblPrefix + "AccountMaster where (Ac_Code like '%" + txtSearchText.Text + "%' or Ac_Name_E like '%" + txtSearchText.Text + "%' or Short_Name like '%" + txtSearchText.Text + "%') and Company_Code='" + Convert.ToInt32(Session["Company_Code"].ToString()) + "'";
                }
                this.showPopup(qry);
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    private void showPopup(string qry)
    {
        try
        {
            this.setFocusControl(txtSearchText);
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            ds = clsDAL.SimpleQuery(qry);
            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        grdPopup.DataSource = dt;
                        grdPopup.DataBind();
                        hdHelpPageCount.Value = grdPopup.PageCount.ToString();
                    }
                    else
                    {
                        grdPopup.DataSource = null;
                        grdPopup.DataBind();
                        hdHelpPageCount.Value = "0";
                    }
                }
            }
        }
        catch
        {

        }
    }

    protected void grdPopup_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdPopup.PageIndex = e.NewPageIndex;
        this.btnSearch_Click(sender, e);

    }

    #region [imgBtnClose_Click]
    protected void imgBtnClose_Click(object sender, EventArgs e)
    {
        try
        {
            //if (hdnfClosePopup.Value == "txtAC_CODE")
            //{
            //    setFocusControl();
            //}

            if (hdnfClosePopup.Value == "txtSmsGroup")
            {
                setFocusControl(txtSmsGroup);
            }


            hdnfClosePopup.Value = "Close";
            pnlPopup.Style["display"] = "none";
            txtSearchText.Text = string.Empty;
            grdPopup.DataSource = null;
            grdPopup.DataBind();
        }
        catch
        {
        }
    }
    #endregion

    #region [setFocusControl]
    private void setFocusControl(WebControl wc)
    {
        objAsp = wc;
        System.Web.UI.ScriptManager.GetCurrent(this).SetFocus(wc);
    }
    #endregion

    #region [grdPopup_RowCreated]
    protected void grdPopup_RowCreated(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow &&
            (e.Row.RowState == DataControlRowState.Normal ||
           e.Row.RowState == DataControlRowState.Alternate))
            {
                //foreach (TableCell cell in e.Row.Cells)
                //{
                //    cell.Style.Add("width", "100px");
                //}

                e.Row.TabIndex = -1;
                e.Row.Attributes["onclick"] = string.Format("javascript:SelectRow(this, {0});", e.Row.RowIndex);
                e.Row.Attributes["onkeydown"] = "javascript:return SelectSibling(event);";
                e.Row.Attributes["onselectstart"] = "javascript:return false;";
                // e.Row.Attributes["onkeyup"] = "javascript:return selectRow(event);";
            }
        }
        catch
        {
            throw;
        }
    }
    #endregion

    #region [grdPopup_RowDataBound]
    protected void grdPopup_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        string v = hdnfClosePopup.Value;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[0].Width = new Unit("100px");
            e.Row.Cells[1].Width = new Unit("400px");
        }
    }
    #endregion
    protected void txtSmsGroup_TextChanged(object sender, EventArgs e)
    {
        try
        {
            if (txtSmsGroup.Text != string.Empty)
            {
                searchString = txtSmsGroup.Text;
                strTextbox = "txtSmsGroup";
                bool a = clsCommon.isStringIsNumeric(txtSmsGroup.Text);
                if (a == false)
                {
                    btntxtSmsGroup_Click(this, new EventArgs());
                }
                else
                {
                    string str = clsCommon.getString("select System_Name_E from " + tblPrefix + "SystemMaster where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Year_Code=" + Convert.ToInt32(Session["year"].ToString()) + " and System_Code=" + txtSmsGroup.Text + " and System_Type='G'");
                    if (str != string.Empty)
                    {
                        lblGroupName.Text = str;
                        setFocusControl(txtAc_Code);
                        pnlPopup.Style["display"] = "none";
                    }
                    else
                    {
                        txtSmsGroup.Text = string.Empty;
                        lblSmsgroup.Text = string.Empty;
                    }
                }
            }
        }
        catch
        {
        }
    }
    protected void btntxtSmsGroup_Click(object sender, EventArgs e)
    {
        try
        {
            pnlPopup.Style["display"] = "block";
            hdnfClosePopup.Value = "txtSmsGroup";
            btnSearch_Click(sender, e);
        }
        catch (Exception)
        {
            throw;
        }
    }
    protected void txtAc_Code_TextChanged(object sender, EventArgs e)
    {
        try
        {
            if (txtAc_Code.Text != string.Empty)
            {
                searchString = txtAc_Code.Text;
                strTextbox = "txtAc_Code";

                bool a = clsCommon.isStringIsNumeric(txtAc_Code.Text);
                if (a == false)
                {
                    btntxtAc_Code_Click(this, new EventArgs());
                }
                else
                {
                    string str = clsCommon.getString("select Ac_Name_E from " + tblPrefix + "AccountMaster where Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + " and Ac_Code=" + txtAc_Code.Text);
                    if (str != string.Empty)
                    {
                        lblAc_Name.Text = str;
                        setFocusControl(btnAddNames);
                        pnlPopup.Style["display"] = "none";
                    }
                    else
                    {
                        txtAc_Code.Text = string.Empty;
                        lblAc_Name.Text = string.Empty;
                    }
                }
            }
        }
        catch
        {
        }
    }

    protected void btntxtAc_Code_Click(object sender, EventArgs e)
    {
        try
        {
            pnlPopup.Style["display"] = "block";
            hdnfClosePopup.Value = "txtAc_Code";
            btnSearch_Click(sender, e);
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void btnAddNames_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtAc_Code.Text == string.Empty)
            {
                setFocusControl(txtAc_Code);
                return;
            }
            DataTable dtGrid = new DataTable();
            dtGrid.Columns.Add(new DataColumn("Ac_Code", typeof(string)));
            dtGrid.Columns.Add(new DataColumn("Ac_Name", typeof(string)));
            dtGrid.Columns.Add(new DataColumn("Mobile", typeof(string)));
            dtGrid.Columns.Add(new DataColumn("IsChecked", typeof(bool)));
            if (grdAccounts.Rows.Count > 0)
            {
                for (int i = 0; i < grdAccounts.Rows.Count; i++)
                {
                    DataRow dr = dtGrid.NewRow();
                    dr["Ac_Code"] = grdAccounts.Rows[i].Cells[0].Text.ToString();
                    dr["Ac_Name"] = grdAccounts.Rows[i].Cells[1].Text.ToString();
                    TextBox txtMobile = (TextBox)grdAccounts.Rows[i].Cells[2].FindControl("txtMobile");
                    dr["Mobile"] = txtMobile.Text;

                    CheckBox chkCheck = (CheckBox)grdAccounts.Rows[i].Cells[3].FindControl("chkCheck");
                    if (chkCheck.Checked == true)
                    {
                        dr["IsChecked"] = true;
                    }
                    else
                    {
                        dr["IsChecked"] = false;
                    }
                    dtGrid.Rows.Add(dr);
                }
            }
            qry = "Select Ac_Code,Ac_Name_E,Mobile_No from " + tblPrefix + "AccountMaster where Ac_Code=" + txtAc_Code.Text + " and Company_Code=" + Convert.ToInt32(Session["Company_Code"].ToString()) + "";
            ds = new DataSet();
            ds = clsDAL.SimpleQuery(qry);
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    DataRow dr2 = dtGrid.NewRow();
                    dr2["Ac_Code"] = ds.Tables[0].Rows[j]["Ac_Code"].ToString();
                    dr2["Ac_Name"] = ds.Tables[0].Rows[j]["Ac_Name_E"].ToString();
                    dr2["Mobile"] = ds.Tables[0].Rows[j]["Mobile_No"].ToString();
                    dr2["IsChecked"] = false;
                    dtGrid.Rows.Add(dr2);
                }

                if (dtGrid.Rows.Count > 0)
                {
                    grdAccounts.DataSource = dtGrid;
                    grdAccounts.DataBind();
                    txtAc_Code.Text = "";
                    lblAc_Name.Text = "";
                    setFocusControl(txtAc_Code);
                }
            }

        }
        catch (Exception)
        {
            throw;
        }
    }
    protected void btnSendSms_Click(object sender, EventArgs e)
    {
        try
        {

            if (grdAccounts.Rows.Count > 0)
            {
                string msg = txtMessage.Text;
                for (int i = 0; i < grdAccounts.Rows.Count; i++)
                {
                    TextBox txtMobile = (TextBox)grdAccounts.Rows[i].Cells[2].FindControl("txtMobile");
                    CheckBox chkCheck = (CheckBox)grdAccounts.Rows[i].Cells[3].FindControl("chkCheck");
                    if (chkCheck.Checked == true)
                    {
                        if (txtMobile.Text != string.Empty)
                        {
                            string API = clsGV.msgAPI + "mobile=" + txtMobile.Text + "&message=" + msg;
                            clsCommon.apicall(API);
                        }
                    }
                }
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ks", "javascript:alert('Message Sent Successfully!')", true);
            }
        }
        catch (Exception)
        {
            throw;
        }
    }
}
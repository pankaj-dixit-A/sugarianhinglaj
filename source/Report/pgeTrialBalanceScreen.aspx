﻿<%@ Page Title="Trial Balance Screen" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" EnableEventValidation="false" CodeFile="pgeTrialBalanceScreen.aspx.cs"
    Inherits="Report_pgeTrialBalanceScreen" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="../JS/DateValidation.js">
    </script>
    <script type="text/javascript" language="javascript">
        function sp(accode, fromdt, todt, DrCr) {
            var tn;
            window.open('rptLedger.aspx?accode=' + accode + '&fromdt=' + fromdt + '&todt=' + todt + '&DrCr=' + DrCr);    //R=Redirected  O=Original
        }
    </script>
    <script language="javascript" type="text/javascript">
        document.body.style.cursor = 'pointer';
        var oldColor = '';

        function ChangeRowColor(rowID) {
            var color = document.getElementById(rowID).style.backgroundColor;
            if (color != 'yellow')
                oldColor = color;
            if (color == 'yellow')
                document.getElementById(rowID).style.backgroundColor = oldColor;
            else document.getElementById(rowID).style.backgroundColor = 'yellow';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <fieldset style="border-top: 1px dotted rgb(131, 127, 130); border-radius: 3px; width: 90%;
        margin-left: 30px; float: left; border-bottom: 0px; padding-top: 0px; padding-bottom: 10px;
        border-left: 0px; border-right: 0px; height: 7px;">
        <legend style="text-align: center;">
            <asp:Label ID="label1" runat="server" Text="   Trial Balance Screen   " Font-Names="verdana"
                ForeColor="White" Font-Bold="true" Font-Size="12px"></asp:Label></legend>
    </fieldset>
    <table width="80%" align="center" cellspacing="10">
        <tr>
            <td align="left">
                Upto Date:
            </td>
            <td>
                <asp:TextBox ID="txtDate" runat="server" CssClass="txt" Width="80px" Height="24px"
                    MaxLength="10" onkeyup="ValidateDate(this,event.keyCode)" onkeydown="return DateFormat(this,event.keyCode)"> </asp:TextBox>
                <asp:Image ID="imgcalender" runat="server" ImageUrl="~/Images/calendar_icon1.png"
                    Width="25px" Height="15px" />
                <ajax1:CalendarExtender ID="calenderExtendertxtFromDt" runat="server" TargetControlID="txtDate"
                    PopupButtonID="imgcalender" Format="dd/MM/yyyy">
                </ajax1:CalendarExtender>
            </td>
            <td align="left">
                Type:&nbsp;<asp:DropDownList ID="drpType" runat="server" Width="200px" Height="25px"
                    CssClass="ddl">
                    <asp:ListItem Text="All" Value="A" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Party" Value="P"></asp:ListItem>
                    <asp:ListItem Text="Supplier" Value="S"></asp:ListItem>
                    <asp:ListItem Text="Bank" Value="B"></asp:ListItem>
                    <asp:ListItem Text="Cash" Value="C"></asp:ListItem>
                    <asp:ListItem Text="Relative" Value="R"></asp:ListItem>
                    <asp:ListItem Text="Fixed Assets" Value="F"></asp:ListItem>
                    <asp:ListItem Text="Interest Party" Value="I"></asp:ListItem>
                    <asp:ListItem Text="Income/Expenses" Value="E"></asp:ListItem>
                    <asp:ListItem Text="Trading" Value="O"></asp:ListItem>
                    <asp:ListItem Text="Mill" Value="M"></asp:ListItem>
                    <asp:ListItem Text="Transport" Value="T"></asp:ListItem>
                    <asp:ListItem Text="Broker" Value="BR"></asp:ListItem>
                </asp:DropDownList>
            </td>
            <td colspan="2">
                <asp:Button ID="btnGet" runat="server" CssClass="btnHelp" Text="Get Data" Width="80px"
                    CommandName="DrCr" OnCommand="Command_Click" Height="24px" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnOnlyDr" runat="server" CssClass="btnHelp" Text="Only Dr" Width="80px"
                    Height="24px" CommandName="Dr" OnCommand="Command_Click" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnOnlyCr" runat="server" CssClass="btnHelp" Text="Only Cr" Width="80px"
                    Height="24px" CommandName="Cr" OnCommand="Command_Click" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnSendSMS" runat="server" CssClass="btnHelp" Text="Send" Width="80px"
                    OnClick="btnSendSMS_Click" Height="24px" />
                &nbsp;&nbsp;&nbsp;<asp:Button ID="btnExportToExcel" runat="server" CssClass="btnHelp"
                    Text="Export To Excel" Width="120px" OnClick="btnExportToExcel_Click" Height="24px" />
                
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
            </td>
            <td align="right">
                <b>From (Rs):</b>
                <asp:TextBox runat="server" ID="txtFromRs" CssClass="txt" Width="80px" Height="24px"></asp:TextBox>&nbsp;<b>To</b>&nbsp;<asp:TextBox
                    runat="server" ID="txtToRs" CssClass="txt" Width="80px" Height="24px"></asp:TextBox>
            </td>
            <td align="left">
                &nbsp;<b>Filter:</b>&nbsp;<asp:DropDownList runat="server" ID="drpFilter" CssClass="ddl"
                    Width="120px" AutoPostBack="true" Height="24px" OnSelectedIndexChanged="drpFilter_SelectedIndexChanged">
                    <asp:ListItem Text="--Select Filter--" Value="0" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Debit" Value="D"></asp:ListItem>
                    <asp:ListItem Text="Credit" Value="C"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
    </table>
    <br />
    <asp:Panel ID="pnlGrid" runat="server" Width="1200px" Height="500px" ScrollBars="Both"
        BorderStyle="Double" BackColor="White" BorderWidth="1px" BorderColor="Blue">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:GridView ID="grdDetail" runat="server" AutoGenerateColumns="false" OnRowCommand="grdDetail_OnRowCommand"
                    HeaderStyle-BackColor="#397CBB" HeaderStyle-ForeColor="White" HeaderStyle-Height="30px"
                    GridLines="Both" EmptyDataText="No Records found" Width="1150px" CellPadding="5"
                    CellSpacing="5" Font-Bold="true" OnRowDataBound="grdDetail_RowDataBound" ForeColor="Black"
                    Font-Names="Verdana" Font-Size="12px" Style="overflow: hidden; table-layout: auto;"
                    OnSelectedIndexChanged="grdDetail_SelectedIndexChanged" OnRowCreated="grdDetail_RowCreated"
                    AllowSorting="true" OnSorting="grdDetail_Sorting">
                    <Columns>
                        <asp:TemplateField HeaderText="Ac_Code" SortExpression="accode">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblAc_Code" Text='<%#Eval("accode") %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Account Name" SortExpression="acname">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="lnkAcName" Text='<%#Eval("acname") %>' OnClick="lnkAcName_Click"
                                    Style="text-decoration: none;" ToolTip="Select Name For Open Ledger..">
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="City" SortExpression="accode">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblCity" Text='<%#Eval("city") %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Debit Amount" SortExpression="debitAmt">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblDebit" Text='<%#Eval("debitAmt") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Credit Amount" SortExpression="creditAmt">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblCredit" Text='<%#Eval("creditAmt") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Mobile" ControlStyle-Width="120px" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:TextBox ID="txtMobile" runat="server" Width="120px" Height="25px" CssClass="txt"
                                    Font-Bold="true" BorderWidth="0px" Style="text-align: right;">
                                </asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="mobile" HeaderText="Mobile" ItemStyle-CssClass="invisible"
                            HeaderStyle-CssClass="invisible" ItemStyle-HorizontalAlign="Right" />
                        <asp:TemplateField HeaderText="Is Print">
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkSelectAll" runat="server" Checked="false" AutoPostBack="true" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkIsPrint" runat="server" Checked="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--  <asp:BoundField DataField="" HeaderText="Status" NullDisplayText="N" ControlStyle-Width="10px"
                            ItemStyle-HorizontalAlign="Left" />--%>
                    </Columns>
                    <RowStyle Height="25px" Wrap="false" ForeColor="Black" />
                </asp:GridView>
            </ContentTemplate>
            <Triggers>
            <asp:PostBackTrigger ControlID="btnExportToExcel" />
            </Triggers>
        </asp:UpdatePanel>
    </asp:Panel>
</asp:Content>

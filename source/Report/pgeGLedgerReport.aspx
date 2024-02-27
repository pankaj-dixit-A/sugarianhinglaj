﻿<%@ Page Title="Ledger Report" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="pgeGLedgerReport.aspx.cs" Inherits="pgeGLedgerReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" language="javascript">
        function party(Ac_type, fromdt, todt, DrCr) {
            window.open('../Report/rptMultiplePartyLedger.aspx?Ac_type=' + Ac_type + '&fromdt=' + fromdt + '&todt=' + todt + '&DrCr=' + DrCr);
        }

        function sp(accode, fromdt, todt, DrCr) {
            var tn;
            window.open('rptLedger.aspx?accode=' + accode + '&fromdt=' + fromdt + '&todt=' + todt + '&DrCr=' + DrCr);    //R=Redirected  O=Original
        }
        function uw(accode, unit_code, fromdt, todt) {
            var tn;
            window.open('rptLedgerUnitwise.aspx?accode=' + accode + '&unit_code=' + unit_code + '&fromdt=' + fromdt + '&todt=' + todt, '_blank');    //R=Redirected  O=Original
        }
        function gw(accode, unit_code, fromdt, todt, DrCr) {
            var tn;
            window.open('rptGroupWiseReport.aspx?accode=' + accode + '&unit_code=' + unit_code + '&fromdt=' + fromdt + '&todt=' + todt + '&DrCr=' + DrCr, '_blank');    //R=Redirected  O=Original
        }
        function sp_multipleLedger(fromdt, todt, groupcode) {

            alert('ML');

            window.open('rptmultipleLedger1.aspx?groupcode=' + groupcode + '&fromdt=' + fromdt + '&todt=' + todt, '_blank');    //R=Redirected  O=Original
        }
        function dispmillwise(fromDT, toDT, Mill_Code) {
            window.open('../Report/rptMillWiseDispatchLedger.aspx?fromDT=' + fromDT + '&toDT=' + toDT + '&Mill_Code=' + Mill_Code);
        }
        function bwsp(Broker_Code, FromDT, ToDt) {
            var df2;
            window.open('rptBrokerWiseShortPayNew.aspx?Broker_Code=' + Broker_Code + '&FromDT=' + FromDT + '&ToDt=' + ToDt);
        }
        function bwspd(Broker_Code, FromDT, ToDt) {
            var df3;
            window.open('rptShortPaymentLedger.aspx?Broker_Code=' + Broker_Code + '&FromDT=' + FromDT + '&ToDt=' + ToDt);
        }
        function bwspdzero(Broker_Code, FromDT, ToDt) {
            window.open('rptShortPaymentLedgerWithZeroBalance.aspx?Broker_Code=' + Broker_Code + '&FromDT=' + FromDT + '&ToDt=' + ToDt);
        }
        function bsp(Broker_Code, FromDT, ToDt) {
            window.open('rptBalanceShortPaymentLedger.aspx?Broker_Code=' + Broker_Code + '&FromDT=' + FromDT + '&ToDt=' + ToDt);
        }
        function TBR(fromDT, toDT, Transport, Branch_Code) {
            window.open('../Report/rptTransportAcLedger.aspx?fromDT=' + fromDT + '&toDT=' + toDT + '&Transport=' + Transport + '&Branch_Code=' + Branch_Code);
        }
        function DispSummary(fromDT, toDT, Branch_Code, Ac_Code) {
            window.open('../Report/rptDayWiseDispatchLedger.aspx?fromDT=' + fromDT + '&toDT=' + toDT + '&Branch_Code=' + Branch_Code + '&Ac_Code=' + Ac_Code);
        }
        function PWDO(fromDT, toDT, Branch_Code, ac_code) {
            window.open('../Report/rptPartyWiseDO.aspx?fromDT=' + fromDT + '&toDT=' + toDT + '&Branch_Code=' + Branch_Code + '&ac_code=' + ac_code);
        }

        function PWDOM(fromDT, toDT, Branch_Code, ac_code) {
            window.open('../Report/rptPartyWiseDOWithMill.aspx?fromDT=' + fromDT + '&toDT=' + toDT + '&Branch_Code=' + Branch_Code + '&ac_code=' + ac_code);
        }

        function envelop(ac_code) {
            window.open('../Report/rptPrintEnvelop.aspx?ac_code=' + ac_code);
        }

        function frtregi(accode, fromdt, todt) {
            window.open('rptFreightRegisterGetpassWise.aspx?accode=' + accode + '&fromdt=' + fromdt + '&todt=' + todt, '_blank');    //R=Redirected  O=Original
            window.open('rptFreightRegisterDateWise.aspx?accode=' + accode + '&fromdt=' + fromdt + '&todt=' + todt, '_blank');
        }

        function depr(fromDT, toDT) {
            window.open('../Report/rptDeprisiation.aspx?FromDt=' + fromDT + '&ToDt=' + toDT, '_blank');
        }

        function daybook(fromDT, toDT) {
            window.open('../Report/rptdaybook.aspx?FromDt=' + fromDT + '&ToDt=' + toDT, '_blank');
        }
        function meaasge() {
            window.alert("Select range date upto 35 days");
        }
    </script>
    <script type="text/javascript" language="javascript">

        var SelectedRow = null;
        var SelectedRowIndex = null;
        var UpperBound = null;
        var LowerBound = null;


        function SelectSibling(e) {
            var e = e ? e : window.event;
            var KeyCode = e.which ? e.which : e.keyCode;

            if (KeyCode == 40) {
                SelectRow(SelectedRow.nextSibling, SelectedRowIndex + 1);
            }
            else if (KeyCode == 38) {
                SelectRow(SelectedRow.previousSibling, SelectedRowIndex - 1);
            }

            else if (KeyCode == 13) {

                var hdnfClosePopupValue = document.getElementById("<%= hdnfClosePopup.ClientID %>").value;

                document.getElementById("<%=pnlPopup.ClientID %>").style.display = "none";

                document.getElementById("<%=txtSearchText.ClientID %>").value = "";

                var grid = document.getElementById("<%= grdPopup.ClientID %>");

                document.getElementById("<%= hdnfClosePopup.ClientID %>").value = "Close";
                var pageCount = document.getElementById("<%= hdHelpPageCount.ClientID %>").value;


                pageCount = parseInt(pageCount);
                if (pageCount > 1) {
                    SelectedRowIndex = SelectedRowIndex + 1;
                }
                if (hdnfClosePopupValue == "txtAcCode") {
                    document.getElementById("<%= txtAcCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%= lblAcCodeName.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%= txtAcCode.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtUnitCode") {
                    document.getElementById("<%= txtUnitCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%= lblUnitName.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%= txtUnitCode.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtBSGroupCode") {
                    document.getElementById("<%= txtBSGroupCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%= lblGroupName.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%= txtBSGroupCode.ClientID %>").focus();
                }
                document.getElementById("<%= hdnfClosePopup.ClientID %>").value = "Close";
            }
        }
        function SelectRow(CurrentRow, RowIndex) {
            UpperBound = parseInt('<%= this.grdPopup.Rows.Count %>') - 1;
            LowerBound = 0;

            if (SelectedRow == CurrentRow || RowIndex > UpperBound || RowIndex < LowerBound)

                if (SelectedRow != null) {
                    SelectedRow.style.backgroundColor = SelectedRow.originalBackgroundColor;
                    SelectedRow.style.color = SelectedRow.originalForeColor;
                }
            if (CurrentRow != null) {
                CurrentRow.originalBackgroundColor = CurrentRow.style.backgroundColor;
                CurrentRow.originalForeColor = CurrentRow.style.color;
                CurrentRow.style.backgroundColor = '#DCFC5C';
                CurrentRow.style.color = 'Black';
            }
            SelectedRow = CurrentRow;
            SelectedRowIndex = RowIndex;
            setTimeout("SelectedRow.focus();", 0);
        }
    </script>
    <script type="text/javascript" src="../JS/DateValidation.js">
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <fieldset style="border-top: 1px dotted rgb(131, 127, 130); border-radius: 3px; width: 90%;
        margin-left: 30px; float: left; border-bottom: 0px; padding-top: 0px; padding-bottom: 10px;
        border-left: 0px; border-right: 0px; height: 7px;">
        <legend style="text-align: center;">
            <asp:Label ID="label1" runat="server" Text="   GLedger Report   " Font-Names="verdana"
                ForeColor="White" Font-Bold="true" Font-Size="12px"></asp:Label></legend>
    </fieldset>
    <asp:HiddenField ID="hdnfClosePopup" runat="server" />
    <asp:HiddenField ID="hdHelpPageCount" runat="server" />
    <table width="70%" align="center" cellspacing="10">
        <tr>
            <td align="left">
                Filter:
            </td>
            <td align="left" colspan="3">
                <asp:DropDownList ID="drpFilter" runat="server" CssClass="ddl" Width="280px" Height="25px"
                    OnSelectedIndexChanged="drpFilter_SelectedIndexChanged" AutoPostBack="true">
                    <asp:ListItem Text="Account Wise" Value="A"></asp:ListItem>
                    <asp:ListItem Text="Balance Sheet Group Wise" Value="G"></asp:ListItem>
                    <asp:ListItem Text="Party" Value="P" Selected="True"></asp:ListItem>
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
            <td colspan="3">
                <b>Mobile No:</b><asp:TextBox runat="server" ID="txtMobileNo" Style="width: 120px;
                    height: 24px;" onkeypress="return blockNonNumbers(this,event,false,false);" CssClass="txt" />
                <b>Balance:</b><asp:TextBox runat="server" ID="txtBalance" Style="width: 120px; height: 24px;"
                    onkeypress="return blockNonNumbers(this,event,false,false);" CssClass="txt" />
                <input type="button" value="SEND" class="btnHelp" onclick="Send();" style="width: 60px;
                    height: 24px;" />
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <asp:Panel ID="pnlAcNameWise" runat="server">
                    <table width="100%" cellspacing="5">
                        <tr>
                            <td align="left" colspan="2">
                                Account Code: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtAcCode" runat="server" Width="80px" CssClass="txt" AutoPostBack="True"
                                    OnTextChanged="txtAcCode_TextChanged" Height="24px"></asp:TextBox>
                                <asp:Button ID="btnAcCode" runat="server" Text="..." CssClass="btnHelp" OnClick="btnAcCode_Click"
                                    Height="24px" Width="20px" />
                                <asp:Label ID="lblAcCodeName" runat="server" CssClass="lblName"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                Unit Code: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtUnitCode" runat="server" Width="80px" CssClass="txt" AutoPostBack="True"
                                    Height="24px" OnTextChanged="txtUnitCode_TextChanged"></asp:TextBox>
                                <asp:Button ID="btnUnitCode" runat="server" Text="..." CssClass="btnHelp" Height="24px"
                                    Width="20px" OnClick="btnUnitCode_Click" />
                                <asp:Label ID="lblUnitName" runat="server" CssClass="lblName"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlBSGroupWise" runat="server">
                    <table width="100%">
                        <tr>
                            <td align="left" style="width: 40%;">
                                Group Code: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox
                                    ID="txtBSGroupCode" runat="server" Width="80px" CssClass="txt" AutoPostBack="True"
                                    OnTextChanged="txtBSGroupCode_TextChanged" Height="24px"></asp:TextBox>
                                <asp:Button ID="btnGroupCode" runat="server" Text="..." CssClass="btnHelp" OnClick="btnGroupCode_Click"
                                    Height="24px" Width="20px" />
                                <asp:Label ID="lblGroupName" runat="server" CssClass="lblName"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td align="left">
                From Date:
            </td>
            <td align="left">
                <asp:TextBox ID="txtFromDt" runat="server" Width="80px" CssClass="txt" Height="24px"
                    MaxLength="10" onkeyup="ValidateDate(this,event.keyCode)" onkeydown="return DateFormat(this,event.keyCode)"></asp:TextBox>
                <asp:Image ID="imgcalender" runat="server" ImageUrl="~/Images/calendar_icon1.png"
                    Width="25px" Height="15px" />
                <ajax1:CalendarExtender ID="calenderExtendertxtFromDt" runat="server" TargetControlID="txtFromDt"
                    PopupButtonID="imgcalender" Format="dd/MM/yyyy">
                </ajax1:CalendarExtender>
            </td>
            <td align="left">
                To Date:
            </td>
            <td align="left">
                <asp:TextBox ID="txtToDt" runat="server" Width="80px" CssClass="txt" Height="24px"
                    MaxLength="10" onkeyup="ValidateDate(this,event.keyCode)" onkeydown="return DateFormat(this,event.keyCode)"></asp:TextBox>
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/calendar_icon1.png" Width="25px"
                    Height="15px" />
                <ajax1:CalendarExtender ID="CalendarExtendertxtToDt" runat="server" TargetControlID="txtToDt"
                    PopupButtonID="Image1" Format="dd/MM/yyyy">
                </ajax1:CalendarExtender>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td colspan="4" align="center">
                <asp:Button ID="btnGetData" runat="server" Text="Get" CssClass="btnHelp" Width="90px"
                    OnClick="btnGetData_Click" Height="24px" />
                &nbsp;
                <asp:Button ID="btnUnitWise" runat="server" Text="Unit Wise" CssClass="btnHelp" Width="90px"
                    Height="24px" OnClick="btnUnitWise_Click" />
                <asp:Button ID="btnGroupWise" runat="server" Text="Group Wise" CssClass="btnHelp"
                    Width="90px" Height="24px" OnClick="btnGroupWise_Click" />
            </td>
        </tr>
        <tr>
            <td colspan="4" align="center">
                <asp:Button runat="server" ID="btnOnlyCr" Text="Only Cr" CssClass="btnHelp" Width="90px"
                    Height="24px" OnClick="btnOnlyCr_Click" />&nbsp;
                <asp:Button runat="server" ID="btnOnlyDr" Text="Only Dr" CssClass="btnHelp" Width="90px"
                    Height="24px" OnClick="btnOnlyDr_Click" />
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <table align="center" width="60%" cellspacing="5" cellpadding="0">
                    <tr>
                        <td align="left">
                            <asp:Button runat="server" ID="btnDispMillWise" Text="MillWise Dispatch" CssClass="btnHelp"
                                Width="130px" Height="24px" OnClick="btnDispMillWise_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnAccountWise" Text="Accountwise" CssClass="btnHelp"
                                Width="130px" Height="24px" OnClick="btnAccountWise_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnTransportAc" Text="Transport Account" CssClass="btnHelp"
                                Width="130px" Height="24px" OnClick="btnTransportAc_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnDayBook" Text="Day Book" CssClass="btnHelp" Width="130px"
                                Height="24px" OnClick="btnDayBook_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <asp:Button runat="server" ID="btnShortPayment" Text="Short Payment" CssClass="btnHelp"
                                Width="130px" Height="24px" OnClick="btnShortPayment_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnDaywiseSummary" Text="Day Wise Summary" CssClass="btnHelp"
                                Width="130px" Height="24px" OnClick="btnDaywiseSummary_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnEnvelopPrint" Text="Envelop Printing" CssClass="btnHelp"
                                OnClick="btnEnvelopPrint_Click" Width="130px" Height="24px" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <asp:Button runat="server" ID="btnFrtRegister" Text="Freight Register" CssClass="btnHelp"
                                Width="130px" Height="24px" OnClick="btnFrtRegister_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnMultipleLedger" Text="Multiple Ledger" CssClass="btnHelp"
                                Width="130px" Height="24px" OnClick="btnMultipleLedger_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btndepri" Text="Depriciation" CssClass="btnHelp" Width="150px"
                                Height="24px" OnClick="btndepri_Click" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Panel ID="pnlPopup" onkeydown="closepopup(event);" runat="server" Width="70%"
        align="center" ScrollBars="None" BackColor="#FFFFE4" Direction="LeftToRight"
        Style="z-index: 5000; position: absolute; display: none; float: right; max-height: 500px;
        min-height: 500px; box-shadow: 1px 1px 8px 2px; background-position: center;
        left: 10%; top: 10%;">
        <asp:ImageButton ID="imgBtnClose" runat="server" ImageUrl="~/Images/closebtn.jpg"
            Width="20px" Height="20px" Style="float: right; vertical-align: top;" OnClick="imgBtnClose_Click"
            ToolTip="Close" />
        <table width="95%">
            <tr>
                <td align="center" style="background-color: #F5B540; width: 100%;">
                    <asp:Label ID="lblPopupHead" runat="server" Font-Size="Medium" Font-Names="verdana"
                        Font-Bold="true" ForeColor="White"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Search Text:
                    <asp:TextBox ID="txtSearchText" onkeydown="SelectFirstRow(event);" runat="server"
                        Width="250px" Height="20px" AutoPostBack="false"></asp:TextBox>
                    <asp:Button ID="btnSearch" onkeydown="SelectFirstRow(event);" runat="server" Text="Search"
                        CssClass="btnSubmit" OnClick="btnSearch_Click" />
                </td>
            </tr>
            <tr>
                <td>
                    <%--<asp:Panel ID="pnlScroll" runat="server" Width="680px" ScrollBars="Both" Direction="LeftToRight" BackColor="#FFFFE4" style="z-index:5000 ;  float:right; max-height:380px; height:380px;">--%>
                    <asp:Panel ID="pnlInner" runat="server" Width="100%" Direction="LeftToRight" BackColor="#FFFFE4"
                        Style="z-index: 5000; float: right; overflow: auto; height: 400px">
                        <asp:GridView ID="grdPopup" Font-Bold="true" CssClass="select" runat="server" AutoGenerateColumns="true"
                            EmptyDataText="No Records Found" ViewStateMode="Disabled" PageSize="20" AllowPaging="true"
                            HeaderStyle-BackColor="#6D8980" HeaderStyle-ForeColor="White" OnRowCreated="grdPopup_RowCreated"
                            OnPageIndexChanging="grdPopup_PageIndexChanging" Style="table-layout: fixed;"
                            OnRowDataBound="grdPopup_RowDataBound">
                            <HeaderStyle Height="30px" ForeColor="White" BackColor="#6D8980" />
                            <HeaderStyle Height="30px" ForeColor="White" BackColor="#6D8980" />
                            <RowStyle Height="25px" ForeColor="Black" Wrap="false" />
                            <PagerStyle BackColor="Tomato" ForeColor="White" Width="100%" Font-Bold="true" />
                            <PagerSettings Position="TopAndBottom" />
                        </asp:GridView>
                    </asp:Panel>
                    <%--</asp:Panel>--%>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <script type="text/javascript">
        function Send() {
            debugger;
            var mobile = $("#" + "<%=txtMobileNo.ClientID %>").val();
            var balance = $("#" + "<%=txtBalance.ClientID %>").val();
            if (mobile == "" || balance == "") {
                alert('Please Enter Mobile and Balance!');
                return false;
            }
            else if (mobile.length < 10) {
                alert('Please Enter Correct Mobile!');
                return false;
            }
            var msg = "Navkar:-Your a/c shows Debit balance of Rs." + balance + ".Please send Urgently SBBJ-A/C-61025337545 IFSC-SBBJ0010526 BR.PRAVATI.PH-09422028789,02024275389 sms";

            $.ajax({
                type: 'POST',
                url: '../sendsms.asmx/SendSMS',
                data: "{'msg':'" + msg + "','mobile':'" + mobile + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    debugger;
                    if (data.d == 1) {
                        alert('Successfully Sent!');
                    }
                }
            });
        }

        function blockNonNumbers(obj, evt, allowDecimal, allowNegative) {
            debugger;
            var charCode = (evt.which) ? evt.which : evt.keyCode;

            if (charCode == 46) {
                //Check if the text already contains the . character
                if (allowDecimal == true) {
                    if (obj.value.indexOf('.') === -1) {
                        return true;
                    } else {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            else {
                //editable keys
                if (charCode == 8 || charCode == 9 || charCode == 37 || charCode == 39 || charCode == 46) {
                    return true;
                }

                if (charCode > 31 && (charCode < 48 || charCode > 57))
                    return false;
            }
            return true;
        }
    </script>
</asp:Content>

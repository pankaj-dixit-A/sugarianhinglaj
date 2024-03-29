﻿<%@ Page Title="DI/Do For GST" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="pgeDeliveryOrderForGST.aspx.cs" Inherits="Sugar_pgeDeliveryOrderForGST" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" language="javascript">
        function memo() {
            window.open('../Sugar/pgeMotorMemo.aspx');    //R=Redirected  O=Original
        }
        function sugarpurchase() {
            window.open('../Sugar/pgeSugarPurchaseForGST.aspx');    //R=Redirected  O=Original
        }
        function loadingvoucher() {
            window.open('../Sugar/pgeLoadingvoucher.aspx');    //R=Redirected  O=Original
        }
        function salebill() {
            window.open('../Sugar/pgrSugarsaleForGST.aspx');    //R=Redirected  O=Original
        }

        function sp(do_no, email) {
            var tn;
            window.open('../Report/rptDeliveryOrderParty.aspx?do_no=' + do_no + '&email=' + email, '_blank');    //R=Redirected  O=Original
        }
        function od(do_no, email, PO, a) {
            var tn;
            window.open('../Report/rptDeliveryOrderForGST.aspx?do_no=' + do_no + '&email=' + email + '&PO=' + PO + '&a=' + a);    //R=Redirected  O=Original
        }
        function DC(do_no, email, PO, a) {
            var tn;
            window.open('../Report/rptDeliveryChallan.aspx?do_no=' + do_no + '&email=' + email + '&PO=' + PO + '&a=' + a);    //R=Redirected  O=Original
        }
        function TL(DONO, DOCODE) {
            var Donumber = document.getElementById('<%=txtdoc_no.ClientID %>').value;
            var DOCode = document.getElementById('<%=txtDO_CODE.ClientID %>').value;
            //if (DOCode != '') {
            window.open('../Report/rptNewTransferLetter.aspx?DONO=' + Donumber + '&DOCODE=' + DOCode);
            //}
        }
        function WB(Doc_Code) {
            var Donumber = document.getElementById('<%=txtdoc_no.ClientID %>').value;
            window.open('../Report/rptWayBill.aspx?Doc_No=' + Donumber);
        }

        function SB() {
            var billno = document.getElementById('<%=lblSB_No.ClientID %>').innerText;
            window.open('../Report/rptSellBillForGST.aspx?billno=' + billno);
        }

        function CV() {
            var VNO = document.getElementById('<%=lblVoucherNo.ClientID %>').innerText;
            var type = document.getElementById('<%=lblVoucherType.ClientID %>').innerText;
            window.open('../Report/rptVoucherForGST.aspx?VNO=' + VNO + '&type=' + type);
        }

        function ITCV() {
            var VNO = document.getElementById('<%=lblVoucherNo.ClientID %>').innerText;
            window.open('../Report/rptITCVouc.aspx?Doc_No=' + VNO);
        }

        function MM() {
            var MNO = document.getElementById('<%=lblMemoNo.ClientID %>').innerText;
            window.open('../Report/rptMotorMemoBlank.aspx?do_no=' + MNO);
        }
        function DebitNote() {
            window.open('../Sugar/pgeLocalvoucherForGST.aspx');    //R=Redirected  O=Original
        }
        function GEway() {
            var dono = document.getElementById('<%=txtdoc_no.ClientID %>').value;
            var SBNO = document.getElementById('<%=txtnewsbno.ClientID %>').value;
            window.open('../Sugar/pgeEwayBill.aspx?dono=' + dono + '&SBNO=' + SBNO);
        }
        function EInovice() {
            var dono = document.getElementById('<%=txtdoc_no.ClientID %>').value;
            var SBNO = document.getElementById('<%=txtnewsbno.ClientID %>').value;
            window.open('../Sugar/pgeEInovice.aspx?dono=' + dono + '&SBNO=' + SBNO + '&Type=SB');
        }
    </script>
    <script type="text/javascript">
        function Vasuli() {
            debugger;
            var drp = document.getElementById('<%=drpDOType.ClientID %>');
            var val = drp.options[drp.selectedIndex].value;

            var drp1 = document.getElementById('<%=drpDeliveryType.ClientID %>');
            var val1 = drp1.options[drp1.selectedIndex].value;

            if (val == "DI") {
                if (val1 == "C" || val1 == "N") {
                    var transport = document.getElementById('<%=txtTRANSPORT_CODE.ClientID %>').value;
                    if (transport == "" || transport == "0") {
                        alert('Transport Code Is Compulsory');
                        document.getElementById('<%=txtTRANSPORT_CODE.ClientID %>').focus();
                        document.getElementById("<%=btnSave.ClientID %>").disabled = false;
                        //document.getElementById("<%=btnSave.ClientID %>").value = "";
                        return false;
                    }
                    else {
                        return true;
                    }
                }
            }
        }</script>
    <script type="text/javascript">
        function Confirm() {
            var confirm_value = document.createElement("INPUT");
            confirm_value.type = "hidden";
            confirm_value.name = "confirm_value";
            if (confirm("Do you want to delete data and all Vouchers?")) {
                confirm_value.value = "Yes";
                document.getElementById("<%= hdconfirm.ClientID %>").value = "Yes";
            }
            else {
                confirm_value.value = "No";
                document.getElementById("<%= hdconfirm.ClientID %>").value = "No";
            }
            document.forms[0].appendChild(confirm_value);
        }

        function ConfirmNew() {
            var confirm_value = document.createElement("INPUT");
            confirm_value.type = "hidden";
            confirm_value.name = "confirm_value";
            if (confirm("Do you want to Generate New SBNo?")) {
                confirm_value.value = "Yes";
                document.getElementById("<%= hdconfirm.ClientID %>").value = "Yes";
            }
            else {
                confirm_value.value = "No";
                document.getElementById("<%= hdconfirm.ClientID %>").value = "No";
            }
            document.forms[0].appendChild(confirm_value);
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
                document.getElementById("<%=pnlPopup.ClientID %>").style.display = "none";
                document.getElementById("<%=txtSearchText.ClientID %>").value = "";
                var hdnfClosePopupValue = document.getElementById("<%= hdnfClosePopup.ClientID %>").value;
                var grid = document.getElementById("<%= grdPopup.ClientID %>");
                document.getElementById("<%= hdnfClosePopup.ClientID %>").value = "Close";

                var pageCount = document.getElementById("<%= hdHelpPageCount.ClientID %>").value;

                pageCount = parseInt(pageCount);
                if (pageCount > 1) {
                    SelectedRowIndex = SelectedRowIndex + 1;
                }


                if (hdnfClosePopupValue == "txtMILL_CODE") {
                    document.getElementById("<%=txtMILL_CODE.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=LBLMILL_NAME.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtGETPASS_CODE.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtGstRate") {
                    document.getElementById("<%=txtGstRate.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lblGstRateName.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtGETPASS_CODE.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtGETPASS_CODE") {
                    document.getElementById("<%=txtGETPASS_CODE.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=LBLGETPASS_NAME.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtGetpassGstStateCode.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtGetpassGstStateCode") {
                    document.getElementById("<%=txtGetpassGstStateCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lbltxtGetpassGstStateName.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtvoucher_by.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtvoucher_by") {
                    document.getElementById("<%=txtvoucher_by.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lblvoucherbyname.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtGRADE.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtVoucherbyGstStateCode") {
                    document.getElementById("<%=txtVoucherbyGstStateCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lbltxtVoucherbyGstStateName.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtGRADE.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtSalebilltoGstStateCode") {
                    document.getElementById("<%=txtSalebilltoGstStateCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lbltxtSalebilltoGstStateName.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtSalebilltoGstStateCode.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtMillGstStateCode") {
                    document.getElementById("<%=txtMillGstStateCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lbltxtMillGstStateCode.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtMillGstStateCode.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtTransportGstStateCode") {
                    document.getElementById("<%=txtTransportGstStateCode.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lbltxtTransportGstStateCode.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtDIFF_AMOUNT.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtGRADE") {
                    document.getElementById("<%=txtGRADE.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;

                    document.getElementById("<%=txtquantal.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtDO_CODE") {
                    document.getElementById("<%=txtDO_CODE.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=LBLDO_NAME.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtGETPASS_CODE.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtBroker_CODE") {
                    document.getElementById("<%=txtBroker_CODE.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=LBLBROKER_NAME.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtBroker_CODE.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtTRANSPORT_CODE") {
                    document.getElementById("<%=txtTRANSPORT_CODE.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=LBLTRANSPORT_NAME.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtDIFF_AMOUNT.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtBANK_CODE") {
                    document.getElementById("<%=txtBANK_CODE.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lblBank_name.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtNARRATION.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtdoc_no") {
                    document.getElementById("<%=txtdoc_no.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtdoc_no.ClientID %>").disabled = false;
                    document.getElementById("<%=txtDOC_DATE.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtEditDoc_No") {
                    document.getElementById("<%=txtEditDoc_No.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtEditDoc_No.ClientID %>").disabled = false;
                    document.getElementById("<%=txtEditDoc_No.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtNARRATION1") {
                    document.getElementById("<%=txtNARRATION1.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtNARRATION2.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtNARRATION2") {
                    document.getElementById("<%=txtNARRATION2.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtNARRATION3.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtNARRATION3") {
                    document.getElementById("<%=txtNARRATION3.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtNARRATION4.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtNARRATION4") {
                    document.getElementById("<%=txtNARRATION4.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtNARRATION4.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtNARRATION") {
                    document.getElementById("<%=txtNARRATION.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtBANK_AMOUNT.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtparty") {
                    document.getElementById("<%=txtNARRATION4.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtSaleBillTo.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtNARRATION4.ClientID %>").disabled = false;
                    document.getElementById("<%=txtNARRATION4.ClientID %>").focus();
                }

                if (hdnfClosePopupValue == "txtcarporateSale") {
                    document.getElementById("<%=txtcarporateSale.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lblCSYearCode.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[6].innerText;
                    document.getElementById("<%=txtcarporateSale.ClientID %>").focus();
                }
                if (hdnfClosePopupValue == "txtUTRNo") {
                    document.getElementById("<%=txtUTRNo.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lblUTRYearCode.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[6].innerText;
                    document.getElementById("<%= hdnfUtrBalance.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[5].innerText;
                    document.getElementById("<%=txtNARRATION.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtNARRATION.ClientID%>").focus();
                }
                if (hdnfClosePopupValue == "txtUTRNoU") {
                    document.getElementById("<%=txtUTRNo.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=lblUTRYearCode.ClientID %>").innerText = grid.rows[SelectedRowIndex + 1].cells[6].innerText;
                    document.getElementById("<%= hdnfUtrBalance.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[5].innerText;
                    document.getElementById("<%=txtNARRATION.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[1].innerText;
                    document.getElementById("<%=txtNARRATION.ClientID%>").focus();
                }

                if (hdnfClosePopupValue == "txtPurcNo") {
                    document.getElementById("<%=txtPurcNo.ClientID %>").disabled = false;
                    document.getElementById("<%=txtPurcNo.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[0].innerText;
                    document.getElementById("<%=txtPurcOrder.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[11].innerText;
                    var cs = document.getElementById("<%=txtcarporateSale.ClientID %>").value;
                    if (cs == '') {
                        if (cs == 0) {
                            document.getElementById("<%=txtquantal.ClientID %>").value = grid.rows[SelectedRowIndex + 1].cells[8].innerText;
                        }
                    }
                    document.getElementById("<%=txtquantal.ClientID %>").focus();
                }
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
    <script type="text/javascript">
        function DisableButton() {
            document.getElementById("<%=btnSave.ClientID %>").disabled = true;
        }

        function EnableButton() {
            document.getElementById("<%=btnSave.ClientID %>").disabled = false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <fieldset style="border-top: 1px dotted rgb(131, 127, 130); border-radius: 3px; width: 90%;
        margin-left: 30px; float: left; border-bottom: 0px; padding-top: 0px; padding-bottom: 10px;
        border-left: 0px; border-right: 0px; height: 7px;">
        <legend style="text-align: center;">
            <asp:Label ID="label1" runat="server" Text="   Delivery Order   " Font-Names="verdana"
                ForeColor="White" Font-Bold="true" Font-Size="12px"></asp:Label></legend>
    </fieldset>
    <asp:UpdatePanel ID="UpdatePanelMain" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:HiddenField ID="hdconfirm" runat="server" />
            <asp:HiddenField ID="hdnfClosePopup" runat="server" />
            <asp:HiddenField ID="hdnf" runat="server" />
            <asp:HiddenField ID="hdnfSuffix" runat="server" />
            <asp:HiddenField ID="hdHelpPageCount" runat="server" />
            <asp:HiddenField ID="hdnvouchernumber" runat="server" />
            <asp:HiddenField ID="hdnmemonumber" runat="server" />
            <asp:HiddenField ID="hdnfpacking" runat="server" />
            <asp:HiddenField ID="hdnfPDSPartyCode" runat="server" />
            <asp:HiddenField ID="hdnfPDSUnitCode" runat="server" />
            <asp:HiddenField ID="hdnfSB_No" runat="server" />
            <asp:HiddenField ID="hdnfSaleRate" runat="server" />
            <asp:HiddenField ID="hdnfUtrBalance" runat="server" />
            <asp:HiddenField ID="hdnfMainBankAmount" runat="server" />
            <asp:HiddenField ID="hdnfSaleTCSRate" runat="server" />
            <asp:HiddenField ID="hdnfPSTCSRate" runat="server" />
            <asp:HiddenField ID="hdnfSaleTDSRate" runat="server" />
            <asp:HiddenField ID="hdnfPSTDSRate" runat="server" />
            <div>
                <asp:Panel ID="pnlMain" runat="server" Font-Names="verdana" Font-Bold="true" ForeColor="Black"
                    Font-Size="Small" Style="margin-left: 30px; margin-top: 0px; z-index: 90; float: left">
                    <table cellspacing="5" align="left">
                        <tr>
                            <td style="width: 100%;" colspan="6">
                                <table width="100%" align="left" style="border: 1px solid white;">
                                    <tr>
                                        <td align="left" colspan="8">
                                            <asp:Button ID="btnAdd" runat="server" Text="Add New" CssClass="btnHelp" Width="90px"
                                                ValidationGroup="save" OnClick="btnAdd_Click" Height="24px" />&nbsp;
                                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btnHelp" Width="90px"
                                                ValidationGroup="add" OnClick="btnSave_Click" UseSubmitBehavior="false" OnClientClick="this.disabled='true';this.value='Wait..'"
                                                Height="24px" TabIndex="42" />
                                            &nbsp;
                                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btnHelp" Width="90px"
                                                ValidationGroup="save" OnClick="btnEdit_Click" Height="24px" />
                                            &nbsp;
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btnHelp" Width="90px"
                                                ValidationGroup="add" OnClick="btnDelete_Click" OnClientClick="Confirm()" Height="24px" />
                                            &nbsp;
                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btnHelp" Width="90px"
                                                ValidationGroup="save" OnClick="btnCancel_Click" Height="24px" />
                                            &nbsp;
                                            <asp:Button ID="btnNewSB" runat="server" Text="Generate New SB" CssClass="btnHelp"
                                                Width="120px" ValidationGroup="save" OnClick="btnNewSB_Click" OnClientClick="ConfirmNew()"
                                                Height="24px" />
                                            &nbsp;
                                            <asp:Button ID="btnGenEinvoice" runat="server" Text="Generate EInvoice" CssClass="btnHelp"
                                                Width="120px" ValidationGroup="save" OnClientClick="EInovice();" Height="24px" />
                                        </td>
                                        <td align="right" colspan="4">
                                            <asp:Button ID="btnFirst" runat="server" Text="<<" ToolTip="First" CssClass="btnHelp"
                                                OnClick="btnFirst_Click" Width="90px" Height="24px" />
                                            <asp:Button ID="btnPrevious" runat="server" Text="<" ToolTip="First" CssClass="btnHelp"
                                                OnClick="btnPrevious_Click" Width="90px" Height="24px" />
                                            <asp:Button ID="btnNext" runat="server" Text=">" ToolTip="First" CssClass="btnHelp"
                                                OnClick="btnNext_Click" Width="90px" Height="24px" />
                                            <asp:Button ID="btnLast" runat="server" Text=">>" ToolTip="First" CssClass="btnHelp"
                                                OnClick="btnLast_Click" Width="90px" Height="24px" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                Change No:
                            </td>
                            <td align="left" colspan="4">
                                <asp:TextBox runat="server" ID="txtEditDoc_No" CssClass="txt" Width="100px" Height="24px"
                                    TabIndex="0" AutoPostBack="true" OnTextChanged="txtEditDoc_No_TextChanged"></asp:TextBox>
                                <%-- <ajax1:FilteredTextBoxExtender runat="server" ID="txtxf" FilterType="Numbers" InvalidChars="."
                                    TargetControlID="txtEditDoc_No">
                                </ajax1:FilteredTextBoxExtender>--%>
                                &nbsp;<asp:Label ID="lblMsg" runat="server" Font-Bold="true" Font-Italic="true" Font-Names="verdana"
                                    Font-Size="Small" ForeColor="Red"></asp:Label>
                                New SB No:
                                <asp:TextBox ID="txtnewsbno" runat="Server" CssClass="txt" TabIndex="4" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtnewsbno_TextChanged"
                                    Height="24px" ReadOnly="true"></asp:TextBox>
                                Date:
                                <asp:TextBox ID="txtnewsbdate" runat="Server" CssClass="txt" TabIndex="1" Width="80px"
                                    MaxLength="10" onkeyup="ValidateDate(this,event.keyCode)" onkeydown="return DateFormat(this,event.keyCode)"
                                    Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtnewsbdate_TextChanged"
                                    Height="24px" ReadOnly="true"></asp:TextBox>
                                <asp:Image ID="imgcalSB" runat="server" ImageUrl="~/Images/calendar_icon1.png" Width="25px"
                                    Height="15px" />
                                <ajax1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtnewsbdate"
                                    PopupButtonID="imgcalSB" Format="dd/MM/yyyy">
                                </ajax1:CalendarExtender>
                                EInvoice No:
                                <asp:TextBox ID="txteinvoiceno" runat="Server" CssClass="txt" TabIndex="4" Width="120px"
                                    Style="text-align: right;" AutoPostBack="True" Height="24px" ReadOnly="False"></asp:TextBox>
                                ACKNo:
                                <asp:TextBox ID="txtackno" runat="Server" CssClass="txt" TabIndex="4" Width="150px"
                                    Style="text-align: right;" AutoPostBack="True" Height="24px" ReadOnly="False"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Entry No: &nbsp;
                            </td>
                            <td align="left" colspan="7" style="width: 100%;">
                                <asp:TextBox ID="txtdoc_no" runat="Server" CssClass="txt" Width="80px" Style="text-align: right;"
                                    AutoPostBack="True" OnTextChanged="txtdoc_no_TextChanged" Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtDOC_NO" runat="server" Text="..." Width="80px" OnClick="btntxtdoc_no_Click"
                                    CssClass="btnHelp" Height="24px" />
                                Date:
                                <asp:TextBox ID="txtDOC_DATE" runat="Server" CssClass="txt" TabIndex="1" Width="80px"
                                    MaxLength="10" onkeyup="ValidateDate(this,event.keyCode)" onkeydown="return DateFormat(this,event.keyCode)"
                                    Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtDOC_DATE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Image ID="imgcalender" runat="server" ImageUrl="~/Images/calendar_icon1.png"
                                    Width="25px" Height="15px" />
                                <ajax1:CalendarExtender ID="calenderExtenderDate" runat="server" TargetControlID="txtDOC_DATE"
                                    PopupButtonID="imgcalender" Format="dd/MM/yyyy">
                                </ajax1:CalendarExtender>
                                &nbsp; Carporate Sale:<asp:TextBox ID="txtcarporateSale" CssClass="txt" Width="80px"
                                    runat="server" AutoPostBack="true" OnTextChanged="txtcarporateSale_TextChanged"
                                    TabIndex="2" Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtcarporateSale" runat="server" CssClass="btnHelp" Text="C. Sale"
                                    Width="80px" OnClick="btntxtcarporateSale_Click" Height="24px" />
                                <asp:Label ID="lblCSYearCode" runat="server" CssClass="lblName"></asp:Label>
                                <asp:Label runat="server" ID="lblPDSParty" CssClass="lblName" ForeColor="Yellow"></asp:Label>
                                &nbsp; Do Type:
                                <asp:DropDownList ID="drpDOType" runat="server" CssClass="ddl" Width="100px" AutoPostBack="true"
                                    OnSelectedIndexChanged="drpDOType_SelectedIndexChanged" Height="26px" TabIndex="3">
                                    <asp:ListItem Text="Dispatch" Value="DI"></asp:ListItem>
                                    <asp:ListItem Text="D.O." Value="DO"></asp:ListItem>
                                </asp:DropDownList>
                                <%--<asp:TextBox ID="txtDESP_TYPE" runat="Server" CssClass="txt" TabIndex="2" Width="80px" style="text-align:left;"
                                      AutoPostBack="True" ontextchanged="txtDESP_TYPE_TextChanged"></asp:TextBox>--%>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Mill Code:
                            </td>
                            <td align="left" colspan="2" style="width: 10%;">
                                <asp:TextBox ID="txtMILL_CODE" runat="Server" CssClass="txt" TabIndex="4" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtMILL_CODE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtMILL_CODE" runat="server" Text="..." OnClick="btntxtMILL_CODE_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="LBLMILL_NAME" runat="server" CssClass="lblName"></asp:Label>
                            </td>
                            <td colspan="2">
                                Mill State Code:
                                <asp:TextBox ID="txtMillGstStateCode" runat="Server" CssClass="txt" TabIndex="7"
                                    Width="80px" Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtMillGstStateCode_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtMillGstStateCode" runat="server" Text="..." OnClick="btntxtMillGstStateCode_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="lbltxtMillGstStateCode" runat="server" CssClass="lblName"></asp:Label>&nbsp;&nbsp;
                                <asp:TextBox ID="txtMillEmailID" Visible="false" runat="server" CssClass="txt" Width="200px"
                                    AutoPostBack="True" OnTextChanged="txtMillEmailID_TextChanged" TabIndex="5" Height="24px"></asp:TextBox>
                                &nbsp;&nbsp;&nbsp;Mill Mobile:&nbsp;<asp:TextBox runat="server" ID="txtMillMobile"
                                    Width="100px" Height="24px" MaxLength="11" CssClass="txt"></asp:TextBox>&nbsp;<asp:Button
                                        runat="server" ID="btnSendSms" Text="Send Sms" CssClass="btnHelp" Height="24px"
                                        Width="80px" OnClick="btnSendSms_Click" />
                            </td>
                        </tr>
                        <tr>
                            <%-- <td align="left">
                            UTR No:
                        </td>
                        <td colspan="2" align="left">
                            <asp:TextBox ID="txtUTRNo" CssClass="txt" Width="80px" runat="server" AutoPostBack="true"
                                OnTextChanged="txtUTRNo_TextChanged" TabIndex="6" Height="24px"></asp:TextBox>
                            <asp:Button ID="btntxtUTRNo" runat="server" CssClass="btnHelp" Text="UTR No" Width="80px"
                                OnClick="btntxtUTRNo_Click" Height="24px" />
                            <asp:Label ID="lblUTRYearCode" runat="server" CssClass="lblName"></asp:Label>
                            &nbsp;
                        </td>--%>
                            <td align="left">
                                Purc. No:
                            </td>
                            <td colspan="3" align="left">
                                <asp:TextBox ID="txtPurcNo" runat="Server" Enabled="false" CssClass="txt" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtPurcNo_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtPurcNo" runat="server" Text="..." OnClick="btntxtPurcNo_Click"
                                    TabIndex="6" CssClass="btnHelp" Height="24px" Width="20px" />
                                &nbsp;
                                <asp:TextBox ID="txtPurcOrder" runat="Server" Enabled="false" AutoPostBack="true"
                                    OnTextChanged="txtPurcNo_TextChanged" CssClass="txt" Width="20px" Style="text-align: right;"
                                    Height="24px"></asp:TextBox>
                                &nbsp; Delivery Type:
                                <asp:DropDownList ID="drpDeliveryType" runat="server" CssClass="ddl" Width="140px"
                                    Enabled="true" TabIndex="7" AutoPostBack="true" Height="26px" OnSelectedIndexChanged="drpDeliveryType_SelectedIndexChanged">
                                    <asp:ListItem Text="Commission" Value="C"></asp:ListItem>
                                    <asp:ListItem Text="Naka Delivery" Value="N"></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp; GST Rate Code:
                                <asp:TextBox ID="txtGstRate" runat="Server" CssClass="txt" TabIndex="7" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtGstRate_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtGstRate" runat="server" Text="..." OnClick="btntxtGstRate_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="lblGstRateName" runat="server" CssClass="lblName"></asp:Label>
                                <asp:Label runat="server" ID="lblPoDetails" CssClass="lblName" ForeColor="Yellow"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Get Pass:
                            </td>
                            <td align="left" colspan="4" style="width: 10%;">
                                <asp:TextBox ID="txtGETPASS_CODE" runat="Server" CssClass="txt" TabIndex="8" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtGETPASS_CODE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtGETPASS_CODE" runat="server" Text="..." OnClick="btntxtGETPASS_CODE_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="LBLGETPASS_NAME" runat="server" CssClass="lblName"></asp:Label>&nbsp;
                                &nbsp;State Code:
                                <asp:TextBox runat="server" ID="txtGetpassGstStateCode" OnTextChanged="txtGetpassGstStateCode_TextChanged"
                                    AutoPostBack="true" CssClass="txt" Height="24px" Width="30px" />
                                <asp:Button Text="..." runat="server" ID="btntxtGetpassGstStateCode" OnClick="btntxtGetpassGstStateCode_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label Text="" runat="server" ID="lbltxtGetpassGstStateName" CssClass="lblName" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Shipped To:
                            </td>
                            <td align="left" colspan="4" style="width: 10%;">
                                <asp:TextBox ID="txtvoucher_by" runat="Server" CssClass="txt" TabIndex="9" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtvoucher_by_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtvoucher_by" runat="server" Text="..." OnClick="btntxtvoucher_by_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="lblvoucherbyname" runat="server" CssClass="lblName"></asp:Label>
                                &nbsp;&nbsp;<asp:Label runat="server" ID="lblVoucherLedgerByBalance" ForeColor="Yellow"
                                    Text=""></asp:Label>&nbsp;State Code:
                                <asp:TextBox runat="server" ID="txtVoucherbyGstStateCode" OnTextChanged="txtVoucherbyGstStateCode_TextChanged"
                                    AutoPostBack="true" CssClass="txt" Height="24px" Width="30px" />
                                <asp:Button Text="..." runat="server" ID="btntxtVoucherbyGstStateCode" OnClick="btntxtVoucherbyGstStateCode_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label Text="" runat="server" ID="lbltxtVoucherbyGstStateName" CssClass="lblName" />
                                &nbsp; Distance:
                                <asp:TextBox runat="server" ID="txtDistance" OnTextChanged="txtDistance_TextChanged"
                                    AutoPostBack="true" CssClass="txt" Height="24px" Width="80px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Grade:
                            </td>
                            <td align="left" colspan="6">
                                <asp:TextBox ID="txtGRADE" runat="Server" CssClass="txt" TabIndex="10" Width="150px"
                                    Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtGRADE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtGRADE" runat="server" Text="..." OnClick="btntxtGRADE_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                Quantal:
                                <asp:TextBox ID="txtquantal" runat="Server" CssClass="txt" TabIndex="11" Width="100px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtquantal_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="filtertxtquantal" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtquantal">
                                </ajax1:FilteredTextBoxExtender>
                                <asp:Label runat="server" ID="count" ForeColor="White" Visible="false"></asp:Label>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Packing:&nbsp;&nbsp;
                                <asp:TextBox ID="txtPACKING" runat="Server" CssClass="txt" TabIndex="12" Width="100px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtPACKING_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="FilteretxtPACKING" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtPACKING">
                                </ajax1:FilteredTextBoxExtender>
                                &nbsp;&nbsp;&nbsp;Bags:&nbsp;&nbsp;<asp:TextBox ID="txtBAGS" runat="Server" CssClass="txt"
                                    TabIndex="13" Width="100px" ReadOnly="true" Style="text-align: right;" AutoPostBack="True"
                                    OnTextChanged="txtBAGS_TextChanged" Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="FilteretxtBAGS" runat="server" FilterType="Numbers"
                                    TargetControlID="txtBAGS">
                                </ajax1:FilteredTextBoxExtender>
                                &nbsp;Excise / GST:&nbsp;
                                <asp:TextBox ID="txtexcise_rate" runat="Server" CssClass="txt" TabIndex="14" Width="100px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtexcise_rate_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="Filteretxtexcise_rate" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtexcise_rate">
                                </ajax1:FilteredTextBoxExtender>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                Mill Rate:
                            </td>
                            <td align="left" colspan="6" style="vertical-align: top;">
                                <asp:TextBox ID="txtmillRate" runat="Server" CssClass="txt" TabIndex="15" Width="100px"
                                    ReadOnly="true" Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtmillRate_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="FilteretxtmillRate" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtmillRate">
                                </ajax1:FilteredTextBoxExtender>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sale
                                Rate:
                                <asp:TextBox ID="txtSALE_RATE" runat="Server" CssClass="txt" TabIndex="16" Width="100px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtSALE_RATE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="FilteretxtSALE_RATE" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtSALE_RATE">
                                </ajax1:FilteredTextBoxExtender>
                                &nbsp;&nbsp;<%--GST Amount On M.R:
                                <asp:TextBox ID="txtGstMRAmount" runat="Server" CssClass="txt" TabIndex="15" Width="100px"
                                    ReadOnly="true" Style="text-align: right;" AutoPostBack="True" Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="FilteredTextBoxExtenderd3" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtGstMRAmount">
                                </ajax1:FilteredTextBoxExtender>
                                &nbsp;&nbsp;M.R Excl GST:
                                <asp:TextBox runat="server" ID="txtGstExMillRate" ReadOnly="true" CssClass="txt"
                                    Width="100px" Height="24px" />
                                <ajax1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtGstExMillRate">
                                </ajax1:FilteredTextBoxExtender>--%><%-- Commission:<asp:TextBox runat="server" ID="txtCommission" Width="50px" AutoPostBack="true"
                                    Height="24px" CssClass="txt" OnTextChanged="txtCommission_TextChanged" />--%>&nbsp;&nbsp;&nbsp;Diff:
                                <asp:Label ID="lblDiffrate" runat="server" CssClass="lblName"></asp:Label>&nbsp;
                                Mill Amount:
                                <asp:Label ID="lblMillAmount" runat="server" CssClass="lblName"></asp:Label>&nbsp;&nbsp;&nbsp;Purchase
                                TCS%
                                <asp:TextBox ID="txtTCSRate" runat="Server" CssClass="txt" Width="42px" AutoPostBack="true"
                                    OnTextChanged="txtTCSRate_TextChanged" TabIndex="17" Style="text-align: right;"
                                    Height="24px"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" FilterType="Numbers,Custom"
                                    ValidChars="." TargetControlID="txtTCSRate">
                                </ajax1:FilteredTextBoxExtender>
                                &nbsp;&nbsp;&nbsp;Sale TCS%
                                <asp:TextBox ID="txtTCSRate_Sale" runat="Server" CssClass="txt" Width="42px" AutoPostBack="true"
                                    OnTextChanged="txtTCSRate_Sale_TextChanged" TabIndex="18" Style="text-align: right;"
                                    Height="24px"></asp:TextBox>
                                &nbsp;Purchase TDS%
                                <asp:TextBox ID="txtPsTDS_Rate" runat="Server" CssClass="txt" Width="42px" AutoPostBack="true"
                                    OnTextChanged="txtPsTDS_Rate_TextChanged" TabIndex="32" Style="text-align: right;"
                                    Height="24px"></asp:TextBox>
                                <asp:TextBox ID="txtPSTDS_Amt" runat="Server" CssClass="txt" Width="70px" AutoPostBack="true"
                                    OnTextChanged="txtPSTDS_Amt_TextChanged" TabIndex="32" Style="text-align: right;"
                                    Height="24px" Visible="false"></asp:TextBox>
                                &nbsp;Sale TDS%
                                <asp:TextBox ID="txtSaleTDS_Rate" runat="Server" CssClass="txt" Width="42px" AutoPostBack="true"
                                    OnTextChanged="txtSaleTDS_Rate_TextChanged" TabIndex="32" Style="text-align: right;"
                                    Height="24px"></asp:TextBox>
                                <asp:TextBox ID="txtSaleTDS_Amt" runat="Server" CssClass="txt" Width="70px" AutoPostBack="true"
                                    OnTextChanged="txtSaleTDS_Amt_TextChanged" TabIndex="32" Style="text-align: right;"
                                    Height="24px" Visible="false"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="border-bottom: 3px solid white; width: 10%;">
                                Truck No:
                            </td>
                            <td align="left" style="width: 20%; border-bottom: 3px solid white;" colspan="6">
                                <asp:TextBox ID="txtTruck_NO" runat="Server" CssClass="txt" TabIndex="17" Width="140px"
                                    Style="text-align: left;" AutoPostBack="false" OnTextChanged="txtTruck_NO_TextChanged"
                                    Height="24px"></asp:TextBox>&nbsp; Driver Mobile:
                                <asp:TextBox runat="server" ID="txtDriverMobile" CssClass="txt" TabIndex="18" Width="140px"
                                    MaxLength="10" Style="text-align: left;" Height="24px" OnTextChanged="txtDriverMobile_TextChanged"></asp:TextBox>
                                <ajax1:FilteredTextBoxExtender ID="ajxmob" runat="server" FilterType="Numbers" TargetControlID="txtDriverMobile">
                                </ajax1:FilteredTextBoxExtender>
                                &nbsp; Transport:
                                <asp:TextBox ID="txtTRANSPORT_CODE" runat="Server" CssClass="txt" TabIndex="19" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtTRANSPORT_CODE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtTRANSPORT_CODE" runat="server" Text="..." OnClick="btntxtTRANSPORT_CODE_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="LBLTRANSPORT_NAME" runat="server" CssClass="lblName"></asp:Label>&nbsp;
                                State Code:
                                <asp:TextBox ID="txtTransportGstStateCode" runat="Server" CssClass="txt" Width="80px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtTransportGstStateCode_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtTransportGstStateCode" runat="server" Text="..." OnClick="btntxtTransportGstStateCode_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="lbltxtTransportGstStateCode" runat="server" CssClass="lblName"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                Diff Amount:
                            </td>
                            <td align="left" style="width: 10%;" colspan="3">
                                <asp:TextBox ID="txtDIFF_AMOUNT" runat="Server" CssClass="txt" TabIndex="20" Width="100px"
                                    ReadOnly="true" Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtDIFF_AMOUNT_TextChanged"
                                    Height="24px"></asp:TextBox>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Frieght:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox
                                    TabIndex="21" runat="server" ID="txtFrieght" CssClass="txt" Width="100px" Style="text-align: right;"
                                    AutoPostBack="true" Height="24px" OnTextChanged="txtFrieght_TextChanged"></asp:TextBox>
                                <asp:TextBox runat="server" ID="txtFrieghtAmount" CssClass="txt" AutoPostBack="false"
                                    ReadOnly="true" Height="24px" Width="100px" Style="text-align: right;" OnTextChanged="txtFrieghtAmount_TextChanged"></asp:TextBox>
                                &nbsp;&nbsp;&nbsp; Memo Advance:
                                <asp:DropDownList runat="server" ID="drpCC" CssClass="ddl" Width="70px" Height="24px"
                                    TabIndex="22">
                                    <asp:ListItem Text="Credit" Value="Credit"></asp:ListItem>
                                    <asp:ListItem Text="Cash" Value="Cash"></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;rate:<asp:TextBox runat="server" ID="txtMemoAdvanceRate" Width="40px" Height="24px"
                                    TabIndex="22" AutoPostBack="true" CssClass="txt" OnTextChanged="txtMemoAdvanceRate_TextChanged"></asp:TextBox>
                                <asp:TextBox runat="server" ID="txtMemoAdvance" CssClass="txt" Width="100px" Style="text-align: right;"
                                    TabIndex="23" AutoPostBack="true" Height="24px" OnTextChanged="txtMemoAdvance_TextChanged"></asp:TextBox>
                                &nbsp;&nbsp;&nbsp;<asp:Label runat="server" ID="lblFrieghtToPay" ForeColor="Yellow"></asp:Label><asp:DropDownList
                                    runat="server" Visible="false" Width="100px" ID="ddlFrieghtType" CssClass="ddl">
                                    <asp:ListItem Text="Own" Value="O"></asp:ListItem>
                                    <asp:ListItem Text="Party" Value="P"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        </tr>
                        <tr>
                            <td align="left">
                                Freight Paid:
                            </td>
                            <td align="left" colspan="5">
                                <asp:TextBox runat="server" ID="txtVasuliRate" TabIndex="24" CssClass="txt" Width="100px"
                                    Style="text-align: right;" AutoPostBack="true" Height="24px" OnTextChanged="txtVasuliRate_TextChanged"></asp:TextBox>
                                <asp:TextBox runat="server" ID="txtVasuliAmount" CssClass="txt" AutoPostBack="false"
                                    Height="24px" Width="100px" Style="text-align: right;" ReadOnly="true"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                                Vasuli Rate:<asp:TextBox runat="server" ID="txtVasuliRate1" CssClass="txt" Width="80px"
                                    TabIndex="25" Style="text-align: right;" AutoPostBack="true" Height="24px" OnTextChanged="txtVasuliRate1_TextChanged"></asp:TextBox>&nbsp;<asp:TextBox
                                        runat="server" ID="txtVasuliAmount1" CssClass="txt" Width="100px" Style="text-align: right;"
                                        Height="24px"></asp:TextBox>&nbsp;&nbsp;<asp:Button runat="server" ID="btnVoucherOtherAmounts"
                                            Text="Other" CssClass="btnHelp" Width="70px" Height="24px" OnClick="btnVoucherOtherAmounts_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                D.O.
                            </td>
                            <td align="left" colspan="4" style="width: 10%;">
                                <asp:TextBox ID="txtDO_CODE" runat="Server" CssClass="txt" TabIndex="26" Width="120px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtDO_CODE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtDO_CODE" runat="server" Text="..." OnClick="btntxtDO_CODE_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="LBLDO_NAME" runat="server" CssClass="lblName">
                                </asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; Eway_Bill No:
                                <asp:TextBox runat="server" ID="txtEwaybill" OnTextChanged="txtEwaybill_TextChanged"
                                    AutoPostBack="true" CssClass="txt" Height="24px" Width="200px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Broker:
                            </td>
                            <td align="left" colspan="4" style="width: 10%;">
                                <asp:TextBox ID="txtBroker_CODE" runat="Server" CssClass="txt" TabIndex="27" Width="120px"
                                    Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtBroker_CODE_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtBroker_CODE" runat="server" Text="..." OnClick="btntxtBroker_CODE_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label ID="LBLBROKER_NAME" runat="server" CssClass="lblName"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                            </td>
                            <td align="left" colspan="3" style="width: 10%;">
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Narration1:
                            </td>
                            <td align="left" style="width: 10%;">
                                <asp:TextBox ID="txtNARRATION1" runat="Server" CssClass="txt" TabIndex="28" Width="200px"
                                    Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtNARRATION1_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtNARRATION1" runat="server" Text="..." OnClick="btntxtNARRATION1_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />&nbsp;<asp:CheckBox runat="server"
                                        ID="chkNoprintondo" Width="10px" Height="10px" />
                            </td>
                            <td align="left" style="width: 10%;">
                                Narration3:
                            </td>
                            <td align="left" style="width: 30%;">
                                <asp:TextBox ID="txtNARRATION3" runat="Server" CssClass="txt" TabIndex="30" Width="200px"
                                    Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtNARRATION3_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtNARRATION3" runat="server" Text="..." OnClick="btntxtNARRATION3_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 10%;">
                                Narration2:
                            </td>
                            <td align="left" style="width: 10%;">
                                <asp:TextBox ID="txtNARRATION2" runat="Server" CssClass="txt" TabIndex="29" Width="200px"
                                    Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtNARRATION2_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtNARRATION2" runat="server" Text="..." OnClick="btntxtNARRATION2_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                            </td>
                            <td align="left" style="width: 10%;">
                                Narration4:
                                <asp:TextBox runat="server" ID="txtSaleBillTo" Height="24px" Width="80px" Enabled="false"
                                    CssClass="txt"></asp:TextBox>&nbsp;
                            </td>
                            <td align="left" style="width: 30%;">
                                <asp:TextBox ID="txtNARRATION4" runat="Server" CssClass="txt" TabIndex="31" Width="200px"
                                    Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtNARRATION4_TextChanged"
                                    Height="24px"></asp:TextBox>
                                <asp:Button ID="btntxtNARRATION4" runat="server" Text="..." OnClick="btntxtNARRATION4_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                &nbsp; State Code:
                                <asp:TextBox runat="server" ID="txtSalebilltoGstStateCode" OnTextChanged="txtSalebilltoGstStateCode_TextChanged"
                                    AutoPostBack="true" CssClass="txt" Height="24px" Width="30px" />
                                <asp:Button Text="..." runat="server" ID="btntxtSalebilltoGstStateCode" OnClick="btntxtSalebilltoGstStateCode_Click"
                                    CssClass="btnHelp" Height="24px" Width="20px" />
                                <asp:Label Text="" runat="server" ID="lbltxtSalebilltoGstStateName" CssClass="lblName" />
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <asp:Button ID="btnOpenDetailsPopup" runat="server" Text="ADD" CssClass="btnHelp"
                                    Width="80px" Height="24px" OnClick="btnOpenDetailsPopup_Click" TabIndex="33" />&nbsp;&nbsp;&nbsp;Invoice
                                No:
                            </td>
                            <td colspan="4" align="left">
                                <asp:TextBox runat="server" ID="txtINVOICE_NO" CssClass="txt" Width="117px" Style="text-align: left;"
                                    TabIndex="32" AutoPostBack="True" Height="24px" OnTextChanged="txtINVOICE_NO_TextChanged"></asp:TextBox>&nbsp;&nbsp;CheckPost
                                :<asp:TextBox runat="server" ID="txtCheckPostName" CssClass="txt" Width="150px" Height="24px"></asp:TextBox>
                                <asp:LinkButton runat="server" ID="lnkMemo" Text="Memo No:" Style="color: Black;
                                    text-decoration: none;" ToolTip="Click to Go On Motor Memo" OnClick="lnkMemo_Click"></asp:LinkButton>
                                &nbsp;<asp:Label ID="lblMemoNo" runat="server" CssClass="lblName"></asp:Label>&nbsp;
                                <asp:LinkButton runat="server" ID="lnkVoucOrPurchase" Text="Number:" Style="color: Black;
                                    text-decoration: none;" ToolTip="Click to Go On Respective Page" OnClick="lnkVoucOrPurchase_Click"></asp:LinkButton>&nbsp;<asp:Label
                                        ID="lblVoucherNo" runat="server" CssClass="lblName"></asp:Label>&nbsp;&nbsp;<asp:Label
                                            ID="lblVoucherType" runat="server" CssClass="lblName"></asp:Label>
                                &nbsp;&nbsp;<asp:LinkButton runat="server" ID="lblsbnol" Text="" Style="color: Black;
                                    text-decoration: none;" ToolTip="Click to Go On Sale Bill" OnClick="lblsbnol_Click"></asp:LinkButton>
                                &nbsp;<asp:Label ID="lblSB_No" runat="server" CssClass="lblName"></asp:Label>&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
            <div style="width: 100%; position: relative; top: 0px; left: 0px;">
                <table width="100%" style="vertical-align: top;" align="left" cellspacing="2">
                    <tr>
                        <td rowspan="6" style="vertical-align: top;" align="left">
                            <asp:UpdatePanel ID="upGrid" runat="server">
                                <ContentTemplate>
                                    <asp:Panel ID="pnlgrdDetail" runat="server" ScrollBars="Both" Height="150px" Width="1000px"
                                        BorderColor="Maroon" BorderWidth="1px" BorderStyle="Solid" Font-Bold="true" Font-Names="Verdana"
                                        Font-Size="11px" BackColor="SeaShell" Style="margin-left: 30px; float: left;">
                                        <asp:GridView ID="grdDetail" runat="server" AutoGenerateColumns="true" HeaderStyle-BackColor="#397CBB"
                                            HeaderStyle-ForeColor="White" HeaderStyle-Height="30px" GridLines="Both" Width="100%"
                                            OnRowCommand="grdDetail_RowCommand" CellPadding="5" CellSpacing="5" OnRowDataBound="grdDetail_RowDataBound"
                                            Style="table-layout: fixed;">
                                            <Columns>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditRecord" Text="Edit"
                                                            CommandArgument="lnk"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteRecord" Text="Delete"
                                                            CommandArgument="lnk"></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <RowStyle Height="25px" Wrap="false" ForeColor="Black" />
                                        </asp:GridView>
                                    </asp:Panel>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <asp:Button ID="btnDeliveryChallan" runat="server" Text="Delivery Challan" CssClass="btnHelp"
                                Width="120px" Height="24px" OnClick="btnDeliveryChallan_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnGentare_EWayBill" Text="Gentare EWayBill" CssClass="btnHelp"
                                Width="120px" Height="24px" OnClientClick="GEway();" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <asp:Button ID="btnOurDO" runat="server" Text="Our DO" CssClass="btnHelp" Width="90px"
                                Height="24px" OnClick="btnOurDO_Click" />
                        </td>
                        <td align="left">
                            <asp:Button runat="server" ID="btnPrintMotorMemo" Text="Motor Memo" CssClass="btnHelp"
                                Width="90px" Height="24px" OnClientClick="MM();" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button runat="server" ID="btnPrintCarpVoucher" Text="Carp.Vouch" CssClass="btnHelp"
                                Width="90px" Height="24px" OnClientClick="CV();" />
                        </td>
                        <td>
                            <asp:Button runat="server" ID="btnPrintITCVoc" Text="ITC Vouch" CssClass="btnHelp"
                                Width="90px" Height="24px" OnClientClick="ITCV();" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button runat="server" ID="btnTransLetter" Text="Print TL" Width="90px" Height="24px"
                                CssClass="btnHelp" OnClientClick="return TL();"></asp:Button>
                        </td>
                        <td>
                            <asp:Button runat="server" ID="btnPrintSaleBill" Text="SB Print" CssClass="btnHelp"
                                Width="90px" Height="24px" OnClientClick="SB();" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="btnMail" runat="server" Text="Party DO" CssClass="btnHelp" Width="90px"
                                ValidationGroup="save" OnClick="btnMail_Click" Height="24px" />
                        </td>
                        <td>
                            <asp:Button ID="btnWayBill" runat="server" Text="Way Bill" CssClass="btnHelp" Width="90px"
                                ValidationGroup="save" OnClientClick="return WB();" Height="24px" />
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Panel ID="pnlPopup" onkeydown="closepopup(event);" runat="server" Width="90%"
                align="center" ScrollBars="None" BackColor="#FFFFE4" Direction="LeftToRight"
                Style="z-index: 5000; position: absolute; display: none; float: right; max-height: 500px;
                min-height: 500px; box-shadow: 1px 1px 8px 2px; background-position: center;
                left: 5%; top: 10%;">
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
                        <td style="width: 100%;" align="left" colspan="2">
                            <table id="Table1" runat="server" width="100%">
                                <tr>
                                    <td style="width: 40%;">
                                        Search Text:
                                        <asp:TextBox ID="txtSearchText" onkeydown="SelectFirstRow(event);" runat="server"
                                            Width="250px" Height="20px" AutoPostBack="true" OnTextChanged="txtSearchText_TextChanged"></asp:TextBox>
                                        &nbsp;<asp:Button ID="btnSearch" onkeydown="SelectFirstRow(event);" runat="server"
                                            Text="Search" CssClass="btnSubmit" OnClick="btnSearch_Click" />
                                    </td>
                                    <td align="left" runat="server" id="tdDate" visible="false">
                                        From:
                                        <asp:TextBox ID="txtFromDate" runat="server" CssClass="txt" Width="80px" Height="24px"
                                            MaxLength="10" onkeyup="ValidateDate(this,event.keyCode)" onkeydown="return DateFormat(this,event.keyCode)"></asp:TextBox>
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/calendar_icon1.png" Width="25px"
                                            Height="15px" />
                                        <ajax1:CalendarExtender ID="calendertxtFromDate" runat="server" TargetControlID="txtFromDate"
                                            PopupButtonID="Image1" Format="dd/MM/yyyy">
                                        </ajax1:CalendarExtender>
                                        To:
                                        <asp:TextBox ID="txtToDate" runat="server" CssClass="txt" Width="80px" Height="24px"
                                            MaxLength="10" onkeyup="ValidateDate(this,event.keyCode)" onkeydown="return DateFormat(this,event.keyCode)"></asp:TextBox>
                                        <asp:Image ID="Image2" runat="server" ImageUrl="~/Images/calendar_icon1.png" Width="25px"
                                            Height="15px" />
                                        <ajax1:CalendarExtender ID="CalendarExtendertxtToDate" runat="server" TargetControlID="txtToDate"
                                            PopupButtonID="Image2" Format="dd/MM/yyyy">
                                        </ajax1:CalendarExtender>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Panel ID="pnlInner" runat="server" Width="100%" Direction="LeftToRight" BackColor="#FFFFE4"
                                Style="z-index: 5000; float: right; overflow: auto; height: 400px">
                                <asp:GridView ID="grdPopup" CssClass="select" runat="server" AutoGenerateColumns="true"
                                    AllowPaging="true" PageSize="40" EmptyDataText="No Records Found" HeaderStyle-BackColor="#6D8980"
                                    HeaderStyle-ForeColor="White" OnRowCreated="grdPopup_RowCreated" OnPageIndexChanging="grdPopup_PageIndexChanging"
                                    OnRowDataBound="grdPopup_RowDataBound" Style="table-layout: fixed;">
                                    <HeaderStyle Height="30px" ForeColor="White" BackColor="#6D8980" />
                                    <RowStyle Height="25px" ForeColor="Black" Wrap="false" />
                                    <PagerStyle BackColor="Tomato" ForeColor="White" Width="100%" Font-Bold="true" />
                                    <PagerSettings Position="TopAndBottom" />
                                </asp:GridView>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlPopupDetails" runat="server" BackColor="GhostWhite" Width="800px"
                BorderColor="Teal" BorderWidth="1px" Height="300px" BorderStyle="Solid" Style="z-index: 4999;
                left: 15%; top: 20%; position: absolute; display: none; font-weight: bold; box-shadow: 1px 2px 10px 2px;">
                <table width="80%" align="center" cellspacing="5px">
                    <tr>
                        <td colspan="2" align="center" style="background-color: lightslategrey; color: White;">
                            <asp:Label ID="lblTenderDetails" runat="server" Font-Size="Medium" Font-Names="verdana"
                                Text="D.O. Details"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            ID&nbsp;<asp:Label ID="lblID" runat="server"></asp:Label>
                        </td>
                        <td>
                            NO&nbsp;<asp:Label ID="lblNo" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 10%;">
                            Type:
                        </td>
                        <td align="left" style="width: 10%;">
                            <asp:DropDownList ID="drpddType" runat="server" CssClass="ddl" TabIndex="34" Width="200px"
                                Height="30px">
                                <asp:ListItem Text="transfer Letter" Value="T"></asp:ListItem>
                                <asp:ListItem Text="Demand Draft" Value="D"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 10%;">
                            BANK CODE:
                        </td>
                        <td align="left" style="width: 10%;">
                            <asp:TextBox ID="txtBANK_CODE" runat="Server" CssClass="txt" TabIndex="35" Width="60px"
                                Height="24px" Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtBANK_CODE_TextChanged"></asp:TextBox>
                            <asp:Button ID="btntxtBANK_CODE" runat="server" Height="24px" Width="20px" Text="..."
                                OnClick="btntxtBANK_CODE_Click" CssClass="btnHelp" />
                            <asp:Label ID="lblBank_name" runat="server" CssClass="lblName"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            UTR No:
                        </td>
                        <td colspan="2" align="left">
                            <asp:TextBox ID="txtUTRNo" CssClass="txt" Width="80px" runat="server" AutoPostBack="true"
                                OnTextChanged="txtUTRNo_TextChanged" TabIndex="36" Height="24px"></asp:TextBox>
                            <asp:Button ID="btntxtUTRNo" runat="server" CssClass="btnHelp" Text="UTR No" Width="80px"
                                OnClick="btntxtUTRNo_Click" Height="24px" />
                            <asp:Label ID="lblUTRYearCode" runat="server" CssClass="lblName"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 10%;">
                            DD/CHQ/RTGS No:
                        </td>
                        <td align="left" style="width: 10%;">
                            <asp:TextBox ID="txtNARRATION" runat="Server" CssClass="txt" TabIndex="37" Height="24px"
                                Width="200px" Style="text-align: left;" AutoPostBack="True" OnTextChanged="txtNARRATION_TextChanged"></asp:TextBox>
                            <asp:Button ID="btntxtNARRATION" runat="server" Text="..." Height="24px" Width="20px"
                                OnClick="btntxtNARRATION_Click" CssClass="btnHelp" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 10%;">
                            Amount:
                        </td>
                        <td align="left" style="width: 10%;">
                            <asp:TextBox ID="txtBANK_AMOUNT" runat="Server" CssClass="txt" TabIndex="38" Height="24px"
                                Width="200px" Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtBANK_AMOUNT_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="FilteretxtBANK_AMOUNT" runat="server" FilterType="Numbers,Custom"
                                ValidChars="." TargetControlID="txtBANK_AMOUNT">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Label runat="server" ID="lblUtrBalnceError" Text="" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left">
                            <asp:Button ID="btnAdddetails" runat="server" Text="ADD" CssClass="btnSubmit" Width="80px"
                                Height="25px" OnClick="btnAdddetails_Click" TabIndex="39" />
                            <asp:Button ID="btnClosedetails" runat="server" Text="Close" CssClass="btnSubmit"
                                Width="80px" Height="25px" OnClick="btnClosedetails_Click" TabIndex="40" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlVoucherEntries" runat="server" Width="500px" align="center" ScrollBars="None"
                Direction="LeftToRight" Style="z-index: 5000; position: absolute; display: none;
                background-color: White; float: right; max-height: 300px; min-height: 300px;
                background-position: center; left: 50%; margin-left: -400px; top: 30%;" Height="400px"
                BorderStyle="Groove" BorderColor="Blue" BorderWidth="2px">
                <table width="80%" align="center" cellspacing="5">
                    <tr>
                        <td align="center" colspan="2" style="border: 1px solid blue;">
                            <asp:Label runat="server" ID="lblKa" Text="Amounts For Voucher" ForeColor="Blue"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <b>Brokrage:</b>
                        </td>
                        <td align="left">
                            <asp:TextBox runat="server" ID="txtVoucherBrokrage" CssClass="txt" Width="120px"
                                Height="24px" Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtVoucherBrokrage_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtBrokrage" TargetControlID="txtVoucherBrokrage"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <b>Service Charge:</b>
                        </td>
                        <td align="left">
                            <asp:TextBox runat="server" ID="txtVoucherServiceCharge" CssClass="txt" Width="120px"
                                Height="24px" Style="text-align: right;" AutoPostBack="True" OnTextChanged="txtVoucherServiceCharge_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" TargetControlID="txtVoucherServiceCharge"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <b>Rate Diff:</b>
                            <asp:TextBox ID="txtVoucherL_Rate_Diff" runat="Server" CssClass="txt" Width="80px"
                                Style="text-align: right;" AutoPostBack="True" Height="24px" OnTextChanged="txtVoucherL_Rate_Diff_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtL_Rate_Diff" TargetControlID="txtVoucherL_Rate_Diff"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                            <b>Amount:</b>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtVoucherRATEDIFFAmt" runat="Server" CssClass="txt" Width="120px"
                                Style="text-align: right;" AutoPostBack="True" ReadOnly="true" Height="24px"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtRATEDIFF" TargetControlID="txtVoucherRATEDIFFAmt"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <b>Bank Comm:</b>
                            <asp:TextBox ID="txtVoucherCommission_Rate" runat="Server" CssClass="txt" Width="80px"
                                Style="text-align: right;" AutoPostBack="True" Height="24px" OnTextChanged="txtVoucherCommission_Rate_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtCommission_Rate" TargetControlID="txtVoucherCommission_Rate"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                            <b>Amount:</b>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtVoucherBANK_COMMISSIONAmt" runat="Server" CssClass="txt" Width="120px"
                                ReadOnly="true" Style="text-align: right;" AutoPostBack="True" Height="24px"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtBANK_COMMISSION" TargetControlID="txtVoucherBANK_COMMISSIONAmt"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <b>Interest:</b>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtVoucherInterest" runat="Server" CssClass="txt" Width="120px"
                                Style="text-align: right;" AutoPostBack="True" Height="24px" OnTextChanged="txtVoucherInterest_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtInterest" TargetControlID="txtVoucherInterest"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <b>Transport:</b>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtVoucherTransport_Amount" runat="Server" CssClass="txt" Width="120px"
                                Style="text-align: right;" AutoPostBack="True" Height="24px" OnTextChanged="txtVoucherTransport_Amount_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtTransport_Amount" TargetControlID="txtVoucherTransport_Amount"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <b>Other Expenses:</b>
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtVoucherOTHER_Expenses" runat="Server" CssClass="txt" Width="120px"
                                Style="text-align: right;" AutoPostBack="True" Height="24px" OnTextChanged="txtVoucherOTHER_Expenses_TextChanged"></asp:TextBox>
                            <ajax1:FilteredTextBoxExtender ID="filtertxtOTHER_Expenses" TargetControlID="txtVoucherOTHER_Expenses"
                                FilterType="Numbers,Custom" runat="server" ValidChars=".">
                            </ajax1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button runat="server" ID="btnOk" Text="OK" CssClass="btnHelp" Width="60px" Height="24px"
                                OnClick="btnOk_Click" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

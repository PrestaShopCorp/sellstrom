{*
* 2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2014 PrestaShop SA
*  @version  Release: $Revision: 14011 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

<style>
.isa_info, .isa_success, .isa_warning, .isa_error {
	margin: 10px 0px;
	padding:12px;
	border-radius:5px;
}
.isa_info {
	color: #00529B;
	background-color: #BDE5F8;
}
.isa_success {
	color: #4F8A10;
	background-color: #DFF2BF;
}
.isa_warning {
	color: #9F6000;
	background-color: #FEEFB3;
}
.isa_error {
	color: #D8000C;
	background-color: #FFBABA;
}
.isa_info i, .isa_success i, .isa_warning i, .isa_error i {
	margin:10px 22px;
	font-size:2em;
	vertical-align:middle;
}
.white_btn_gray {
    background-color: #ffffff;
    border: 1px solid #777777;
    color: #777777;
    font-weight: bold;
}   
.white_btn_product {
    background-color: #ffffff;
    border: 1px solid #777777;
    color: #ff9955;
    font-weight: bold;
    margin-left: 26px;
}   
.watermarked {
    color: #aaaaaa;
}
</style>

<script type='text/javascript'>
	{literal}
	var contentData;

    function resetFields() {
		if (document.getElementById('addFundsForm'))
	        document.getElementById('addFundsForm').reset();
    }
    function enableAddFundsForm() {
        document.getElementById('addFundsMainDiv').style.display = 'block';
    }
    function disableAddFundsForm() {
        document.getElementById('addFundsMainDiv').style.display = 'none';
    }
    function populateFinal() {
        var addAmount = document.getElementById('addAmount');
        var finalAmount = document.getElementById('finalAmount');
        var finalSubmit = document.getElementById('finalSubmitValue');
        var finalValue = Number(addAmount.value); // + Number(0.02 * addAmount.value);
        finalAmount.value = '$' + finalValue;
        finalSubmit.value = finalValue;
    }
    function getCurrentPageURL() {
        var currentUrl = window.location.href;
        return currentUrl;
    }
    function submitForm() {
        var amount = document.getElementById('addAmount').value;
        if (!amount) {
            alert('Add funds amount cannot be empty. Please enter the amount and click on Pay Now.');
            return false;
        } else if (amount < 1) {
            alert('Add funds amount should be more than or equal to $1.');
            return false;
        }

        var finalAmountValue = document.getElementById('finalAmount').value;
        var c = confirm('You will be now redirected to the PayPal secured payment gateway for the payment of amount (' + 
                        finalAmountValue + 
                        '). Are you sure you want to proceed with the payment?');
        if (c == true) {
            document.getElementById('currentPageUrl').value = getCurrentPageURL();

            // Create a dynamic form
            var f = document.createElement('form');
            f.setAttribute('method','post');
            f.setAttribute('action','http://54.235.249.8/console/index.php');

            var amt = document.createElement('INPUT');
            amt.type = 'hidden';
            amt.name = 'amount';
            amt.value = document.getElementById('finalAmount').value;
            f.appendChild(amt);

            var addamt = document.createElement('INPUT');
            addamt.type = 'hidden';
            addamt.name = 'addAmount';
            addamt.value = document.getElementById('addAmount').value;
            f.appendChild(addamt);

            var akey = document.createElement('INPUT');
            akey.type = 'hidden';
            akey.name = 'apiKey';
            akey.value = document.getElementById('apiKey').value;
            f.appendChild(akey);

            var uname = document.createElement('INPUT');
            uname.type = 'hidden';
            uname.name = 'username';
            uname.value = document.getElementById('username').value;
            f.appendChild(uname);

            var upass = document.createElement('INPUT');
            upass.type = 'hidden';
            upass.name = 'password';
            upass.value = document.getElementById('userpass').value;
            f.appendChild(upass);

            var purl = document.createElement('INPUT');
            purl.type = 'hidden';
            purl.name = 'finalRedirectUrl';
            purl.value = document.getElementById('currentPageUrl').value;
            f.appendChild(purl);

            var fact = document.createElement('INPUT');
            fact.type = 'hidden';
            fact.name = 'action';
            fact.value = document.getElementById('formAction').value;
            f.appendChild(fact);

            document.body.appendChild(f);
            f.submit();
        }
    }

	function restCustomCodeTableRows() {
	    var j = document.getElementById("txtProductLineValue").value;
	    for ( var i = 1; i < j; i++) {
	        var row = document.getElementById("id");
	        row.parentNode.removeChild(row);
	    }  
	    document.getElementById("txtProductLineValue").value = 1;
		document.getElementById("txtProductDescription1").value = '';
		document.getElementById("txtProductCode1").value = '';
		document.getElementById("txtProductValue1").value = '';
	}

	function displayDocumentsCustoms() {
	    var radio_button_value = $('input[name=createInvoicerblPackageContents]:radio:checked').val();
	    
	    if(radio_button_value=="doc") {
	        $("#create_Invoice_DocumentDescription").show();
	        $("#create_Invoice_TolValCustoms").show();
	        $("#create_Invoice_Insurance").show();
	        $("#create_Invoice_ShipmentPurpose").hide();
	        $("#create_Invoice_CustomCodeTable").hide();
	    } else {
	        $("#create_Invoice_DocumentDescription").hide();            
	        $("#create_Invoice_TolValCustoms").hide();
	        $("#create_Invoice_ShipmentPurpose").show();
	        $("#create_Invoice_Insurance").show();
	        $("#create_Invoice_CustomCodeTable").show();
	        restCustomCodeTableRows();
	    }
	}

	function submitCreateInvoice() {
		console.log(contentData);
		var productsTableRows = document.getElementById('ciCustomCodeTable').rows.length - 2;
		var docChecked = document.getElementById('create_Invoice_rblPackageContents_0').checked;
		var comChecked = document.getElementById('create_Invoice_rblPackageContents_1').checked;
		var docDescription = $('#create_Invoice_drpDocumentDescription').val();
		var shipPurpose = $('#create_Invoice_drpShipmentPurpose').val();
		var totalPackages = contentData.products.length;
		var totalWeight = 0;
		for (var w=0;w<totalPackages;w++) {
			totalWeight += contentData.products[w].weight
		}

		console.log('productsTableRows = ' + productsTableRows);
		console.log('docChecked = ' + docChecked);
		console.log('comChecked = ' + comChecked);

		if (comChecked) {
			var c = validateInputText();
			if (c == 0)
				return false;
		} else {
			var docValue = $.trim($('#create_Invoice_txtDeclaredValue').val());
			$('#create_Invoice_txtDeclaredValue').val(docValue);
			if (docValue == '') {
	        	alert("Product/Document value must be filled out");
	        	$("#errorPV").show();
	        	$("#errorPD").hide();
				return false;
			}
		}

		var products = new Array();
		if (comChecked) {
			for (var p = 1; p <= productsTableRows; p++) {
				products.push({
					'product_desc': '['+shipPurpose+'] '+$('#txtProductDescription'+p).val(),
					'product_code': $('#txtProductCode'+p).val(),
					'product_value': $('#txtProductValue'+p).val()
				});
			}
		}
		else {
			products.push({
				'product_desc': '[Documents] '+docDescription,
				'product_code': '',
				'product_value': $('#create_Invoice_txtDeclaredValue').val()
			});
		}

		console.log(products);

		$.ajax({
			url: contentData.module_dir+'/createInvoice.php',
			method: 'post',
			beforeSend: function() {
				$('#ajaxLoaderImg').show();
			},
			complete: function() {
				$('#ajaxLoaderImg').hide();
			},
			data: {
				'id_order': contentData.id_order,
				'shipper_state': contentData.shipper_address.state,
				'shipper_country': contentData.shipper_address.country,
				'tracking_number': contentData.shipment_labels[0].tracking_number,
				'custom_products': JSON.stringify(products),
				'total_packages': totalPackages,
				'total_weight': totalWeight
			},
			dataType: 'json',
			success: function(response) {
				console.log(response);
				window.open(contentData.module_dir+'/invoices/'+response.filename, '_blank');
			},
			error: function(response) {
			}
		});
	}

	function cancelCreateInvoice() {
		document.getElementById("create_Invoice").style.display = "none";
	}

	function createInvoice() {
	    document.getElementById("create_Invoice").style.display = "block";
	    $("#create_Invoice_DocumentDescription").show();
	    $("#create_Invoice_TolValCustoms").show();
	    $("#create_Invoice_Insurance").show();
	    $("#create_Invoice_ShipmentPurpose").hide();
	    $("#create_Invoice_CustomCodeTable").hide();
	    document.getElementById("create_Invoice_rblPackageContents_0").checked = true;
	    $("#errorPD").hide();
	    $("#errorPV").hide();
	    restCustomCodeTableRows();
	}

	function addNewProductLine() {
	    // check for blank first
	    // if not blank then add new row
	    var c = validateInputText();
	    //alert(c);
	    if ( c == 1 ){
	        $("#errorPD").hide();
	        $("#errorPV").hide();
	        var j = document.getElementById("txtProductLineValue").value;
	        j++; 
	        document.getElementById("txtProductLineValue").value = j;
	        var x = document.getElementById("ciCustomCodeTable").rows.length;
	        x--; 
	        var table = document.getElementById("ciCustomCodeTable");
	        var row = table.insertRow(x);
	        row.id = "id";
	        var cell1 = row.insertCell(0);
	        var cell2 = row.insertCell(1);
	        var cell3 = row.insertCell(2);
	        cell1.innerHTML = " <input id='txtProductDescription"+j+"' type='text' style='background-color:white;' name='txtProductDescription"+j+"'> ";
	        cell2.innerHTML = " <input id='txtProductCode"+j+"' type='text' class='watermarked' style='background-color:white;' name='txtProductCode"+j+"'> ";
	        cell3.innerHTML = " <input id='txtProductValue"+j+"' type='text' style='background-color:white;width:75px;' name='txtProductValue"+j+"'> ";
	    }
	}

	function validateInputText() {
	    var i = document.getElementById("txtProductLineValue").value;
	    var x = document.getElementById("txtProductDescription"+i).value;
	    var y = document.getElementById("txtProductValue"+i).value;
	    if ((x==null || x=="") && (y==null || y=="")) {
	        alert("Product Description and Product value must be filled out");
	        $("#errorPD").show();
	        $("#errorPV").show();
	        return 0;
	    } else if (y==null || y=="") {
	        alert("Product/Document value must be filled out");
	        $("#errorPV").show();
	        $("#errorPD").hide();
	        return 0;
	    } else if (x==null || x=="") {
	        alert("Product Description must be filled out");
	        $("#errorPD").show();
	        $("#errorPV").hide();
	        return 0;
	    } else {
	        return 1;
	    }
	}

	function openCustomCodeURL() {
		var win = window.open('http://hts.usitc.gov/', '_blank');
		win.focus();
	}

	$(function() {
		contentData = {/literal}{$content_data|json_encode}{literal};
		console.log(contentData);
		var psVersion = contentData.ps_version;
		var showPanel = psVersion.match(/^1.5/) ? false : true;
		var htmlContent = '<br/>';

		if (contentData.error_message) {
			htmlContent += '<div class="isa_error" id="sellstromErrorMessage">'+contentData.error_message+'</div>';
		}
	
		if (contentData.info_message) {
			htmlContent += '<div class="isa_info"  id="sellstromInfoMessage">'+contentData.info_message+'</div>';
		}

		if (showPanel) {
			htmlContent += '<div class="panel">';
			htmlContent += '<div class="panel-heading">';
		} else {
			htmlContent += '<fieldset><legend>';
		}

		htmlContent += '	<img src="'+contentData.presta_base_dir+'img/admin/delivery.gif" alt="">&nbsp;Sellstrom';

		if (showPanel)
			htmlContent += '</div>';
		else htmlContent += '</legend>';

		htmlContent += '<form action="" method="POST">';
		htmlContent += '<fieldset>';
		htmlContent += '<div class="panel">';	
		htmlContent += '	<label for="SSBalance">Your Sellstrom balance:</label>';
		htmlContent += '	<input type="text" readonly=readonly id="SSBalance" value="'+contentData.balance_amount+'" />';
		if (!showPanel)
			htmlContent += '<br/>';
		htmlContent += '	<a href="###" onclick="javascript:enableAddFundsForm();" style="color:#00aff0;text-decoration:none;font-size:12px;">';
		htmlContent += '		<img src="'+contentData.module_dir+'/img/add-credit.gif">Add more credit';
		htmlContent += '	</a>';
		htmlContent += '	<br/><br/>';
		htmlContent += '	<div id="addFundsMainDiv" style="display:none">';
		htmlContent += '		<form action="http://54.235.249.8/console/index.php" method="post" name="addFundsForm" id="addFundsForm">';
		htmlContent += '			<label for="addAmount" id="addFundsLabel">Add funds ($)</label>';
		htmlContent += '			<div class="margin-form" id="addFundsFormDiv">';
		htmlContent += '				<input id="addAmount" name="addAmount" type="text" onBlur="javascript:populateFinal();" value="" />';
		htmlContent += '				<input id="formAction" type="hidden" name="action" value="addFunds" />';
		htmlContent += '				<input id="apiKey" type="hidden" name="apiKey" value="'+contentData.user_id+'" />';
		htmlContent += '				<input id="username" type="hidden" name="username" value="'+contentData.login+'" />';
		htmlContent += '				<input id="userpass" type="hidden" name="password" value="'+contentData.password+'" />';
		htmlContent += '				<input id="currentPageUrl" type="hidden" name="finalRedirectUrl" />';
		htmlContent += '				<input id="finalSubmitValue" type="hidden" name="amount" value="" />';
		htmlContent += '				<input id="finalAmount" type="hidden" value="" />';
		htmlContent += '			</div>';
		htmlContent += '			<br/>';
		htmlContent += '			<div id="addFundsButtonsDiv">';
		htmlContent += '				<a href="##" onClick="javascript:submitForm()">';
		htmlContent += '					<img src="'+contentData.module_dir+'/img/paypal_paynow.gif">';
		htmlContent += '				</a>';
		htmlContent += '				<a href="##" class="sellstrom-link-ext" onClick="javascript:disableAddFundsForm();resetFields();"';
		htmlContent += '					style="color:#00aff0;text-decoration:none;font-size:12px;">';
		htmlContent += '					Cancel';
		htmlContent += '				</a>';
		htmlContent += '			</div>';
		if (!showPanel)
			htmlContent += '<br/>';
	
		htmlContent += '		</form>';
		htmlContent += '	</div>';
		htmlContent += '</div>';

		if (contentData.shipment_voided)
		{
			htmlContent += '<div class="panel">';	
			htmlContent += '	<label for="voidSSShipping">This shipment has been voided.</label>';
			htmlContent += '</div>';
		}
		else
		{
			if (contentData.allow_void_shipment)
			{	
				htmlContent += '<div class="panel">';	
				htmlContent += '	<label for="voidSSShipping">Click here to void shipping:</label>&nbsp;&nbsp;';
				htmlContent += '	<input id="voidSSShipping" type="submit" class="button" name="voidSSShipping" value="Void"';
				htmlContent += '		onClick="return confirm(\'Are you sure you want to cancel shipping for this order?\');" />&nbsp;&nbsp;';
				htmlContent += '	<a href="###" onclick="javascript:createInvoice();">Create Invoice</a>';
				htmlContent += '</div>';

				// Create Invoice
				htmlContent += '<div id="create_Invoice" class="panel" style="display:none;">';
				htmlContent += '<fieldset>';
				htmlContent += '	<div class="panel-heading">';
				htmlContent += '		<img src="'+contentData.presta_base_dir+'img/admin/delivery.gif" alt="">';
				htmlContent += '		Sellstrom - Create Invoice';
				htmlContent += '	</div>';
				htmlContent += '	<table id="create_Invoice_rblPackageContents" border="0">';
				htmlContent += '		<tr>';
				htmlContent += '			<td colspan="3">';
				htmlContent += '				<div id="errorPD" style="color: Red; display: inline;">* Product description is required</div>';
				htmlContent += '			</td>';
				htmlContent += '		</tr>';
				htmlContent += '		<tr>';
				htmlContent += '			<td colspan="3">';
				htmlContent += '				<div id="errorPV" style="color: Red; display: inline;">* Product/Document value is required</div>';
				htmlContent += '			</td>';
				htmlContent += '		</tr>';
				htmlContent += '		<tr>';
				htmlContent += '			<td style="font-weight:bold;width:175px">';
				htmlContent += '				<span id="create_Invoice_PackageContents">Package Contents</span>';
				htmlContent += '			</td>';
				htmlContent += '			<td style="width:95px;">';
				htmlContent += '				<input id="create_Invoice_rblPackageContents_0" name="createInvoicerblPackageContents" value="doc" ';
				htmlContent += '					type="radio" checked onclick="javascript:displayDocumentsCustoms();">';
				htmlContent += '				<label for="create_Invoice_rblPackageContents_0">Documents</label>';
				htmlContent += '			</td>';
				htmlContent += '			<td>';
				htmlContent += '				<input id="create_Invoice_rblPackageContents_1" name="createInvoicerblPackageContents" value="com" ';
				htmlContent += '					type="radio" onclick="javascript:displayDocumentsCustoms();" >';
				htmlContent += '				<label for="create_Invoice_rblPackageContents_1">Products</label>';
				htmlContent += '			</td>';
				htmlContent += '		</tr>';
				htmlContent += '	</table>';
				htmlContent += '</fieldset>';
				htmlContent += '<div id="create_Invoice_DocumentDescription">';
				htmlContent += '    <table>';
				htmlContent += '        <tr> ';
				htmlContent += '            <td style="font-weight: bold;width:175px"><span id="create_Invoice_lblDocumentDescription">Document Description</span></td>';
				htmlContent += '            <td><select name="createInvoicedrpDocumentDescription" id="create_Invoice_drpDocumentDescription">';
				htmlContent += '            <option selected="selected" value="No Customs Value">No Customs Value</option>';
				htmlContent += '            <option value="Accounting Documents">Accounting Documents</option>';
				htmlContent += '            <option value="Analysis Reports">Analysis Reports</option>';
				htmlContent += '            <option value="Applications (Completed)">Applications (Completed)</option>';
				htmlContent += '            <option value="Bank Statements">Bank Statements</option>';
				htmlContent += '            <option value="Bid Quotations">Bid Quotations</option>';
				htmlContent += '            <option value="Bills of Sale">Bills of Sale</option>';
				htmlContent += '            <option value="Birth Certificates">Birth Certificates</option>';
				htmlContent += '            <option value="Bonds">Bonds</option>';
				htmlContent += '            <option value="Business Correspondence">Business Correspondence</option>';
				htmlContent += '            <option value="Checks (Completed)">Checks (Completed)</option>';
				htmlContent += '            <option value="Claim Files">Claim Files</option>';
				htmlContent += '            <option value="Closing Statements">Closing Statements</option>';
				htmlContent += '            <option value="Conference Reports">Conference Reports</option>';
				htmlContent += '            <option value="Contracts">Contracts</option>';
				htmlContent += '            <option value="Cost Estimates">Cost Estimates</option>';
				htmlContent += '            <option value="Court Transcripts">Court Transcripts</option>';
				htmlContent += '            <option value="Credit Applications">Credit Applications</option>';
				htmlContent += '            <option value="Data Sheets">Data Sheets</option>';
				htmlContent += '            <option value="Deeds">Deeds</option>';
				htmlContent += '            <option value="Employment Papers">Employment Papers</option>';
				htmlContent += '            <option value="Escrow Instructions">Escrow Instructions</option>';
				htmlContent += '            <option value="Export Papers">Export Papers</option>';
				htmlContent += '            <option value="Financial Statements">Financial Statements</option>';
				htmlContent += '            <option value="Immigration Papers">Immigration Papers</option>';
				htmlContent += '            <option value="Income Statements">Income Statements</option>';
				htmlContent += '            <option value="Insurance Documents">Insurance Documents</option>';
				htmlContent += '            <option value="Interoffice Memos">Interoffice Memos</option>';
				htmlContent += '            <option value="Inventory Reports">Inventory Reports</option>';
				htmlContent += '            <option value="Invoices (Completed)">Invoices (Completed)</option>';
				htmlContent += '            <option value="Leases">Leases</option>';
				htmlContent += '            <option value="Legal Documents">Legal Documents</option>';
				htmlContent += '            <option value="Letter of Credit Packets">Letter of Credit Packets</option>';
				htmlContent += '            <option value="Letters and Cards">Letters and Cards</option>';
				htmlContent += '            <option value="Loan Documents">Loan Documents</option>';
				htmlContent += '            <option value="Marriage Certificates">Marriage Certificates</option>';
				htmlContent += '            <option value="Medical Records">Medical Records</option>';
				htmlContent += '            <option value="Office Records">Office Records</option>';
				htmlContent += '            <option value="Operating Agreements">Operating Agreements</option>';
				htmlContent += '            <option value="Patent Applications">Patent Applications</option>';
				htmlContent += '            <option value="Permits">Permits</option>';
				htmlContent += '            <option value="Photocopies">Photocopies</option>';
				htmlContent += '            <option value="Proposals">Proposals</option>';
				htmlContent += '            <option value="Prospectuses">Prospectuses</option>';
				htmlContent += '            <option value="Purchase Orders">Purchase Orders</option>';
				htmlContent += '            <option value="Quotations">Quotations</option>';
				htmlContent += '            <option value="Reservation Confirmation">Reservation Confirmation</option>';
				htmlContent += '            <option value="Resumes">Resumes</option>';
				htmlContent += '            <option value="Sales Agreements">Sales Agreements</option>';
				htmlContent += '            <option value="Sales Reports">Sales Reports</option>';
				htmlContent += '            <option value="Shipping Documents">Shipping Documents</option>';
				htmlContent += '            <option value="Statements/Reports">Statements/Reports</option>';
				htmlContent += '            <option value="Statistical Data">Statistical Data</option>';
				htmlContent += '            <option value="Stock Information">Stock Information</option>';
				htmlContent += '            <option value="Tax Papers">Tax Papers</option>';
				htmlContent += '            <option value="Trade Confirmation">Trade Confirmation</option>';
				htmlContent += '            <option value="Transcripts">Transcripts</option>';
				htmlContent += '            <option value="Warranty Deeds">Warranty Deeds</option>';
				htmlContent += '        </select></td>';
				htmlContent += '        </tr>';
				htmlContent += '    </table> ';
				htmlContent += '</div>';
				htmlContent += '<div id="create_Invoice_ShipmentPurpose">';
				htmlContent += '    <table>';
				htmlContent += '    <tr>';  
				htmlContent += '            <td style="font-weight: bold;width:175px"><span id="create_Invoice_lblShipmentPurpose">Shipment Purpose</span></td>';
				htmlContent += '            <td><select name="createInvoicedrpShipmentPurpose" id="create_Invoice_drpShipmentPurpose">';
				htmlContent += '            <option selected="selected" value="Commercial">Commercial</option>';
				htmlContent += '            <option value="Gift">Gift</option>';
				htmlContent += '            <option value="Sample">Sample</option>';
				htmlContent += '            <option value="Return and Repair">Return and Repair</option>';
				htmlContent += '            <option value="Personal Effects">Personal Effects</option>';
				htmlContent += '            <option value="Personal Use">Personal Use</option>';
				htmlContent += '            </select></td>';
				htmlContent += '    </tr>';
				htmlContent += '    </table>';
				htmlContent += '</div>';
				htmlContent += '<div id="create_Invoice_TolValCustoms">';
				htmlContent += '    <table>';
				htmlContent += '        <tr>';
				htmlContent += '            <td style="font-weight: bold;width:175px">Total Value for Customs (USD)</td>';
				htmlContent += '            <td><input name="createInvoicetxtDeclaredValue" value="" maxlength="10" id="create_Invoice_txtDeclaredValue"';
				htmlContent += '					style="width:80px;" type="text"></td>';
				htmlContent += '        </tr>';
				htmlContent += '    </table>';
				htmlContent += '</div>';
				htmlContent += '<div id="create_Invoice_CustomCodeTable" style="margin-top:10px;">';
				htmlContent += '    <table id="ciCustomCodeTable" class="table">';
				htmlContent += '		<thead>';
				htmlContent += '        <tr>';
				htmlContent += '            <th>Description Of Content</th>';
				htmlContent += '            <th>Code</th>';
				htmlContent += '            <th>Value (USD)</th>';
				htmlContent += '        </tr>';
				htmlContent += '		</thead>';
				htmlContent += '        <tr id="pnlProduct1">';
				htmlContent += '            <td>';
				htmlContent += '                <input id="txtProductDescription1" type="text" style="background-color:white;"';
				htmlContent += '					name="txtProductDescription1">';
				htmlContent += '            </td>';
				htmlContent += '            <td>';
				htmlContent += '                <input id="txtProductCode1" type="text" class="watermarked" style="background-color:white;"';
				htmlContent += '					name="txtProductCode1">';
				htmlContent += '            </td>';
				htmlContent += '            <td>';
				htmlContent += '                <input id="txtProductValue1" type="text" style="background-color:white;width:75px;" name="txtProductValue1">';
				htmlContent += '            </td>';
				htmlContent += '        </tr>';
				htmlContent += '        <tr>';
				htmlContent += '            <td colspan="3" style="text-align:left;">';
				htmlContent += '                <input id="btnProductAdd1" type="button" class="white_btn_product" style="width:100px;" value="Add Row"';
				htmlContent += '					name="btnProductAdd1" onclick="addNewProductLine()">';
				htmlContent += '                <input id="btnProductLookup1" type="button" class="white_btn_gray"  style="width:200px;"';
				htmlContent += '					value="Find Customs Comm. Code" name="btnProductLookup1" onclick="openCustomCodeURL()">';
				htmlContent += '                <input id="txtProductLineValue" value="1" type="hidden" name="txtProductLineValue">';
				htmlContent += '                <input id="btnProductAdd1" type="button" class="white_btn_product" style="width:100px;" value="Reset"';
				htmlContent += '					name="btnProductAdd1" onclick="restCustomCodeTableRows()">';
				htmlContent += '            </td>';
				htmlContent += '        </tr>';
				htmlContent += '    </table>';
				htmlContent += '</div>';
				htmlContent += '<div style="margin-top:20px;">';
				htmlContent += '	<button type="button" onClick="javascript:submitCreateInvoice();"';
				htmlContent += '			class="btn btn-primary">Create Invoice</button>';
				htmlContent += '    &nbsp;&nbsp;';
				htmlContent += '    <button type="button" onClick="javascript:cancelCreateInvoice();" class="btn btn-primary">Cancel</button>';
				htmlContent += '	&nbsp;&nbsp;';
				htmlContent += '    <img src="'+contentData.module_dir+'/img/ajax-loader.gif" style="height:20px;" id="ajaxLoaderImg">';
				htmlContent += '</div>';
				htmlContent += '</div>';
			}
			else
			{
				htmlContent += '<div class="panel">';	
				if (contentData.allow_create_label)
				{
					htmlContent += '	<label for="validateSSShipping">Click here to create a label for shipment:</label>';
					htmlContent += '	<input id="validateSSShipping" type="submit" class="button" name="validateSSShipping" value="Create Label" />';
				}
				else
					htmlContent += '	<label for="validateSSShipping">You do not have enough money in your account to create a label for shipment.</label>';
				htmlContent += '</div>';
			}
		}
	
		htmlContent += '</fieldset>';
		htmlContent += '</form>';
	
		if (contentData.shipment_validated)
		{
			htmlContent += '<div class="panel">';	
			htmlContent += '<fieldset>';
			htmlContent += '	<div class="panel-heading">';
			htmlContent += '		<img src="'+contentData.presta_base_dir+'img/admin/delivery.gif" alt="">';
			htmlContent += '		Sellstrom - Labels';
			htmlContent += '	</div>';
			htmlContent += '	<div class="table-responsive">';
			htmlContent += '	<table class="table" style="width: 100%;" id="sellstromLabels">';
			htmlContent += '		<thead><tr>';
			htmlContent += '			<th>Tracking Number</th>';
			htmlContent += '			<th>Unit</th>';
			htmlContent += '			<th>Label</th>';
			htmlContent += '		</tr></thead>';
			for (var i=0; i < contentData.shipment_labels.length; i++)
			{
				var labelData = contentData.shipment_labels[i];
				var labelUrl = contentData.presta_base_dir+'modules/sellstrom/label.php?id_tracking='+
								labelData.id_sellstrom_tracking+'&id_order='+labelData.id_order+'&secure_key='+
								labelData.secure_key;

				htmlContent += '	<tr>';
				htmlContent += '		<td>'+labelData.tracking_number+'</td>';
				htmlContent += '		<td>'+labelData.unit+'</td>';
				htmlContent += '		<td><a target="_blank" href="'+labelUrl+'">Print</a></td>';
				htmlContent += '	</tr>';
			}
			htmlContent += '	</table>';
			htmlContent += '	</div>';
			htmlContent += '</fieldset>';
			htmlContent += '</div>';
			htmlContent += '<div class="panel">';	
			htmlContent += '<fieldset>';
			htmlContent += '	<div class="panel-heading">';
			htmlContent += '		<img src="'+contentData.presta_base_dir+'img/admin/delivery.gif" alt="">';
			htmlContent += '		Sellstrom - Tracking';
			htmlContent += '	</div>';
			htmlContent += '	<div class="table-responsive">';
			htmlContent += '	<table class="table" style="width: 100%;" id="trackingData">';
			htmlContent += '		<thead><tr>';
			htmlContent += '			<th>Date</th>';
			htmlContent += '			<th>Tracking Number</th>';
			htmlContent += '			<th>Event</th>';
			htmlContent += '			<th>Location</th>';
			htmlContent += '		</tr></thead>';
			for (var i=0; i < contentData.tracking_data.length; i++)
			{
				var trackData = contentData.tracking_data[i];
				htmlContent += '	<tr>';
				htmlContent += '		<td>'+trackData.date+'</td>';
				htmlContent += '		<td>'+trackData.tracking_number+'</td>';
				htmlContent += '		<td>'+trackData.event+'</td>';
				htmlContent += '		<td>'+trackData.location+'</td>';
				htmlContent += '	</tr>';
			}
			htmlContent += '	</table>';
			htmlContent += '	</div>';
			htmlContent += '	<form action="" method="POST">';
			htmlContent += '		<input type="submit" class="button" name="refreshTrackingEvent" value="Refresh tracking"/>';
			htmlContent += '	</form>';
			htmlContent += '</fieldset>';
			htmlContent += '</div>';
		}

		if (showPanel)
			htmlContent += '</div>';
		else
			htmlContent += '</fieldset>';

		$('#formAddPayment').parent().after(htmlContent);
		$('#ajaxLoaderImg').hide();
	});
	{/literal}
</script>

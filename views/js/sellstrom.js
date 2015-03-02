/*
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
*/
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

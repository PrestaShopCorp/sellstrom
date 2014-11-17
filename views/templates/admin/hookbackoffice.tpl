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
</style>

<script type='text/javascript'>
	{literal}
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
        var finalValue = Number(addAmount.value) + Number(0.02 * addAmount.value);
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

	$(function() {
		var contentData = {/literal}{$content_data|json_encode}{literal};
		var htmlContent = '<div class="panel">';
		htmlContent += '<div class="panel-heading">';
		htmlContent += '	<legend><img src="'+contentData.presta_base_dir+'/img/admin/delivery.gif" alt="">&nbsp;Sellstrom</legend>';
		htmlContent += '</div>';

		if (contentData.error_message) {
			htmlContent += '<div class="isa_error" id="sellstromErrorMessage">'+contentData.error_message+'</div>';
		}
	
		if (contentData.info_message) {
			htmlContent += '<div class="isa_info"  id="sellstromInfoMessage">'+contentData.info_message+'</div>';
		}

		htmlContent += '<form action="" method="POST">';
		htmlContent += '<fieldset>';
		htmlContent += '<div class="panel">';	
		htmlContent += '	<label for="SSBalance">Your Sellstrom balance:</label>';
		htmlContent += '	<input type="text" readonly=readonly id="SSBalance" value="'+contentData.balance_amount+'" />';
		htmlContent += '	<a href="###" onclick="javascript:enableAddFundsForm();">';
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
		htmlContent += '			</div>';
		htmlContent += '			<label for="addAmount" id="addFundsFinalLabel">';
		htmlContent += '				Final amount to be paid (including 2% PayPal processing fee)';
		htmlContent += '			</label>';
		htmlContent += '			<div id="addFundsFinalDiv">';
		htmlContent += '				<input id="finalAmount" type="text" disabled value="" />';
		htmlContent += '			</div>';
		htmlContent += '			<br/>';
		htmlContent += '			<div id="addFundsButtonsDiv">';
		htmlContent += '				<a href="##" onClick="javascript:submitForm()">';
		htmlContent += '					<img src="'+contentData.module_dir+'/img/paypal_paynow.gif">';
		htmlContent += '				</a>';
		htmlContent += '				<a href="##" class="sellstrom-link-ext" onClick="javascript:disableAddFundsForm();resetFields();">';
		htmlContent += '					Cancel';
		htmlContent += '				</a>';
		htmlContent += '			</div>';
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
				htmlContent += '	<label for="voidSSShipping">Click here to void shipping</label>&nbsp;&nbsp;';
				htmlContent += '	<input id="voidSSShipping" type="submit" class="button" name="voidSSShipping" value="Void"';
				htmlContent += '		onClick="return confirm(\'Are you sure you want to cancel shipping for this order?\');" />';
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
			htmlContent += '		<img src="'+contentData.presta_base_dir+'/img/admin/delivery.gif" alt="">';
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
			htmlContent += '		<img src="'+contentData.presta_base_dir+'/img/admin/delivery.gif" alt="">';
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
		htmlContent += '</div>';

		$('#formAddPayment').parent().after(htmlContent);
	});
	{/literal}
</script>

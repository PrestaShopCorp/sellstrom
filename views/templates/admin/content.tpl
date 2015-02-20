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

<link href="{$module_dir|escape:'htmlall':'UTF-8'}views/css/sellstrom.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
	    var height = 0;
	    $('.twoCol').each(function(){
		if (height < $(this).height())
		    height = $(this).height();
	    });

	    $('.twoCol').css({'height' : $('.twoCol').css('height', height+'px')});
	});

	/* Fancybox */
	$('a.sellstrom-video-btn').live('click', function(){
	    $.fancybox({
	        'type' : 'iframe',
	        'href' : this.href.replace(new RegExp("watch\\?v=", "i"), 'embed') + '?rel=0&autoplay=1',
	        'swf': {'allowfullscreen':'true', 'wmode':'transparent'},
	        'overlayShow' : true,
	        'centerOnScroll' : true,
	        'speedIn' : 100,
	        'speedOut' : 50,
	        'width' : 853,
	        'height' : 480
	    });
	    return false;
	});
	{/literal}
</script>

<div class="sellstrom-wrapper">
	<a href="http://www.sellstromship.com/" target=_blank class="sellstrom-logo"><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/logo-sellstrom.png" alt="Sellstrom Global Shipping" border="0" /></a>
	<p class="sellstrom-intro">
		{l s='The Smarter Shipping Solution' mod='sellstrom'}
		<a href="http://www.sellstromship.com/" target=_blank>{l s='Create an account' mod='sellstrom'}</a>
	</p>
	<div class="sellstrom-content">
		<div class="sellstrom-video">
			<a href="http://www.youtube.com/embed/tzSSQyli6H4" class="sellstrom-video-btn"><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/video-screen.jpg" alt="Sellstrom Global Shipping" /><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/btn-video.png" alt="" class="video-icon" /></a>
			<a href="http://www.sellstromship.com/" target=_blank class="sellstrom-link">{l s='Create your free SGS account today!' mod='sellstrom'}</a>
		</div>
		<div class="sellstrom-leftCol">
			<h3>{l s='SGS Saves  You Time  and Money' mod='sellstrom'}</h3>
			<p>{l s='The SGS Shipping Module simplifies your shipping and saves your company money. Your customer chooses the carrier and transit time - UPS, FedEx, USPS and DHL - all on one platform. Once the customer chooses the carrier and service, the shipping label is automatically created within your order.' mod='sellstrom'}</p>
				<div>
				<table border=0 width="80%">
					<tr>
						<td align=center><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/click.png" class="carriers-logos" height="90px" /></td>
						<td align=center><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/print.png" class="carriers-logos" height="90px" /></td>
						<td align=center><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/label.png" class="carriers-logos" height="90px" /></td>
					</tr>
					<tr>
						<td align=center valign=top>Click</td>
						<td align=center valign=top>Print</td>
						<td align=center valign=top>Label</td>
					</tr>
				</table>
				<br/>
				<p>{l s='You just click, print and place the shipping label on the box. The tracking information is downloaded into the order and available for your customer. No more entering orders or tracking numbers.' mod='sellstrom'}</p>
			</div>
		</div>
	</div>
	<div class="sellstrom-content-left">
		<div class="sellstrom-content-left">
			<p>{l s='If you have a current UPS, FedEx or DHL contract, we can plug it into the module. We will even assist you in opening any accounts that you may need. Don’t have a DHL account? We work with authorized DHL resellers to bring you the best pricing on your international shipments available. This module also includes negotiated pricing on postal services and eliminates the need for a separate postal account, saving you money. With the SGS Module, you don’t need to be a shipping expert, we handle the details for you.' mod='sellstrom'}</p>
			<center><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/carries-logos.png" alt="USPS, DHL and UPS" class="carriers-logos" /></center>
		</div>
	</div>

{if isset($validation)}
    <div class="conf confirm">
    	 {$validation|escape}
    </div>
{/if}

	<form action="" method="post">
		<fieldset class="twoCol floatLeft">
			<legend><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/credentials.png"> {l s='Settings' mod='sellstrom'}</legend>
			<h4>{l s='Please enter your SGS username and password, which is needed to complete the configuration process.' mod='sellstrom'}</h4>
			<label for="login">{l s='API Key' mod='sellstrom'}</label>
			<div class="margin-form">
				<input id="user_id" type="text" name="user_id" value="{$user_id|escape:'htmlall':'UTF-8'}" />
			</div>
			<label for="login">{l s='Username' mod='sellstrom'}</label>
			<div class="margin-form">
				<input id="login" type="text" name="login" value="{$login|escape:'htmlall':'UTF-8'}" />
			</div>
 			<label for="password">{l s='Password' mod='sellstrom'}</label>
			<div class="margin-form">
				<input id="password" type="password" name="password" value="{$password|escape:'htmlall':'UTF-8'}" />
			</div>

			<div class="margin-form clear">
				<input class="button" type="submit" value="{l s='Save' mod='sellstrom'}" />
			</div>
			<br/>
		</fieldset>
	</form>
	<fieldset class="twoCol floatRight">
		<legend><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/address.gif"> {l s='Address' mod='sellstrom'}</legend>
		<h4>{l s='Information/Address below will be used as the shipping origination address for all quotes and shipments.' mod='sellstrom'}</h4>
		<p><label for="login">{l s='Company' mod='sellstrom'}</label>{$merchant.company|escape:'htmlall':'UTF-8'}</p>
		<p><label for="login">{l s='Address 1' mod='sellstrom'}</label>{$merchant.address1|escape:'htmlall':'UTF-8'}</p>
		<p><label for="password">{l s='Address 2' mod='sellstrom'}</label>{$merchant.address2|escape:'htmlall':'UTF-8'}</p>
		<p><label for="password">{l s='City' mod='sellstrom'}</label>{$merchant.city|escape:'htmlall':'UTF-8'}</p>
		<p><label for="password">{l s='State' mod='sellstrom'}</label>{$merchant.state|escape:'htmlall':'UTF-8'}</p>
		<p><label for="password">{l s='Zip' mod='sellstrom'}</label>{$merchant.zip|escape:'htmlall':'UTF-8'}</p>
		<p><label for="password">{l s='Country' mod='sellstrom'}</label>{$merchant.country|escape:'htmlall':'UTF-8'}</p>
		<div class="margin-form"><a href="{$addr_edit_link}" class="sellstrom-link-ext"><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/edit.gif">{l s='Edit my address' mod='sellstrom'}</a></div>
	</fieldset>
	<fieldset class="clearBoth">
		<legend><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/credit.gif"> {l s='Credit' mod='sellstrom'}</legend>
		<h4>{l s='This field shows the remaining credit you have with Sellstrom' mod='sellstrom'}</h4>
		<label for="login">{l s='Remaining credit' mod='sellstrom'}</label>
		<div class="margin-form">
			<input id="login" type="text" name="login" value="{displayPrice price=$merchant.balance}" />
		</div>
		<div class="margin-form">
			<a href="####" class="sellstrom-link-ext" onClick="javascript:enableAddFundsForm();">
				<img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/add-credit.gif">{l s='Add more credit' mod='sellstrom'}
			</a>
		</div>
		<div id="addFundsMainDiv" style="display:none">
		<form action="http://54.235.249.8/console/index.php" method="post" name="addFundsForm" id="addFundsForm">
			<label for="addAmount" id="addFundsLabel">{l s='Add funds ($)' mod='sellstrom'}</label>
			<div class="margin-form" id="addFundsFormDiv">
				<input id="addAmount" name="addAmount" type="text" onBlur="javascript:populateFinal();" value="" />
				<input id="formAction" type="hidden" name="action" value="addFunds" />
				<input id="apiKey" type="hidden" name="apiKey" value="{$user_id|escape:'htmlall':'UTF-8'}" />
				<input id="username" type="hidden" name="username" value="{$login|escape:'htmlall':'UTF-8'}" />
				<input id="userpass" type="hidden" name="password" value="{$password|escape:'htmlall':'UTF-8'}" />
				<input id="currentPageUrl" type="hidden" name="finalRedirectUrl" />
				<input id="finalSubmitValue" type="hidden" name="amount" value="" />
				<input id="finalAmount" type="hidden" value="" />
			</div>
			<div class="margin-form" id="addFundsButtonsDiv">
				<a href="##" onClick="javascript:submitForm()">
					<img src="https://www.paypalobjects.com/webstatic/en_US/btn/btn_paynow_cc_144x47.png">
				</a>
				<a href="##" class="sellstrom-link-ext" onClick="javascript:disableAddFundsForm();resetFields();">{l s='Cancel' mod='sellstrom'}</a>
			</div>
		</form>
		</div>
	</fieldset>
</div>

<script type="text/javascript">
	function resetFields() {
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
		var apiKey = document.getElementById('apiKey').value;
		var username = document.getElementById('username').value;
		var userpass = document.getElementById('userpass').value;
		if (!amount) {
			alert('Add funds amount cannot be empty. Please enter the amount and click on Pay Now.');
			return false;
		} else if (amount < 1) {
			alert('Add funds amount should be more than or equal to $1.');
			return false;
		} else if (apiKey == '' || username == '' || userpass == '') {
			alert('API Key, Username and Password are mandatory account details that are required to Add Funds to your account. To create a new account, please click on the button \'Create an account\'');
			return false;
		}

		var finalAmountValue = document.getElementById('finalAmount').value;
		var c = confirm("You will be now redirected to the PayPal secured payment gateway for the payment of amount (" + finalAmountValue + "). Are you sure you want to proceed with the payment?");
		if (c == true) {
			document.getElementById('currentPageUrl').value = getCurrentPageURL();
			document.getElementById('addFundsForm').submit();
		}
	}

	resetFields();
</script>

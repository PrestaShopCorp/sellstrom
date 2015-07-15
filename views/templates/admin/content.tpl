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
{if isset($validation)}
    <div class="conf confirm">
    	 {$validation|escape:'htmlall':'UTF-8'}
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
	<br/>
	<div class="halfCol floatLeft">
		<h1>{l s='Steps to Configure Your SGS Module' mod='sellstrom'}</h1>
		<h3>{l s='Input the Login Credentials' mod='sellstrom'}</h3>
		<p>{l s='1. Log into your PrestaShop Dashboard.' mod='sellstrom'}</p>
		<p>{l s='2. Click the Modules tab on the left side of the page.' mod='sellstrom'}</p>
		<p>{l s='3. Scroll down until you see the SGS Module.' mod='sellstrom'}</p>
		<p>{l s='4. Click on the configure button on the right side of the module.' mod='sellstrom'}</p>
		<br />
		
		<h3>{l s='Set Product and Weight Dimensions' mod='sellstrom'}</h3>
		<p>{l s='1. From the PrestaShop Dashboard, click on Catalog from the menu on the left.' mod='sellstrom'}</p>
		<p>{l s='2. Click on Products.' mod='sellstrom'}</p>
		<p>{l s='3. Click Edit to the right of each product.' mod='sellstrom'}</p>
		<p>{l s='4. Click the shipping tab on the edit page.' mod='sellstrom'}</p>
		<p>{l s='5. Fill in the package size and weight information for each product.' mod='sellstrom'}</p>
		<br />
		
		<h3>{l s='Select the Carriers' mod='sellstrom'}</h3>
		<p>{l s='1. From the PrestaShop Dashboard, click on Shipping from teh menu on the left.' mod='sellstrom'}</p>
		<p>{l s='2. Click on Carriers.' mod='sellstrom'}</p>
		<p>{l s='3. This will show a list of carriers and services - Click the X next to any carrier service that you do not want to be offered to your customer.' mod='sellstrom'}</p>
		<br />
		
		
		<h3>{l s='Add a Handling Charge' mod='sellstrom'}</h3>
		<p>{l s='The price that your custoer will see for shipping will be the same amount that you will be charged unless there is a handling charge added. You may want to consider this, especially if you are doing frequent FedEx and UPS shipments because of the residential delivery fee. Adding a handling charge changes the amount that the customer sees for the shipping price - it is not broken out as a separate fee.' mod='sellstrom'}</p>
		<p>{l s='1. From the PrestaShop Dashboard, click on Shipping from the menu on the left.' mod='sellstrom'}</p>
		<p>{l s='2. Click on Preferences.' mod='sellstrom'}</p>
		<p>{l s='3. Enter a dollar amount in the handling charges.' mod='sellstrom'}</p>
		<br />
		
		<h3>{l s='Choose the Countries You Will Ship Products To' mod='sellstrom'}</h3>
		<p>{l s='1. From the PrestaShop Dashboard, click on Localization from the menu on the left.' mod='sellstrom'}</p>
		<p>{l s='3. Click on Countries.' mod='sellstrom'}</p>
		<p>{l s='3. Enable or Disable Country by Selecting a Checkmark or X.' mod='sellstrom'}</p>
		<br />
		
		<h3>{l s='Fund Your Meter Balance' mod='sellstrom'}</h3>
		<p>{l s='All USPS shipments and shipments utilizing an SGS account need to be prepaid from your SGS postage meter. Shipments utilizing your companys carrier account, will be billed to you by the carrier and do not need to be prepaid. To fund your meter:' mod='sellstrom'}</p>
		<p>{l s='1. Log into the SGS Console @ sellstromship.com.' mod='sellstrom'}</p>
		<p>{l s='2. Click login and enter the username and password from the registration email.' mod='sellstrom'}</p>
		<p>{l s='3. Or if already logged in, click console from the menu on the top of page.' mod='sellstrom'}</p>
		<p>{l s='4. On the top right side of page, under the add funds section, enter the amount to add to your meter.' mod='sellstrom'}</p>
		<p>{l s='5. You will be redirected to the SGS PayPal page to complete the transaction.' mod='sellstrom'}</p>
	</div>
	<div class="halfCol floatRight">
		<div class="sellstrom-video">
			<a href="https://www.youtube.com/embed/8rdCkt3nhCg" class="sellstrom-video-btn"><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/IntroducingPrestashop.png" alt="Sellstrom Global Shipping" /><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/btn-video.png" alt="" class="video-icon" /></a>
			<a href="http://www.sellstromship.com/" target=_blank class="sellstrom-link">{l s='PrestaShop & SGS' mod='sellstrom'}</a>
		</div>
		<br/>
		<div class="sellstrom-video">
			<a href="https://www.youtube.com/embed/v1x-2DaPoiw" class="sellstrom-video-btn"><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/HowPrestaShopWorks.png" alt="Sellstrom Global Shipping" /><img src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/btn-video.png" alt="" class="video-icon" /></a>
			<a href="http://www.sellstromship.com/" target=_blank class="sellstrom-link">{l s='How it Works...' mod='sellstrom'}</a>
		</div>
	</div>
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

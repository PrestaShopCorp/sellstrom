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

<link href="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/css/sellstrom.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/js/sellstromFrontEnd.js"></script>

<script type="text/javascript">
	{literal}
	$(function() {
		contentData = {/literal}{$content_data|json_encode}{literal};
		var carrierData = contentData.carrier_data;
		var productHash = contentData.product_hash;
		var htmlContent = '';
		for (var i=0; i < carrierData.length; i++) {
			var data = carrierData[i];
			productHash = data.product_hash;
			htmlContent += '<div class="delivery_option item">';
			htmlContent += '	<div>';
			htmlContent += '    <table class="resume table table-bordered">';
			htmlContent += '    	<tr>';
			htmlContent += '    		<td class="delivery_option_radio">';
			htmlContent += '				<div id="uniform-'+data.radio_id+'" class="radio">';
			htmlContent += '					<span>';
			htmlContent += '    					<input 	class="delivery_option_radio" type="radio"';
			htmlContent += '    							name="'+data.radio_name+'"';
			htmlContent += '    							onchange="'+data.radio_onchange+'"';
			htmlContent += '    							id="'+data.radio_id+'"';
			htmlContent += '    							value="'+data.radio_value+'" checked="checked">';
			htmlContent += '					</span>';
			htmlContent += '				</div>';
			htmlContent += '    		</td>';
			htmlContent += '            <td class="delivery_option_logo">';
			htmlContent += '                <img src="'+data.carrier_img_src+'" alt="'+data.carrier_img_alt+'" />';
			htmlContent += '            </td>';
			htmlContent += '            <td>';
			htmlContent += '                <div class="delivery_option_title">'+data.delivery_option_title+'</div>';
			htmlContent += '                <div class="delivery_option_delay">'+data.delivery_option_delay+'</div>';
			htmlContent += '            </td>';
			htmlContent += '            <td>';
			htmlContent += '                <div class="delivery_option_price">'+data.delivery_option_price+'</div>';
			htmlContent += '            </td>';
			htmlContent += '        </tr>';
			htmlContent += '    </table>';
			htmlContent += '    <input type="hidden" value="'+data.carrier_id+'" name="id_carrier">';
			htmlContent += '	</div>';
			htmlContent += '</div>';
		}

		htmlContent += '<div class="isa_info" id="addInsuranceDisplay">';
		htmlContent += '	Insurance Amount: '+contentData.insurance_amount+' USD (<a href="#" onclick="javascript:removeInsurance();">Remove</a>)';
		htmlContent += '    &nbsp;&nbsp;';
		htmlContent += '    <img src="'+contentData.module_dir+'/views/img/ajax-loader.gif" style="height:20px;" id="ajaxLoaderImgRemove">';
		htmlContent += '</div>';

		htmlContent += '<p class="checkbox" id="addInsuranceCheck" style="margin-bottom:10px;">';
		htmlContent += '	<input id="addInsurance" type="checkbox" value="1" name="addInsurance" onchange="javascript:checkAddInsurance(this);">';
		htmlContent += '	<label for="addInsurance"><b>Add Insurance</b></label>';
		htmlContent += '</p>';
		htmlContent += '<div id="addInsuranceForm" style="margin-top:10px;margin-bottom:10px;width:275px;border:1px solid #d6d4d4;padding:12px;">';
		htmlContent += '	<label for="addInsuranceAmount">Amount *</label>';
		htmlContent += '	<input id="addInsuranceAmount" type="text" class="is_required validate form-control" name="addInsuranceAmount" style="margin-bottom:10px;">';
		htmlContent += '	<button type="button" onClick="javascript:fetchInsuranceData();" class="btn btn-primary">Submit</button>';
		htmlContent += '    &nbsp;&nbsp;';
		htmlContent += '    <img src="'+contentData.module_dir+'/views/img/ajax-loader.gif" style="height:20px;" id="ajaxLoaderImg">';
		htmlContent += '</div>';

		var pdata = contentData.post_data;
		htmlContent += '<form id="sellstromPostController" method="POST" action="'+pdata.url+'">';
		jQuery.each(pdata, function(i, val) {
			htmlContent += '<input type="hidden" name="'+i+'" value="'+val+'">';
		});
		htmlContent += '</form>';

		$('#noCarrierWarning').hide();
		$('#form .delivery_options').html(
			$('#form .delivery_options').html() + htmlContent
		);

		if (contentData.insurance_amount) {
			$('#addInsuranceDisplay').show();
			$('#addInsuranceCheck').hide();
		}
		else {
			$('#addInsuranceDisplay').hide();
			$('#addInsuranceCheck').show();
		}
		$('#addInsuranceForm').hide();
		$('#ajaxLoaderImg').hide();
		$('#ajaxLoaderImgRemove').hide();
	});

	{/literal}
</script>

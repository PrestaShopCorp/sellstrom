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

<script type="text/javascript">
	{literal}
	$(function() {
		var contentData = {/literal}{$content_data|json_encode}{literal};
		var htmlContent = '';
		for (var i=0; i < contentData.length; i++) {
			var data = contentData[i];
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
		$('#noCarrierWarning').hide();
		$('#form .delivery_options').html(
			$('#form .delivery_options').html() + htmlContent
		);
	});
	{/literal}
</script>

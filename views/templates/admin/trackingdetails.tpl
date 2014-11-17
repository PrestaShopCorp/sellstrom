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
		htmlContent += '<div class="table-responsive">';
		htmlContent += '	<table class="table" style="width: 100%;" id="trackingData">';
		htmlContent += '		<thead><tr>';
		htmlContent += '			<th>Date</th>';
		htmlContent += '            <th>Tracking Number</th>';
		htmlContent += '            <th>Event</th>';
		htmlContent += '            <th>Location</th>';
		htmlContent += '        </tr></thead>';

		for (var i=0; i < contentData.length; i++) {
			var data = contentData[i];
			htmlContent += '		<tr>';
			htmlContent += '            <td>'+data.date+'</td>';
			htmlContent += '            <td>'+data.tracking_number+'</td>';
			htmlContent += '            <td>'+data.event+'</td>';
			htmlContent += '            <td>'+data.location+'</td>';
			htmlContent += '        </tr>';
		}

		htmlContent += '    </table>';
		htmlContent += '</div>';

		$('#order-detail-content').after(htmlContent);
	});
	{/literal}
</script>

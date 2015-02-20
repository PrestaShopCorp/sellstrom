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
function checkAddInsurance(c) {
	if (c.checked) {
		$('#addInsuranceForm').show();
	} else {
		$('#addInsuranceForm').hide();
		$('#addInsuranceAmount').val('');
	}
}
function fetchInsuranceData() {
	var insuranceAmount = $.trim($('#addInsuranceAmount').val());
	$('#addInsuranceAmount').val(insuranceAmount);
	if (insuranceAmount == '' || insuranceAmount < 0) {
		alert('Please enter insurance amount value of the seleted product(s).');
		return false;
	} else {
		var c = confirm('Adding Insurance may lead to change in the shipping charges of the carriers. Are you sure you want to continue?');
		if (c == true) {
			$.ajax({
				url: contentData.module_dir+'/insurance.php',
				method: 'post',
				beforeSend: function() {
					$('#ajaxLoaderImg').show();
				},
				complete: function() {
					$('#ajaxLoaderImg').hide();
				},
				dataType: 'json',
				data: {
					'action': 'add',
					'product_hash': contentData.product_hash,
					'id_cart': contentData.id_cart,
					'insurance_amount': $('#addInsuranceAmount').val()
				},
				success: function(response) {
					if (!response.success) {
						alert(response.msg);
						return false;
					}

					window.location.reload(true);
				},
				error: function(response) {
					alert('error');
				}
			});
		}
	}
}
function removeInsurance() {
	var c = confirm('Are you sure you want to remove the insurance amount?');
	if (c == true) {
		$.ajax({
			url: contentData.module_dir+'/insurance.php',
			method: 'post',
			beforeSend: function() {
				$('#ajaxLoaderImgRemove').show();
			},
			complete: function() {
				$('#ajaxLoaderImgRemove').hide();
			},
			dataType: 'json',
			data: {
				'action': 'remove',
				'product_hash': contentData.product_hash
			},
			success: function(response) {
				if (!response.success) {
					alert(response.msg);
					return false;
				}

				$('#addInsuranceDisplay').hide();
				$('#addInsuranceCheck').show();
				$('#addInsurance').uniform();
				var t = $('#addInsurance').attr('checked', false);
				$.uniform.update(t);

				window.location.reload(true);
			},
			error: function(response) {
				alert('error');
			}
		});
	}
}

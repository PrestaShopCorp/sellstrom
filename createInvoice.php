<?php
/**
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
*  @author    PrestaShop SA <contact@prestashop.com>
*  @copyright 2014 PrestaShop SA
*  @version  Release: $Revision: 7095 $
*  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

include(dirname(__FILE__).'/../../config/config.inc.php');
include(dirname(__FILE__).'/../../init.php');

if (Tools::getIsset('id_order'))
{
	$id_order = (int)Tools::getValue('id_order');
	$products = Tools::getValue('custom_products');

	$sql = 'SELECT
		o.`id_order`,
		o.`reference`,
		o.`id_lang`,
		o.`id_cart`,
		curr.`iso_code` currency_code,
		curr.`sign` currency_sign,
		cust.`firstname`,
		cust.`lastname`,
		cust.`email` delivery_email,
		ad.`company` delivery_company,
		ad.`address1` delivery_address1,
		ad.`address2` delivery_address2,
		ad.`postcode` delivery_postcode,
		ad.`city` delivery_city,
		ad.`phone` delivery_phone,
		ad.`phone_mobile` delivery_mobile,
		adcl.`name` delivery_country,
		adst.`name` delivery_state
	FROM
		`'._DB_PREFIX_.'orders` o,
		`'._DB_PREFIX_.'currency` curr,
		`'._DB_PREFIX_.'customer` cust,
		`'._DB_PREFIX_.'address` ad,
		`'._DB_PREFIX_.'country_lang` adcl,
		`'._DB_PREFIX_.'state` adst
	WHERE
		o.`id_currency` = curr.`id_currency`
	AND o.`id_customer` = cust.`id_customer`
	AND o.`id_address_delivery` = ad.`id_address`
	AND ad.`id_country` = adcl.`id_country`
	AND adcl.`id_lang` = o.`id_lang`
	AND adst.`id_state` = ad.`id_state`
	AND o.`id_order` = '.$id_order;

	$r = Db::getInstance()->getRow($sql);
	$postvars = '';
	foreach ($r as $key => $value)
		$postvars .= $key.'='.$value.'&';

	$postvars .= 'action=createCommercialInvoice&';
	$postvars .= 'shipper_company='.Configuration::get('PS_SHOP_NAME').'&';
	$postvars .= 'shipper_address1='.Configuration::get('PS_SHOP_ADDR1').'&';
	$postvars .= 'shipper_address2='.Configuration::get('PS_SHOP_ADDR2').'&';
	$postvars .= 'shipper_city='.Configuration::get('PS_SHOP_CITY').'&';
	$postvars .= 'shipper_state='.Tools::getValue('shipper_state').'&';
	$postvars .= 'shipper_country='.Tools::getValue('shipper_country').'&';
	$postvars .= 'shipper_zip='.Configuration::get('PS_SHOP_CODE').'&';
	$postvars .= 'shipper_phone='.Configuration::get('PS_SHOP_PHONE').'&';
	$postvars .= 'tracking_number='.Tools::getValue('tracking_number').'&';
	$postvars .= 'custom_products='.Tools::getValue('custom_products').'&';
	$postvars .= 'total_packages='.Tools::getValue('total_packages').'&';
	$postvars .= 'total_weight='.Tools::getValue('total_weight').'&';

	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, 'http://54.235.249.8/console/index.php');
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $postvars);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	$server_output = curl_exec ($ch);
	curl_close ($ch);
	$filename = time().'.html';
	file_put_contents(dirname(__FILE__).'/invoices/'.$filename, $server_output);
	echo Tools::jsonEncode(array('filename' => $filename));
}

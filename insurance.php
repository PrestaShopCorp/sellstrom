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

if (Tools::getIsset('action') && Tools::getIsset('product_hash'))
{
	$action = Tools::getValue('action');
	$product_hash = Tools::safeOutput(Tools::getValue('product_hash'));
	$success = true;
	if ($action == 'add')
	{
		$insurance_amount = Tools::safeOutput(Tools::getValue('insurance_amount'));

		$isql = 'INSERT INTO `'._DB_PREFIX_.'sellstrom_insurance` (`product_hash`, `insurance_amount`)
				 VALUES (\''.pSQL($product_hash).'\', \''.$insurance_amount.'\')
				 ON DUPLICATE KEY
					UPDATE `insurance_amount`=VALUES(`insurance_amount`)';

		if (!Db::getInstance()->Execute($isql))
		{
			echo Tools::jsonEncode(array('success' => false, 'msg' => 'Insurance Amount update failed.'));
			exit;
		}

		$rsql = 'DELETE FROM `'._DB_PREFIX_.'sellstrom_quote_cache` WHERE `product_hash` = \''.pSQL($product_hash).'\'';
		if (!Db::getInstance()->Execute($rsql))
		{
			echo Tools::jsonEncode(array('success' => false, 'msg' => 'Failed to delete the cached quotes'));
			exit;
		}

		echo Tools::jsonEncode(array('success' => true));
	}
	else if ($action == 'remove')
	{
		$rsql = 'DELETE FROM `'._DB_PREFIX_.'sellstrom_insurance` WHERE `product_hash` = \''.pSQL($product_hash).'\'';
		if (!Db::getInstance()->Execute($rsql))
		{
			echo Tools::jsonEncode(array('success' => false, 'msg' => 'Failed to remove the insurance amount'));
			exit;
		}

		$rsql = 'DELETE FROM `'._DB_PREFIX_.'sellstrom_quote_cache` WHERE `product_hash` = \''.pSQL($product_hash).'\'';
		if (!Db::getInstance()->Execute($rsql))
		{
			echo Tools::jsonEncode(array('success' => false, 'msg' => 'Failed to delete the cached quotes'));
			exit;
		}

		echo Tools::jsonEncode(array('success' => true));
	}
}

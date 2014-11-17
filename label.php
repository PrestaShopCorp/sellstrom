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

if (Tools::getIsset('id_order') && Tools::getIsset('secure_key') && Tools::getIsset('id_tracking'))
{
	$id_tracking = Db::getInstance()->getValue('SELECT st.`id_sellstrom_tracking`
					FROM `'._DB_PREFIX_.'sellstrom_tracking` st
					LEFT JOIN `'._DB_PREFIX_.'orders` o ON (st.`id_order` = o.`id_order`)
					WHERE st.`id_order` = '.(int)Tools::getValue('id_order').'
					AND o.`secure_key` = \''.pSQL(Tools::getValue('secure_key')).'\'
					AND st.`id_sellstrom_tracking` = '.(int)Tools::getValue('id_tracking'));
	if (!$id_tracking)
		echo 'The label haven\'t been found or the secure_key is invalid.';
	else
	{
		# Get the file with extension
		$file_match	= glob(dirname(__FILE__).'/label/'.(int)$id_tracking.'.*');

		if (is_array($file_match))
		{
			$file_name	= $file_match[0];
			$file_ext	= Tools::strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
		}

		if ($file_ext == 'jpg')		header('Content-Type: image/jpeg');
		elseif ($file_ext == 'gif')	header('Content-Type: image/gif');
		elseif ($file_ext == 'png')	header('Content-Type: image/png');
		elseif ($file_ext == 'pdf')	header('Content-Type: application/pdf');
		else 						header('Content-Type: application/octet-stream');

		# Force download
		header('Content-Description: File Transfer');
		header('Content-Disposition: attachment; filename='.basename($file_name));
		header('Expires: 0');
		header('Cache-Control: must-revalidate');
		header('Pragma: public');
		header('Content-Length: '.filesize($file_name));
		ob_clean();
		flush();
		readfile($file_name);
		exit;
	}
}

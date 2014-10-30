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

if (!defined('_PS_VERSION_'))
	exit;

require_once(_PS_MODULE_DIR_.'sellstrom/classes/SSCredentials.php');
require_once(_PS_MODULE_DIR_.'sellstrom/classes/SSAddress.php');
require_once(_PS_MODULE_DIR_.'sellstrom/classes/SSService.php');
require_once(_PS_MODULE_DIR_.'sellstrom/classes/SSPackage.php');
require_once(_PS_MODULE_DIR_.'sellstrom/classes/SSRequest.php');

class SSQuoteRequest extends SSRequest
{
	/** @var SSAddress $from 'from' Address object*/
	public $from = null;
	/** @var string $from_id 'from' token */
	public $from_id = null;

	/** @var SSAddress $to 'to' Address Object */
	public $to = null;
	/** @var string $to_id 'to' token */
	public $to_id = null;

	/** @var Array $packages Array of SSPackage to be quoted */
	public $packages = array();

	/** @var Array $accessorials Unused */
	public $accessorials = array();

	/** @var string $carrier Unused */
	public $carrier = null;
	/** @var SSService $service Unused */
	public $service = null;

	public function __construct($from = null,
								$to = null,
								Array $packages = array(),
								Array $accessorials = array(),
								$carrier = null,
								SSService $service = null)
	{
		if ($from instanceof SSAddress)
			$this->from = $from;
		else
			$this->from_id = $from;

		if ($to instanceof SSAddress)
			$this->to = $to;
		else
			$this->to_id = $to;

		$this->packages = $packages;
		$this->accessorials = $accessorials;
		$this->carrier = $carrier;
		$this->service = $service;
	}
}

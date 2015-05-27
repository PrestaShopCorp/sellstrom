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

require_once(_PS_MODULE_DIR_.'sellstrom/classes/SSPackaging.php');

class SSProduct
{
	/** @var string $item Product name */
	public $item = null;

	/** @var string $item Product id */
	public $number = null;

	/** @var string $description Product description */
	public $description = null;

	/** @var enum $packaging @see SSPackaging class for possible values */
	public $packaging = SSPackaging::BOX;

	/** @var interger $pieces Amount of piece for the product */
	public $pieces = 1;

	/** @var float $lbs LBS part of the weight for the Product (@see $ounces) */
	public $lbs = 0.;

	/** @var float $ounces OUNCES part of the weigth for the Product (@see $lbs) */
	public $ounces = 0.;

	public $weight_unit = '';

	public $length = 0.;
	public $width = 0.;
	public $height = 0.;

	public $fclass = 0.;
	public $nmfc = null;
	public $insurance = 0.;
	public $declared_value = 0.;

	public $tariff_no = 0.;
	public $country_of_origin = null;
	public $hazardous = false;
	public $not_stackable = false;
	public $included_products = array();

	public function __construct()
	{
	}
}

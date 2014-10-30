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

require_once(_PS_MODULE_DIR_.'sellstrom/classes/SSLogin.php');

class SSCredentials
{
	/** @var integer $id Unique customer ID provided by SellStrom */
	public $id = null;

	/** @var SSLogin $login login Object */
	public $login = null;
	/** @var string $login_id login token */
	public $login_id = null;

	public $session_id = null;

	public function __construct($username, $password, $id)
	{
		$this->id = $id;
		$this->login = new SSLogin($username, $password);
	}

	/**
	 * @brief Swtich from the Login object to Login token
	 *
	 * @param string $login_id Login token
	 *
	 */
	public function setLoginId($login_id)
	{
		//unset($this->login);
		$this->login_id = $login_id;
	}
}

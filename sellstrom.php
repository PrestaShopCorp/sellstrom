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

#error_reporting(E_ERROR);

#require_once('/usr/local/src/ship_api/libs/ishippers/Utilities/HelperP.php');

if (!defined('_PS_VERSION_'))
	exit;

class Sellstrom extends CarrierModule
{
	protected $init = false;
	protected $messages = array();
	protected $new_carriers = array();
	public $id_carrier = 0;

	public function __construct()
	{
	$this->name = 'sellstrom';
	$this->tab = 'shipping_logistics';
	$this->version = '0.1.0';
	$this->author = 'Sellstrom Global Shipping';
	$this->need_instance = 1;

		parent::__construct();

#		Configuration::updateValue('PS_LANG_DEFAULT','en');

	if ($this->id && !Configuration::get('SELLSTROM_USER_ID'))
		$this->warning = $this->l('You must provide your Sellstrom account details to complete the configuration process.');

	$this->confirmUninstall = $this->l('Are you sure you want to delete your details?');
	$this->displayName = $this->l('Sellstrom Global Shipping');
	$this->description = $this->l('Sellstrom offers discounted global shipping services on one platform
	to help simplify your shipping needs and save your business money.');
	}

	public function install()
	{
		$this->checkRequirement();

		if (!Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'sellstrom_carrier` (
			`id_carrier` int(11) NOT NULL AUTO_INCREMENT,
			`hash` varchar(32) NOT NULL,
			PRIMARY KEY (`id_carrier`,`hash`),
			UNIQUE KEY `hash` (`hash`)
		) ENGINE=InnoDB  DEFAULT CHARSET=utf8') ||
			!Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'sellstrom_quote_cache` (
			`id_sellstrom_quote_cache` int(11) NOT NULL AUTO_INCREMENT,
		`quote_ref` int(11) NOT NULL,
		`quote_id` int(11) NOT NULL,
		`login_id` int(11) NOT NULL,
		`id_carrier` int(11) NOT NULL,
		`id_address` int(11) NOT NULL,
		`id_cart` int(11) NOT NULL,
		`id_currency` int(11) NOT NULL,
		`price` float(8,4) NOT NULL,
		`product_hash` varchar(32) NOT NULL,
		`label_url` varchar(255) DEFAULT NULL,
		`date_add` int(11) DEFAULT NULL,
	 PRIMARY KEY (`id_sellstrom_quote_cache`)
	 ) ENGINE=InnoDB  DEFAULT CHARSET=utf8') ||
			!Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'sellstrom_tracking` (
		`id_sellstrom_tracking` int(11) NOT NULL AUTO_INCREMENT,
			`id_order` int(11) NOT NULL,
		`tracking_id` int(11) NOT NULL,
		`product_id` int(11) NOT NULL,
		`unit` int(11) NOT NULL,
		`tracking_number` varchar(255) NOT NULL,
			`printed` tinyint(1) NOT NULL DEFAULT 0,
	 PRIMARY KEY (`id_sellstrom_tracking`)
	 ) ENGINE=InnoDB DEFAULT CHARSET=utf8') ||
			!Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'sellstrom_shipment` (
		`id_sellstrom_shipment` int(11) NOT NULL AUTO_INCREMENT,
		`id_order` int(11) NOT NULL,
		`shipment_id` varchar(255) NOT NULL,
		`void` tinyint(1) NOT NULL,
	 PRIMARY KEY (`id_sellstrom_shipment`)
	 ) ENGINE=InnoDB DEFAULT CHARSET=utf8') ||
			!Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'sellstrom_tracking_event` (
		`id_sellstrom_tracking_event` int(11) NOT NULL AUTO_INCREMENT,
		`id_order` int(11) NOT NULL,
		`event` varchar(255) NOT NULL,
		`location` varchar(255) NOT NULL,
		`tracking_number` varchar(255) NOT NULL,
		`date` datetime NOT NULL,
	 PRIMARY KEY (`id_sellstrom_tracking_event`)
	 ) ENGINE=InnoDB DEFAULT CHARSET=utf8'))
			$this->_errors[] = $this->l('Error with the database during the installation');

		return !count($this->_errors) && parent::install() &&
			Configuration::updateValue('SELLSTROM_USER_ID', '') &&
			Configuration::updateValue('SELLSTROM_LOGIN', '') &&
			Configuration::updateValue('SELLSTROM_PASSWORD', '') &&
			Configuration::updateValue('SELLSTROM_MODE_TEST', false) &&
			Configuration::updateValue('SELLSTROM_ALLOW_NEGATIVE', false) &&
			$this->registerHook('header') &&
			$this->registerHook('backofficeHeader') && $this->registerHook('displayOrderDetail');
	}

	public function hookDisplayOrderDetail($params)
	{
		$r = Db::getInstance()->ExecuteS('SELECT `date`, 
												`tracking_number`, 
												`event`, 
												`location` 
										FROM `'._DB_PREFIX_.'sellstrom_tracking_event` 
										WHERE `id_order` = '.(int)$params['order']->id);
		$html = '';
		if ($r && count($r))
		{
				$html .= '<div class="table_block"><table class="std"><tr><th>'.$this->l('Date').
							'</th><th>'.$this->l('Event').'</th><th>'.$this->l('Location').
							'</th><th>'.$this->l('Tracking number').'</th></tr>';
				foreach ($r as $line)
					$html .= '<tr><td>'.Tools::safeOutput(Tools::displayDate($line['date'], null, true)).'</td>
								<td>'.Tools::safeOutput($line['event']).'</td>
								<td>'.Tools::safeOutput($line['location']).'</td>
								<td>'.Tools::safeOutput($line['tracking_number']).'</td></tr>';
				$html .= '</table></div>';
		}

			return '<script type="text/javascript">
$(function() {
$(\'#order-detail-content\').after(\''.str_replace(array('\'', "\n"), array('\\\'', "\\\n"), $html).'\');
});
</script>';
	}

	public function uninstall()
	{
		return Configuration::deleteByName('SELLSTROM_USER_ID') &&
			Configuration::deleteByName('SELLSTROM_LOGIN') &&
			Configuration::deleteByName('SELLSTROM_PASSWORD') &&
			Configuration::deleteByName('SELLSTROM_MODE_TEST') &&
			Configuration::deleteByName('SELLSTROM_ALLOW_NEGATIVE') &&
			parent::uninstall();
	}

	protected function instanciateClient()
	{
		###HelperP::log('instanciateClient called.');

		if ($this->init)
			return;
		$this->init = true;

		include(dirname(__FILE__).'/classes/SSQuoteRequest.php');
		include(dirname(__FILE__).'/classes/SSQuoteResponse.php');
		include(dirname(__FILE__).'/classes/SSQuote.php');

		ini_set('soap.wsdl_cache_enabled', '0');
		ini_set('allow_url_fopen', '1');
		$this->_client = new SoapClient('http://54.235.249.8/soap_server/wsdl/webship.wsdl', array('trace' => 1, 'classmap' => array(
													'QuoteRequest' => 'SSQuoteRequest',
													'QuoteResponse' => 'SSQuoteResponse',
													'Quote' => 'SSQuote',
													'Package' => 'SSPackage',
													'Credentials' => 'SSCredentials',
													'Login' => 'SSLogin',
													'Product' => 'SSProduct',
													'TrackingNumbers' => 'SSTrackingNumbers',
												))); // Refer to http://us3.php.net/manual/en/ref.soap.php for more information

		###HelperP::log('instanciateClient :: calling SSCredentials');
		$this->static_cred = new SSCredentials(Configuration::get('SELLSTROM_LOGIN'),
												Configuration::get('SELLSTROM_PASSWORD'),
												Configuration::get('SELLSTROM_USER_ID'));
		###HelperP::log('instanciateClient :: credentials == ' . json_encode($this->static_cred));
	}

	public function getContent()
	{
		###HelperP::log('Called getContent...');
		// Add fancybox for the video
		$this->context->controller->addJQueryPlugin('fancybox');

		###HelperP::log('Going to call checkRequirement ...');
		$this->checkRequirement();
		###HelperP::log('Going to call processFormGetContent ...');
		$this->processFormGetContent();

		###HelperP::log('Going to call smarty->assign ...');
		$this->context->smarty->assign(array(
				'merchant' => array(
					'company' => Configuration::get('PS_SHOP_NAME'),
					'address1' => Configuration::get('PS_SHOP_ADDR1'),
					'address2' => Configuration::get('PS_SHOP_ADDR2'),
					'city' => Configuration::get('PS_SHOP_CITY'),
					'state' => $this->getIsoByStateId((int)Configuration::get('PS_SHOP_STATE_ID')),
					'zip' => Configuration::get('PS_SHOP_CODE'),
					'country' => Country::getIsoById((int)Configuration::get('PS_SHOP_COUNTRY_ID')),
					'balance' => $this->getSSBalance(),
				),
				'addr_edit_link' => 'index.php?controller=AdminStores&token='.Tools::safeOutput(Tools::getAdminTokenLite('AdminStores').'#store_form'),
			));

		return $this->display(__FILE__, 'views/templates/admin/content.tpl');
	}

	protected function processFormGetContent()
	{
		###HelperP::log('Called processFormGetContent.');
		if (Tools::isSubmit('login'))
		{
			Configuration::updateValue('SELLSTROM_LOGIN', Tools::getValue('login'));
			Configuration::updateValue('SELLSTROM_USER_ID', Tools::getValue('user_id'));
			Configuration::updateValue('SELLSTROM_PASSWORD', Tools::getValue('password'));
			Configuration::updateValue('SELLSTROM_MODE_TEST', Tools::getValue('test_mode'));
			Configuration::updateValue('SELLSTROM_ALLOW_NEGATIVE', Tools::getValue('allow_negative'));
			$this->context->smarty->assign('validation',
				$this->l('The settings have been saved. Customers can now choose Sellstrom as their shipping provider.'));
		}

		$this->context->smarty->assign(
			array(
				'login' => Tools::safeOutput(Configuration::get('SELLSTROM_LOGIN')),
				'user_id' => Tools::safeOutput(Configuration::get('SELLSTROM_USER_ID')),
				'password' => Tools::safeOutput(Configuration::get('SELLSTROM_PASSWORD')),
				'test_mode' => (int)Configuration::get('SELLSTROM_MODE_TEST'),
				'allow_negative' => (bool)Configuration::get('SELLSTROM_ALLOW_NEGATIVE'),
			));
	}

	protected function checkRequirement()
	{
		if (!class_exists('SoapClient'))
			$this->_errors[] = $this->l('Sellstrom requires the PHP SOAP extension. Please contact your hosting provider if you need help enabling it.');
	}

	protected function getIsoByStateId($id_state)
	{
		// Retreive the state isocode
		$id_state = $id_state ? $id_state : (int)Configuration::get('PS_SHOP_STATE_ID');
		$state = new State((int)$id_state);
		if (Validate::isLoadedObject($state))
			return $state->iso_code;
		return '';
	}

	protected function getShopAddress()
	{
		return new SSAddress(array(
				'company' => Configuration::get('PS_SHOP_NAME'),
				'address1' => Configuration::get('PS_SHOP_ADDR1'),
				'address2' => Configuration::get('PS_SHOP_ADDR2'),
				'city' => Configuration::get('PS_SHOP_CITY'),
				'state' => $this->getIsoByStateId((int)Configuration::get('PS_SHOP_STATE_ID')),
				'zip' => Configuration::get('PS_SHOP_CODE'),
				'country' => Country::getIsoById((int)Configuration::get('PS_SHOP_COUNTRY_ID')),
				'phone' => Configuration::get('PS_SHOP_PHONE'),
			));
	}

	protected function convertAddress(Address $addr)
	{
		if (!Validate::isLoadedObject($addr))
			return null;

		return new SSAddress(array(
				'attn' => $addr->firstname.' '.$addr->lastname,
				'company' => $addr->company,
				'address1' => $addr->address1,
				'address2' => $addr->address2,
				'city' => $addr->city,
				'state' => $this->getIsoByStateId((int)$addr->id_state),
				'zip' => $addr->postcode,
				'country' => Country::getIsoById((int)$addr->id_country),
				'phone' => $addr->phone_mobile ? $addr->phone_mobile : $addr->phone,
			));
	}

	protected function forgePackagesFromCart(Cart $cart)
	{
		###HelperP::log('Calling forgePackagesFromCart ...');
		if (!Validate::isLoadedObject($cart))
			return null;
		$packages = array();
		###HelperP::log('   cart getProducts ====> ' . json_encode($cart->getProducts()));
		foreach ($cart->getProducts() as $product)
		{
			$p = new SSProduct();
			$p->item = $product['name'];
			$p->description = $product['description_short'];
			$p->number = $product['id_product'].'_'.$product['id_product_attribute'];
			$p->pieces = $product['cart_quantity'];
			$p->lbs = ($product['weight']) ? $product['weight'] : '0.1';
			$p->length = $product['depth'];
			$p->width = $product['width'];
			$p->height = $product['height'];
			$p->declared_value = $product['total'];
			$packages[] = new SSPackage($p);
		}
		return $packages;
	}

	protected function getQuotes(Cart $cart, Address $addr)
	{
		###HelperP::log('Called getQuotes.');
		if (!Validate::isLoadedObject($cart) || !Validate::isLoadedObject($addr))
			return null;

		###HelperP::log('Instantiating the SOAP Client from getQuotes.');
		// Instanciate the SOAP Client
		$this->instanciateClient();

		// Forge the SSAddress with the store data
		$src_addr = $this->getShopAddress();
		// Forge the destination address with the customer data
		$dst_addr = $this->convertAddress($addr);

		$packages = $this->forgePackagesFromCart($this->context->cart);

		###HelperP::log('Creating SSQuoteRequest webservice from getQuotes.');
		###HelperP::log('  packages ===> ' . json_encode($packages));
		$quote_request = new SSQuoteRequest($src_addr, $dst_addr, $packages);
		###HelperP::log(print_r($quote_request));
		$quote_request->setCredentials($this->static_cred);

		try
		{
			###HelperP::log('Calling SSQuoteRequest::getQuotes webservice from getQuotes.');
			$ret = $this->_client->getQuotes($quote_request);
			if (!count($ret->packages))
				$ret->packages = $packages;

			###HelperP::log('Quotes returned from webservice ===> ' . json_encode($ret) . "\n");
			//unset($this->static_cred->login);
			$this->static_cred->login_id = $ret->login_id;
			$this->static_cred->session_id = $ret->session_id;
		}
		catch (SoapFault $e)
		{
			Logger::addLog('Error: '.Tools::safeOutput($e->getMessage()));
			return null;
		}

		return $ret;
	}

	/**
	 * @brief Hash the cart
	 */
	protected function getCartHash(Cart $cart)
	{
		###HelperP::log('Called getCartHash.');
		###HelperP::log('Cart date_upd === ' . $cart->date_upd);
		###HelperP::log('Cart details === ' . json_encode($cart->getProducts()));
		if (!Validate::isLoadedObject($cart))
			return null;

		$hash = (int)$cart->id.'_'.(int)$cart->id_address_delivery.'___';
		foreach ($cart->getProducts() as $p)
			$hash .= (int)$p['id_product'].'_'.(int)$p['id_product_attribute'].'__'.(int)$p['cart_quantity'].'|'; //'__'.$cart->date_upd.'|';

		###HelperP::log('Cart hash === ' . md5($hash));

		return md5($hash);
	}

	/**
	 * @brief Retrieve the id_carrier from the cache, create the carrier and fill the cache if not exists.
	 */
	protected function getCarrierFromQuote(SSQuote $quote)
	{
		###HelperP::log('Called  getCarrierFromQuote ... Quote ==>  ' . json_encode($quote));
		// Retrieve the id_carrier from the database
		$id_carrier = (int)Db::getInstance()->getValue('SELECT `id_carrier` 
							FROM `'._DB_PREFIX_.'sellstrom_carrier` 
							WHERE `hash` = \''.md5($quote->carrier.'_'.$quote->service.'_'.$quote->transit_time).'\'');

		// Instanciate the carrier
		if ($id_carrier)
			$carrier = new Carrier((int)$id_carrier);

		// If there is no id_carrier or if the carrier does not laod, create new ones
		if (!$id_carrier || !isset($carrier) || !Validate::isLoadedObject($carrier))
		{
			###HelperP::log("\nCalling installExternalCarrier from getCarrierFromQuote");
			$id_carrier = $this->installExternalCarrier($quote);
			Db::getInstance()->Execute('INSERT INTO `'._DB_PREFIX_.'sellstrom_carrier` 
					(`id_carrier`, `hash`) 
					VALUES('.(int)$id_carrier.', \''.pSQL(md5($quote->carrier.'_'.$quote->service.'_'.$quote->transit_time)).'\')');
		}
		return $id_carrier;
	}

	/**
	 * @brief Retrieve the Quotes from the cache for this given cart
	 */
	protected function getCacheQuotes()
	{
		###HelperP::log('getCacheQuotes called.');
		$hash = $this->getCartHash($this->context->cart);
		$current_time = time();
		$crep = Db::getInstance()->ExecuteS('SELECT `id_carrier`,
													`id_cart`,
													`quote_ref`,
													`quote_id`,
													`login_id`,
													`price`,
													`date_add`
											FROM `'._DB_PREFIX_.'sellstrom_quote_cache`
											WHERE `product_hash` = \''.pSQL($hash).'\'');
		if ($crep && count($crep))
		{
			foreach ($crep as $q)
			{
				$qtime = $q['date_add'];
				break;
			}
			$time_diff = $current_time - $qtime;
			###HelperP::log("Current time = $current_time .... QTime = $qtime .... Time Diff = $time_diff");
			# If the quotes are cached for more than a day then delete the cache quotes from DB.
			if ($time_diff >= (24 * 3600))
			{
				###HelperP::log('Deleting the cache quotes from DB');
				Db::getInstance()->Execute('DELETE from `'._DB_PREFIX_.'sellstrom_quote_cache` WHERE `product_hash` = \''.pSQL($hash).'\'');
				return false;
			}
			return $crep;
		}
		return false;
	}

	/**
	 * @brief Fill the cache with the given quotes for the given cart
	 */
	protected function cacheQuotes($quote_ref, $quotes, $login_id)
	{
		$hash = $this->getCartHash($this->context->cart);

		if (!count($quotes))
			return;

		// Delete the quotes if already present
		//Db::getInstance()->Execute('DELETE FROM `'._DB_PREFIX_.'sellstrom_quote_cache` WHERE `product_hash` = \'' . pSQL($hash) . '\'');

		$date_add = time();

		$query = 'INSERT INTO `'._DB_PREFIX_.'sellstrom_quote_cache` (`quote_ref`, `quote_id`, `login_id`, `id_carrier`,
					`id_address`, `id_cart`, `price`, `product_hash`, `date_add`) VALUES';
		foreach ($quotes as $q)
		{
			$query .= '(\''.pSQL($quote_ref).'\', '.(int)$q->id.', \''.pSQL($login_id).'\', '.
						(int)$this->getCarrierFromQuote($q).', '.(int)$this->context->cart->id_address_delivery.', '.
						(int)$this->context->cart->id.', \''.pSQL($q->price).'\', \''.pSQL($hash).'\', \''.pSQL($date_add).'\'),';
		}
		$query = rtrim($query, ',');
		Db::getInstance()->Execute($query);
	}

	/**
	 * Load Javascripts and CSS related to the Stripe's module
	 * Only loaded during the checkout process
	 *
	 * @return string HTML/JS Content
	 */
	public function hookHeader()
	{
		####HelperP::log('hookHeader called.');
		if (Tools::getValue('controller') == 'order-opc' ||
			(($_SERVER['PHP_SELF'] == 'order.php' || Tools::getValue('controller') == 'order') &&
				Tools::getValue('step') == 2))
		{
			####HelperP::log('hookHeader called while placing an order.');
			// Load the delivery address, if fail, return.
			$addr = new Address($this->context->cart->id_address_delivery);
			if (!Validate::isLoadedObject($addr))
				return;

			####HelperP::log('calling getCacheQuotes from hookHeader.');
			$cache_quotes = $this->getCacheQuotes();
			#$cache_quotes = false;
			if (!$cache_quotes)
			{
				####HelperP::log('Could not find cache_quotes.  Calling cacheQuotes from hookHeader.');
				$resp = $this->getQuotes($this->context->cart, $addr);
				$this->cacheQuotes($resp->quote_id, $resp->quotes, $resp->login_id);
			}

			$html = '';
			foreach ($this->new_carriers as $id_carrier)
			{
				// If the carrier fail to load, skip it
				$carrier = new Carrier((int)$id_carrier);
				if (!Validate::isLoadedObject($carrier))
					continue;

				$this->id_carrier = (int)$carrier->id;

				// item / alternate-iten
				$html .= '
<div class="delivery_option '.(!($carrier->id % 2) ? 'alternate_' : '').'item">
	<input class="delivery_option_radio" type="radio"
			name="delivery_option['.(int)$this->context->cart->id_address_delivery.']"
			onchange="updateExtraCarrier(\''.(int)$carrier->id.',\', '.(int)$this->context->cart->id_address_delivery.');"
			id="delivery_option_'.(int)$this->context->cart->id_address_delivery.'_'.(int)$carrier->id.'"
			value="'.(int)$carrier->id.'," checked="checked">

	<label for="delivery_option_'.(int)$this->context->cart->id_address_delivery.'_'.(int)$carrier->id.'">
	<table class="resume">
		 <tr>
		 <td class="delivery_option_logo"><img src="'._THEME_SHIP_DIR_.(int)$carrier->id.'.jpg" alt="'.Tools::safeOutput($carrier->name).'" /></td>
		 <td>
		 <div class="delivery_option_title">'.str_replace('\'', '\\\'', Tools::safeOutput($carrier->name)).'</div>
		 <div class="delivery_option_delay">'.
			str_replace('\'', '\\\'', Tools::safeOutput($carrier->delay[(int)$this->context->cookie->id_lang])).
		'</div>
		 </td>
		 <td><div class="delivery_option_price">'.
			Tools::safeOutput(Tools::displayPrice($this->getOrderShippingCost($this->context->cart,
										Configuration::get('PS_SHIPPING_HANDLING')))).' (tax incl.)</div></td>
		 </tr>
		 </table>

		 <input type="hidden" value="'.(int)$carrier->id.'" name="id_carrier">
		 </label>
</div>';
			}
			return '<script type="text/javascript">
$(function() {
$(\'#noCarrierWarning\').hide();

$(\'#form .delivery_options\').html($(\'#form .delivery_options\').html() + \''.str_replace(array('\'', "\n"), array('\\\'', "\\\n"), $html).'\');
});
</script>';
		}
	}

	public function validateSSShipping($params)
	{
		####HelperP::log("Called validateSSShipping ...");
		// Retrieve the id_order
		$id_order = (int)Order::getOrderByCartId((int)$params['cart']->id);

		// Check that the order has not been validated
		if (Db::getInstance()->getValue('SELECT `id_order` FROM `'._DB_PREFIX_.'sellstrom_shipment` WHERE `id_order` = '.(int)$id_order))
		{
			$this->_errors[] = $this->l('The shipment has been successfully validated.');
			return;
		}

		// Check that all cache data we need are present
		$quote_sql = 'SELECT `login_id`, `quote_id`, `id_sellstrom_quote_cache`, `quote_ref`
				FROM `'._DB_PREFIX_.'sellstrom_quote_cache`
				WHERE `product_hash` = \''.pSQL($this->getCartHash($params['cart'])).'\'
					AND `id_cart` = '.(int)$params['cart']->id.'
					AND `id_carrier` = '.(int)$params['cart']->id_carrier.'
					AND `id_address` = '.(int)$params['cart']->id_address_delivery;

		$r = Db::getInstance()->getRow($quote_sql);
		####HelperP::log('quoteSQL == ' . $quote_sql);

		if (!$r)
		{
			$this->_errors[] = $this->l('This order is corrupt (cache missing). Please contact Sellstrom to validate shipment.');
			return false;
		}
		####HelperP::log("sellstrom_quote_cache data == " . json_encode($r));
		$login_id = pSQL($r['login_id']);
		$quote_id = pSQL($r['quote_id']);
		$quote_ref_id = pSQL($r['quote_ref']);

		// Get the total shipping cost including all taxes from the orders table
		$sr = Db::getInstance()->getRow('SELECT `total_shipping`,
												`total_paid_tax_incl`,
												`total_paid`
										FROM `'._DB_PREFIX_.'orders`
										WHERE `id_order` = '.(int)$id_order);
		$total_shipping_cost = pSQL($sr['total_shipping']);
		$total_product_cost  = pSQL($sr['total_paid_tax_incl']);
		####HelperP::log('total_shipping_cost == ' . $total_shipping_cost);

		// Get the default currency of the shop - Configuration::get('PS_CURRENCY_DEFAULT')
		$default_currency = Configuration::get('PS_CURRENCY_DEFAULT');
		$curres = Db::getInstance()->getRow('SELECT `iso_code` FROM `'._DB_PREFIX_.'currency` WHERE `id_currency` = '.(int)$default_currency);
		$cur_iso_code = $curres['iso_code'];

		// Instanciate the client and set the login session
		$this->instanciateClient();
		//unset($this->static_cred->login);
		$this->static_cred->login_id = $login_id;

		####HelperP::log("Calling BookShipment ... ");
		####HelperP::log("Currency == $cur_iso_code");
		try
		{
			$ret = $this->_client->bookShipment(array(
								'credentials' => $this->static_cred,
								'quote_id' => $quote_id,
								'quote_ref_id' => $quote_ref_id,
								'total_shipping_cost' => $total_shipping_cost,
								'total_product_cost' => $total_product_cost,
								'currency' => $cur_iso_code
							));
			//unset($this->static_cred->login);
			$this->static_cred->login_id = $ret->login_id;
			$this->static_cred->session_id = $ret->session_id;
		}
		catch (Exception $e)
		{
			$this->_errors[] = Tools::safeOutput($e->getMessage());
			return false;
		}

		####HelperP::log("BookShipment data == " . json_encode($ret));

		// Make sure the result is an array
		if (!is_array($ret->tracking_numbers))
			$ret->tracking_numbers = array($ret->tracking_numbers);

		// Put the shipment in base
		Db::getInstance()->Execute('INSERT INTO `'._DB_PREFIX_.'sellstrom_shipment`
				(`id_order`, `shipment_id`)
				VALUES('.(int)$id_order.', \''.pSQL($ret->shipment_id).'\')');

		// Retrieve the first order_carrier with empty tracking_number
		$id_order_carrier = Db::getInstance()->getValue('
				SELECT `id_order_carrier`
				FROM `'._DB_PREFIX_.'order_carrier`
				WHERE `id_order` = '.(int)$id_order.'
				ORDER BY `id_order_carrier` ASC');
		if (!$id_order_carrier)
		{
			$this->_errors[] = $this->l('Shipping data missing.');
			return false;
		}

		// Update the order carrier tracking number with the first element
		$oc = new OrderCarrier((int)$id_order_carrier);
		if (!Validate::isLoadedObject($oc))
		{
			$this->_errors[] = $this->l('Impossible to load shipping data');
			return false;
		}
		$oc->tracking_number = $ret->tracking_numbers[0]->tracking_number;
		$oc->update();

		// For all other elements, create new order carrier and insert the details to the database
		// For each element, generate the label
		$i = 0;
		foreach ($ret->tracking_numbers as $t)
		{
			if ($i++ > 0)
			{
				$oc->tracking_number = pSQL($t->tracking_number);
				$oc->add();
			}
			Db::getInstance()->Execute('INSERT INTO `'._DB_PREFIX_.'sellstrom_tracking` (`id_order`, `tracking_id`, `product_id`, `unit`, `tracking_number`)
				VALUES('.(int)$id_order.', '.(int)$t->id.', '.(int)$t->product_id.', '.(int)$t->unit.', \''.pSQL($t->tracking_number).'\')');
			$id_sellstrom_tracking = Db::getInstance()->Insert_ID();
			####HelperP::log("Calling GetLabel:: tracking_number == " . $t->tracking_number);
			try
			{
				$ret = $this->_client->GetLabel(array(
									'credentials' => $this->static_cred,
									'shipment_id' => $t->id,
									'product_id' => $t->product_id,
									'package_no' => $t->unit,
								));
				####HelperP::log(" .... Label Image == " . $ret->image);
				file_put_contents(_PS_MODULE_DIR_.'sellstrom/label/'.(int)$id_sellstrom_tracking.'.'.$ret->label_fmt, Tools::file_get_contents($ret->image));
				####HelperP::log(" .... Successfully created the label image.");
			}
			catch (Exception $e)
			{
				$this->_errors[] = Tools::safeOutput($e->getMessage());
				continue;
			}
		}

		// Fetch the tracking data
		$this->refreshTrackingEvent($params);

		if (!count($this->_errors))
		{
			$this->messages[] = $this->l('The shipment has been successfully validated.');
			return true;
		}
		return false;
	}

	public function voidSShipping($params)
	{
		// Check that all cache data we need are present
		$login_id = Db::getInstance()->getRow('SELECT `login_id`
				FROM `'._DB_PREFIX_.'sellstrom_quote_cache`
				WHERE `product_hash` = \''.pSQL($this->getCartHash($params['cart'])).'\'
					AND `id_cart` = '.(int)$params['cart']->id.'
					AND `id_carrier` = '.(int)$params['cart']->id_carrier.'
					AND `id_address` = '.(int)$params['cart']->id_address_delivery);
		if (!$login_id)
		{
			$this->_errors[] = $this->l('This order is corrupt (cache missing). Please contact Sellstrom to validate shipment.');
			return false;
		}

		// Retrieve the id_order
		$id_order = (int)Order::getOrderByCartId((int)$params['cart']->id);

		// Retrive the shipment_id
		$tracking_number = Db::getInstance()->getValue('SELECT `tracking_number`
							FROM `'._DB_PREFIX_.'sellstrom_tracking` WHERE `id_order` = '.(int)$id_order);
		if ($tracking_number === false)
		{
			$this->_errors[] = $this->l('No shipping for this order has been found.');
			return false;
		}

		// Instanciate the client and set the login session
		$this->instanciateClient();

		try
		{
			$ret = $this->_client->Void(array(
						'credentials' => $this->static_cred,
						'tracking_number' => $tracking_number,
					));

			$this->static_cred->login_id = $ret->login_id;
			$this->static_cred->session_id = $ret->session_id;
		}
		catch (Exception $e)
		{
			//$this->_errors[] = Tools::safeOutput($e->getMessage());
			$this->_errors[] = Tools::safeOutput('No shipment found within the allowed void period');
			return false;
		}
		Db::getInstance()->Execute('UPDATE `'._DB_PREFIX_.'sellstrom_shipment` SET `void` = 1 WHERE `id_order` = '.(int)$id_order);

		if (!count($this->_errors))
		{
			$this->messages[] = $this->l('The shipment has been voided.');
			return true;
		}
		return false;
	}

	public function processForm($params)
	{
		####HelperP::log("Called processForm... validateSSShipping = " . Tools::isSubmit('validateSSShipping'));
		####HelperP::log("Called processForm... voidSSShipping = " . Tools::isSubmit('voidSSShipping'));
		####HelperP::log("Called processForm... refreshTrackingEvent = " . Tools::isSubmit('refreshTrackingEvent'));
		####HelperP::log("Params ===> " . json_encode($params));

		if (Tools::isSubmit('validateSSShipping'))
			$this->validateSSShipping($params);
		if (Tools::isSubmit('voidSSShipping'))
			$this->voidSShipping($params);
		if (Tools::isSubmit('refreshTrackingEvent'))
			$this->refreshTrackingEvent($params);
	}

	protected function getSSBalance()
	{
		####HelperP::log("Called getSSBalance ..");
		$this->instanciateClient();

		#HelperP::log('PS_LANG_DEFAULT === ' . Configuration::get('PS_LANG_DEFAULT'));
		####HelperP::log('Current Default === ' . Configuration::get('PS_CURRENCY_DEFAULT'));
		####HelperP::log('getSSBalance :: credentials == ' . json_encode($this->static_cred));
		try
		{
			$ret = $this->_client->GetAccountBalance(array(
						'credentials' => $this->static_cred,
						'account_no' => Configuration::get('SELLSTROM_LOGIN'),
					));
			$this->static_cred->login_id = $ret->login_id;
			$this->static_cred->session_id = $ret->session_id;

			####HelperP::log('Account balance = ' . $ret->balance);
		}
		catch (Exception $e)
		{
			####HelperP::log('Issue sellstrom balance: '.Tools::safeOutput($e->getMessage()));
			Logger::addLog('Issue sellstrom balance: '.Tools::safeOutput($e->getMessage()));
			return 0;
		}
		return $ret->balance;
	}

	protected function refreshTrackingEvent($params)
	{
		// Retrieve the id_order
		$id_order = (int)Order::getOrderByCartId((int)$params['cart']->id);

		$this->instanciateClient();

		$rep = Db::getInstance()->ExecuteS('SELECT `unit`, 
													`product_id`, 
													`tracking_id`, 
													`tracking_number` 
											FROM `'._DB_PREFIX_.'sellstrom_tracking`
											WHERE `id_order` = '.(int)$id_order);
		foreach ($rep as $line)
		{
			try
			{
				$res = $this->_client->TrackPackage(array(
							'credentials' => $this->static_cred,
							'shipment_id' => $line['tracking_id'],
							'product_id' => $line['product_id'],
							'package_no' => $line['unit'],
						));
				if (isset($this->static_cred->login))
				{
					//unset($this->static_cred->login);
					$this->static_cred->login_id = $res->login_id;
					$this->static_cred->session_id = $res->session_id;
				}

				// Get the track events
				$track_events = $res->track_events;
				$is_indexed = array_values($track_events) === $track_events;
				if (!$is_indexed)
					$track_events = array($track_events);

				####HelperP::log("isIndexed == $is_indexed ... trackevents = " . json_encode($track_events));
				foreach ($track_events as $ret)
				{
					$id_tracking_event = Db::getInstance()->getValue('SELECT `id_sellstrom_tracking_event` 
											FROM `'._DB_PREFIX_.'sellstrom_tracking_event` 
											WHERE `id_order` = '.(int)$id_order.' 
											AND `event` = \''.pSQL($ret->event).'\' 
											AND `location` = \''.pSQL($ret->location).'\' 
											AND `tracking_number` = \''.pSQL($line['tracking_number']).'\'');
					if (!$id_tracking_event)
					{
						Db::getInstance()->Execute('INSERT INTO `'._DB_PREFIX_.'sellstrom_tracking_event` 
							(`id_order`, `event`, `location`, `tracking_number`, `date`) 
							VALUES('.(int)$id_order.', \''.pSQL($ret->event).'\', \''.pSQL($ret->location).
									'\', \''.pSQL($line['tracking_number']).'\', \''.pSQL($ret->timestamp).'\')');
					}
					else
					{
						Db::getInstance()->Execute('UPDATE `'._DB_PREFIX_.'sellstrom_tracking_event` 
													SET `date` = \''.pSQL($ret->timestamp).'\' 
													WHERE `id_sellstrom_tracking_event` = '.(int)$id_tracking_event);
					}
				}
			}
			catch (Exception $e)
			{
				$this->_errors[] = Tools::safeOutput($e->getMessage());
				continue;
			}
		}
		if (!count($this->_errors))
		{
			$this->messages[] = $this->l('The tracking events have been updated successfully.');
			return true;
		}
		return false;
	}

	public function hookBackofficeHeader($params)
	{
		####HelperP::log("Called hookBackofficeHeader ... params = " . json_encode($params['cart']));
		if (Tools::strtolower(Tools::getValue('controller')) != 'adminorders' || !Tools::getValue('id_order') || !Tools::isSubmit('vieworder'))
			return;

		$this->processForm($params);
		####HelperP::log("After processForm.... errors = " . json_encode($this->_errors));

		$html = '';

		$balance_amount = (float)$this->getSSBalance();

		if (count($this->_errors))
			$html .= '<br /><div class="error">'.implode("\n", $this->_errors).'</div>';

		if (count($this->messages))
			$html .= '<br /><div class="conf">'.implode("\n", $this->messages).'</div>';

		$html .= '<br /><form action="" method="POST"><fieldset>
				<legend><img src="../img/admin/delivery.gif" alt="">'.$this->l('Sellstrom').'</legend>
				<label for="SSBalance">'.$this->l('Your Sellstrom balance: ').'</label>
				<input type="text" readonly=readonly id="SSBalance" value="'.$balance_amount.'" />
				<a href="###" onclick="javascript:enableAddFundsForm();">
					<img src="'.__PS_BASE_URI__.'modules/sellstrom/img/add-credit.gif">'.$this->l('Add more credit').'
				</a>
				<br/>
				<br/>
		';

		$user_id  = $this->static_cred->id;
		$login	= $this->static_cred->login->username;
		$password = $this->static_cred->login->password;
		$module_dir = __PS_BASE_URI__.'modules/sellstrom';

		$add_funds_html = '
		<p>
		<div id="addFundsMainDiv" style="display:none">
		<form action="http://54.235.249.8/console/index.php" method="post" name="addFundsForm" id="addFundsForm">
			<label for="addAmount" id="addFundsLabel">'.$this->l('Add funds ($)').'</label>
			<div class="margin-form" id="addFundsFormDiv">
				<input id="addAmount" name="addAmount" type="text" onBlur="javascript:populateFinal();" value="" />
				<input id="formAction" type="hidden" name="action" value="addFunds" />
				<input id="apiKey" type="hidden" name="apiKey" value="'.$user_id.'" />
				<input id="username" type="hidden" name="username" value="'.$login.'" />
				<input id="userpass" type="hidden" name="password" value="'.$password.'" />
				<input id="currentPageUrl" type="hidden" name="finalRedirectUrl" />
				<input id="finalSubmitValue" type="hidden" name="amount" value="" />
			</div>
			<label for="addAmount" id="addFundsFinalLabel">'.$this->l('Final amount to be paid (including 2% PayPal processing fee)').'</label>
			<div id="addFundsFinalDiv">
				<input id="finalAmount" type="text" disabled value="" />
			</div>
			<br/>
			<div id="addFundsButtonsDiv">
				<a href="##" onClick="javascript:submitForm()"><img src="'.$module_dir.'/img/paypal_paynow.gif"></a>
				<a href="##" class="sellstrom-link-ext" onClick="javascript:disableAddFundsForm();resetFields();">'.$this->l('Cancel').'</a>
			</div>
		</form>
		</div>

		<br/>
		<br/>
		';

		$html .= $add_funds_html;

		// Make sure we have the right id_carrier
		$this->id_carrier = $params['cart']->id_carrier;
		// Get the shipping cost
		$ss_cost = (float)$this->getOrderShippingCost($params['cart'], 0);

		####HelperP::log("ss_cost == $ss_cost");

		// Check if the order has been voided
		$r = Db::getInstance()->getRow('SELECT `id_order`, 
												`void` 
										FROM `'._DB_PREFIX_.'sellstrom_shipment` 
										WHERE `id_order` = '.(int)Order::getOrderByCartId((int)$params['cart']->id));
		if ($r && $r['void'])
			$html .= $this->l('This shipment has been voided.');
		else
		{
			if (!$r)
			{
				if ($ss_cost <= $balance_amount)
				{
					$html .= '<label for="validateSSShipping">'.$this->l('Click here to create a label for shipment: ').'</label>
<input id="validateSSShipping" type="submit" class="button" name="validateSSShipping" value="'.$this->l('Create Label').'" />';
				}
				else
					$html .= $this->l('You do not have enough money in your account to create a label for shipment.');
			}
			else
			{
				$html .= '<label for="voidSSShipping">'.$this->l('Click here to void shipping').'</label>&nbsp;&nbsp;
			<input id="voidSSShipping" type="submit" 
			class="button" 
			onClick="return confirm(\''.str_replace('\'', '\\\'', $this->l('Are you sure you want to cancel shipping for this order?')).'\');" 
			name="voidSSShipping" value="'.$this->l('Void').'" />';
			}
		}
		$html .= '</fieldset></form>';

		// If the shipment has been validated, display the labels
		if ($r)
		{
			$rep = Db::getInstance()->ExecuteS('SELECT st.`id_order`, 
						st.`id_sellstrom_tracking`, 
						st.`tracking_number`, 
						st.`unit`, 
						st.`product_id`, 
						st.`tracking_id`, 
						o.`secure_key`
				FROM `'._DB_PREFIX_.'sellstrom_tracking` st
				LEFT JOIN `'._DB_PREFIX_.'orders` o ON (st.`id_order` = o.`id_order`)
				WHERE st.`id_order` = '.(int)Order::getOrderByCartId((int)$params['cart']->id));
			if ($rep)
			{
				$html .= '<br /><fieldset><legend><img src="../img/admin/delivery.gif" alt="">'.$this->l('Sellstrom - Labels').'</legend>
<table class="table" style="width: 100%;"><tr><th>'.$this->l('Tracking number').'</th><th>'.$this->l('Unit').'</th><th>'.
$this->l('Label').'</th></tr>';
				foreach ($rep as $line)
				{
					$html .= '<tr><td>'.Tools::safeOutput($line['tracking_number']).'</td><td>'.(int)$line['unit'].'</td>
								<td>
<a target="_blank" 
	href="'.__PS_BASE_URI__.'modules/sellstrom/label.php?id_tracking='.(int)$line['id_sellstrom_tracking'].
	'&id_order='.(int)$line['id_order'].'&secure_key='.Tools::safeOutput($line['secure_key']).'" 
	class="button">'.$this->l('Print').'</a></td></tr>';
				}
				$html .= '</table></fieldset>';
			}

			$html .= '<br /><fieldset><legend><img src="../img/admin/delivery.gif" alt="">'.$this->l('Sellstrom - Tracking').'</legend>';
			$r = Db::getInstance()->ExecuteS('SELECT `date`, 
									`tracking_number`, 
									`event`, 
									`location` 
								FROM `'._DB_PREFIX_.'sellstrom_tracking_event` 
								WHERE `id_order` = '.(int)Order::getOrderByCartId((int)$params['cart']->id));
			if ($r && count($r))
			{
				$html .= '<table class="table" style="width: 100%;"><tr><th>'.$this->l('Date').'</th><th>'.
$this->l('Tracking number').'</th><th>'.$this->l('Event').'</th><th>'.$this->l('Location').'</th></tr>';
				foreach ($r as $line)
				{
					$html .= '<tr><td>'.Tools::safeOutput(Tools::displayDate($line['date'], null, true)).'</td>
								<td>'.Tools::safeOutput($line['tracking_number']).'</td>
								<td>'.Tools::safeOutput($line['event']).'</td>
								<td>'.Tools::safeOutput($line['location']).'</td></tr>';
				}
				$html .= '</table>';
			}
			$html .= '<br /><form action="" method="POST">
<input type="submit" class="button" name="refreshTrackingEvent" value="'.$this->l('Refresh tracking').'" /></form>';
			$html .= '</fieldset>';
		}

		$add_credit_js = "
<script type='text/javascript'>
	function resetFields() {
		document.getElementById('addFundsForm').reset();
	}
	function enableAddFundsForm() {
		document.getElementById('addFundsMainDiv').style.display = 'block';
	}
	function disableAddFundsForm() {
		document.getElementById('addFundsMainDiv').style.display = 'none';
	}
	function populateFinal() {
		var addAmount = document.getElementById('addAmount');
		var finalAmount = document.getElementById('finalAmount');
		var finalSubmit = document.getElementById('finalSubmitValue');
		var finalValue = Number(addAmount.value) + Number(0.02 * addAmount.value);
		finalAmount.value = '$' + finalValue;
		finalSubmit.value = finalValue;
	}
	function getCurrentPageURL() {
		var currentUrl = window.location.href;
		return currentUrl;
	}
	function submitForm() {
		var amount = document.getElementById('addAmount').value;
		if (!amount) {
			alert('Add funds amount cannot be empty. Please enter the amount and click on Pay Now.');
			return false;
		} else if (amount < 1) {
			alert('Add funds amount should be more than or equal to $1.');
			return false;
		}

		var finalAmountValue = document.getElementById('finalAmount').value;
		var c = confirm('You will be now redirected to the PayPal secured payment gateway for the payment of amount (' + 
						finalAmountValue + 
						'). Are you sure you want to proceed with the payment?');
		if (c == true) {
			document.getElementById('currentPageUrl').value = getCurrentPageURL();

			// Create a dynamic form
			var f = document.createElement('form');
			f.setAttribute('method','post');
			f.setAttribute('action','http://54.235.249.8/console/index.php');

			var amt = document.createElement('INPUT');
			amt.type = 'hidden';
			amt.name = 'amount';
			amt.value = document.getElementById('finalAmount').value;
			f.appendChild(amt);

			var addamt = document.createElement('INPUT');
			addamt.type = 'hidden';
			addamt.name = 'addAmount';
			addamt.value = document.getElementById('addAmount').value;
			f.appendChild(addamt);

			var akey = document.createElement('INPUT');
			akey.type = 'hidden';
			akey.name = 'apiKey';
			akey.value = document.getElementById('apiKey').value;
			f.appendChild(akey);

			var uname = document.createElement('INPUT');
			uname.type = 'hidden';
			uname.name = 'username';
			uname.value = document.getElementById('username').value;
			f.appendChild(uname);

			var upass = document.createElement('INPUT');
			upass.type = 'hidden';
			upass.name = 'password';
			upass.value = document.getElementById('userpass').value;
			f.appendChild(upass);

			var purl = document.createElement('INPUT');
			purl.type = 'hidden';
			purl.name = 'finalRedirectUrl';
			purl.value = document.getElementById('currentPageUrl').value;
			f.appendChild(purl);

			var fact = document.createElement('INPUT');
			fact.type = 'hidden';
			fact.name = 'action';
			fact.value = document.getElementById('formAction').value;
			f.appendChild(fact);

			document.body.appendChild(f);
			f.submit();
		}
	}

</script>

		";

		$all_contents = $add_credit_js.'
<script type="text/javascript">
$(function() {
$(\'#formAddPayment\').parent().after(\''.str_replace(array('\'', "\n"), array('\\\'', "\\\n"), $html).'\');
});
</script>';

		return $all_contents;
	}

	public function getOrderShippingCost($cart, $shipping_cost)
	{
		##HelperP::log('Called getOrderShippingCost...' . $shipping_cost);
		####HelperP::log('id address delivery == ' . $this->context->cart->id_address_delivery);
		// Make sure the cache is up to date
		if (!$this->getCacheQuotes())
		{
			// Load the delivery address, if fail, return.
			$addr = new Address($this->context->cart->id_address_delivery);
			####HelperP::log('Address === ' . json_encode($addr));

			if (!Validate::isLoadedObject($addr))
				false;
			$resp = $this->getQuotes($this->context->cart, $addr);
			$this->cacheQuotes($resp->quote_id, $resp->quotes, $resp->login_id);
		}

		$price = Db::getInstance()->getValue('SELECT `price`
				FROM `'._DB_PREFIX_.'sellstrom_quote_cache`
				WHERE `product_hash` = \''.$this->getCartHash($cart).'\'
					AND `id_address` = '.(int)$cart->id_address_delivery.'
					AND `id_carrier` = '.(int)$this->id_carrier.'
					AND `id_cart` = '.(int)$cart->id);
		if ($price === false)
			return false;

		return $price + $shipping_cost;
	}

	public function getOrderShippingCostExternal($params)
	{
		####HelperP::log('Called getOrderShippingCostExternal ...');
		return $this->getOrderShippingCost($params, null);
	}

	public function installExternalCarrier(SSQuote $quote)
	{
		##HelperP::log("\nCalled installExternalCarrier ... Quote ===> " . gettype($quote) . " ... " . json_encode($quote));
		$carrier = new Carrier();
		$carrier->name = 'Sellstrom - '.$quote->carrier.' '.$quote->service;
//		$carrier->delay = $quote->transit_time;

		$carrier->delay = array(
			'en' => $quote->transit_time,
			Language::getIsoById(Configuration::get('PS_LANG_DEFAULT')) => $quote->transit_time,
			Configuration::get('PS_LANG_DEFAULT') => $quote->transit_time
		);

		$carrier->active = true;
		$carrier->is_module = true;
		$carrier->shipping_external = true;
		$carrier->external_module_name = 'sellstrom';
		$carrier->need_range = true;

		# Check whether the carrier already exists. If so, just return the carrier id.
		$carrier_sql = 'SELECT `id_carrier` FROM `'._DB_PREFIX_.'carrier` 
						WHERE `active` = 1 AND `deleted` = 0 AND `name` = \''.$carrier->name.'\'';
		$existing_carrier_id = Db::getInstance()->getValue($carrier_sql);
		##HelperP::log("installExternalCarrier == $carrier_sql");
		##HelperP::log("installExternalCarrier == carrier id = $existing_carrier_id");
		if ($existing_carrier_id)
			return $existing_carrier_id;

		##HelperP::log("Carrier details ==> " . json_encode($carrier));

		if ($carrier->add())
		{
			##HelperP::log("Going to insert carrier === " . $carrier->name);
			$this->new_carriers[] = (int)$carrier->id;

			$groups = Group::getGroups(true);
			foreach ($groups as $group)
				Db::getInstance()->autoExecute(_DB_PREFIX_.'carrier_group',
					array('id_carrier' => (int)$carrier->id, 'id_group' => (int)$group['id_group']), 'INSERT');

			$range_price = new RangePrice();
			$range_price->id_carrier = $carrier->id;
			$range_price->delimiter1 = '0';
			$range_price->delimiter2 = '100000';
			$range_price->add();

			$range_weight = new RangeWeight();
			$range_weight->id_carrier = $carrier->id;
			$range_weight->delimiter1 = '0';
			$range_weight->delimiter2 = '100000';
			$range_weight->add();

			$zones = Zone::getZones(true);
			foreach ($zones as $zone)
			{
				Db::getInstance()->autoExecute(_DB_PREFIX_.'carrier_zone',
					array('id_carrier' => (int)$carrier->id, 'id_zone' => (int)$zone['id_zone']), 'INSERT');
				Db::getInstance()->autoExecuteWithNullValues(_DB_PREFIX_.'delivery',
					array('id_carrier' => (int)$carrier->id,
							'id_range_price' => (int)$range_price->id,
							'id_range_weight' => null,
							'id_zone' => (int)$zone['id_zone'],
							'price' => '0'), 'INSERT');
				Db::getInstance()->autoExecuteWithNullValues(_DB_PREFIX_.'delivery',
					array('id_carrier' => (int)$carrier->id,
							'id_range_price' => null,
							'id_range_weight' => (int)$range_weight->id,
							'id_zone' => (int)$zone['id_zone'],
							'price' => '0'), 'INSERT');
			}

			switch (Tools::strtoupper($quote->carrier))
			{
				case 'USPS':
					$logo = 'usps.jpg';
					break;
				case 'UPS':
					$logo = 'ups.jpg';
					break;
				case 'FEDEX':
					$logo = 'fedex.jpg';
					break;
				case 'DHL':
					$logo = 'dhl.png';
					break;
				case 'STAMPS':
					$logo = 'stamps.png';
					break;
				default:
					$logo = 'sellstrom.png';
					break;
			}

			// Copy Logo
			if (!copy(dirname(__FILE__).'/img/'.$logo, _PS_SHIP_IMG_DIR_.'/'.(int)$carrier->id.'.jpg'))
				return false;

			##HelperP::log('carrier id ===> ' . $carrier->id);

			// Return ID Carrier
			return (int)$carrier->id;
		}

		return false;
	}

}

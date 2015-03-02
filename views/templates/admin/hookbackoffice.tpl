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

{$show_panel = $content_data['show_panel']}
<div id="sellstromBackOffice" style="display:none;">
{if (!$show_panel)}
	<br/>
{/if}
{if (isset($content_data['error_message']) && $content_data['error_message'] != '')}
	<div class="isa_error" id="sellstromErrorMessage">{$content_data['error_message']|escape:'htmlall':'UTF-8'}</div>
{/if}
{if (isset($content_data['info_message']) && $content_data['info_message'] != '')}
	<div class="isa_info"  id="sellstromInfoMessage">{$content_data['info_message']|escape:'htmlall':'UTF-8'}</div>
{/if}
{if ($show_panel)}
	<div class="panel">
		<div class="panel-heading">
{else}
	<fieldset>
		<legend>
{/if}
			<img src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/img/delivery.gif" alt="">&nbsp;Sellstrom
{if ($show_panel)}
		</div>
{else}
		</legend>
{/if}
		<form action="" method="POST">
			<fieldset>
				<div class="panel">
					<label for="SSBalance">Your Sellstrom balance:</label>
					<input type="text" readonly=readonly id="SSBalance" value="{$content_data['balance_amount']|escape:'htmlall':'UTF-8'}"/>
{if (!$show_panel)}
	<br/>
{/if}
					<a href="###" onclick="javascript:enableAddFundsForm();" style="color:#00aff0;text-decoration:none;font-size:12px;">
						<img src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/img/add-credit.gif">Add more credit
					</a>
					<br/><br/>
					<div id="addFundsMainDiv" style="display:none">
						<form action="http://54.235.249.8/console/index.php" method="post" name="addFundsForm" id="addFundsForm">
							<label for="addAmount" id="addFundsLabel">Add funds ($)</label>
							<div class="margin-form" id="addFundsFormDiv">
								<input id="addAmount" name="addAmount" type="text" onBlur="javascript:populateFinal();" value="" />
								<input id="formAction" type="hidden" name="action" value="addFunds" />
								<input id="apiKey" type="hidden" name="apiKey" value="{$content_data['user_id']|escape:'htmlall':'UTF-8'}" />
								<input id="username" type="hidden" name="username" value="{$content_data['login']|escape:'htmlall':'UTF-8'}" />
								<input id="userpass" type="hidden" name="password" value="{$content_data['password']|escape:'htmlall':'UTF-8'}" />
								<input id="currentPageUrl" type="hidden" name="finalRedirectUrl" />
								<input id="finalSubmitValue" type="hidden" name="amount" value="" />
								<input id="finalAmount" type="hidden" value="" />
							</div>
							<br/>
							<div id="addFundsButtonsDiv">
								<a href="##" onClick="javascript:submitForm()">
									<img src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/img/paypal_paynow.gif">
								</a>
								<a href="##" class="sellstrom-link-ext" onClick="javascript:disableAddFundsForm();resetFields();"
									style="color:#00aff0;text-decoration:none;font-size:12px;">Cancel
								</a>
							</div>
{if (!$show_panel)}
	<br/>
{/if}
						</form>
					</div>
				</div>
{if (isset($content_data['shipment_voided']) && $content_data['shipment_voided'])}
				<div class="panel">
					<label for="voidSSShipping">This shipment has been voided.</label>
				</div>
{else}
	{if (isset($content_data['allow_void_shipment']) && $content_data['allow_void_shipment'])}
				<div class="panel">
					<label for="voidSSShipping">Click here to void shipping:</label>&nbsp;&nbsp;
					<input id="voidSSShipping" type="submit" class="btn btn-primary" name="voidSSShipping" value="Void"
						onClick="return confirm('Are you sure you want to cancel shipping for this order?');" />&nbsp;&nbsp;
					<a href="###" onclick="javascript:createInvoice();">Create Invoice</a>
				</div>

				<!-- Create Invoice -->
				<div id="create_Invoice" class="panel" style="display:none;">
					<fieldset>
						<div class="panel-heading">
							<img src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/img/delivery.gif" alt="">&nbsp;Sellstrom - Create Invoice
						</div>
						<table id="create_Invoice_rblPackageContents" border="0">
							<tr>
								<td colspan="3">
									<div id="errorPD" style="color: Red; display: inline;">* Product description is required</div>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<div id="errorPV" style="color: Red; display: inline;">* Product/Document value is required</div>
								</td>
							</tr>
							<tr>
								<td style="font-weight:bold;width:175px">
									<span id="create_Invoice_PackageContents">Package Contents</span>
								</td>
								<td style="width:95px;">
									<input id="create_Invoice_rblPackageContents_0" name="createInvoicerblPackageContents" value="doc"
										type="radio" checked onclick="javascript:displayDocumentsCustoms();">
									<label for="create_Invoice_rblPackageContents_0">Documents</label>
								</td>
								<td>
									<input id="create_Invoice_rblPackageContents_1" name="createInvoicerblPackageContents" value="com"
										type="radio" onclick="javascript:displayDocumentsCustoms();">
									<label for="create_Invoice_rblPackageContents_1">Products</label>
								</td>
							</tr>
						</table>
					</fieldset>
					<div id="create_Invoice_DocumentDescription">
						<table>
							<tr>
								<td style="font-weight: bold;width:175px"><span id="create_Invoice_lblDocumentDescription">Document Description</span></td>
								<td>
									<select name="createInvoicedrpDocumentDescription" id="create_Invoice_drpDocumentDescription">
										<option selected="selected" value="No Customs Value">No Customs Value</option>
										<option value="Accounting Documents">Accounting Documents</option>
										<option value="Analysis Reports">Analysis Reports</option>
										<option value="Applications (Completed)">Applications (Completed)</option>
										<option value="Bank Statements">Bank Statements</option>
										<option value="Bid Quotations">Bid Quotations</option>
										<option value="Bills of Sale">Bills of Sale</option>
										<option value="Birth Certificates">Birth Certificates</option>
										<option value="Bonds">Bonds</option>
										<option value="Business Correspondence">Business Correspondence</option>
										<option value="Checks (Completed)">Checks (Completed)</option>
										<option value="Claim Files">Claim Files</option>
										<option value="Closing Statements">Closing Statements</option>
										<option value="Conference Reports">Conference Reports</option>
										<option value="Contracts">Contracts</option>
										<option value="Cost Estimates">Cost Estimates</option>
										<option value="Court Transcripts">Court Transcripts</option>
										<option value="Credit Applications">Credit Applications</option>
										<option value="Data Sheets">Data Sheets</option>
										<option value="Deeds">Deeds</option>
										<option value="Employment Papers">Employment Papers</option>
										<option value="Escrow Instructions">Escrow Instructions</option>
										<option value="Export Papers">Export Papers</option>
										<option value="Financial Statements">Financial Statements</option>
										<option value="Immigration Papers">Immigration Papers</option>
										<option value="Income Statements">Income Statements</option>
										<option value="Insurance Documents">Insurance Documents</option>
										<option value="Interoffice Memos">Interoffice Memos</option>
										<option value="Inventory Reports">Inventory Reports</option>
										<option value="Invoices (Completed)">Invoices (Completed)</option>
										<option value="Leases">Leases</option>
										<option value="Legal Documents">Legal Documents</option>
										<option value="Letter of Credit Packets">Letter of Credit Packets</option>
										<option value="Letters and Cards">Letters and Cards</option>
										<option value="Loan Documents">Loan Documents</option>
										<option value="Marriage Certificates">Marriage Certificates</option>
										<option value="Medical Records">Medical Records</option>
										<option value="Office Records">Office Records</option>
										<option value="Operating Agreements">Operating Agreements</option>
										<option value="Patent Applications">Patent Applications</option>
										<option value="Permits">Permits</option>
										<option value="Photocopies">Photocopies</option>
										<option value="Proposals">Proposals</option>
										<option value="Prospectuses">Prospectuses</option>
										<option value="Purchase Orders">Purchase Orders</option>
										<option value="Quotations">Quotations</option>
										<option value="Reservation Confirmation">Reservation Confirmation</option>
										<option value="Resumes">Resumes</option>
										<option value="Sales Agreements">Sales Agreements</option>
										<option value="Sales Reports">Sales Reports</option>
										<option value="Shipping Documents">Shipping Documents</option>
										<option value="Statements/Reports">Statements/Reports</option>
										<option value="Statistical Data">Statistical Data</option>
										<option value="Stock Information">Stock Information</option>
										<option value="Tax Papers">Tax Papers</option>
										<option value="Trade Confirmation">Trade Confirmation</option>
										<option value="Transcripts">Transcripts</option>
										<option value="Warranty Deeds">Warranty Deeds</option>
									</select>
								</td>
							</tr>
						</table>
					</div>
					<div id="create_Invoice_ShipmentPurpose">
						<table>
							<tr>
								<td style="font-weight: bold;width:175px"><span id="create_Invoice_lblShipmentPurpose">Shipment Purpose</span></td>
								<td>
									<select name="createInvoicedrpShipmentPurpose" id="create_Invoice_drpShipmentPurpose">
										<option selected="selected" value="Commercial">Commercial</option>
										<option value="Gift">Gift</option>
										<option value="Sample">Sample</option>
										<option value="Return and Repair">Return and Repair</option>
										<option value="Personal Effects">Personal Effects</option>
										<option value="Personal Use">Personal Use</option>
									</select>
								</td>
							</tr>
						</table>
					</div>
					<div id="create_Invoice_TolValCustoms">
						<table>
							<tr>
								<td style="font-weight: bold;width:175px">Total Value for Customs (USD)</td>
								<td>
									<input name="createInvoicetxtDeclaredValue" value="" maxlength="10" id="create_Invoice_txtDeclaredValue"
										style="width:80px;" type="text">
								</td>
							</tr>
						</table>
					</div>
					<div id="create_Invoice_CustomCodeTable" style="margin-top:10px;">
						<table id="ciCustomCodeTable" class="table">
							<thead>
							<tr>
								<th>Description Of Content</th>
								<th>Code</th>
								<th>Value (USD)</th>
							</tr>
							</thead>
							<tr id="pnlProduct1">
								<td>
									<input id="txtProductDescription1" type="text" style="background-color:white;" name="txtProductDescription1">
								</td>
								<td>
									<input id="txtProductCode1" type="text" class="watermarked" style="background-color:white;" name="txtProductCode1">
								</td>
								<td>
									<input id="txtProductValue1" type="text" style="background-color:white;width:75px;" name="txtProductValue1">
								</td>
							</tr>
							<tr>
								<td colspan="3" style="text-align:left;">
									<input id="btnProductAdd1" type="button" class="btn btn-default" style="width:100px;" value="Add Row"
										name="btnProductAdd1" onclick="addNewProductLine()">
									<input id="btnProductLookup1" type="button" class="btn btn-default"  style="width:200px;" value="Find Customs Comm. Code"
										name="btnProductLookup1" onclick="openCustomCodeURL()">
									<input id="txtProductLineValue" value="1" type="hidden" name="txtProductLineValue">
									<input id="btnProductAdd1" type="button" class="btn btn-default" style="width:100px;" value="Reset"
										name="btnProductAdd1" onclick="restCustomCodeTableRows()">
								</td>
							</tr>
						</table>
					</div>
					<div style="margin-top:20px;">
						<button type="button" onClick="javascript:submitCreateInvoice();" class="btn btn-primary">Create Invoice</button>
						&nbsp;&nbsp;
						<button type="button" onClick="javascript:cancelCreateInvoice();" class="btn btn-primary">Cancel</button>
						&nbsp;&nbsp;
						<img src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/img/ajax-loader.gif" style="height:20px;" id="ajaxLoaderImg">
					</div>
				</div>
	{else}
				<div class="panel">
		{if (isset($content_data['allow_create_label']) && $content_data['allow_create_label'])}
					<label for="validateSSShipping">Click here to create a label for shipment:</label>&nbsp;&nbsp;
					<input id="validateSSShipping" type="submit" class="btn btn-primary" name="validateSSShipping" value="Create Label" />
		{else}
					<label for="validateSSShipping">You do not have enough money in your account to create a label for shipment.</label>
		{/if}
				</div>
	{/if}
{/if}
			</fieldset>
		</form>
{if (isset($content_data['shipment_validated']) && $content_data['shipment_validated'])}
		<div class="panel">
			<fieldset>
				<div class="panel-heading">
					<img src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/img/delivery.gif" alt="">&nbsp;Sellstrom - Labels
				</div>
				<div class="table-responsive">
					<table class="table" style="width: 100%;" id="sellstromLabels">
						<thead><tr>
							<th>Tracking Number</th>
							<th>Unit</th>
							<th>Label</th>
						</tr></thead>
	{if (isset($content_data['shipment_labels']) && is_array($content_data['shipment_labels']))}
		{foreach $content_data['shipment_labels'] as $label_data}
						<tr>
							<td>{$label_data['tracking_number']|escape:'htmlall':'UTF-8'}</td>
							<td>{$label_data['unit']|escape:'htmlall':'UTF-8'}</td>
							<td>
								<a target="_blank" href="{$label_data['label_url']|escape:'htmlall':'UTF-8'}">Print</a>
							</td>
						</tr>
		{/foreach}
	{/if}
					</table>
				</div>
			</fieldset>
		</div>
		<div class="panel">
			<fieldset>
				<div class="panel-heading">
					<img src="{$content_data['module_dir']|escape:'htmlall':'UTF-8'}/views/img/delivery.gif" alt="">&nbsp;Sellstrom - Tracking
				</div>
				<div class="table-responsive">
					<table class="table" style="width: 100%;" id="sellstromLabels">
						<thead><tr>
							<th>Date</th>
							<th>Tracking Number</th>
							<th>Event</th>
							<th>Location</th>
						</tr></thead>
	{if (isset($content_data['tracking_data']) && is_array($content_data['tracking_data']))}
		{foreach $content_data['tracking_data'] as $track_data}
						<tr>
							<td>{$track_data['date']|escape:'htmlall':'UTF-8'}</td>
							<td>{$track_data['tracking_number']|escape:'htmlall':'UTF-8'}</td>
							<td>{$track_data['event']|escape:'htmlall':'UTF-8'}</td>
							<td>{$track_data['location']|escape:'htmlall':'UTF-8'}</td>
						</tr>
		{/foreach}
	{/if}
					</table>
				</div>
				<form action="" method="POST">
					<input type="submit" class="btn btn-primary" name="refreshTrackingEvent" value="Refresh tracking"/>
				</form>
			</fieldset>
		</div>
{/if}
{if ($show_panel)}
	</div>
{else}
	</fieldset>
{/if}
</div>
<script type='text/javascript'>
	{literal}
	$(function() {
		contentData = {/literal}{$content_data|json_encode}{literal};
		document.getElementById('sellstromBackOffice').style.display = 'block';
		var temp = $('#sellstromBackOffice').detach();
		$('#formAddPayment').parent().after( temp );
		$('#ajaxLoaderImg').hide();
	});
	{/literal}
</script>

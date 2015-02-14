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

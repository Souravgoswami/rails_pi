require("@rails/ujs").start()
require("turbolinks").start()
require("channels")

require('jquery')
require('bootstrap')

document.addEventListener('turbolinks:load', () => {
	$('[data-toggle="tooltip"]').tooltip({
		trigger: 'hover'
	}).click(function() { $(this).tooltip('hide') })

	$('[data-toggle="popover"]').popover()
})

$(() => {
	window.showNotification = function(string) {
		$('#notification').html(
			`
				<div id="notification-fade"><div class="alert alert-success fade show slow" role="alert">
					${string}

					<button type="button" class="close" data-dismiss="alert" aira-label="close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div></div>
			`
		)

		setTimeout(() => {
			$('#notification-fade').fadeOut(500)
		}, 2000)
	}

	window.wait = function() {
		$('#go').attr('data-content', 'Wait...').css('opacity', '0.5')
	}

	window.copy = function() {
		var copyText = 'copy'
		var string = $('#puts').html()

		if ( string.length < 1 || /[^\d\.]/.test(string) ) {
			showNotification('Nothing to copy!')
		}

		else {
			var copyHelper = document.createElement('input')
			copyHelper.className = 'copy-helper'
			document.body.appendChild(copyHelper)
			copyHelper.value = $('#puts').html()
			copyHelper.select()
			document.execCommand('copy')
			document.body.removeChild(copyHelper)
			$('#copy').attr('data-content', "copied")
			showNotification('Copied!')

			setTimeout(() => {
				$('#copy').attr('data-content', copyText)
			}, 2000)
		}
	}
})

window.$ = $

require("@rails/ujs").start()
require("turbolinks").start()
require("channels")

require('jquery')
require('bootstrap')

import Rails from '@rails/ujs'

var interval = null
document.addEventListener('turbolinks:load', () => {
	$('[data-toggle="tooltip"]').tooltip({
		trigger: 'hover'
	}).click(function() { $(this).tooltip('hide') })

	$('[data-toggle="popover"]').popover()

	if (document.getElementById('systemStatsPage') && !interval) {
		clearInterval(interval)
		interval = setInterval(function() {
			Rails.ajax({
				url: '/system_stats',
				type: 'get',
				dataType: 'script',
			})
		}, 500)
	}

	else if (!document.getElementById('systemStats') && interval) {
		clearInterval(interval)
		interval = null
	}
})

$(() => {
	let n = 0
	window.showNotification = function(string) {
		n += 1
		$('#notification').append(
			`
				<div class="notification-fade-${n}"><div class="alert alert-success fade show slow" role="alert">
					${string}

					<button type="button" class="close" data-dismiss="alert" aria-label="close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div></div>
			`
		)

		let notification = `.notification-fade-${n}`
		setTimeout(() => {
			$(notification).fadeOut(500)
		}, 5000)
	}

	window.wait = function() {
		$('#go').attr('data-content', 'Wait...').css('opacity', '0.5')
	}

	window.copy = function() {
		var copyText = 'copy'
		var string = $('#puts').val().toString()

		if ( string.length < 1 || /[^\d\.]/.test(string) ) {
			showNotification('Nothing to copy!')
		} else {
			var copyHelper = document.createElement('input')
			copyHelper.value = string
			document.body.appendChild(copyHelper)
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

window.JQuery = $
window.$ = $

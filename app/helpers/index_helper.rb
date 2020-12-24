module IndexHelper
	def cpu_usage
		"Total: #{sprintf "%.2f", $cpu_usage[0]} %<br>".concat(
			$cpu_usage.except(0).map { |x| "Core #{x[0]} => #{sprintf "%.2f", x[1]} %" }.join('<br>').html_safe
		).html_safe
	end

	def uptime
		u = LinuxStat::OS.uptime.values.map { |x|
			x = x.to_i
			x < 10 ? ?0.freeze + x.to_s : x.to_s
		}

		"Uptime: <strong>#{u.join(?:)}</strong>".html_safe
	end

	def memory_stat
		"#{LinuxStat::PrettifyBytes.convert_short_decimal(LinuxStat::Memory.used * 1000)}/ "\
		"#{LinuxStat::PrettifyBytes.convert_short_decimal(LinuxStat::Memory.total * 1000)} "\
		"( #{LinuxStat::Memory.percent_used}% )"
	end

	def swap_usage
		devs = LinuxStat::Swap.list.map { |x|
			"#{x[0]} => #{x[1].drop(1).tap(&:pop).reverse.map { |y|
				"#{LinuxStat::PrettifyBytes.convert_short_decimal(y * 1000)}"
			}.join(' / ')}"
		}.join('<br>')

		"#{LinuxStat::PrettifyBytes.convert_short_decimal(LinuxStat::Swap.used.*(1000))}/ "\
		"#{LinuxStat::PrettifyBytes.convert_short_decimal(LinuxStat::Swap.total.*(1000))} "\
		"( #{LinuxStat::Swap.percent_used}% )<br>#{devs}".html_safe
	end

	def net_usage
		u = LinuxStat::Net.total_bytes

		"Total Download: <strong>#{LinuxStat::PrettifyBytes.convert_short_decimal(u[:received])}</strong><br>"\
		"Total Upload: <strong>#{LinuxStat::PrettifyBytes.convert_short_decimal(u[:transmitted])}</strong><br>"\
		"Current DL: <strong>#{LinuxStat::PrettifyBytes.convert_short_decimal $current_net_usage[:received]}/s</strong><br>"\
		"Current U/L: <strong>#{LinuxStat::PrettifyBytes.convert_short_decimal $current_net_usage[:transmitted]}/s</strong>".html_safe
	end

	def process_cpu_usage
		$process_cpu_usage
	end

	def nproc
		total = LinuxStat::ProcessInfo.nproc
		online_count = LinuxStat::CPU.count_online

		"#{total} / #{online_count} (#{sprintf "%0.2f", total.*(100).fdiv(online_count)}%)"
	end

	$usb_devs = []
	$usb_devs_bef = []

	def usb_stats
		$usb_devs = LinuxStat::USB.devices_stat

		plugged = $usb_devs - $usb_devs_bef
		$usb_devs_bef = $usb_devs

		now = plugged.empty? ? nil : plugged.map { |x| x[:id] }

		$usb_devs.map.with_index { |x, i|
			new_dev = now && now.include?(x[:id])

			hwdata = x[:hwdata]
			vendor = hwdata[:vendor]
			product = hwdata[:product]
			product_name = x[:product]

			product_name_str = product_name ? "(#{product_name})" : ''

			product_str = if product_name && product && product_name != product
				"#{product_name} (#{product}) from "
			elsif product_name
				"#{product_name} from "
			elsif product
				"#{product} from "
			else
				''.freeze
			end

			out = "<strong>#{sprintf "%03d", i + 1}.</strong> #{product_str}#{vendor}"

			if new_dev
				out[0, 0] = '<span style="color: #66f">'.freeze
				out << '</span>'.freeze
			end

			out
		}.join('<br>').html_safe
	end
end

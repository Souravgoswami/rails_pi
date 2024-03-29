module IndexHelper
	def cpu_usage
		$cpu_usage
	end

	def uptime
		u = LS::OS.uptime
		h = "%02d" % u[:hour]
		m = "%02d" % u[:minute]
		s = "%02d" % u[:second]
		j = "%02d" % u[:jiffy]

		"Uptime: <strong>#{h}:#{m}:#{s}:#{j}<br></strong>"\
		"Uptime Second: <strong>#{LS::OS.uptime_f}s</strong>".html_safe
	end

	def memory_stat
		_stat = LS::Sysinfo.stat
		_stat.default = 0

		"#{pb(LS::Memory.used * 1000)}/ "\
		"#{pb(_stat[:totalram])} "\
		"( #{LS::Memory.percent_used}% )<br>"\
		"Free: <strong>#{pb(_stat[:freeram])}</strong><br>"\
		"Shared: <strong>#{pb(_stat[:sharedram])}</strong><br>"\
		"Buffer: <strong>#{pb(_stat[:bufferram])}</strong><br>"\
		"Total High: <strong>#{pb(_stat[:totalhigh])}</strong><br>"\
		"Free High: <strong>#{pb(_stat[:freehigh])}</strong>".html_safe
	end

	def swap_usage
		devs = LS::Swap.list.map { |x|
			"#{x[0]} => #{x[1].drop(1).tap(&:pop).reverse.map { |y|
				"#{pb(y * 1000)}"
			}.join(' / ')}"
		}.join('<br>')

		"#{pb(LS::Swap.used.*(1000))}/ "\
		"#{pb(LS::Swap.total.*(1000))} "\
		"( #{LS::Swap.percent_used}% )<br>#{devs}".html_safe
	end

	def net_usage
		u = LS::Net.total_bytes

		[
			pb(u[:received]),
			pb(u[:transmitted]),
			"#{pb($current_net_usage[:received])}/s",
			"#{pb($current_net_usage[:transmitted])}/s"
		]
	end

	def process_cpu_usage
		$process_cpu_usage
	end

	def nproc
		total = LS::ProcessInfo.nproc
		online_count = LS::CPU.count_online

		"#{total} / #{online_count} (#{sprintf "%0.2f", total.*(100).fdiv(online_count)}%)"
	end

	$usb_devs = []
	$usb_devs_bef = []

	def usb_stats
		$usb_devs = LS::USB.devices_stat

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
		}.join('<br>'.freeze).html_safe
	end

	def pci_stats
		LS::PCI.devices_info.map.with_index { |x, i|
			id = x[:id]
			driver = x[:kernel_driver]
			driver_str = driver ? "(driver: #{driver})" : ''.freeze

			hwdata = x[:hwdata]
			vendor = hwdata &.[](:vendor)
			product = hwdata &.[](:product)

			vendor_str = vendor ? vendor + ' '.freeze : ''.freeze
			product_str = product ? "#{product} from " : ''.freeze

			"<strong>#{sprintf "%03d", i + 1}.</strong> #{id} #{product_str}#{vendor_str}#{driver_str}"
		}.join('<br>'.freeze).html_safe
	end

	def thermal_zone
		sensors = LS::Thermal.temperatures.sort_by { |x| x[:label] || x[:name] || x[:path] }.map.with_index { |x, i|
			t = x[:temperature]
			temp_c = sprintf "%.1f", t
			temp_f = sprintf "%.1f", t.*(1.8).+(32).to_f

			label = x[:label] || x[:name] || x[:path]

			"<strong>#{sprintf '%03d', i + 1}.</strong> #{label}: #{temp_c}&#176C (#{temp_f}&#176F)"
		}.join('<br>')

		fans = LS::Thermal.fans.sort_by { |x| x[:label] || x[:name] || x[:path] }.map.with_index { |x, i|
			rpm = x[:rpm]
			label = x[:label] || x[:name] || x[:path]

			"<strong>#{sprintf '%03d', i + 1}.</strong> #{label}, RPM: #{rpm}"
		}.join('<br>')

		<<~EOF.html_safe
			<h5>Sensors (#{LS::Thermal.count_sensors})</h5>
			#{sensors}
			<h5>Fans (#{LS::Thermal.count_fans})</h5>
			#{fans}
		EOF
	end
end

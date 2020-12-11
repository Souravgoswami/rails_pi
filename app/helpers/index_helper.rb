module IndexHelper
	def processor
		if File.readable?('/proc/cpuinfo'.freeze)
			cpuinfo = IO.readlines('/proc/cpuinfo'.freeze)
			model = cpuinfo.select { |x| x[/\Amodel\sname/] }
			[model[0].split(?:)[1].strip, model.count]
		else
			[]
		end

		LinuxStat::CPU.model
	end

	def cpu_usage
		usages = LinuxStat::CPU.usages(0.03).values
		total = usages.shift
		core_usages = usages.map.with_index { |x, i|
			%Q(Core #{i} => <strong>#{x} %</strong>)
		}.join('<br>')

		"Total: <strong>#{total}%</strong>"\
		"<br>#{core_usages}".html_safe
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
		"Total Upload: <strong>#{LinuxStat::PrettifyBytes.convert_short_decimal(u[:transmitted])}</strong><br>".html_safe
	end
end

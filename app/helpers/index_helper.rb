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
		"Total: <strong>#{LinuxStat::CPU.total_usage}%</strong>"\
		"<br>Core Usage: <strong>"\
		"| #{LinuxStat::CPU.usages.values.join(' | ')} |"\
		"</strong>".html_safe
	end

	def uptime
		u = LinuxStat::OS.uptime.values.map { |x|
			x = x.to_i
			x < 10 ? ?0.freeze + x.to_s : x.to_s
		}

		"Uptime: <strong>#{u.join(?:)}</strong>".html_safe
	end

	def memory_stat
		"#{LinuxStat::Memory.used.fdiv(1048576).round(2)} GiB / "\
		"#{LinuxStat::Memory.total.fdiv(1048576).round(2)} GiB "\
		"( #{LinuxStat::Memory.percent_used}% )"
	end

	def swap_usage
		devs = LinuxStat::Swap.list.map { |x|
			"#{x[0]} => #{x[1].drop(1).tap(&:pop).reverse.map { |y|
				"#{y.fdiv(1048576).round(2)} GiB"
			}.join(' / ')}"
		}.join('<br>')

		"#{LinuxStat::Swap.used.fdiv(1048576).round(2)} GiB / "\
		"#{LinuxStat::Swap.total.fdiv(1048576).round(2)} GiB "\
		"( #{LinuxStat::Swap.percent_used}% )<br>"\
		"#{devs}".html_safe
	end
end

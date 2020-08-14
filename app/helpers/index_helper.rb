module IndexHelper
	def processor
		if File.readable?('/proc/cpuinfo'.freeze)
			cpuinfo = IO.readlines('/proc/cpuinfo'.freeze)
			model = cpuinfo.select { |x| x[/\Amodel\sname/] }
			[model[0].split(?:)[1].strip, model.count]
		else
			[]
		end
	end

	def cpu_usage
		if File.readable?('/proc/stat'.freeze)
			data = IO.readlines('/proc/stat'.freeze).select! { |x| x[/^cpu\d*/] }.map! { |x| x.split.map!(&:to_f) }
			Kernel.sleep(0.075)
			prev_data = IO.readlines('/proc/stat'.freeze).select! { |x| x[/^cpu\d*/] }.map! { |x| x.split.map!(&:to_f) }

			data.size.times.map do |x|
				%w(user nice sys idle iowait irq softirq steal).each_with_index { |el, ind| binding.eval("@#{el}, @prev_#{el} = #{data[x][ind + 1]}, #{prev_data[x][ind + 1]}".freeze) }

				previdle, idle = @prev_idle + @prev_iowait, @idle + @iowait
				totald = idle + (@user + @nice + @sys + @irq + @softirq + @steal) -
					(previdle + (@prev_user + @prev_nice + @prev_sys + @prev_irq + @prev_softirq + @prev_steal))
				"#{((totald - (idle - previdle)) / totald * 100).round( x == 0 ? 2 : 0 ).then { |y| y.to_s == 'NaN' ? 0 : y }.abs}%"
			end
		else
			''
		end
	end

	def memory
		if File.readable?('/proc/meminfo'.freeze)
			meminfo = IO.foreach('/proc/meminfo'.freeze).first(3)
			total = meminfo.find { |x| x[/^MemTotal/] }.split[1].to_f
			available = meminfo.find { |x| x[/^MemAvailable/] }.split[1].to_f
			used = (total - available) * 100 / total

			[total./(1048576).round(2), (total - available)./(1048576).round(2), used.round(2)]
		else
			[0, 0, 0]
		end
	end

	def uptime
		if File.readable?('/proc/uptime')
			uptime = IO.read('/proc/uptime').split[0].to_i
			[uptime / 3600, uptime % 3600 / 60, uptime % 60]
		else
			[]
		end
	end
end

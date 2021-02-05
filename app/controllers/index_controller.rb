class IndexController < ApplicationController
	TIMEOUT = 30
	before_action :set_digits, only: %i[calculate render_results]
	@@cpu_usage_thread = Thread.new { }
	@@net_usage_thread = Thread.new { }
	@@process_cpu_usage_thread = Thread.new { }

	def home
	end

	def calculate
		start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

		begin
			Timeout.timeout(TIMEOUT) do
				@str = find_pi(@digits)
				end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
				@time = end_time - start_time
				render :calculate
			end
		rescue Timeout::Error
			render :error_calculate
		end
	end

	def render_results
		start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

		@str = begin
			Timeout.timeout(TIMEOUT) { find_pi(@digits) }
		rescue Timeout::Error
			find_pi(5000)
		end

		end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
		@time = end_time - start_time
		msg = {digits: @str.length - 2, value: @str, time: @time}
		render :json => msg

	end

	def api_example
	end

	$cpu_usage = {}.tap { |x| x.default = 0 }
	$current_net_usage = {}.tap { |x| x.default = 0 }
	$process_cpu_usage = 0

	def system_stats
		unless @@cpu_usage_thread.alive?
			@@cpu_usage_thread = Thread.new { $cpu_usage = LS::CPU.usages(0.25) }
		end

		unless @@net_usage_thread.alive?
			@@net_usage_thread = Thread.new { $current_net_usage = LS::Net.current_usage(0.25) }
		end

		unless @@process_cpu_usage_thread.alive?
			@@process_cpu_usage_thread = Thread.new { $process_cpu_usage = LS::ProcessInfo.cpu_usage(sleep: 0.25) }
		end
	end

	private
	def set_digits
		@digits = params[:digits].to_i.then { |x| x < 1 ? 100 : x }
	end

	def find_pi(n)
		n = 100 if n > 2 ** 60
		BigPie.calculate(n + 1).join.tap { |x| x[1, 0] = ?..freeze }
	end
end

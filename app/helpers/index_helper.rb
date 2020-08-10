module IndexHelper
	def system_details
		IO.readlines('/proc/cpuinfo') rescue nil
	end
end

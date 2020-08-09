module ApplicationHelper
	def seo_tags
		<<~EOF.html_safe
			<meta charset="utf-8">
			<meta name="author" content="Sourav Goswami [souravgoswami@protonmail.com]">
			<meta name="robots" content="all">
			<meta name="description" content="Calculate Pi on the Server">
			<meta property="og:title" content="Pi Calculator">
			<meta property="og:type" content="webapp">
			<meta property="og:image" content="#{image_url('pi')}">
		EOF
	end

	def example_code(route)
		code = <<~EOF
			require 'net/https'
			require 'json'
			json_data = Net::HTTP.get(URI("#{route}"))
			JSON.parse(json_data)
		EOF

		_binding = binding
		code.each_line.map { |x| "<code>#{x}=> #{_binding.eval(x)}\n</code>" }.join.html_safe
	end
end

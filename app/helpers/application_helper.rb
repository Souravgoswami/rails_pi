module ApplicationHelper
	def seo_tags(image)
		<<~EOF.html_safe
			<meta charset="utf-8">
			<meta name="author" content="Sourav Goswami [souravgoswami@protonmail.com]">
			<meta name="robots" content="all">
			<meta name="description" content="Calculate Pi on the Server">
			<meta property="og:title" content="Pi Calculator">
			<meta property="og:type" content="webapp">
			<meta property="og:image" content="#{image}">
		EOF
	end

	def example_code(route)
		code = <<~EOF.lstrip
			require 'net/https'
			require 'json'
			json_data = Net::HTTP.get(URI("#{route}"))
			JSON.parse(json_data)
		EOF

		_binding = binding
		code.each_line.map { |x| %[\n<code class="code">#{x}<span class="return-value"> # => #{_binding.eval(x)}</span></code>] }.join.html_safe
	end

	def pb(n)
		LS::PrettifyBytes.convert_short_decimal(n)
	end
end

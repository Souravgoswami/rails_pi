class IndexController < ApplicationController
	def home
	end

	def calculate
		@digits = params[:digits].to_i.then { |x| x < 1 ? 100 : x }
		start_time = Time.now

		q = t = k = 1
		m = x = 3
		n, r = @digits + 1, 0
		@str = ''

		if (4 * q + r - t < m * t)
			@str << m.to_s
			r, m, q = 10 * (r - m * t), 10.*(3 * q + r) / t - 10 * m, q * 10
		else
			t *= x
			m, r = q.*(7 * k + 2).+(r * x) / t, x * (2 * q + r)
			q, k, x = q * k, k + 1, x + 2
		end while (@str.length < n)

		@str.insert(1, ?.)
		@time = Time.now - start_time

		render :calculate
	end
end

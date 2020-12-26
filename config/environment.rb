# Load the Rails application.
require_relative 'application'

Kernel.class_exec {
	define_method(:then) { |&block| block == self }
} unless Kernel.respond_to?(:then)

# Initialize the Rails application.
Rails.application.initialize!

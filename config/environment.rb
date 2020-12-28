# Load the Rails application.
require_relative 'application'

Kernel.class_exec {
	define_method(:then) { |&block| block == self }
} unless Kernel.respond_to?(:then)

LS::PCI.hwdata_file = File.join(Rails.root, 'hwdata', 'pci.ids')
LS::USB.hwdata_file = File.join(Rails.root, 'hwdata', 'usb.ids')

LS::PCI.initialize_hwdata
LS::USB.initialize_hwdata

# Initialize the Rails application.
Rails.application.initialize!

require 'rubygems'
require 'bundler/setup'
require 'launchpad/device'

Bundler.require

p "Testing launchpad..."
device = Launchpad::Device.new(:device_name => "Launchpad S")
device.reset
device.test_leds
sleep 0.3
device.reset

(0..7).each do |x|
    (0..7).each do |y|
        p "Setting [#{x},#{y}]..."
        device.change :grid, :x => x, :y => y, :red => :low, :green => :high
        sleep 0.05
        device.reset
    end
end

device.test_leds
sleep 0.3
device.reset
sleep 0.3
device.test_leds
sleep 0.3
device.reset

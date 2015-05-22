require 'rubygems'
require 'bundler/setup'
require 'launchpad/device'

Bundler.require

p "Testing launchpad..."
device = Launchpad::Device.new
device.test_leds
sleep 1
device.reset
sleep 1
device.change :grid, :x => 4, :y => 4, :red => :high, :green => :low

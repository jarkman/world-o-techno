# Represents a provider of GPS fixes and a dispatcher of event callbacks for applications needing 
# such fixes.
module Gps
	class Receiver
		include Fix

		def initialize(options = {})
			super
			@last_latitude = @last_longitude = 0
			@position_change_threshold = 0
			@last_speed = 0
			@last_course = 0
			@last_altitude = 0
			@last_satellites = 0
		end

		# Factory for creating a +Receiver+.
		# Accepts an implementation and a hash of options, both optional. If no 
		# implementation is provided, the first is used by default. Implementations are in 
		# the module +Gps::Receivers+.
		def self.create(arg = nil, args = {})
			implementation = arg.respond_to?(:capitalize)? Receivers.const_get(arg.capitalize): Receivers.const_get(Receivers.constants[0])
			options = arg.kind_of?(Hash)? arg: args
			implementation.new(options)
		end

		# Sets the position from an array of the form [latitude, longitude], calling the 
		# _on_position_change_ callback if necessary.
		def position=(value)
			@latitude = value[0]
			@longitude = value[1]
			call_position_change_if_necessary
		end

		# Called on position change, but only if the change is greater than +threshold+ degrees.
		# The block receives the amount of change in degrees.
		def on_position_change(threshold = 0, &block)
			@position_change_threshold = threshold
			@on_position_change = block
		end

		# Called on speed change.
		def on_speed_change(&block)
			@on_speed_change = block
		end

		# Called on course change.
		def on_course_change(&block)
			@on_course_change = block
		end

		# Called when the altitude changes.
		def on_altitude_change(&block)
			@on_altitude_change = block
		end

		# Called when the number of visible satellites changes.
		def on_satellites_change(&block)
			@on_satellites_change = block
		end

		# Override this in children. Opens the connection, device, etc.
		def start
			@thread = Thread.new do
				while true
					update
				end
			end
		end

		# Override this in children. Closes the device, connection, etc. and stops updating.
		def stop
			@thread.kill if @thread
			@thread = nil
		end

		# Returns _true_ if started, _false_ otherwise.
		def started?
			!@thread.nil? && @thread.alive?
		end

		# Override this in children, setting fix variables from the GPS receiver.
		# Here we dispatch to callbacks if necessary.
		def update
			call_position_change_if_necessary
			@on_speed_change.call if @on_speed_change and @speed != @last_speed
			@last_speed = @speed
			@on_course_change.call if @on_course_change and @course != @last_course
			@last_course = @course
			@on_altitude_change.call if @on_altitude_change and @altitude != @last_altitude
			@last_altitude = @altitude
			@on_satellites_change.call if @on_satellites_change and @satellites != @last_satellites
			@last_satellites = @satellites
		end

		private
		def call_position_change_if_necessary
			if position_change > @position_change_threshold
				@on_position_change.call(position_change) if @on_position_change
				@last_latitude = @latitude
				@last_longitude = @longitude
			end
		end

		def position_change
			(@latitude-@last_latitude).abs+(@longitude-@last_longitude).abs
		end
	end

	module Receivers
	end
end
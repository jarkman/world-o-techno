require "socket"
require 'json'

# Represents a +Receiver+ that obtains information from GPSD.
module Gps::Receivers
	class Gpsd < Gps::Receiver
		attr_reader :host, :port

		# Accepts an options +Hash+ consisting of the following:
		# * _:host_: The host to which to connect
		# * _:port_: The port to which to connect
		def initialize(options = {})
			super
			@host ||= options[:host] ||= "localhost"
			@port = options[:port] ||= 2947
		end

		def start
			@socket = TCPSocket.new(@host, @port)
			@socket.puts("?WATCH={\"enable\":true,\"json\": true}")
			super
		end

		def update
			line = @socket.gets.chomp
			return if !line
			jline = JSON.parse(line)
			#puts jline.inspect
			
			msgtype = jline['class']
			case msgtype
			when 'TPV'
				@last_tag = jline['tag']
				@timestamp = jline['time']
				@timestamp_error_estimate = jline['ept']
				@latitude = jline['lat']
				@longitude = jline['lon']
				@altitude = jline['lon']
				@horizontal_error_estimate = jline['epx']
				@vertical_error_estimate = jline['epv']
				@course = jline['track']
				@speed = jline['speed']
				@climb = jline['climb']
				@course_error_estimate = jline['epd']
				@speed_error_estimate = jline['eps']
				@climb_error_estimate = jline['epc']
			when 'SKY'
				@satellites = jline['satellites']
			end
		end
	end
end

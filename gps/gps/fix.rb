# Module representing all data in a GPS fix.
module Gps::Fix
	attr_reader :last_tag, :timestamp, :timestamp_error_estimate, :latitude, :longitude, :altitude, :horizontal_error_estimate, :vertical_error_estimate, :course, :speed, :climb, :course_error_estimate, :speed_error_estimate, :climb_error_estimate, :satellites

	def initialize(*args)
		@altitude = 0
		@latitude = 0
		@longitude = 0
		@speed = 0
		@course = 0
		@satellites = 0
	end
end
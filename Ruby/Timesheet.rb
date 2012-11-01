

require 'time'

def gross_pay (start, stop, pay)
	seconds = Time.parse(stop) - Time.parse(start)
	minutes = seconds / 60
	hours = minutes / 60
	total = hours * pay
	puts ""
	puts "=================================="
	puts "Total Gross Payment: $#{total}"
	puts "Total Hours Worked: #{hours}"
	puts "Total Minutes Worked: #{minutes}"
	puts "=================================="
end

def single_day
	puts "=================================="
	print "Enter Start Time: "
		s_time = gets.chomp

	print "Enter End Time: "
		e_time = gets.chomp

	print "Enter Hourly Rate: [Default $10] "
		rate = gets.chomp.to_i
	puts "=================================="
	if rate == 0
		rate = 10
	end
	puts gross_pay(s_time, e_time, rate)
end

def multple_day


end

single_day


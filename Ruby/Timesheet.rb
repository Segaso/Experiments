
require 'time'
require 'CSV'

def gross_pay (start, stop, pay)
	seconds = Time.parse(stop) - Time.parse(start)
	minutes = seconds / 60
	hours = minutes / 60
	total = hours * pay
	puts ""
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

def multiple_days
	m_total = 0
	puts "==================="
	print "Path to CSV: "
		m_path = gets.chomp
	print "Enter Pay Rate: "
		m_rate = gets.chomp.to_f
	puts "==================="

	CSV.foreach(m_path,  :headers           => true, 
						 :header_converters => :symbol,
						 :converters        => :numeric) do |row|
		
		m_time = (Time.parse(row[:end]) - Time.parse(row[:start])).to_f
		mh_time = m_time / 60 / 60
		m_total = m_total.to_f + mh_time.to_f
	end


		m_gross = m_total * m_rate
			puts ""
			puts "=================================="
			puts "Total Gross Payment: $#{m_total}"
			puts "Total Hours Worked: #{m_total}"
			puts "=================================="			
end


choice_end = 0

while choice_end == 0
	puts ""
	puts "====== Menu ======="
	puts "Select a Method:"
	puts "Single Day   = 1"
	puts "Multple Days = 2"
	puts "Exit         = 3"
	puts "==================="
	prompt = '>'
	print prompt
	option = gets.chomp.to_i
	if option == 1
		single_day
	end
	if option == 2
		multiple_days
	end
	if option == 3
		choice_end = 1
	end
end
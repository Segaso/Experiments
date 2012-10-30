=begin
	TO DO:
		• Add the ability to append to CSV
		• Import CSV
		• Add Tax and Net Pay

=end

require 'time'

print "Enter Start Time: "
	s_time = gets.chomp.to_s

print "Enter End Time: "
	e_time = gets.chomp.to_s

print "Enter Hourly Rate: [Default $10] "
	rate = gets.chomp.to_i

# print "Tax percent: "
	# tax = gets.chomp.to_i

if rate == 0
	rate = 10
end
puts "#{rate}"
# if tax == ""
	# tax = "1.104"
# end
	
gross =(((Time.parse(e_time) - Time.parse(s_time))/60/60)*rate).round(2).to_s
puts " "
puts "Total Gross Payment: $#{gross}"

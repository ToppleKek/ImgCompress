require 'rmagick'

data = File.open('test_results.txt', 'w') do |line| line.write("ImgCompress Test Results: (At #{Time.now})\n") end
# Creates a new test_results file if there isn't one, opens it for writing.
# Each write call overwrites whatever the file had before (w)
    
puts "ImgCompress\n"\
     "Enter name of file to test:"

image_to_comp = gets.chomp!
img = Magick::Image.read(image_to_comp).first

base_colours = `identify -format %k "#{image_to_comp}"`
data = File.open('test_results.txt', 'a') do |line| line.write("Amount of colours in test image before compression: #{base_colours}\n") end

def get_test_type
    puts "Select test type:\n"\
         "\n1. JPEG\n"\
         "2. BPG\n"\
         "3. WebP\n"\
         "4. Full Test\n"
    test_type = gets.chomp!
    return test_type
end

def get_amount_of_times(test_type)
    if test_type.to_i == 4
        return 9
    end
    puts 'How many times to compress? (1-9) '
    comp_amount = gets.chomp!
    if comp_amount.to_i > 9
        puts 'Too many times!'
        return false
    elsif comp_amount.to_i < 1
	puts 'Too little times!'
	return false
    else
	return comp_amount
    end
end

def comp_jpeg(amount_func, img_func)
    puts "Now compressing your image using JPEG"
	qual = 100 # set the quality to 100 by default
	amount_got_int = amount_func.to_i # amount_func is the number of times from a string, this converts it to an int if its a string.
	data = File.open('test_results.txt', 'a+') do |line| line.write("---JPEG RESULTS---\n") end
	amount_got_int.times do
		qual -= 10
		img_func.write("compress_JPEG#{amount_got_int}.jpeg") { self.quality = qual }
		puts "Compressed and wrote #{amount_got_int}. Writing to results file..."
		colours = `identify -format %k "compress_JPEG#{amount_got_int}.jpeg"`
		data = File.open('test_results.txt', 'a+') do |line| # opens the results file for appending data
		    line.write("#{colours} colours in JPEG image #{amount_got_int}\n") # appends the new data to the end of the file
		end
		amount_got_int -= 1
	end
	data = File.open('test_results.txt', 'a+') do |line| line.write("---END JPEG RESULTS---\n") end
end

def comp_webp(amount_func, img_func)
    puts "Now compressing your image using WEBP"
	qual = 100 # set the quality to 100 by default
	amount_got_int = amount_func.to_i # amount_func is the number of times from a string, this converts it to an int if its a string.
	data = File.open('test_results.txt', 'a+') do |line| line.write("---WEBP RESULTS---\n") end
	amount_got_int.times do
		qual -= 10
        system( "cwebp -q #{qual} #{img_func} -o compress_WEBP#{amount_got_int}.webp" )
		#img_func.write("compress_WEBP#{amount_got_int}.webp") { self.quality = qual }
        
		puts "Compressed and wrote #{amount_got_int}. Writing to results file..."
		colours = `identify -format %k "compress_WEBP#{amount_got_int}.webp"`
		data = File.open('test_results.txt', 'a+') do |line| # opens the results file for appending data
		    line.write("#{colours} colours in WEBP image #{amount_got_int}\n") # appends the new data to the end of the file
		end
		amount_got_int -= 1
	end
	data = File.open('test_results.txt', 'a+') do |line| line.write("---END WEBP RESULTS---\n") end
end

def comp_bpg(amount_func, img_func) # img_func should be the filename
    puts "Now compressing your image using BPG"
	qual = 0 # set the quality to 0 by default, maybe this is right?? I guess bpgenc goes smallest number == bigger filesize so we start at 0
	amount_got_int = amount_func.to_i # amount_func is the number of times from a string, this converts it to an int if its a string.
	data = File.open('test_results.txt', 'a+') do |line| line.write("---BPG RESULTS---\n") end
	amount_got_int.times do
	    qual += 1 # we go up because bpgenc is really backwards from everything else
        system( "bpgenc -m #{qual} #{img_func} -o compress_BPG#{amount_got_int}.bpg" )
        
		puts "Compressed and wrote #{amount_got_int}. Writing to results file..."
		colours = `identify -format %k "compress_BPG#{amount_got_int}.bpg"`
		data = File.open('test_results.txt', 'a+') do |line| # opens the results file for appending data
		    line.write("#{colours} colours in BPG image #{amount_got_int}\n") # appends the new data to the end of the file
		end
		amount_got_int -= 1
	end
	data = File.open('test_results.txt', 'a+') do |line| line.write("---END BPG RESULTS---\n") end
end

test_type_got = get_test_type # what test do they want to do?

until test_type_got.to_i < 5 do
    if test_type_got.to_i != 4 && test_type_got.to_i < 5
        puts 'debug: the type was not 4!'
        amount_got = get_amount_of_times
    elsif test_type_got.to_i > 4 # if its more than 4 so not valid
        puts 'Not a valid option.'
        test_type_got = get_test_type
    end
end

amount_got = get_amount_of_times(test_type_got) # how many times do they want to test it? we pass test_type_got so the method can return 9 if the type is 4

case test_type_got.to_i
    when 1
        comp_jpeg(amount_got, img)
        system( 'cat test_results.txt' )
        
    when 2
        comp_bpg(amount_got, image_to_comp) # we pass the method image_to_comp instead of img because we use bpgenc instead of imagemagick here
        system( 'cat test_results.txt' )
        
    when 3
        comp_webp(amount_got, image_to_comp) # same as before, we pass the method image_to_comp instead of img because we use cwebp instead of imagemagick here
        system( 'cat test_results.txt' )
        
    when 4
        comp_jpeg(9, img)
        comp_bpg(9, image_to_comp)
        comp_webp(9, image_to_comp)
        system( 'cat test_results.txt' )
        
    end

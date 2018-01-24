#!/usr/bin/ruby

###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Drew Beck"
$counter = 0

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|
			line.force_encoding 'utf-8'	# This forces every line to be interpreted as utf-8. Solution found with the help of stack overflow
																	# thread https://stackoverflow.com/questions/17022394/how-to-convert-a-string-to-utf8-in-ruby
			noisy_title = line.sub(/.*>/, "")
			punc_title = noisy_title.sub(/([\(\[\{\\\/_\-\:\"\`\+\=\*]|feat\.).*/, "")
			#puts punc_title
			#punc_title.force_encoding 'utf-8'
			title = punc_title.gsub(/[?!.;&@%#|¿¡]/, "")
			#puts foreign_title

			regex = /^[\w\s']+\n/	# Matches only full titles containing no non-english characters ignoring spaces and '

			#p title =~ regex
			if title =~ regex
				$counter += 1
				title.downcase!
				words = title.split(' ')
				index = 0
				words.each do |word|
					if $bigrams[word] == nil
						$bigrams[word] = Hash.new
						$bigrams[word][words[index+1]] = 1
					elsif $bigrams[word][words[index+1]] == nil
						$bigrams[word][words[index+1]] = 1
					else
						$bigrams[word][words[index+1]] += 1
					end # if $bigrams[word] == nil
					index += 1
					if index > words.length - 2
						break
					end # if index > words.length -2
				end # do words.each
			end # if title =~ regex
		end # do IO.foreach

		puts "Finished. Bigram model built.\n"
		puts "#{$counter} song titles found"
	rescue
		STDERR.puts "Could not open file"
		raise
		exit 4
	end # rescue
end # def

def cleanup_title line
	line.force_encoding 'utf-8'	# This forces every line to be interpreted as utf-8. Solution found with the help of stack overflow
															# thread https://stackoverflow.com/questions/17022394/how-to-convert-a-string-to-utf8-in-ruby
	noisy_title = line.sub(/.*>/, "")
	punc_title = noisy_title.sub(/([\(\[\{\\\/_\-\:\"\`\+\=\*]|feat\.).*/, "")
	#puts punc_title
	#punc_title.force_encoding 'utf-8'
	title = punc_title.gsub(/[?!.;&@%#|¿¡]/, "")
	#puts foreign_title

	regex = /^[\w\s']+\n/	# Matches only full titles containing no non-english characters ignoring spaces and '

	if title =~ regex
		title.downcase!
	else
		title = nil
	end # if title =~ regex
	return title
end # def cleanup_title str

def mcw str
	most_common_number = 0
	most_common_word = ""

	begin
		$bigrams[str].keys.each do |key|
			if $bigrams[str][key] > most_common_number
				most_common_number = $bigrams[str][key]
				most_common_word = key
			end # if
		end # do
		#puts "The most common word to follow '#{str}' is '#{most_common_word}'"
		return most_common_word
	rescue # begin
	end # begin
end # def

def create_title str
	current = str
	created_title = "#{current}"
	#print "#{current} "
	(0..19).each do
		if (mcw current) != nil
			#print "#{mcw current} "
			created_title += " #{mcw current}"
			current = (mcw current)
		end # if mcw str != nil
	end # do 0..20
	return created_title
end # create_title str

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	#puts "The most common word to follow 'happy' is '#{mcw("happy")}'"
	#puts "The most common word to follow 'sad' is '#{mcw("sad")}'"
	#puts "The most common word to follow 'love' is '#{mcw("love")}'"
	#user = gets.chomp!
	puts create_title("happy")


	# Get user input
end

main_loop()

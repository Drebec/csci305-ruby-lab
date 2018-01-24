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
$name = "Drew Beck" # Me

# Function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|
			title = cleanup_title(line)
			build_bigram(title)
		end # do IO.foreach
		puts "Finished. Bigram model built.\n"
	rescue # begin
		STDERR.puts "Could not open file"
		raise
		exit 4
	end # rescue
end # def process_file

def cleanup_title line	# This method exists only for the rspec check.
	line.force_encoding 'utf-8'
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

def build_bigram title
	if title != nil	# Check if the title containts any non-english characters
		title.downcase!	# Reduce case of title
		words = title.split(' ')	# Separate words
		index = 0	# Tracks the index of the current word. Used to ignore the last word of every song
		words.each do |word|	# For each word
			if $bigrams[word] == nil # If it doesn't already exist in the bigram, create a new entry for it and the following
															 # word and initialize the value to 1
				$bigrams[word] = Hash.new
				$bigrams[word][words[index+1]] = 1
			elsif $bigrams[word][words[index+1]] == nil	# If the current word exists but the following word does not
																									# create the entry and initialize the value to 1
				$bigrams[word][words[index+1]] = 1
			else
				$bigrams[word][words[index+1]] += 1	# If the entry already exists, increment the value
			end # if $bigrams[word] == nil
			index += 1	# Increment the word index
			if index > words.length - 2	# If the index is at the final word, stop the loop, thus ignoring the last word of each title
				break
			end # if index > words.length -2
		end # do words.each
	end # if title =~ regex
end # build_bigram str

def mcw str
	most_common_number = 0
	most_common_word = ""
	begin
		$bigrams[str].keys.each do |key|
			if $bigrams[str][key] > most_common_number
				most_common_number = $bigrams[str][key]
				most_common_word = key
			end # if $bigrams[str][key] ? most_common_number
		end # do $bigrams[str].keys.each
		#puts "The most common word to follow '#{str}' is '#{most_common_word}'"
		return most_common_word
	rescue # begin
	end # begin
end # def mcw str

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

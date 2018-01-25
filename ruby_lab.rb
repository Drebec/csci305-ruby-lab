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
$counter = 0	# Tracks each time a new valid song title is processes in the bigram

# Function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|
			title = cleanup_title(line)	# Removes unwanted text and sets string to downcase
			build_bigram(title)	# Builds the bigram structure
		end # do IO.foreach
		puts "Finished. Bigram model built.\n"
	rescue # begin
		STDERR.puts "Could not open file"
		raise
		exit 4
	end # rescue
end # def process_file

def cleanup_title line	# Function to pick off title, remove excess information, eliminate punctuation, filter non-English characters, and set string to downcase
	line.force_encoding 'utf-8'	# Fixes encoding mismatch bug, solution derived from stack overflow https://stackoverflow.com/questions/17022394/how-to-convert-a-string-to-utf8-in-ruby
	noisy_title = line.sub(/.*>/, "")	# Grabs only the song title
	punc_title = noisy_title.sub(/([\(\[\{\\\/_\-\:\"\`\+\=\*]|feat\.).*/, "")	# Removes superfluous text
	title = punc_title.gsub(/[?!.;&@%#|¿¡]/, "")	# => Removes punctuation

	regex = /^[\w\s']+\n/	# Matches only full titles containing no non-english characters ignoring spaces and '

	if title =~ regex	# If the title contains any non-English characters, this will fail
		title.downcase!	# Set to lowercase
	else
		title = nil	# Remove titles containing non-English characters
	end # if title =~ regex
	return title	# Return the fully processed title for use in the build_bigram method
end # def cleanup_title str

def build_bigram title	# Populates the $bigrams hash
	if title != nil	# Check if the title containts any non-english characters
		title.downcase!	# Reduce case of title
		$counter += 1	# A new valid song title is being processed
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

def mcw str	# Returns the most common word to follow the input str
	most_common_number = 0	# Initialize
	most_common_word = ""
	begin
		$bigrams[str].keys.each do |key|	# For each word to follow the input str
			if $bigrams[str][key] > most_common_number	# If the occurrance of the following word is greater than the current max
				most_common_number = $bigrams[str][key]		# Overwrite the current max and save the word
				most_common_word = key
			end # if $bigrams[str][key] ? most_common_number
		end # do $bigrams[str].keys.each
		return most_common_word	# Return resulting most common following word
	rescue # begin
		return ""
		# If the word doesn't exist in the bigram, do nothing
	end # begin
end # def mcw str

def get_random_word str
	$bigrams[str].keys.each do |key|

	end # do $bigrams[str].keys.each
end # get_next_word str

def create_title str	# Creates a 20 string title using the mcw function
	current = str	# The current string
	created_title = "#{current}"	# String being created
	if (mcw current) != nil	# As long as the mcw exists for the current word
		(0..19).each do 	# Do 20 times
			created_title += " #{mcw current}"	# Add the mcw to the end of the created_title string
			current = (mcw current)	# Get the next mcw
		end # do 0..20
	end # if mcw str != nil
	return created_title	# Return result
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
	#puts "The most common word to follow 'computer' is '#{mcw("computer")}'"
	#puts "The word 'computer' has #{$bigrams['computer'].count} unique words that follow it"
	#puts "The most common word to follow 'love' is '#{mcw("love")}'"
	#puts create_title("happy")
	#puts $counter

	# Get user input

	print "Enter a word [Enter 'q' to quit]: "
	while (user = STDIN.gets.chomp) != 'q'
		puts create_title(user)
		print "Enter a word [Enter 'q' to quit]: "
	end
end

main_loop()

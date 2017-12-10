require "json"

puts "Welcome to Hangman!\n\n"

def save (word, player_guesses, incorrect_guesses_left)
  string = JSON::dump({
    :word => word,
    :player_guesses => player_guesses,
    :incorrect_guesses_left => incorrect_guesses_left
    })
    puts string.class
    File.open("saves.json", "a") do |file|
      file << string
      file << "\n"
    end
end

def load_file
  contents = []
  file = File.open("saves.json", "r")
  system "clear"
  puts "Save files: \n\n"
  file.each_line.with_index do |line, index|
    contents.push(line)
    temp = JSON.parse(contents[index])
    print "\n#{index+1}. "
    temp["word"].split("").each do |letter|
      if temp["player_guesses"].include? letter
        print letter + " "
      else
        print "_ "
      end
    end
    print "\n The letters you have already guessed in this game: "
    temp["player_guesses"].each do |letter|
      print letter + ", "
    end
    print "\n Incorrect guesses left: #{temp["incorrect_guesses_left"]}\n\n"
  end
  file.close

  print "\n\nPlease select the save you would like to load by entering the corresponding number: "

  select_save = gets.chomp

  data = JSON.parse(contents[select_save.to_i-1])
end

dictionary = File.open("5desk.txt", "r")
contents = dictionary.read
dictionary.close
word = ""

while word.length < 5 || word.length > 12 do
  #start and end to find whole word
  random_index = rand(contents.length-2)+2
  start_index = nil
  end_index = nil
  word = ""
  while start_index == nil || end_index == nil do
    if start_index == nil
      if contents[random_index] != "\n"
        random_index -= 1
      else
        start_index = random_index + 1
      end
    else
      if contents[random_index] != "\r"
        random_index += 1
      else
        end_index = random_index - 1
      end
    end
  end
  word = contents[start_index..end_index]
end

word = word.upcase
#puts word

word.length.times do
  print "_ "
end

print "\nPlease guess a letter you think is in the word: "

winner = false
player_guesses = []
incorrect_guesses_left = 6


while !winner do
  correct_guesses = 0
  input = gets.chomp.upcase
  if input == "SAVE"
    save(word, player_guesses, incorrect_guesses_left)
  elsif input == "LOAD"
    data = load_file
    if data != nil
      word = data["word"]
      player_guesses = data["player_guesses"]
      incorrect_guesses_left = data["incorrect_guesses_left"]
    end
  else
    input = input[0]
  end

  system "clear"


  if player_guesses.include? input
    puts "\nYou already guessed that letter!"
  else
    player_guesses.push(input) unless input == "LOAD" || input == "SAVE"
  end


  unless word.include? input
    incorrect_guesses_left -= 1
  end
  puts "\nYou have #{incorrect_guesses_left} wrong guesses left!"

  puts "\nType load or save at anytime to load or save a game.\n\n"

  puts "\n"
  word.split("").each do |letter|
    if player_guesses.include? letter
      correct_guesses += 1
      print letter + " "
    else
      print "_ "
    end
  end
  puts "\n"

  if incorrect_guesses_left == 0
    break
  end

  print "\nThe letters you have already guessed: "
  player_guesses.each do |letter|
    print letter + ", "
  end

  if correct_guesses == word.length
    winner = true
  else
    print "\n\nPlease guess a letter you think is in the word: "
  end
end

if winner
  puts "\nYay! You win! \u263b"
else
  puts "\nOh no! Looks like you lost \u2639"
end

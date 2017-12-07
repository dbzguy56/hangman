puts "Welcome to Hangman!\n\n"

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
puts word

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
  input = input[0]

  if player_guesses.include? input
    puts "\nYou already guessed that letter!"
  else
    player_guesses.push(input)
  end

  unless word.include? input
    incorrect_guesses_left -= 1
    puts "\nYou have #{incorrect_guesses_left} wrong guesses left!"
  end

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

dictionary = File.readlines("5desk.txt")

dictionary.map! do |word|
	word.strip
end

puts dictionary.length

dictionary.select! do |word|
	(word.length >= 5) && (word.length <= 12) && (word[0].upcase != word[0])
end

puts dictionary.length

solution = dictionary[rand(39784)]

puts solution
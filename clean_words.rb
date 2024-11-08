# frozen_string_literal: true

filedata = File.readlines("words.txt").map(&:chomp).select { |str| str.length < 13 && str.length > 4 }
File.open("cleaned_words.txt", "w") do |file|
  filedata.each { |line| file.puts(line) }
end

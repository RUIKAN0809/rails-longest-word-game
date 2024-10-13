class GamesController < ApplicationController
  require 'json'
  require 'open-uri'
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].downcase
    @letters = params[:letters].downcase.split('')

    if !word_in_grid?(@word, @letters)
      @message = "Sorry but #{@word.upcase} can't be built out of #{@letters.chars.join(", ")}"
    elsif !valid_english_word?(@word)
      @message = "Sorry but #{@word.upcase} is not a valid English word."
    else
      @message = "Congratulations! #{@word.upcase} is a valid word."
    end
  end

  private

  def word_in_grid?(word, grid)
    word.upcase.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  # Check if the word is a valid English word
  def valid_english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    begin
      response = URI.open(url).read
      json = JSON.parse(response)
      json['found'] # Returns true or false
    rescue OpenURI::HTTPError => e
      Rails.logger.error("Error fetching word validity: #{e.message}")
      false
    end
  end
end

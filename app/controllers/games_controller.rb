require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @alphabets = []
    10.times do
      @alphabets << ('A'..'Z').to_a.sample
    end
  end

  def score
    user_input = params[:longestword].upcase
    @given_alphabets = params[:token]
    @result = word_checker?(@given_alphabets, user_input)
    @word_info = api_initiator(user_input)
    @score = @word_info["length"]
    @word = @word_info["word"]

    if @word_info["found"] && @result
      @message_good = "Congratulations! #{@word.upcase} is a valid English word!\n And you got #{@score} points!"
    elsif @result == false
      @message_not_in_grid = "Sorry but #{@word.upcase} can't be built out of #{params[:token]}"
    elsif @word_info["found"] == false
      @message_not_in_english = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    end
  end

  def api_initiator(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_info_serialized = URI.open(url).read
    return JSON.parse(word_info_serialized)
  end

  def word_checker?(given, attempt)
    check_alphabets = given.split.join.upcase
    attempt.upcase.each_char { |char| check_alphabets.sub!(char, "") }
    return given.split.size - attempt.size == check_alphabets.size
  end
end

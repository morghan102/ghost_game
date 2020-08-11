require "set"
require "byebug"

class GhostGame
  ALPHA = Set.new("a".."z")
  attr_reader :players, :fragment, :dictionary

  def initialize(player_1, player_2)
    @players = [player_1, player_2]
    # @fragment = "" they dont initliaze w frag, they start it in play_round
    
    words = File.readlines("../dictionary.txt").map(&:chomp)
    @dictionary = Set.new(words)
  end
  

  def play_round
    @fragment = ""
    # debugger
    until full_word?(@fragment)
      puts "---".rjust(13)

      take_turn(current_player)
      next_player!
    end
    puts "#{@players[1]} you lose this round!" #prevplay isnt showing up
    # method to count score here!
  end

  def current_player
    @players[0]
  end

  def previous_player
    @players[1]#this will need to change
  end

  def next_player!
    @players.rotate!
  end

  def chitchat
    puts "Player #{current_player}, it's your turn."
    puts "The current fragment is #{@fragment}." if @fragment.length > 0
    puts
    puts "Please give a letter:"
    puts "---------------------"
  end


  def take_turn(player)
    chitchat
    letter = nil
    until letter 
      letter = gets.chomp
      puts
      @fragment += letter if valid_play?(letter)
      puts
      puts
    end
  end


  def valid_play?(str)
    new_frag = @fragment + str
    if !ALPHA.include?(str) || str.length > 1
      puts "That isn't a valid guess. You miss a turn."
      return false
    end
    @dictionary.any? { |word| word.start_with?(new_frag) }
  end


  def full_word?(frag)
    dictionary.include?(frag) && (
      dictionary.none? do |word| 
        word.start_with?(frag) && word.length > frag.length
      end #dict includes frag and no words in the dict
      # that start w frag while being longer
    )
    #   puts "#{current_player}, you completed the word!" 

  end

end
  #wd be nice to to correlate num of times player has gone and 
# that frag's position in words of the dictionary
  #make output look better, it's confusng
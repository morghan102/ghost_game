require "set"
require "byebug"
require_relative "./player.rb"

class GhostGame
  ALPHA = Set.new("a".."z")
  attr_reader :players, :fragment, :dictionary

  def initialize(*people)
    # @players = [player_1, player_2]
    @players = []
    people.each do |name|
      @players << Player.new(name)
    end
    # @fragment = "" they dont initliaze w frag, they start it in play_round
    
    words = File.readlines("../dictionary.txt").map(&:chomp)
    @dictionary = Set.new(words)
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
    puts "Player #{current_player.name}, it's your turn."
    puts "The current fragment is #{@fragment}." if @fragment.length > 0
    puts
    puts "Please give a letter:"
    puts "---------------------"
  end

  def display_standings
    puts "SCOREBOARD"
    players.each do |player|
      puts "#{player.name}: #{player.losses}"
    end
  end

  def deathtoll 
    puts "#{previous_player.name}, you are the loser"
    puts "#{current_player.name}, congratulations!"
    puts "* * * * * * * *"
    current_player
  end

  def run
    until current_player.losses_left == 0 || previous_player.losses_left == 0#either player gets ghost
      display_standings
      play_round
    end
    deathtoll
  end

    def play_round
    @fragment = ""
    until full_word?(@fragment)
      puts "---".rjust(13)

      take_turn(current_player)
      next_player!
    end
    lose
    puts "* * * * *"
    puts "#{@players[1].name} you lose this round!" #prevplay isnt showing up
    puts "* * * * *"
    puts
  end

  def take_turn(player)
    chitchat
    letter = nil
    until letter 
      letter = current_player.guess
      puts
      @fragment += letter if valid_play?(letter)
      puts
      # puts
    end
  end


  def valid_play?(str)
    new_frag = @fragment + str
    if !ALPHA.include?(str) || str.length > 1
      # debugger
      current_player.alert_invalid_guess
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

  def lose
    previous_player.losses_left -= 1
    record(previous_player)
  end

  def record(player)
    ghost = "GHOST".split("").reverse
    player.losses += ghost[ player.losses_left ] #string
  end

end
  #wd be nice to to correlate num of times player has gone and 
# that frag's position in words of the dictionary
  #make output look better, it's confusng
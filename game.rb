require "set"
require "byebug"
require_relative "./player.rb"

class GhostGame
  ALPHA = Set.new("a".."z")
  attr_reader :players, :fragment, :dictionary

  def initialize(*people)
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
    @players[-1]
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
    lose_round
    puts "* * * * *"
    puts "#{previous_player.name} you lose this round!"
    puts "* * * * *"
    puts
  end

  def winner_winner_winner
    puts "     *"
    puts "#{@players[0].name} wins!!!!!"
    puts "* * * * * * *"
    puts "* * * * * *"
    puts "* * * * *"
    puts "* * * *"
    puts "* * *"
    puts "* *"
    puts "*"
  end

  def run
    until @players.one? {|player| player.losses_left > 0 }
      display_standings
      play_round
      if players.any? {|player| player.losses_left == 0 }
        puts "#{@players.pop.name}, you are finished."
        puts "- - - - "
        # debugger
        # couldnt get that message towork sadly :/
        # puts "Players #{@players.each {|player| print "#{player.name}, "}}, continue playing!"
      end
    end
    winner_winner_winner
  end

    def play_round
    @fragment = ""
    until full_word?(@fragment)
      puts "---".rjust(13)

      take_turn(current_player)
      next_player!
    end
    deathtoll
  end

  def take_turn(player)
    chitchat
    letter = nil
    until letter 
      letter = current_player.guess
      puts
      @fragment += letter if valid_play?(letter)
      puts
    end
  end


  def valid_play?(str)
    new_frag = @fragment + str
    if !ALPHA.include?(str) || str.length > 1
      current_player.alert_invalid_guess
      return false
    end
    @dictionary.any? { |word| word.start_with?(new_frag) }
  end


  def full_word?(frag)
    dictionary.include?(frag) && (
      dictionary.none? do |word| 
        word.start_with?(frag) && word.length > frag.length
      end
    )
  end

  def lose_round
    previous_player.losses_left -= 1
    record(previous_player)
  end

  def record(player)
    ghost = "GHOST".split("").reverse
    player.losses += ghost[ player.losses_left ] 
  end

end
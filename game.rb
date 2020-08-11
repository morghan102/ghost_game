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
    until full_word?(@fragment) #this may need to change
      puts "---".rjust(13)
      puts "Player #{current_player}, it's your turn."
      puts "The current fragment is #{@fragment}." if @fragment.length > 0
        # could put all this elsewhere, looks messy
      take_turn(current_player)

      next_player!
    end
    # methid to count score here!
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



  def take_turn(player)
    puts "Please give a letter:"
    puts "---------------------"
    letter = gets.chomp
    puts
    @fragment += letter if valid_play?(letter)
    return false if full_word?(@fragment)
  end



  def valid_play?(str)
    new_frag = @fragment + str
    return false if !ALPHA.include?(str) || str.length > 1
      # puts "That isn't a valid guess, please keep guesses to 1 letter. You miss a turn."
      # return false
    @dictionary.any? { |word| word.start_with?(new_frag) } #&& word.length == new_frag.length
      # puts "That word is invalid."
      # puts "#{current_player}, you lose!!"
      # return false
 
    # elsif full_word?(new_frag)
    #   return false
    # end
    # true
  end

#!!!!!!!!!!!!!!!!!!!!!!!!!!!
# i need to restruc based on theirs :(






  def full_word?(frag)
    if @dictionary.any? do |word| 
      word == frag && word.length == frag.length && @dictionary.none? { |word| word.length > @fragment.length}
    end
      # if @dictionary.none? { |word| word.length > @fragment.length} #checking new @fragment if already a word
    # i'll check the length
    # if the word is longer than the length of the frag
      puts "#{current_player}, you completed the word!" 
      return true
  
    end
    false
  end

end
# fix too so sand doesnt stop bc sandwich! not sure how to do
  #wd be nice to to correlate num of times player has gone and 
# that frag's position in words of the dictionary
  #make output look better, it's confusng
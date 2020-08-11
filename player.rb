class Player

  def initialize(name)
    @name = name
    @losses = ""
    @losses_left = 5
  end

  attr_accessor :name, :losses, :losses_left

  def guess
    gets.chomp
  end

  def alert_invalid_guess
    puts "That isn't a valid guess. You miss a turn."
  end

  def name
    @name
  end

end
require 'logger'

class Warship
  attr_reader :health

  def initialize(health, damage)
    @initial_health = health
    @health = health
    @damage = damage

    @logger = Logger.new(STDOUT)
  end

  def state
    if @health == @initial_health
      :ok
    elsif @health > 0
      :damaged
    else
      :wasted
    end
  end

  def attacked(with_damage)
    @health -= with_damage.to_i
  end

  def attack(object)
    object.attacked(@damage) if object.respond_to?(:attacked)
    @logger.info('One object attacked other')
  end
end

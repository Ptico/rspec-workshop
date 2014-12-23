class Warship
  attr_reader :health

  def initialize(health, damage)
    @health = health
    @damage = damage
  end

  def state
    @health > 0 ? :ok : :wasted
  end

  def attacked(with_damage)
    @health -= with_damage.to_i
  end
end

class Journey

  attr_reader :entry_station, :exit_station

  PENALTY_CHARGE = 6.00

  def initialize(entry_station = nil)
    @entry_station = entry_station
  end

  def finish(exit_station)
    @exit_station = exit_station
    self
  end

  def fare
    return PENALTY_CHARGE if incomplete?
    (@entry_station.zone - @exit_station.zone).abs + 1.00
  end

  private

  def incomplete?
    @entry_station.nil? || @exit_station.nil?
  end

end

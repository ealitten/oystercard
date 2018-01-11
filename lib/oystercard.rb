require_relative 'journeylog'


class Oystercard

  attr_reader :balance

  MAX_BALANCE = 90.00
  MINIMUM_FARE = 1.00

  def initialize(initial_balance = 0.00, journey_log = JourneyLog.new)
    @balance = initial_balance
    @journey_log = journey_log
  end

  def top_up(value)
    fail "Cannot top up past maximum balance of #{MAX_BALANCE}" if balance_limit_exceeded?(value)
    @balance += value
  end

  def touch_in(entry_station)
    raise "insufficient balance for journey" if insufficient_funds?
    # ask JL if current journey incomplete? ==> deduct
    deduct(@journey_log.current_journey.fare) if @journey_log.current_journey.incomplete?
    @journey_log.start(entry_station)
  end

  def touch_out(exit_station)
    @journey_log.finish(exit_station)
    deduct(@journey_log.journeys.last.fare)
  end

  def journeys
    @journey_log.journeys
  end

  private

  def insufficient_funds?
    @balance <  MINIMUM_FARE
  end

  def balance_limit_exceeded?(value)
    @balance + value > MAX_BALANCE
  end

  def deduct(value)
    @balance -= value
  end
end

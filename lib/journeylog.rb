require_relative 'journey'

class JourneyLog

  attr_reader :current_journey

  def initialize(journey_class = Journey, existing_journey = nil)
    @journey_class = journey_class
    @current_journey = existing_journey
    @history = []
  end

  def start(station)
    close_journey if @current_journey
    create_journey(station)
  end

  def finish(station)
    create_journey unless @current_journey
    close_journey(station)
  end

  def journeys
    @history.dup
  end

  private

  def store_journey(journey)
    @history << journey
  end

  def create_journey(entry_station = nil)
    @current_journey = @journey_class.new(entry_station)
  end

  def close_journey(exit_station = nil)
    @current_journey.finish(exit_station)
    store_journey(@current_journey)
    clear_journey
  end

  def clear_journey
    @current_journey = nil
  end
end

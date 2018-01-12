require "oystercard"

describe Oystercard do
  let (:entry_station) { double :entry_station}
  let (:exit_station) { double :exit_station}
  let (:journey) { double :journey, fare: 1, incomplete?: true}
  let (:journey_log) { double :journey_log, start: journey, finish: nil, journeys: [journey], current_journey: journey }
  
  subject(:oystercard) { described_class.new(5.00, journey_log) }

  describe "#top_up" do
    it "should increase balance" do
      expect{ oystercard.top_up(3.50) }.to change { oystercard.balance }.by (3.50)
    end

    it "should return balance" do
      expect( oystercard.top_up(3.50) ).to eq oystercard.balance
    end

    it "should not allow top-up over max balance" do
      oystercard = Oystercard.new(Oystercard::MAX_BALANCE)
      expect { oystercard.top_up(1.00) }.to raise_error("Cannot top up past maximum balance of #{Oystercard::MAX_BALANCE}")
    end
  end

  describe "#touch_in" do
    it "should raise an error if a card with insufficient balance is touched in" do
      oystercard = Oystercard.new(0.99)
      expect{ oystercard.touch_in(entry_station) }.to raise_error "insufficient balance for journey"
    end

    it "should instruct journey_log to create a new journey" do
      oystercard.touch_in(entry_station)
      expect(journey_log).to have_received(:start)
    end

    it "should return a newly-created journey" do
      expect(oystercard.touch_in(entry_station)).to eq journey
    end
  end

  describe "#touch_out" do
    it "should instruct journey_log to finish journey" do
      oystercard.touch_out(exit_station)
      expect(journey_log).to have_received(:finish)
    end

    it "should charge card for journey" do
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }
    end
  end
end

require 'journeylog'

describe JourneyLog do
  let (:journey) { double :journey, finish: nil }
  let (:old_journey) { double :journey, finish: nil }
  let (:journey_class) { double :journey_class, new: journey }
  let (:entry_station) { double :entry_station }
  let (:exit_station) { double :exit_station }
  
  subject(:journeylog) { described_class.new(journey_class) }


  describe "initialize" do
    it "should create empty journey history" do
      expect(journeylog.journeys).to eq []
    end
  end


  context "when a journey already exists" do

    subject(:journeylog) { described_class.new(journey_class, old_journey) }

    describe "#start" do
      it "closes old journey first" do
        journeylog.start(entry_station)
        expect(journeylog.journeys).to include old_journey
      end
    end

    describe "#finish" do
      it "closes journey" do
        expect(journeylog).to receive(:close_journey)
        journeylog.finish(exit_station)
      end

      it "stores journey in history" do
        journeylog.finish(exit_station)
        expect(journeylog.journeys).to include old_journey
      end

      it "clears current_journey" do
        expect(journeylog.finish(exit_station)).to eq nil
      end

    end
  end

  context "when a journey doesn't exist" do
    describe "#start" do
      it "creates a new journey" do
        journeylog.start(entry_station)
        expect(journeylog.current_journey).to eq journey
      end

      it "returns a journey" do
        expect(journeylog.start(entry_station)).to eq journey
      end
    end

    describe "#finish" do
      it "creates incomplete journey first" do
        journeylog.finish(exit_station)
        expect(journeylog.journeys).to include journey
      end
    end

  end
end
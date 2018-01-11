require "journeylog"

describe JourneyLog do
  let (:journey) { double :journey, finish: journey }
  let (:journey_class) { double :journey_class, new: journey }
  let (:entry_station) { double :entry_station }
  let (:exit_station) { double :exit_station }
  subject(:journeylog) { described_class.new(journey_class) }

  describe "initialize" do
    it "should create empty journey history" do
      expect(journeylog.journeys).to eq []
    end
  end


  context "a journey already exists" do

    # subject(:journeylog) { described_class.new(journey_class, journey) }

    describe "#start" do
      it "closes old journey & starts new one if one already exists" do
        journeylog.start(entry_station)
        expect(journeylog.journeys).to include journey
      end
    end

    describe "#finish" do
      it "finishes a journey" do
        expect(journeylog.finish(exit_station)).to eq nil
      end
    end
  end

  context "a journey doesn't exist" do
    describe "#start" do
      it "starts a journey" do
        expect(journeylog.start(entry_station)).to eq journey
      end
    end

    describe "#finish" do
      it "creates journey, then closes it" do
        journeylog.finish(exit_station)
        expect(journeylog.journeys).to include journey
      end
    end

  end


end

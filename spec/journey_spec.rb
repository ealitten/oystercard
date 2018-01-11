require 'journey'

describe Journey do

  let (:entry_station) { double :entry_station}
  let (:exit_station) { double :exit_station}

  subject(:journey) {described_class.new(entry_station)}

  describe "#initialize" do

    it "should create a new journey with starting station" do
      expect(journey.entry_station).to eq entry_station
    end
    it "should create a new journey with destination = nil" do
      expect(journey.exit_station).to eq nil
    end
  end

  describe "#finish" do

    it "should return self on completion" do
      expect(journey.finish(exit_station)).to eq journey
    end

  end

  describe "#fare" do

    before {journey.finish(exit_station) }

    it "should return correct fare if crossing one zone" do
      allow(entry_station).to receive(:zone).and_return(1)
      allow(exit_station).to receive(:zone).and_return(2)
      expect(journey.fare).to eq 2.00
    end

    it "should return correct fare if crossing no zones" do
      allow(entry_station).to receive(:zone).and_return(1)
      allow(exit_station).to receive(:zone).and_return(1)
      expect(journey.fare).to eq 1.00
    end

    it "should return penalty fare if incomplete journey" do
      journey = Journey.new
      expect(journey.fare).to eq 6.00
    end

  end

end

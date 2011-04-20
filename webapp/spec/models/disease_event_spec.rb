require 'spec_helper'

describe DiseaseEvent do

  before do
    @de = DiseaseEvent.create
  end

  it "validates the onset date" do
    @de.update_attribute(:disease_onset_date, 'not a date string')
    @de.should_not be_valid
    @de.errors.on(:disease_onset_date).should_not be_nil
  end

  describe "date diagnosed" do
    it "is valid if it is after the onset date" do
      @de.update_attributes(:disease_onset_date => Date.yesterday)
      @de.update_attributes(:date_diagnosed => Date.today)
      @de.should be_valid
      @de.errors.on(:date_diagnosed).should be_nil
    end

    it "is invalid if it is before the onset date" do
      @de.update_attributes(:disease_onset_date => Date.today)
      @de.update_attributes(:date_diagnosed => Date.yesterday)
      @de.errors.on(:date_diagnosed).should == "must be on or after " + Date.today.to_s
    end

    it "is valid if if occurs in the past" do
      @de.update_attributes(:date_diagnosed => Date.yesterday)
      @de.should be_valid
      @de.errors.on(:date_diagnosed).should be_nil
    end

    it "is not valid if it occurs in the future" do
      @de.update_attributes(:date_diagnosed => Date.tomorrow)
      @de.errors.on(:date_diagnosed).should == "must be on or before " + Date.today.to_s
    end
  end

end

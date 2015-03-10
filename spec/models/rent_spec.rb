require 'spec_helper'

describe Rent do
  before(:each) do
    @artwork = Kunstvoorwerp.first
  end

  it "should run just fine" do
    @rent = @artwork.rents.new
    @rent.confirm(User.first).should_be true
  end
end

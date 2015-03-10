class TestController < ApplicationController
  def index
    @kunstprop = Propertycontainer.find(:all, :include => :kunstproperties)
     @kunstprop[0].kunstproperties.inspect
    raise @kunstprop[0].inspect
  end
end

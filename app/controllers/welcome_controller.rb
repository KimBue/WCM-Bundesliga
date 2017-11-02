class WelcomeController < ApplicationController
  def index
    @avail_sports = OpenligaSoapService.new.get_avail_sports
  end
end

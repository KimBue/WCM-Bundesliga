class WelcomeController < ApplicationController
  def index
    @openligaReachable = true
    @avail_sports = OpenligaSoapService.new.get_avail_sports
  rescue Net::OpenTimeout, Net::ReadTimeout, SocketError => timeOut
    puts 'Welcome#index: Web-Error: ' + timeOut.to_s
    @openligaReachable = false
  end
end

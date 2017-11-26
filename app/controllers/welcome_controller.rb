class WelcomeController < ApplicationController
  def index
    begin
      @openligaReachable = true
      @avail_sports_online = OpenligaSoapService.new.get_avail_sports
    rescue => error
      puts 'WelcomeController - Error: ' + error.message.to_s
      @openligaReachable = false
      @avail_sports_local = League.select(:sports_id).distinct
      end
  end
end

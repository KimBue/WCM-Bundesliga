class LeaguesController < ApplicationController
  def index
    @openligaReachable = true
    @sports_id = params[:sports_id]
    response = OpenligaSoapService.new.get_avail_leagues_by_sports(@sports_id)
    @avail_leagues = response.sort_by {|hash| hash[:league_saison]}
    # get table-data and publish it in instance-variables
    @league_goals = LeagueGoal.all
  rescue Net::OpenTimeout, Net::ReadTimeout, SocketError => timeOut
    puts 'Leagues#index: Web-Error: ' + timeOut.to_s
    @openligaReachable = false
  end

  def create
    OpenligaParser.new.parse_openliga(params[:league_shortcut], params[:league_saison])
    redirect_to action: 'index', sports_id: params[:sports_id]
  end

  private
end

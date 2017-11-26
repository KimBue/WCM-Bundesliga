class LeaguesController < ApplicationController
  def index
    begin
      @openligaReachable = true
      @sports_id = params[:sports_id]
      @sports_name = params[:sports_name]
      # get available online data
      response = OpenligaSoapService.new.get_avail_leagues_by_sports(@sports_id)
      @avail_leagues_online = response.sort_by { |hash| hash[:league_saison] }
      @league_goals = LeagueGoal.all
      # get available local data
    rescue => error
      puts 'LeaguesController - Error: ' + error.message.to_s
      @openligaReachable = false
      @avail_leagues_local = League.where(sports_id: params[:sports_id])
      @league_goals = LeagueGoal.all
    end
  end

  def create
    OpenligaParser.new.parse_openliga(params[:sports_id],
                                      params[:sports_name],
                                      params[:league_shortcut],
                                      params[:league_saison])
    redirect_to action: 'index', sports_id: params[:sports_id]
  end

  private
end

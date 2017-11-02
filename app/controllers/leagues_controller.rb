class LeaguesController < ApplicationController
  def index
    @sports_id = params[:sports_id]
    @avail_leagues = OpenligaSoapService.new.get_avail_leagues_by_sports(@sports_id)

    # get table-data and publish it in instance-variables
    @league_goals = LeagueGoal.all
  end

  def create
    puts 'create for ' + params[:league_shortcut] + ' / ' + params[:league_saison]
    OpenligaParser.new.parse_openliga(params[:league_shortcut], params[:league_saison])
  end

  private
end

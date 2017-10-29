class LeaguesController < ApplicationController
  def index

    openliga = OpenligaParser.new
    openliga.parse_openliga

    @leagues = League.all
    @league_goals = LeagueGoal.all
  end

  def create
    puts 'create called'
  end

  private
end

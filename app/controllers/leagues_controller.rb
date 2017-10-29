class LeaguesController < ApplicationController
  def index
    # fill tables
    openliga = OpenligaParser.new
    openliga.parse_openliga
    # get table-data and publish it in instance-variables
    @leagues = League.all
    @league_goals = LeagueGoal.all
  end

  def create
    puts 'create called'
  end

  private
end

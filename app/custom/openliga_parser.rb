require 'net/http'
require 'json'

class OpenligaParser
  # @param [Object] league_shortcut
  def parse_openliga(league_shortcut, league_saison)
    net_response = Net::HTTP.get(URI("https://www.openligadb.de/api/getmatchdata/#{league_shortcut}/#{league_saison}"))
    @parsed_result = JSON.parse(net_response)
    fill_league_table(league_shortcut)
    fill_group_table
    fill_team_table
    fill_match_table
    fill_result_table
    fill_goal_table
  end

  private

  def fill_league_table(league_shortcut)
    @parsed_result.each do |m|
      next if (m['LeagueId']).nil?
      next if League.exists?(league_id: m['LeagueId'])
      league = League.new
      league.league_id = m['LeagueId']
      league.league_name = m['LeagueName']
      league.league_shortcut = league_shortcut
      league.save
    end
  end

  def fill_group_table
    @parsed_result.each do |m|
      next if (begin
                 m['Group']['GroupID']
               rescue
                 nil
               end).nil?
      next if Group.exists?(group_id: m['Group']['GroupID'])
      group = Group.new
      group.group_id = m['Group']['GroupID']
      group.group_name = m['Group']['GroupName']
      group.group_order_id = m['Group']['GroupOrderID']
      group.save
    end
  end

  def fill_team_table
    @parsed_result.each do |m|
      unless (begin
                m['Team1']['TeamId']
              rescue
                nil
              end).nil?
        next if Team.exists?(team_id: m['Team1']['TeamId'])
        team1 = Team.new
        team1.team_id = m['Team1']['TeamId']
        team1.team_name = m['Team1']['TeamName']
        team1.short_name = m['Team1']['ShortName']
        team1.team_icon_url = m['Team1']['TeamIconUrl']
        team1.save
      end
      next if (begin
                 m['Team2']['TeamId']
               rescue
                 nil
               end).nil?
      next if Team.exists?(team_id: m['Team2']['TeamId'])
      team2 = Team.new
      team2.team_id = m['Team2']['TeamId']
      team2.team_name = m['Team2']['TeamName']
      team2.short_name = m['Team2']['ShortName']
      team2.team_icon_url = m['Team2']['TeamIconUrl']
      team2.save
    end
  end

  def fill_result_table
    @parsed_result.each do |m|
      (0..m['MatchResults'].count).each do |i|
        next if (begin
                   m['MatchResults'][i]['ResultID']
                 rescue
                   nil
                 end).nil?
        next if MatchResult.exists?(result_id: m['MatchResults'][i]['ResultID'])
        result = MatchResult.new
        result.result_id = m['MatchResults'][i]['ResultID']
        result.result_name = m['MatchResults'][i]['ResultName']
        result.result_order_id = m['MatchResults'][i]['ResultOrderID']
        result.result_type_id = m['MatchResults'][i]['ResultTypeID']
        result.points_team1 = m['MatchResults'][i]['PointsTeam1']
        result.points_team2 = m['MatchResults'][i]['PointsTeam2']
        result.result_description = m['MatchResults'][i]['ResultDescription']
        result.match_id = m['MatchID']
        result.save
      end
    end
  end

  def fill_goal_table
    @parsed_result.each do |m|
      (0..m['Goals'].count).each do |i|
        next if (begin
                   m['Goals'][i]['GoalID']
                 rescue
                   nil
                 end).nil?
        next if Goal.exists?(goal_id: m['Goals'][i]['GoalID'])
        goal = Goal.new
        goal.goal_id = m['Goals'][i]['GoalID']
        goal.goal_getter_id = m['Goals'][i]['GoalGetterID']
        goal.goal_getter_name = m['Goals'][i]['GoalGetterName']
        goal.match_minute = m['Goals'][i]['MatchMinute']
        goal.score_team1 = m['Goals'][i]['ScoreTeam1']
        goal.score_team2 = m['Goals'][i]['ScoreTeam2']
        goal.comment = m['Goals'][i]['Comment']
        goal.is_overtime = m['Goals'][i]['IsOvertime']
        goal.is_own_goal = m['Goals'][i]['IsOwnGoal']
        goal.is_penalty = m['Goals'][i]['IsPenalty']
        goal.match_id = m['MatchID']
        goal.save
        # join-table league-goal
        league_goal = LeagueGoal.new
        league_goal.league_id = m['LeagueId']
        league_goal.goal_id = m['Goals'][i]['GoalID']
        league_goal.save
      end
    end
  end

  def fill_match_table
    @parsed_result.each do |m|
      next if (m['MatchID']).nil?
      next if Match.exists?(match_id: m['MatchID'])
      # match info
      match = Match.new
      match.match_id = m['MatchID']
      match.match_date_time = m['MatchDateTime']
      match.match_date_time_utc = m['MatchDateTimeUTC']
      match.last_update_date_time = m['LastUpdateDateTime']
      match.match_is_finished = m['MatchIsFinished']
      match.number_of_viewers = m['NumberOfViewers']
      match.time_zone_id = m['TimeZoneID']
      match.location_id = m['Location']['LocationID'] unless (
      begin
        m['Location']['LocationID']
      rescue
        nil
      end).nil?
      match.location_city = m['Location']['LocationCity'] unless (
      begin
        m['Location']['LocationCity']
      rescue
        nil
      end).nil?
      match.location_stadium = m['Location']['LocationStadium'] unless (
      begin
        m['Location']['LocationStadium']
      rescue
        nil
      end).nil?
      # foreign keys, references
      match.league_id = m['LeagueId'] unless (m['LeagueId']).nil?
      unless (begin
                m['Group']['GroupID']
              rescue
                nil
              end).nil?
        match.group_id = m['Group']['GroupID']
      end
      unless (begin
                m['Team1']['TeamId']
              rescue
                nil
              end).nil?
        match.team1_id = m['Team1']['TeamId']
      end
      unless (begin
                m['Team2']['TeamId']
              rescue
                nil
              end).nil?
        match.team2_id = m['Team2']['TeamId']
      end
      match.save
    end
  end
end

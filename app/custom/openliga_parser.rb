require 'net/http'
require 'json'
require 'wikidata'
require 'sparql/client'

class OpenligaParser
  # @param [Object] league_shortcut
  def parse_openliga(sports_id, sports_name,
                     league_shortcut, league_saison)
    net_response = Net::HTTP.get(URI("https://www.openligadb.de/api/getmatchdata/#{league_shortcut}/#{league_saison}"))
    @parsed_result = JSON.parse(net_response)
    fill_league_table(sports_id, sports_name, league_shortcut)
    fill_group_table
    fill_team_table
    fill_match_table
    fill_result_table
    fill_goal_table
  end

  private

  def fill_league_table(league_shortcut, sports_id, sports_name)
    @parsed_result.each do |m|
      next if (m['LeagueId']).nil?
      next if League.exists?(league_id: m['LeagueId'])
      league = League.new
      league.league_id = m['LeagueId']
      league.league_name = m['LeagueName']
      league.league_shortcut = league_shortcut
      league.sports_id = sports_id
      league.sports_name = sports_name
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
        team1_wikiId = Wikidata::Item.search m['Team1']['TeamName']
        if not team1_wikiId == nil
          team1.team_wikiId = team1_wikiId.results[0].id
        end
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
      team2_wikiId = Wikidata::Item.search m['Team2']['TeamName']
      if not team2_wikiId == nil
        team2.team_wikiId = team2_wikiId.results[0].id
      end
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
        #trage zu diesem Tor passenden Goalgetter in Spielertabelle
        if  not goal.is_own_goal
         fill_goalgetters(m, goal, i )
        else
          puts 'Eigentor: ' + goal.goal_getter_name + ' hat ei Eigentor erziehlt '
        end
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

  def fill_goalgetters(match, goal, i)
    #diese Funktion sollte aufgerufen werden, wenn ein neues Match eingelesen wird
    # denn dann habe ich Zugriff auf Spielername UND Verein
    # openligadb gibt Torschützen IDs, jedoch sid trotzde leider viele Dopplungen enthalten


    if not Goalgetter.exists?(goalgetter_id: goal.goal_getter_id)
      #die Spieler_id von openligadb ist noch nicht vergeben, wie sieht es mit de Namen aus?
      #Todo schreibe da mal ne extra Funktion für, die mit Regex prüft, ob Name und Verein identisch sind, es gibt nämlich viele Duplikate in den openliga Daten

      ein_spieler = Goalgetter.new
      ein_spieler.goalgetter_id = goal.goal_getter_id
      ein_spieler.name = goal.goal_getter_name
      #um den Verein herauszufinden, muss ich schauen, von welchem Team das Tor geschossen wurde
      # dafür muss ich schauen, wie der Spielstad vor dem Tor war

      #erstes Tor?
      if i ==0
        if goal.score_team1 ==1
          ein_spieler.team_id =  match['Team1']['TeamId']
        else
          ein_spieler.team_id = match['Team2']['TeamId']
        end
      else

        pre_goal = match['Goals'][i-1]
        if pre_goal['ScoreTeam1'] ==goal.score_team1
          ein_spieler.team_id = match['Team2']['TeamId']
        else
          ein_spieler.team_id =  match['Team1']['TeamId']
        end
      end
      puts 'Spielername: ' + ein_spieler.name
      wikiID = get_spieler_WikiId(ein_spieler.name, ein_spieler.team_id)
      if not wikiID == '-1'
        ein_spieler.wikidata_id = wikiID
      end
      ein_spieler.save


    end



  end

  def get_spieler_WikiId(name, team_id)
    #Falls vor und Nachname in umgekehrter Reihenfolge auftreten, müssen die für Wikidata umgedreht werden
    if name.include? ","
      splittet = name.split(",")
      name = ""
      splittet.each do |sp|
        name = sp.strip + " " + name
      end
      name = name.strip
      name.slice! ","

    end

    #Falls Punkt Abkürzung
    if name.include? "."
      splittet = name.split(".")

      if splittet.length == 2
        name = splittet[1]
        name.slice! "."
        name = name.strip
        vorname_first_char = splittet[0]
      end
    end
    name = name.strip
    sparql = SPARQL::Client.new("https://query.wikidata.org/sparql")
    wikidata_verein = Team.find(team_id).team_wikiId
    name_reg = make_diacritic_insensitive(name)
    query= sparql.query("SELECT ?item ?itemLabel WHERE {  ?item wdt:P106 wd:Q937857. ?item wdt:P54 wd:#{wikidata_verein}. ?item rdfs:label ?itemLabel.FILTER((LANG(?itemLabel)) = \"en\")FILTER(REGEX(?itemLabel, \"(#{name_reg})$*\"))}")
    wikiIDs = []
    puts "SELECT ?item ?itemLabel WHERE {  ?item wdt:P106 wd:Q937857. ?item wdt:P54 wd:#{wikidata_verein}. ?item rdfs:label ?itemLabel.FILTER((LANG(?itemLabel)) = \"en\")FILTER(REGEX(?itemLabel, \"(#{name_reg})$*\"))}"

    query.each do |p|
      puts 'Hier sind wir: Jetzt echt:  '
      uri = p['item'].to_s
      puts p.to_s
      urisplit = uri.split("/")
      wikiIDs.push urisplit[urisplit.length -  1 ]
      if not vorname_first_char == nil
        if not vorname_first_char == p['itemLabel'].to_s.scan(/./)[0]
          puts "Obacht, der Vorname scheint nicht zu korrespondieren"
          puts p['itemLabel']
        end
      end
    end
    if wikiIDs.length == 1
      return wikiIDs[0]
    else
      puts 'Achtung, zu viele oder zu wenige Goalgetter gefunden: ' +  wikiIDs.to_s
      puts name + " " + team_id.to_s
    end

  end


  def make_diacritic_insensitive(regex)
    regex_array = regex.scan(/./)
    regex_array.each_with_index do |char, i|
      if char == 'e'
        regex_array[i] = "(e|é|è|ê|ë)"
      end
      if char =='E'
        regex_array[i] = "(E|É|È|Ê)"
      end
      if char == 'C'
        regex_array[i] = "(C|Ç|Č)"
      end
      if char == 'c'
        regex_array[i]= "(c|ç|č|ć)"
      end
      if char == "g"
        regex_array[i] = "(g|ğ)"
      end
      if char == 'i'
        regex_array[i] = '(i|í|ì|î|ï)'
      end
      if char == 'L'
        regex_array[i] = '(L|Ł)'
      end
      if char == 's'
        regex_array[i] = '(s|š)'
      end
      if char == 'A'
        regex_array[i] = '(A|Á|Ä)'
      end
      if char == 'a'
        regex_array[i] = '(a|á|à|â)'
      end
      if char == 'o'
        regex_array[i]= '(o|ô|ó)'
      end


    end
    return regex_array.join("")
  end

end

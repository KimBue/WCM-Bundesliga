class KarteController < ApplicationController
  def index
    @league_shortcut = params[:league_shortcut]
    puts 'karte hat league_shortcut: ' + @league_shortcut
  end
  def getNbOfGoalsPerEntity(season, group_id, entity_wiki_id)
    #ToDo fertig schreiben /testen
    #returns the number of Goals on this matchday scored from players born in the entity
    count = 0
    matches = Match.where(group_id: group_id)
    for match in matches do
      goals = Goal.where(match_id:match.match_id )
      for goal in goals do
        #those are the goals scored on that matchday
        # diese Abfrage wirkt ziemlich zeitintensiv, wie kann man sie scheller machen?
        goalgetter = Goalgetter.where(goalgetter_id: goal.goalgetter_id )
        if not goalgetter == nil
         if checkHigherDistricts?(goalgetter.birthplace_id, entity_wiki_id)
           count += 1
         end
      end
    end
  end
  end

  def checkHigherDistricts?(wiki_id_higherDistrict, wiki_id_compareWith )
    if wiki_id_higherDistrict == wiki_id_compareWith
      return true
    end
    if not Birthplace.exists?(wiki_id:wiki_id_higherDistrict)
      return false
    end
    higher_district = Birthplace.where(wiki_id: wiki_id_higherDistrict).first

      puts higher_district.wiki_id
      puts higher_district.to_s
      return  checkHigherDistricts?( higher_district.district_wiki_id, wiki_id_compareWith)


  end
  end


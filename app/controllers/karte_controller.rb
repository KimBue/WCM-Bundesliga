class KarteController < ApplicationController
  def index
    @league_shortcut = params[:league_shortcut]
    puts 'karte hat league_shortcut: ' + @league_shortcut
  end
end

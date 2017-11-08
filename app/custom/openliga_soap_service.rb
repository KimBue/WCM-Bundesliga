class OpenligaSoapService
  def get_avail_sports
    response = client.call(:get_avail_sports)
    response.to_hash[:get_avail_sports_response][:get_avail_sports_result][:sport]
  rescue Savon::SOAPFault => error
    fault = error.to_hash[:fault]
    puts fault.to_s
  end

  def get_avail_leagues_by_sports(sports_id)
    message = { sportID: sports_id }
    response = client.call(:get_avail_leagues_by_sports, message: message)
    response.to_hash[:get_avail_leagues_by_sports_response][:get_avail_leagues_by_sports_result][:league]
  rescue Savon::SOAPFault => error
    fault = error.to_hash[:fault]
    puts fault.to_s
  end

  private

  def client
    Savon.client(wsdl: 'https://www.openligadb.de/Webservices/Sportsdata.asmx?wsdl',
      open_timeout: 10, # 10 sec timeout for open
      read_timeout: 10) # 10 sec timeout for read
  end
end

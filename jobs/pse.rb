require 'rest-client'
require 'json'

URL = "http://phisix-api.appspot.com/stocks.json"

SCHEDULER.every '2s', :first_in => 0 do |job|
  value = RestClient.get URL
  data = JSON.parse(value)["stock"]

  #values
  stocks = Pse.new data
  values = stocks.value(settings.stock_symbol)

  #top advances
  advances = stocks.top_changes.map{|stock| { :label => stock["name"],
                                              :value => stock["percent_change"]}}


  send_event('stock', {current: values[:current], last: values[:previous]})
  send_event('stock-volume', {value: stocks.find(settings.stock_symbol)["volume"],
                              max: stocks.total_volume})
  send_event('advances', {items: advances})
end

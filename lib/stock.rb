class Pse
  def initialize(values = {})
    @stocks = values
  end

  def find(symbol)
    @stocks.select{ |hash| hash["symbol"] == symbol}.first
  end

  def total_volume
    @stocks.map{|stock| stock["volume"]}.inject("+")
  end

  def top_volumes
    @stocks.sort_by{|hash| hash["volume"]}[-10...-1]
  end

  def top_changes
    @stocks.sort_by{|hash| hash["percent_change"]}[-10...-1]
  end

  def value(symbol)
    data = find(symbol) || find("BPI")
    current = data["price"]["amount"].to_f
    percentage = (100 - data["percent_change"].to_f)/100
    previous = current * percentage

    { :current => current, :previous => previous}
  end

end

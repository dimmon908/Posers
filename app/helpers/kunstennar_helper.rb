# encoding: utf-8

module KunstennarHelper
  # Returns shipping price according to option (verzendmethode)
  # chosen when registering artwork
  #
  def shipping_info(option)
    prices = { 0 => "5,80", 1 => "13,80", 2 => "13,80" }
    price = "€ #{prices[option]}"

    if option == 3
      price = "nader te bepalen"
    end

    "verzendkosten #{price}"
  end

  # Rent price should be 7% of sale price with no decimals
  # 3.78 returns 4 and 3.3 returns 3
  #
  def rent_price(price)
    format("%.0f", (price * 7.0) / 100)
  end
end

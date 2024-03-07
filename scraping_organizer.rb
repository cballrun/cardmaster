require "selenium-webdriver"
require "interactor"
require_relative "get_latest_sales"
require_relative "get_listings"



class ScrapingOrganizer
    include Interactor::Organizer

    organize GetLatestSales, GetListings
end
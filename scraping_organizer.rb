require "selenium-webdriver"
require "interactor"
require_relative "get_latest_sales"



class ScrapingOrganizer
    include Interactor::Organizer

    organize GetLatestSales
end
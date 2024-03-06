require "selenium-webdriver"
require "interactor"
require_relative "scraping_organizer"
require "pry"

class ScraperMain
    
    # options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument("--headless")
    
    def initialize
        @options = Selenium::WebDriver::Chrome::Options.new
                    # @options.add_argument("--headless")
        @driver = Selenium::WebDriver.for :chrome, options: @options
        @card_link = "https://www.tcgplayer.com/product/107055/pokemon-base-set-shadowless-pikachu?xid=pi6d47a20b-0ff5-4b4b-9d2d-bfeb8a79516a&page=1&Language=English"
        @driver.get @card_link
        @wait = Selenium::WebDriver::Wait.new(timeout: 10)
    end

    def scrape
        ScrapingOrganizer.call(
            driver: @driver,
            wait: @wait,
            card_link: @card_link
        )
        @driver.quit
    end
end

ScraperMain.new.scrape
require "selenium-webdriver"
require "interactor"
require_relative "scraping_organizer"
require "pry"

class ScraperMain
    
    def initialize
        @options = Selenium::WebDriver::Chrome::Options.new
                    # @options.add_argument("--headless")
        @driver = Selenium::WebDriver.for :chrome, options: @options
        @card_link = "https://www.tcgplayer.com/product/86395/pokemon-legendary-collection-kabutops?xid=pi6f3b55c2-b680-4d36-88ad-384d51486e1f&page=1&Language=English"
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
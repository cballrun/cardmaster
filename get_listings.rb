require "selenium-webdriver"
require "interactor"

class GetListings
include Interactor
    CardListing = Struct.new(:condition, :price, :seller, keyword_init: true)


    def call
        sleep 2
        create_listings(context.driver, context.wait)
    end

    private 

    def find_listings(driver, wait)
        listings_section = wait.until do
            driver.find_elements(:css, "section.listing-item.product-details__listings-results")
        end
    end

    def create_listings(driver, wait)
        all_listings = []
        listings = find_listings(driver, wait)
        listings.each do |listing|
            condition = listing.find_element(:css, "h3").text
            price = listing.find_element(:css, "div.listing-item__price").text
            seller = listing.find_element(:css, "a.seller-info__name").text

            card_listing = CardListing.new(condition: condition, price: price, seller: seller)
            all_listings << card_listing
        end
        all_listings
    end
end
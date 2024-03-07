require "selenium-webdriver"
require "interactor"

class GetListings
include Interactor
    CardListing = Struct.new(:condition, :price, :seller, keyword_init: true)

    def call
        CSV.open("listings.csv", "wb", write_headers: true, headers: ["condition", "price", "seller"]) do |csv|
            while next_page_button_visible?(context.wait, context.driver) do
                create_listings(context.driver, context.wait, csv)
                next_page_link(context.driver)
                next_page_button(context.driver)
            end
        end
    end

    private 

    def find_listings(driver, wait)
        listings_section = wait.until do
            driver.find_elements(:css, "section.listing-item.product-details__listings-results")
        end
    end

    def create_listings(driver, wait, csv)
        listings = find_listings(driver, wait)
        listings.each do |listing|
            condition = listing.find_element(:css, "h3").text
            price = listing.find_element(:css, "div.listing-item__price").text
            seller = listing.find_element(:css, "a.seller-info__name").text

            card_listing = CardListing.new(condition: condition, price: price, seller: seller)
            csv << card_listing
        end
    end

    def next_page_link(driver)
        pagination_buttons = driver.find_elements(:css, "a.tcg-button.tcg-button--md.tcg-standard-button.tcg-standard-button--flat")
        next_page_link = pagination_buttons.last.attribute("href")
        if next_page_link.class == String
            driver.get next_page_link
        else
            driver.quit
        end
    end

    def next_page_button(driver)
        next_button = driver.find_elements(:css, "a.tcg-button.tcg-button--md.tcg-standard-button.tcg-standard-button--flat").last
    end

    def next_page_button_visible?(wait, driver)
        sleep 2
        wait.until { next_page_button(driver).displayed? }
    end
end
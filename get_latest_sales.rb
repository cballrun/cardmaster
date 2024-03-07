require "selenium-webdriver"
require "interactor"
require "csv"

class GetLatestSales
include Interactor
    CardSale = Struct.new(:date, :condition, :quantity, :price, keyword_init: true)


    def call
        CSV.open("sales.csv", "wb", write_headers: true, headers: ["date", "condition", "quantity", "price"]) do |csv|
            click_view_more_data_button(context.driver, context.wait)
            while load_more_sales_button_visible?(context.wait, context.driver) do
                click_load_more_sales_button(context.driver, context.wait)
            end
            create_sales(context.driver, context.wait, csv)
        end
    end

    private

    def click_view_more_data_button(driver, wait)
        view_more_data_button = wait.until do
            driver.find_element(:css, "div.modal__activator")
        end
        view_more_data_button.click
    end

    def load_more_sales_button(driver)
        load_more_sales_button = driver.find_element(:css, "button.sales-history-snapshot__load-more")
    end

    def load_more_sales_button_visible?(wait, driver)
        sleep 2
        wait.until { load_more_sales_button(driver).displayed? }
    rescue Selenium::WebDriver::Error::TimeoutError #THIS IS BAD CODE I NEED TO FIX IT
        false
    end

    def click_load_more_sales_button(driver, wait)
        load_more_sales_button = wait.until do
            driver.find_element(:css, "button.sales-history-snapshot__load-more")
        end
        sleep 2
        load_more_sales_button.click
    end

    def create_sales(driver, wait, csv)
        all_card_sales = []
        sales_list = wait.until do
            driver.find_element(:css, "ul.is-modal")
        end
        all_sales = sales_list.find_elements(:css, "li")
        all_sales.each do |sale|
            date = sale.find_element(:css, "span.date")&.text
            condition = sale.find_element(:css, "span.condition")&.text
            quantity = sale.find_element(:css, "span.quantity")&.text
            price = sale.find_element(:css, "span.price")&.text

            card_sale = CardSale.new(date: date, condition: condition, quantity: quantity, price: price)
            csv << card_sale.to_a
        end
    end
end
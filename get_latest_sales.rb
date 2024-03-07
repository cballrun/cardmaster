require "selenium-webdriver"
require "interactor"
require "csv"

class GetLatestSales
include Interactor
    CardSale = Struct.new(:date, :condition, :quantity, :price, keyword_init: true)


    def call
        CSV.open("sales.csv", "wb", write_headers: true, headers: ["date", "condition", "quantity", "price"]) do |csv|
            click_view_more_data_button(context.driver, context.wait)
            four_times_click_load_more_sales_button(context.driver, context.wait)
            create_sales(context.driver, context.wait, csv)
        end
    end

    private

    def click_view_more_data_button(driver, wait)
        view_more_data_button = context.wait.until do
            context.driver.find_element(:css, "div.modal__activator")
        end
        view_more_data_button.click
    end

    def four_times_click_load_more_sales_button(driver, wait)
        load_more_sales_button = context.wait.until do
            context.driver.find_element(:css, "button.sales-history-snapshot__load-more")
        end
        sleep 2
        load_more_sales_button.click

        load_more_sales_button_2 = context.wait.until do
            context.driver.find_element(:css, "button.sales-history-snapshot__load-more")
        end
        sleep 2
        load_more_sales_button_2.click

        load_more_sales_button_3 = context.wait.until do
            context.driver.find_element(:css, "button.sales-history-snapshot__load-more")
        end
        sleep 2
        load_more_sales_button_3.click

        load_more_sales_button_4 = context.wait.until do
            context.driver.find_element(:css, "button.sales-history-snapshot__load-more")
        end
        sleep 2
        load_more_sales_button_4.click
    end

    def create_sales(driver, wait, csv)
        all_card_sales = []
        sales_list = context.wait.until do
            context.driver.find_element(:css, "ul.is-modal")
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
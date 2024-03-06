require "selenium-webdriver"
require "interactor"

class GetLatestSales
include Interactor

    def call
        click_view_more_data_button(context.driver, context.wait)
        three_times_click_load_more_sales_button(context.driver, context.wait)

    end

    private

    def click_view_more_data_button(driver, wait)
        view_more_data_button = context.wait.until do
            context.driver.find_element(:css, "div.modal__activator")
        end
        view_more_data_button.click
    end

    def three_times_click_load_more_sales_button(driver, wait)
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
    end
end
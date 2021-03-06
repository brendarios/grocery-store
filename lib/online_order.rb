require 'csv'
require 'awesome_print'
require_relative 'order.rb'
require_relative 'customer.rb'

FILE_NAME2 = 'support/online_orders.csv'

module Grocery

  # All possible status for fuillfillment as values for a constant.
  STATUS_1 = :pending
  STATUS_2 = :paid
  STATUS_3 = :processing
  STATUS_4 = :shipped
  STATUS_5 = :complete
  
  class Online_Orders < Grocery::Order

    attr_reader :id, :products, :customer_id, :fullfillment_status

    # Set pending as the default fullfillment_status
    # and set the variable fullfillment_status into a symbol type
    def initialize(id, products, customer_id, fullfillment_status = STATUS_1)
      @id = id
      @products = products
      @customer_id = customer_id
      @fullfillment_status = fullfillment_status.to_sym
    end


    def total
      if @products.count == 0
        return 0
      else
        super()
        shipping_fee = 10
        new_total = super() + shipping_fee
        return new_total
      end
    end


    def add_product(product_name, product_price)
      if @fullfillment_status == STATUS_1 || @fullfillment_status == STATUS_2
        @products[product_name] = product_price
        return true
      end
      return nil
    end

    def self.all
      all_online_orders = []
      CSV.open(FILE_NAME2, 'r').each do |online_order|
        id = online_order[0].to_i
        customer_id = online_order[-2].to_i
        fullfillment_status = online_order[-1].to_sym
        products = {}
        produce = online_order[1].split(";")
        produce.each do |items|
          pair = items.split(":")
          keys = pair[0]
          value = pair[1].to_f
          products[keys] = value
        end
        new_online_order = Online_Orders.new(id, products, customer_id, fullfillment_status)
        all_online_orders << new_online_order
      end
      return all_online_orders
    end


    def self.find(id)
      array_ids = []
      all_online_orders = Grocery::Online_Orders.all
      all_online_orders.each do |arr|
        array_ids << arr.id
        if array_ids.include? id
          return Online_Orders.new(arr.id, arr.products, arr.customer_id, arr.fullfillment_status)
        end
      end
      return NIL
    end

    # Here I used the self.allf from Customers to know the customers that exists.
    # and then be able to test if the customer does not exist return NIL.
    def self.find_by_customer(customer_id)
      if customer_id == 0 || customer_id > Grocery::Customers.all.length
        return NIL
      end
      all_online_orders = Grocery::Online_Orders.all
      array_orders_per_customer = []
      all_online_orders.each do |customer_order|
        if customer_order.customer_id == customer_id
          array_orders_per_customer << customer_order
        end
      end
      return array_orders_per_customer
    end
  end
end

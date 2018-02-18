require 'csv'
require 'awesome_print'
require_relative 'order.rb'

FILE_NAME2 = 'support/online_orders.csv'

module Grocery

  class Online_Orders < Order
    attr_reader :id, :products, :customer_id, :fullfillment_status

    # all possible status

    # set pending as the default fullfillment_status and set the variable into a symbol type
    def initialize (id, products, customer_id, fullfillment_status = :pending )
      @id = id
      @products = products
      @customer_id = customer_id
      @fullfillment_status = fullfillment_status
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

    fullfillment_status = [:pending, :paid, :processing, :shipped, :complete]

    def add_product(product_name, product_price)
      if fullfillment_status == :pending || fullfillment_status == :paid
        @products[product_name] = product_price
        return true
      else
        return nil
      end
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

    #     def self.find_by_customer(customer_id)
    # # # # returns a list of OnlineOrder instances where the value of
    # the customer's ID matches the passed parameter.

  end #class
end #module
require "rubyXL"
require "pg"

require_relative "outils_postgresql.rb"

require_relative "order.rb"
require_relative "package.rb"
require_relative "item.rb"


connexion_bd = OutilsPostgreSQL.open_connexion("due", "due", "due_mdp")

workbook = RubyXL::Parser.parse("Orders.xlsx")

orders = []

workbook.worksheets.each do |worksheet|
  order_id = worksheet.sheet_name.sub("Order ", "").to_i
  orders << Order.new(order_id, worksheet.sheet_name)
  orders[-1].insert_in_database(connexion_bd)

  current_package = -1
  current_item = -1

  package = nil
  item = nil

  worksheet.each_with_index do |row, index|
    next if index == 0 # Ignore l'en-tête

    if current_package != row[0].value
      package = Package.new(orders[-1].get_orderid)
      package.insert_in_database(connexion_bd)
      current_package = row[0].value
    end

    if current_item != row[1].value
      item = Item.new(package.get_packageid)
      item.insert_in_database(connexion_bd)
      current_item = row[1].value
    end

    item.update_attributes(connexion_bd, row[2].value, row[3].value)

  end
end

OutilsPostgreSQL.close_connexion(connexion_bd)

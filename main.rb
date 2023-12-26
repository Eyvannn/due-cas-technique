require 'rubyXL'
require 'pg'

require_relative "outils_postgresql.rb"
require_relative "orders.rb"


connexion_bd = OutilsPostgreSQL.open_connexion("due", "due", "due_mdp")

workbook = RubyXL::Parser.parse("Orders.xlsx")

workbook.worksheets.each do |worksheet|
  puts worksheet.sheet_name
  order_id = worksheet.sheet_name.sub("Order ", "").to_i
  connexion_bd.exec_params("INSERT INTO orders (orderid, ordername) VALUES ($1, $2)", [order_id, worksheet.sheet_name])


  current_package = -1
  current_item = -1

  package_id = 0
  item_id = 0

  worksheet.each_with_index do |row, index|
    next if index == 0 # Ignore l'en-tête

    if current_package != row[0].value
      package_id = OutilsPostgreSQL.exec_simple_requete(connexion_bd, "SELECT MAX(packageid) FROM packages;").getvalue(0, 0)
      if package_id == nil
        package_id = 1
      else
        package_id = package_id.to_i + 1
      end

      connexion_bd.exec_params('INSERT INTO packages (packageid, orderid) VALUES ($1, $2)', [package_id, order_id])

      current_package = row[0].value
    end

    if current_item != row[1].value
      item_id = OutilsPostgreSQL.exec_simple_requete(connexion_bd, "SELECT MAX(itemid) FROM items;").getvalue(0, 0)
      if item_id == nil
        item_id = 1
      else
        item_id = item_id.to_i + 1
      end

      connexion_bd.exec_params('INSERT INTO items (itemid, packageid) VALUES ($1, $2)', [item_id, package_id])

      current_item = row[1].value
    end

    #connexion_bd.exec_params('INSERT INTO items (orderid, ordername) VALUES ($1, $2)', [col1, col2])
  end
end



#resultat = OutilsPostgreSQL.exec_simple_requete(connexion_bd, "SELECT * FROM orders;")



OutilsPostgreSQL.close_connexion(connexion_bd)

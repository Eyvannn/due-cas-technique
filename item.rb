
class Item
  
  @@cpt_items = 0

  def initialize(packageid)
    @@cpt_items += 1

    @itemid = @@cpt_items
    @name = nil
    @price = nil
    @ref = nil
    @packageid = packageid
    @warranty = nil
    @duration = nil
  end
  
  def insert_in_database(connexion_bd)
    #connexion_bd.exec_params('INSERT INTO items (itemid, packageid) VALUES ($1, $2)', [@itemid, @packageid]) # si warranty doit être par défaut null
    connexion_bd.exec_params('INSERT INTO items (itemid, packageid, warranty) VALUES ($1, $2, false)', [@itemid, @packageid]) # si warranty doit être par défaut false
  end

  def update_attributes(connexion_bd, attribut, valeur)
    case attribut
    when "name"
      connexion_bd.exec_params("UPDATE items SET name=$1 WHERE itemid=$2;", [valeur, @itemid])
    when "price"
      connexion_bd.exec_params("UPDATE items SET price=$1 WHERE itemid=$2;", [valeur, @itemid])
    when "ref"
      connexion_bd.exec_params("UPDATE items SET ref=$1 WHERE itemid=$2;", [valeur, @itemid])
    when "warranty"
      if valeur.downcase == "yes"
        connexion_bd.exec_params("UPDATE items SET warranty=true WHERE itemid=$1;", [@itemid])
      elsif valeur.downcase == "no" || valeur.length == 0
        connexion_bd.exec_params("UPDATE items SET warranty=false WHERE itemid=$1;", [@itemid])
      end
    when "duration"
      connexion_bd.exec_params("UPDATE items SET duration=$1 WHERE itemid=$2;", [valeur, @itemid])
    end
  end
  
end

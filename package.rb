
class Package

  @@cpt_package = 0

  def initialize(orderid)
    @@cpt_package += 1

    @packageid = @@cpt_package
    @orderid = orderid
  end

  def get_packageid
    @packageid
  end

  def insert_in_database(connexion_bd)
    connexion_bd.exec_params("INSERT INTO packages (packageid, orderid) VALUES ($1, $2)", [@packageid, @orderid])
  end



end

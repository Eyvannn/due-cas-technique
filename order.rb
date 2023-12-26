
class Order

  def initialize(orderid, ordername)
    @orderid = orderid
    @ordername = ordername
  end

  def get_orderid
    @orderid
  end

  def insert_in_database(connexion_bd)
    connexion_bd.exec_params("INSERT INTO orders (orderid, ordername) VALUES ($1, $2);", [@orderid, @ordername])
  end

end

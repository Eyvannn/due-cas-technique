require "pg"

class OutilsPostgreSQL

  def self.open_connexion(database_name, username, password, server = "localhost", port = 5432)
    begin
      connexion = PG.connect(dbname: database_name, port: port, user: username, password: password, host: server)
      puts "Connexion à la base de donnée #{database_name} réussie"
      return connexion
    rescue => e
      puts "Erreur : Impossible de se connecter à la base de données : #{database_name}"
      puts "Message d'erreur : #{e.message}"
      exit(1)
    end
  end

  def self.close_connexion(connexion)
    begin
      connexion.close
      puts "Connexion à la base de donnée fermée"
    rescue => e
      puts "Erreur : Impossible de fermer la connexion"
      puts "Message d'erreur : #{e.message}"
      exit(1)
    end
  end

end

#This is our ORM Object relational mapping

require "sqlite3"
require "singleton" #makes sure we only ever have one copy of db class.

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super("plays.db")
    self.type_translation = true #Get out same datatype we put in
    self.results_as_hash = true #Get return in hash form
  end
end

class Play
  attr_accessor :title, :year, :playwright_id

  def self.all #SHow every entry in database
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum) }
  end

  def self.find_by_title(title) # Returns the instance of Play based on title.
    data = PlayDBConnection.instance.execute(<<-SQL, title)
      SELECT *
      FROM plays
      WHERE title=?
    SQL
    raise "title: '#{title}' not in database" unless data[0]
    Play.new(data[0])
  end

  def self.find_by_playwright(name) # return all plays written by playwright
    data = PlayDBConnection.instance.execute(<<-SQL, name)
      SELECT *
      FROM playwrights
      WHERE name=?
    SQL
    raise "title: '#{name}' not in database" unless data[0]
    data.map { |datum| Playwright.new(datum) }
  end

  def initialize(options) # create new instance of play class
    @id = options["id"] #weill either ve defined if ffrom self.all,
    #or null if person creates without relation
    @title = options["title"]
    @year = options["year"]
    @playwright_id = options["playwright_id"]
  end

  def create #save instance to db
    raise "#{self} already in database" if @id #raise error if in db
    #                                      heredoc V below
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
        INSERT INTO 
            plays (title, year, playwright_id)
        VALUES
            (?, ?, ?) --pulls in vals from declared variables up above, in same order
    SQL
    @id = PlayDBConnection.instance.last_insert_row_id
    #Why do we use these ? values instead of putting in @title, @year ect.
    #We would hope they put in right vlas, but if they DONT, then they
    #could put in a malicious attack like:
    # playwright_id = "3; DROP TABLE plays" <---SQL injections attack
    # that would drop our table

    #Therefore anytime we are inputting values not supplied by ourselves,
    # we must sanitise them, by using check marks.

  end

  def update #update istance in db
    raise "#{self} not in database" unless @id #raise error if not in db
    #use a heredoc to insert SQL into the ruby, note it will be SQL, and pass in the vriables listed.
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id, @id)
        --Update our plays db, question marks refernce vars in order or passing in. 
        UPDATE 
            plays
        SET
            --can see each one being updates with sanitized values
            title = ?, year = ?, playwright_id = ?
        WHERE
            id = ?
    SQL
  end
end

class Playwright
  attr_accessor :name, :birth_year

  def self.all #Show every entry in database from playwright table
    data = PlayDBConnection.instance.execute("SELECT * FROM playwrights")
    data.map { |datum| Playwright.new(datum) }
  end

  def self.find_by_name(name) # return playwright based on name
    data = PlayDBConnection.instance.execute(<<-SQL, name)
      SELECT *
      FROM playwrights
      WHERE name=?
    SQL
    raise "name: '#{name}' not in database" unless data[0]
    Playwright.new(data[0])
  end

  def initialize(options) # create new instance of playwright class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @name = options["name"]
    @birth_year = options["birth_year"]
  end

  def create #save instance to db
    raise "#{self} already in database" if @id #raise error if in db
    #                                      heredoc V below
    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year)
        INSERT INTO 
            playwrights (name, birth_year)
        VALUES
            (?, ?) --pulls in vals from declared variables up above, in same order
    SQL
    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update #update istance in db
    raise "#{self} not in database" unless @id #raise error if not in db
    #use a heredoc to insert SQL into the ruby, note it will be SQL, and pass in the vriables listed.
    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year, @id)
        --Update our plays db, question marks refernce vars in order or passing in. 
        UPDATE 
            playwrights
        SET
            --can see each one being updates with sanitized values
            name = ?, birth_year = ?
        WHERE
            id = ?
    SQL
  end

  def get_plays
    data = PlayDBConnection.instance.execute(<<-SQL, @id)
    SELECT *
    FROM plays
    WHERE playwright_id=?
  SQL
    raise "'#{self.name}' has no Plays atrributed yet" unless data[0]
    data.map { |datum| Play.new(datum) }
  end
end

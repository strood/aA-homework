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

# This will be the ORM - Object Relational Mapping

require "sqlite3"
require "singleton" # Ensures only a single copy of db class ever created

class QuestionDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.type_translation = true #Get out same datatype as we submit
    self.results_as_hash = true # Get our output in hash form
  end
end

class User
  attr_accessor :fname, :lname

  def self.all #Show all entries from plays table
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT *
      FROM users
      WHERE id=?
    SQL
    raise "id: '#{id}' not in users database" unless data[0]
    User.new(data[0])
  end

  def self.find_by_name(fname, lname) #fname, lname are just strings, not hash input
    data = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname=? AND lname=?
    SQL
    raise "fname, lname : '#{fname}, #{lname}' not in users database" unless data[0]
    User.new(data[0])
  end

  def initialize(options) # create new instance of user class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end
end

class Question
  attr_accessor :title, :body, :author

  def self.all #Show all entries from plays table
    data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT *
      FROM questions
      WHERE id=?
    SQL
    raise "id: '#{id}' not in questions database" unless data[0]
    Question.new(data[0])
  end

  def self.find_by_author_id(author_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, author_id)
      SELECT *
      FROM questions
      WHERE author=?
    SQL
    raise "author_id: '#{author_id}' was not found in questions database" unless data[0]
    if data.length > 1
      data.map { |datum| Question.new(datum) }
    else
      Question.new(data[0])
    end
  end

  def initialize(options) # create new instance of question class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @title = options["title"]
    @body = options["body"]
    @author = options["author"]
  end

  def author
    @author
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end

class Question_Follow
  attr_accessor :question, :follower
  def self.all #Show all entries from plays table
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| Question_Follow.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT *
      FROM question_follows
      WHERE id=?
    SQL
    raise "id: '#{id}' not in question_follows database" unless data[0]
    Question_Follow.new(data[0])
  end

  def initialize(options) # create new instance of question_follow class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @question = options["question"]
    @follower = options["follower"]
  end
end

class Reply
  attr_accessor :subject, :parent, :author, :body

  def self.all #Show all entries from plays table
    data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT *
      FROM replies
      WHERE id=?
    SQL
    raise "id: '#{id}' not in replies database" unless data[0]
    Reply.new(data[0])
  end

  def self.find_by_user_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT *
      FROM replies
      WHERE author=?
    SQL
    raise "user_id: '#{id}' not in replies database" unless data[0]
    if data.length > 1
      data.map { |datum| Reply.new(datum) }
    else
      Reply.new(data[0])
    end
  end

  def self.find_by_question_id(question_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM replies
      WHERE subject=?
    SQL
    raise "question_id: '#{question_id}' not in replies database" unless data[0]
    if data.length > 1
      data.map { |datum| Reply.new(datum) }
    else
      Reply.new(data[0])
    end
  end

  def initialize(options) # create new instance of reply class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @subject = options["subject"]
    @parent = options["parent"]
    @author = options["author"]
    @body = options["body"]
  end

  def author
    @author
  end

  def question
    @subject
  end

  def parent_reply
    @parent
  end

  def child_replies
    data = QuestionDBConnection.instance.execute(<<-SQL, @id)
      SELECT * 
      FROM replies
      WHERE parent=?
    SQL
    raise "no child replies for reply_id: '#{@id}'in replies database" unless data[0]
    if data.length > 1
      data.map { |datum| Reply.new(datum) }
    else
      Reply.new(data[0])
    end
  end
end

class Question_Like
  attr_accessor :question, :liker
  def self.all #Show all entries from plays table
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| Question_Like.new(datum) }
  end

  def self.find_by_id(id)
    data = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT *
      FROM question_likes
      WHERE id=?
    SQL
    raise "id: '#{id}' not in question_likes database" unless data[0]
    Question_Like.new(data[0])
  end

  def initialize(options) # create new instance of reply class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @question = options["question"]
    @liker = options["liker"]
  end
end

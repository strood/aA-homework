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

  def save #save instance to db, default to update if already present in db.
    if @id #perform update if in db, will have id already if in db, else it wont by default
      QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE users
        SET fname=?, lname=?
        WHERE id=?
      SQL
    else
      QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO users (fname, lname)
        VALUES (?, ?)
      SQL
      @id = QuestionDBConnection.instance.last_insert_row_id
    end
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    Question_Follow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    Question_Like.liked_questions_for_user_id(@id)
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

  def self.most_followed(n)
    Question_Follow.most_followed_questions(n)
  end

  def self.most_liked(n)
    Question_Like.most_liked_questions(n)
  end

  def initialize(options) # create new instance of question class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @title = options["title"]
    @body = options["body"]
    @author = options["author"]
  end

  def save #save instance to db, default to update if already present in db.
    if @id #perform update if in db, will have id already if in db, else it wont by default
      QuestionDBConnection.instance.execute(<<-SQL, @title, @body, @author, @id)
        UPDATE questions
        SET title=?, body=?, author=?
        WHERE id=?
      SQL
    else
      QuestionDBConnection.instance.execute(<<-SQL, @title, @body, @author)
        INSERT INTO questions (title, body, author)
        VALUES (?, ?, ?)
      SQL
      @id = QuestionDBConnection.instance.last_insert_row_id
    end
  end

  def author
    @author
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Question_Follow.followers_for_question_id(@id)
  end

  def likers
    Question_Like.likers_for_question_id(@id)
  end

  def num_likes
    Question_Like.num_likes_for_question_id(@id)
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

  def self.followers_for_question_id(question_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT fname, lname, users.id
      FROM question_follows
      JOIN users
      ON users.id = question_follows.follower
      WHERE question_follows.question=?
    SQL
    raise "question_id: '#{question_id}' does not have any followers un users database" unless data[0]

    data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT questions.author, questions.body, questions.title, questions.id 
      FROM question_follows
      JOIN questions
      ON questions.id = question_follows.question
      WHERE question_follows.follower=?
    SQL
    raise "user_id: '#{user_id}' is not following any questions in the questions database" unless data[0]

    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(n)
    data = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT questions.id, questions.title, questions.body, questions.author 
      FROM question_follows
      JOIN questions 
      ON questions.id = question_follows.question 
      GROUP BY question 
      ORDER BY count(*) DESC
      LIMIT ?;
    SQL
    data.map { |datum| Question.new(datum) }
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

  def save #save instance to db, default to update if already present in db.
    if @id #perform update if in db, will have id already if in db, else it wont by default
      QuestionDBConnection.instance.execute(<<-SQL, @subject, @parent, @author, @body, @id)
        UPDATE replies
        SET subject=?, parent=?, author=?, body=?
        WHERE id=?
      SQL
    else
      QuestionDBConnection.instance.execute(<<-SQL, @subject, @parent, @author, @body)
        INSERT INTO replies (subject, parent, author, body)
        VALUES (?, ?, ?, ?)
      SQL
      @id = QuestionDBConnection.instance.last_insert_row_id
    end
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

  def self.likers_for_question_id(question_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT users.fname, users.lname, users.id
      FROM question_likes
      JOIN users
      ON question_likes.liker = users.id
      WHERE question_likes.question=?
    SQL
    raise "question_id: '#{question_id}' has no likers in users database" unless data[0]
    data.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT COUNT(*)
      FROM question_likes
      WHERE question=?
    SQL
    data[0]["COUNT(*)"]
  end

  def self.most_liked_questions(n)
    data = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT questions.id, questions.title, questions.body, questions.author 
      FROM question_likes
      JOIN questions
      ON questions.id = question_likes.question
      GROUP BY question
      ORDER BY count(*) DESC
      LIMIT ?
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT questions.id, questions.title, questions.body, questions.author
      FROM question_likes
      JOIN questions
      ON question_likes.question = questions.id
      WHERE question_likes.liker=?
    SQL
    raise "user_id: '#{user_id}' has no liked questions in questions database" unless data[0]
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options) # create new instance of reply class
    @id = options["id"] #will either be defined if from self.all,
    #or null if person creates without relation
    @question = options["question"]
    @liker = options["liker"]
  end
end

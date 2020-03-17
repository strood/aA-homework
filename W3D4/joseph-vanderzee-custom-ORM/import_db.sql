PRAGMA foreign_keys = ON;
-- Data Definition Language Section -seeing up db tables structure

-- statement makes sqlite3 actually respect the foreign key constraints
--  you've added in your CREATE TABLE statements. Whenever we have a foreign
--  key column in a table we want to make sure that the id we provide
--  actually references a record in the corresponding table. If you plan on
--  putting DROP TABLE statements at the top of your import_db.sql file you
--  need to make sure you're dropping the tables in the right order. If you
--  drop a table that is depended upon by a foreign key in another table,
--  you will get an error telling you you've violated the foreign key
--  constraint.

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);


CREATE TABLE questions (
    id  INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body VARCHAR(255) NOT NULL,
    author INTEGER NOT NULL,

    FOREIGN KEY (author) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question INTEGER NOT NULL, -- will be a question id
    follower INTEGER NOT NULL, -- will be a user id, following the post

    FOREIGN KEY (question) REFERENCES questions(id),
    FOREIGN KEY (follower) REFERENCES users(id) 
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    subject INTEGER NOT NULL, --the subject teh reply for, questions id
    parent INTEGER, -- The parent reply, first reply does not have parent
    author INTEGER NOT NULL, -- user id who wrote the reply
    body VARCHAR(255) NOT NULL, -- body or text of the reply

    FOREIGN KEY (parent) REFERENCES replies(id),
    FOREIGN KEY (subject) REFERENCES questions(id),
    FOREIGN KEY (author) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY, 
    question INTEGER NOT NULL, --question being liked
    liker INTEGER NOT NULL, --user liking qusiton

    FOREIGN KEY (question) REFERENCES questions(id), -- question being liked
    FOREIGN KEY (liker) REFERENCES users(id) --user who likes the question
);


-- SEEDING THE DATABASE BELOW, 

INSERT INTO 
    users(fname, lname)
VALUES
    ('Albert', 'Einstein'),
    ('Glen', 'Ross'),
    ('Gloria', 'Pickles'),
    ('Roberto', 'Juicestien'),
    ('Vana', 'Tolook'),
    ('Kara', 'Swisher'),
    ('Barry', 'Bigglesworth'),
    ('Donald', 'Trump'),
    ('Wanda', 'Clowen'),
    ('Sandra', 'Foggenstog');

INSERT INTO 
    questions(title, body, author)
VALUES
    ("First Question", "What color is the best jello, and how do i make it?", 5),
    ("My Question", "Are hamburgers real?", 4),
    ("Dumb Question", "What color is your refrigorator?", 7),
    ("Question", "Is the toast the most?", 1),
    ("Title For Question", "What time is it in Japan?", 3),
    ("Big Q", "Who let the dogs out?", 2),
    ("FQ", "If reddit a good website, or is twitter better?", 8),
    ("Hmm", "What is your moms name?", 9),
    ("MyQ", "What would be the best question?", 10),
    ("What?", "What is your favorite soup?", 3),
    ("Where?", "Where do you sleep at night?", 5),
    ("Why?", "Why would you say such a thing?", 7),
    ("How", "How could you do that to me?", 1);

INSERT INTO 
    replies(subject, parent, author, body) -- ADD IN BODIES!
VALUES
    (1, NULL, 3,"Im learning how to reply!"),
    (5, NULL, 7,"This is a junk question"),
    (7, NULL, 2,"Wish i had an answer"),
    (3, NULL, 5,"I wouldnt do it if i were you"),
    (3, NULL, 5,"Take it home"),
    (3, NULL, 5,"Wash your mittens"),
    (2, NULL, 1,"Couldnt be true"),
    (1, 1, 10,"FIRst REplY oH i Am the BEst"),
    (3, 4, 8,"this is a nice reply"),
    (10, NULL, 4,"You are making me angry"),
    (11, NULL, 6,"want to come for supper?"),
    (10, 8, 6,"that looks like good soup!"),
    (11, 9, 6,"i like ti!");

INSERT INTO
    question_likes(question, liker)
VALUES
    (1,5),
    (1,8),
    (4,8),
    (3,1),
    (7,10),
    (8,3),
    (10,2),
    (10,7);

INSERT INTO 
    question_follows(question, follower)
VALUES
    (12,1),
    (11,2),
    (10,3),
    (4,4),
    (12,5),
    (9,6),
    (8,7),
    (7,8),
    (1,10),
    (2,2),
    (3,4),
    (5,7);
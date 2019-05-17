class Student
  attr_accessor :id, :name, :grade

# create a new Student object given a row from the database
# This class method creates a new student object based on the information in the row.
  def self.new_from_db(row)
    new_student = new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]

    new_student
  end

  # retrieve all the rows from the "Students" database
  # remember each row should be a new instance of the Student class
  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      new_from_db(row)
    end
  end

  # This method should return an array of all the students in grade 9.
  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql,"9").map do |row|
      new_from_db row
    end
  end

  # This method should return an array of all the students below 12th grade.
  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < ?
    SQL

    DB[:conn].execute(sql,"12").map do |row|
      new_from_db row
    end
  end

  # This method should return an array of exactly X number of students.
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql, 10)[0, x]
  end

  #  This should return the first student that is in grade 10.
  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    ORDER BY id LIMIT 1
    SQL

    new_from_db DB[:conn].execute(sql,10)[0]
  end

  # This method should return an array of all students for grade X.
  def self.all_students_in_grade_X (x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql,x).map do |row|
      new_from_db row
    end
  end

  # Find the student in the database given a name
  # Return a new instance of the Student class
  # Take the result and create a new student instance using the .new_from_db method
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL

    DB[:conn].execute(sql,name).map do |row|
      new_from_db(row)
    end.first
  end

  # This is an instance method that saves the attributes describing a given student to the students table in our database
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  # This is a class method that creates the students table.
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  # This is a class method that drops the students table. 
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

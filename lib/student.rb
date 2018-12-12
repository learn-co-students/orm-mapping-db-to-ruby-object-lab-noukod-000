class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    s = self.new
    s.id, s.name, s.grade = row
    s
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
              SELECT * From students
    SQL
    # remember each row should be a new instance of the Student class
    DB[:conn].execute(sql).map do |row|
     self.new_from_db(row)
   end

  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
              SELECT * From students where name = ? Limit 1
    SQL
    # return a new instance of the Student class
    DB[:conn].execute(sql, name).map do |row|
     self.new_from_db(row)
   end.first
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
              SELECT * From students where grade = 9
    SQL
    DB[:conn].execute(sql).map do |row|
     self.new_from_db(row)
   end
  end

  def self.all_students_in_grade_X(grade)

      sql = <<-SQL
                SELECT * From students where grade = ?
      SQL
      DB[:conn].execute(sql, grade).map do |row|
       self.new_from_db(row)
     end
  end

  def self.students_below_12th_grade
      sql = <<-SQL
                SELECT * From students where grade < 12
      SQL
      DB[:conn].execute(sql).map do |row|
       self.new_from_db(row)
     end
  end

  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
              SELECT * From students where grade = 10 Limit ?
    SQL
    DB[:conn].execute(sql, limit).map do |row|
     self.new_from_db(row)
   end
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

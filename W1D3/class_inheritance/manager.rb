require_relative "employee.rb"

class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary, boss)
    super
    @employees = []
  end

  def bonus(multiplier)
    employees_salaries = 0
    self.employees.each { |employee| employees_salaries += employee.salary }
    bonus = employees_salaries * multiplier
  end
end

ned = Manager.new("Ned", "Founder", 1000000, nil)
darren = Manager.new("Darren", "Grunt", 78000, ned)
shawna = Employee.new("Shawna", "TA", 12000, darren)
david = Employee.new("David", "TA", 10000, darren)
#nik = Employee.new("Nik", "Grunt", 50000, man)
ned.employees << darren
ned.employees << shawna
ned.employees << david
darren.employees << shawna
darren.employees << david

p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000

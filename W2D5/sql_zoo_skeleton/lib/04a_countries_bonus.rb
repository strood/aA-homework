# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative "./sqlzoo.rb"

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT
    name
  FROM
    countries
  WHERE
    gdp > ALL (
      SELECT
        gdp
      FROM
        countries
      WHERE
        continent='Europe' AND gdp is not null
    )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT x.continent, x.name, x.area
  FROM countries AS x
  WHERE x.area = (
    SELECT MAX(y.area)
    FROM countries AS y
    WHERE x.continent = y.continent)
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    SELECT x.name, x.continent
    FROM countries AS x
    WHERE x.population/3 > ALL (
      SELECT y.population
      FROM countries AS y
      WHERE x.continent = y.continent 
      AND x.name != y.name)
  SQL
end

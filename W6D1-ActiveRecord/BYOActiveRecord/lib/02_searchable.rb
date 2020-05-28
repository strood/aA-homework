require_relative "db_connection"
require_relative "01_sql_object"

module Searchable
  def where(params)
    # search for our specific cat baes in params passed in as hash
    where_line = params.each_key.map { |key| "#{key} = ?" }.join(" AND ")

    db_return = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{where_line}
    SQL

    parse_all(db_return)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end

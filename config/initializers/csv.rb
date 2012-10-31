def unwrap_stream (stream)
  require 'csv'
  data = CSV.parse(stream)
  keys = data.shift.map {|i| i.to_s }
  values = data.map {|row| row.map {|cell| cell.to_s } }
  hash_table = values.map {|row| Hash[*keys.zip(row).flatten] }
  return hash_table
end

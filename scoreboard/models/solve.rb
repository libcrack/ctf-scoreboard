class Solve
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, Text
  property :team, Text
  property :challengeid, Integer
  property :points, Integer
end

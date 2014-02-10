class Challenge
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, Text
  property :body, Text
  property :link, Text
  property :category, Text
  property :points, Integer
  property :flag, Text
  property :visible, Boolean
end

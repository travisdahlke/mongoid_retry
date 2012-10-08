class Thing
  include Mongoid::Document
  include Mongoid::MongoidRetry

  field :name
  field :color
  field :shape

  index :name, unique: true
  index ([[:color, Mongo::ASCENDING], [:shape, Mongo::DESCENDING]]), unique: true
end
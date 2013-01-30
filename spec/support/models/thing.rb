class Thing
  include Mongoid::Document
  include Mongoid::MongoidRetry

  field :name
  field :color
  field :shape

  if Mongoid::VERSION < '3'
    index :name, unique: true
    index ([[:color, Mongo::ASCENDING], [:shape, Mongo::DESCENDING]]), unique: true
  else
    index({name: 1}, {unique: true})
    index({color: 1, shape: -1}, {unique: true})
  end
end
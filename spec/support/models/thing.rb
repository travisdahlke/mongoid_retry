class Thing
  include Mongoid::Document
  include Mongoid::MongoidRetry

  field :name
  field :color

  index :name, unique: true
end
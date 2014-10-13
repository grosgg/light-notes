class Category
  include Mongoid::Document

  field :title,                :type => String
  field :icon,                 :type => String
  field :color,                :type => String

  has_many :notes
  belongs_to :account

end
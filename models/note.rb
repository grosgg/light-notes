class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :body,  :type => String

  belongs_to :account
end

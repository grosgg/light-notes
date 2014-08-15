class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,                :type => String
  field :body,                 :type => String
  field :evernote_id,          :type => String
  field :keep_synchronized,    :type => Boolean, :default => false

  belongs_to :account

  def label
  	if self.created_at - 2.days.ago > 0
  		{ text: 'new', type: 'label-info' }
  	elsif self.updated_at - 2.days.ago > 0
  		{ text: 'updated', type: 'label-warning' }
  	end
  end

end

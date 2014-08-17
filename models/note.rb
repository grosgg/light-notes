class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,                :type => String
  field :body,                 :type => String
  field :evernote_id,          :type => String
  field :keep_synchronized,    :type => Boolean, :default => false
  field :share_id,             :type => String

  belongs_to :account

  def date_label
    if self.created_at - 2.days.ago > 0
      { text: 'new', type: 'label-primary' }
    elsif self.updated_at - 2.days.ago > 0
      { text: 'updated', type: 'label-default' }
    end
  end

  def share_label
  	if self.share_id
  		{ text: 'shared', type: 'label-warning' }
    end
  end

  def sync_label
    if self.keep_synchronized
      { text: 'synced', type: 'label-success' }
    end
  end
end

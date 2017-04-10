class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

  field :title,                :type => String
  field :body,                 :type => String
  field :evernote_id,          :type => String
  field :keep_synchronized,    :type => Boolean, :default => false
  field :share_id,             :type => String
  field :soft_deleted,         :type => Boolean, :default => false
  field :archived,             :type => Boolean, :default => false

  belongs_to :account
  belongs_to :category
  search_in :title

  def date_label
    if self.created_at + 2.days > DateTime.now
      { text: 'pencil', type: 'label-primary' }
    elsif self.updated_at + 2.days > DateTime.now
      { text: 'pencil', type: 'label-default' }
    end
  end

  def self.active(current_account)
    current_account.notes.ne(title: nil).where(soft_deleted: false, archived: false).map(&:id)
  end

  def self.archived(current_account)
    current_account.notes.where(soft_deleted: false, archived: true).map(&:id)
  end

  def self.just_deleted(current_account)
    current_account.notes.where(soft_deleted: true).gt(updated_at: 2.minutes.ago).map(&:id)
  end
end

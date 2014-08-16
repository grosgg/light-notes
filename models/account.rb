class Account
  include Mongoid::Document
  attr_accessor :password, :password_confirmation

  # Fields
  field :name,             :type => String
  field :surname,          :type => String
  field :email,            :type => String
  field :crypted_password, :type => String
  field :role,             :type => String
  field :evernote_token,   :type => String
  field :last_sync,        :type => Integer, :default => 0

  # Relations
  has_many :notes

  # Validations
  validates_presence_of     :email, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  ##
  # This method is for authentication purpose.
  #
  def self.authenticate(email, password)
    account = where(:email => /#{Regexp.escape(email)}/i).first if email.present?
    account && account.has_password?(password) ? account : nil
  end

  ##
  # This method is used by AuthenticationHelper.
  #
  def self.find_by_id(id)
    find(id) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def synchronize!
    client = EvernoteOAuth::Client.new(token: evernote_token, consumer_key:OAUTH_CONSUMER_KEY, consumer_secret:OAUTH_CONSUMER_SECRET, sandbox: SANDBOX)
    state = client.note_store.getSyncState()
    sync_count = 0
    notes_to_import = notes.nin(evernote_id: [nil, '']).in(title: [nil, ''])
    if state.updateCount > last_sync || notes_to_import.count > 0
      notes.nin(evernote_id: [nil, '']).where(keep_synchronized: true).each do |note|
        evernote = client.note_store.getNote(note.evernote_id, true, false, false, false)
        note.title = evernote.title
        note.created_at = Time.at(evernote.created/1000)
        note.updated_at = Time.at(evernote.updated/1000)
        note.body = ReverseMarkdown.convert(evernote.content, unknown_tags: :bypass, github_flavored: true)
        sync_count+=1 if note.save
      end
      state = client.note_store.getSyncState()
      self.last_sync = state.updateCount
      save
    end
    sync_count
  end

  private

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(self.password)
  end

  def password_required
    crypted_password.blank? || self.password.present?
  end


end

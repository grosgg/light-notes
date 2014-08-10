LightNotes::App.controllers :evernotes do
	before do
    if OAUTH_CONSUMER_KEY.empty? || OAUTH_CONSUMER_SECRET.empty?
      flash.now[:error] = pat('Evernote key and secret not found!')
      redirect url(:notes, :index)
    else
      begin
        define_client
      rescue => e # Evernote token is expired
        redirect url(:evernotes, :request_token)
      end
    end
  end

  get :index do
    if current_account.evernote_token
      notebooks = @client.note_store.listNotebooks
      @notebooks = notebooks.map do |nb|
        note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
        note_filter.notebookGuid = nb.guid
        result_spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
        result_spec.includeTitle = true
        {name: nb.name, notes: @client.note_store.findNotesMetadata(note_filter, 0, 100, result_spec).notes}
      end
    else
      redirect url(:evernotes, :request_token)
    end
    render :index
  end

  post :synchronize do
    if params[:evernotes]

      @success = []
      @fail = []

      params[:evernotes].map(&:first).each do |evernote_guid|
        evernote = @client.note_store.getNote(evernote_guid, true, false, false, false)
        note = Note.find_or_initialize_by(evernote_id: evernote.guid, account: current_account)
        if note.new_record? || note.updated_at < Time.at(evernote.updated/1000)
          note.title = evernote.title
          note.created_at = Time.at(evernote.created/1000)
          note.updated_at = Time.at(evernote.updated/1000)
          note.body = ReverseMarkdown.convert(evernote.content, unknown_tags: :bypass, github_flavored: true)
          (note.save ? @success : @fail) << note.title
        else
          @fail << note.title
        end
      end
      render :synchronize
    else
      flash.now[:error] = pat('Please select at least one note to synchronize')
      render :index
    end
  end

  # Delete client and remove user credentials from DB
  get :logout do
    @client = nil
    current_account.update_attributes(evernote_token: nil)
    redirect url(:evernotes, :index)
  end

  # Step 1: Get a request token
  get :request_token do
    begin
      session[:request_token] = @client.request_token(:oauth_callback => absolute_url(:evernotes, :callback))
      redirect url(:evernotes, :authorize)
    rescue => e
      flash.now[:error] = pat('Couldn\'t get a request token')
      render :index
    end
  end

  # Step 2: Send the user to the authorization page
  get :authorize do
    if session[:request_token]
      redirect session[:request_token].authorize_url
    else
      # You shouldn't be invoking this if you don't have a request token
      flash.now[:error] = pat('You don\'t have a request token')
      render :index
    end
  end

  # Step 3: Redirect him back to our app and save his token in DB
  get :callback do
    unless params['oauth_verifier'] || session['request_token']
      flash.now[:error] = pat('Content owner did not authorize the temporary credentials')
      render :index
    end
    begin
      access_token = session[:request_token].get_access_token(:oauth_verifier => params['oauth_verifier'])
      current_account.update_attributes(evernote_token: access_token.token)
      redirect url(:evernotes, :index)
    rescue => e
      flash.now[:error] = pat('Error extracting access token')
      render :index
    end
  end

end
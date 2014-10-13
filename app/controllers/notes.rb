LightNotes::App.controllers :notes do
  get :index, :map => '/*', :priority => :low do
    if params[:search] && !params[:search].empty?
      @notes = Note.in(id: current_account.active_notes + current_account.archived_notes).full_text_search(params[:search])
    elsif params[:category]
      @notes = Note.in(id: current_account.active_notes + current_account.archived_notes).where(category_id: params[:category])
    else
      @notes = Note.in(id: current_account.active_notes + current_account.just_deleted_notes).desc(:updated_at)
    end
    @categories = current_account.categories
    render 'notes/index'
  end

  get :show, :with => :id, :provides => [:html, :pdf] do
    unless @note = current_account.notes.where(_id: params[:id]).first
    	redirect url(:notes, :index)
    end
    renderer = Redcarpet::Render::Groscarpet.new(render_options = {})
    markdown = Redcarpet::Markdown.new(renderer, tables: true, strikethrough: true, superscript: true)
    @body = markdown.render(@note.body)
    @format = params[:format]

    case content_type
    when :pdf
      kit = PDFKit.new(render('notes/show', layout: false), :page_size => 'A4')
      kit.stylesheets << 'public/stylesheets/bootstrap.min.css'
      headers["Content-Disposition"] = "attachment;filename=#{@note.title} #{Time.now.to_s}.pdf"
      headers['Content-Description'] = 'File Transfer'
      headers['Content-Transfer-Encoding'] = 'binary'
      headers['Content-Type'] = 'application/pdf'
      headers['Expires'] = '0'
      headers['Pragma'] = 'public'
      headers['Cache-Control'] = 'private, max-age=0, must-revalidate'
      kit.to_pdf
    else
      render 'notes/show'
    end

  end

  get :new do
    @note = Note.new
    @categories = current_account.categories
    render 'notes/new'
  end

  post :create do
    @note = Note.new(params[:note])
    @note.account = current_account
    if @note.save
      flash[:success] = pat(:create_success, :model => 'Note')
      redirect url(:notes, :show, :id => @note.id)
    else
      flash.now[:error] = pat(:create_error, :model => 'note')
      render 'notes/new'
    end
  end

  get :edit, :with => :id do
    @note = Note.where(id: params[:id], account: current_account).first
    if @note
      @categories = current_account.categories
      render 'notes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @note = Note.where(id: params[:id], account: current_account).first
    if @note
      if @note.update_attributes(params[:note])
        flash[:success] = pat(:update_success, :model => 'Note', :id =>  "#{params[:id]}")
        redirect(url(:notes, :show, :id => @note.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'note')
        render 'notes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  get :duplicate, :with => :id do
    note = Note.where(id: params[:id], account: current_account).first
    if note
      @note = note.clone
      @note.assign_attributes(share_id: nil, evernote_id: nil, keep_synchronized: false, created_at: Time.now, updated_at: Time.now)

      if @note.save
        flash[:success] = pat(:create_success, :model => 'Note')
        redirect(url(:notes, :index))
      else
        flash.now[:error] = pat(:create_error, :model => 'note')
        render 'notes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  get :toggle_share, :with => :id do
    @note = Note.where(id: params[:id], account: current_account).first
    if @note
      if @note.share_id.blank?
        @note.update_attributes(share_id: SecureRandom.hex(5))
      else
        @note.update_attributes(share_id: nil)
      end
      flash[:success] = pat(:update_success, :model => 'Note', :id => "#{params[:id]}")
      redirect(url(:notes, :show, :id => @note.id))
    else
      flash[:warning] = pat(:update_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  get :toggle_archive, :with => :id do
    note = Note.where(id: params[:id], account: current_account).first
    if note
      note.update_attributes(archived: !note.archived)
      flash[:success] = pat(:update_success, :model => 'Note', :id => "#{params[:id]}")
      redirect(url(:notes, :index))
    else
      flash[:warning] = pat(:update_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  get :toggle_destroy, :with => :id do
    note = Note.where(id: params[:id], account: current_account).first
    if note
      note.update_attributes(soft_deleted: !note.soft_deleted)
      flash[:success] = pat(note.soft_deleted ? :delete_success : :update_success, :model => 'Note', :id =>  "#{params[:id]}")
      redirect(url(:notes, :index))
    else
      flash[:warning] = pat(:delete_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

end

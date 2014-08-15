LightNotes::App.controllers :notes do
  get :index, :map => '/*', :priority => :low do
    @notes = current_account.notes.ne(title: nil).desc(:updated_at)
    render 'notes/index'
  end

  get :show, :with => :id, :provides => [:html, :pdf] do
    unless @note = current_account.notes.where(_id: params[:id]).first
    	redirect url(:notes, :index)
    end
    renderer = Redcarpet::Render::HTML.new(render_options = {})
    markdown = Redcarpet::Markdown.new(renderer, tables: true, strikethrough: true)
    @body = markdown.render(@note.body)
    @format = params[:format]

    case content_type
    when :pdf
      kit = PDFKit.new(render('notes/show', layout: false), :page_size => 'Folio')
      kit.stylesheets << 'public/stylesheets/bootstrap.min.css'
      headers["Content-Disposition"] = "attachment;filename=#{@note.title} #{Time.now.to_s}.pdf"
      kit.to_pdf
    else
      render 'notes/show'
    end

  end

  get :new do
    @note = Note.new
    render 'notes/new'
  end

  post :create do
    @note = Note.new(params[:note])
    @note.account = current_account
    if @note.save
      flash[:success] = pat(:create_success, :model => 'Note')
      redirect url(:notes, :index)
    else
      flash.now[:error] = pat(:create_error, :model => 'note')
      render 'notes/new'
    end
  end

  get :edit, :with => :id do
    @note = Note.find(params[:id])
    if @note
      render 'notes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @note = Note.find(params[:id])
    if @note
      if @note.update_attributes(params[:note])
        flash[:success] = pat(:update_success, :model => 'Note', :id =>  "#{params[:id]}")
        redirect(url(:notes, :index))
      else
        flash.now[:error] = pat(:update_error, :model => 'note')
        render 'notes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'note', :id => "#{params[:id]}")
      halt 404
    end
  end

end

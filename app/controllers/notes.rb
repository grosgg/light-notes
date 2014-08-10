LightNotes::App.controllers :notes do
  get :index, :map => '/*', :priority => :low do
    @notes = current_account.notes.desc(:updated_at)
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
      kit = PDFKit.new(render('notes/show', layout: false), :page_size => 'Letter')
      headers["Content-Disposition"] = "attachment;filename=#{@note.title} #{Time.now.to_s}.pdf"
      kit.to_pdf
    else
      render 'notes/show'
    end

  end

end

LightNotes::App.controllers :shares do
  get :show, :with => :id do
    unless @note = Note.where(share_id: params[:id], soft_deleted: false).first
      halt 404
    end
    renderer = Redcarpet::Render::HTML.new(render_options = {})
    markdown = Redcarpet::Markdown.new(renderer, tables: true, strikethrough: true)
    @body = markdown.render(@note.body)

    render 'notes/show'
  end

end

LightNotes::App.controllers :notes do
  get :index, :map => '/*', :priority => :low do
    @notes = current_account.notes.desc(:updated_at)
    render 'notes/index'
  end

  get :show, :with => :id do
    unless @note = current_account.notes.where(_id: params[:id]).first
    	redirect url(:notes, :index)
    end
    renderer = Redcarpet::Render::HTML.new(render_options = {})
    markdown = Redcarpet::Markdown.new(renderer, tables: true, strikethrough: true)
    @body = markdown.render(@note.body)
    render 'notes/show'
  end

end

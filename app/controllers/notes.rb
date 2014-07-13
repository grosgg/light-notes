LightNotes::App.controllers :notes do

  get :index, :map => '/*', :priority => :low do
    @notes = current_account.notes
    render 'notes/index'
  end

  get :show, :with => :id do
    unless @note = current_account.notes.where(_id: params[:id]).first
    	redirect url(:notes, :index)
    end
    render 'notes/show'
  end

end

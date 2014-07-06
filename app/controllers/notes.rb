LightNotes::App.controllers :notes do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :index do
    @notes = Note.all
    render 'notes/index'
  end

  get :show, :with => :id do
  end

  get :new do

  end

  post :create do

  end

  get :edit, :with => :id do
  end

  put :update do

  end

  delete :destroy, :with => :id do
  end

end

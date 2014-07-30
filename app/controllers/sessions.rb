LightNotes::App.controllers :sessions do  
  get :new do
    render "/sessions/new", nil
  end

  post :create do
    puts 'caca'
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      redirect url(:notes, :index)
    else
      params[:email] = h(params[:email])
      render "/sessions/new", nil
    end
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end

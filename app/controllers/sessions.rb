LightNotes::App.controllers :sessions do
  get :new do
    render "/sessions/new", nil
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      account.update_attributes(last_login: Time.now)
      set_current_account(account)
      redirect url(:notes, :index)
    else
      params[:email] = h(params[:email])
      flash.now[:error] = pat('login.error')
      render "/sessions/new", nil
    end
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end

LightNotes::Admin.controllers :sessions do
  get :new do
    render :new, :layout => false
  end

  post :create do
    account = Account.authenticate(params[:email], params[:password])
    if account && account.role == 'admin'
      account.update_attributes(last_login: Time.now)
      set_current_account(account)
      redirect url(:notes, :index)
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
      set_current_account(account)
      redirect url(:notes, :index)
    else
      params[:email] = h(params[:email])
      flash.now[:error] = pat('login.error')
      render :new, :layout => false
    end
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end

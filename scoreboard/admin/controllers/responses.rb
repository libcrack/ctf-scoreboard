Scoreboard::Admin.controllers :responses do
  get :index do
    @title = "Responses"
    @responses = Response.all
    render 'responses/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'response')
    @response = Response.new
    render 'responses/new'
  end

  post :create do
    @response = Response.new(params[:response])
    if @response.save
      @title = pat(:create_title, :model => "response #{@response.id}")
      flash[:success] = pat(:create_success, :model => 'Response')
      params[:save_and_continue] ? redirect(url(:responses, :index)) : redirect(url(:responses, :edit, :id => @response.id))
    else
      @title = pat(:create_title, :model => 'response')
      flash.now[:error] = pat(:create_error, :model => 'response')
      render 'responses/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "response #{params[:id]}")
    @response = Response.get(params[:id])
    if @response
      render 'responses/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'response', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "response #{params[:id]}")
    @response = Response.get(params[:id])
    if @response
      if @response.update(params[:response])
        flash[:success] = pat(:update_success, :model => 'Response', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:responses, :index)) :
          redirect(url(:responses, :edit, :id => @response.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'response')
        render 'responses/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'response', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Responses"
    response = Response.get(params[:id])
    if response
      if response.destroy
        flash[:success] = pat(:delete_success, :model => 'Response', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'response')
      end
      redirect url(:responses, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'response', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Responses"
    unless params[:response_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'response')
      redirect(url(:responses, :index))
    end
    ids = params[:response_ids].split(',').map(&:strip)
    responses = Response.all(:id => ids)
    
    if responses.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Responses', :ids => "#{ids.to_sentence}")
    end
    redirect url(:responses, :index)
  end
end

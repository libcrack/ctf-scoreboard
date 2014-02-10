Scoreboard::Admin.controllers :challenges do
  get :index do
    @title = "Challenges"
    @challenges = Challenge.all
    render 'challenges/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'challenge')
    @challenge = Challenge.new
    render 'challenges/new'
  end

  post :create do
    @challenge = Challenge.new(params[:challenge])
    if @challenge.save
      @title = pat(:create_title, :model => "challenge #{@challenge.id}")
      flash[:success] = pat(:create_success, :model => 'Challenge')
      params[:save_and_continue] ? redirect(url(:challenges, :index)) : redirect(url(:challenges, :edit, :id => @challenge.id))
    else
      @title = pat(:create_title, :model => 'challenge')
      flash.now[:error] = pat(:create_error, :model => 'challenge')
      render 'challenges/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "challenge #{params[:id]}")
    @challenge = Challenge.get(params[:id])
    if @challenge
      render 'challenges/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'challenge', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "challenge #{params[:id]}")
    @challenge = Challenge.get(params[:id])
    if @challenge
      if @challenge.update(params[:challenge])
        flash[:success] = pat(:update_success, :model => 'Challenge', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:challenges, :index)) :
          redirect(url(:challenges, :edit, :id => @challenge.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'challenge')
        render 'challenges/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'challenge', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Challenges"
    challenge = Challenge.get(params[:id])
    if challenge
      if challenge.destroy
        flash[:success] = pat(:delete_success, :model => 'Challenge', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'challenge')
      end
      redirect url(:challenges, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'challenge', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Challenges"
    unless params[:challenge_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'challenge')
      redirect(url(:challenges, :index))
    end
    ids = params[:challenge_ids].split(',').map(&:strip)
    challenges = Challenge.all(:id => ids)
    
    if challenges.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Challenges', :ids => "#{ids.to_sentence}")
    end
    redirect url(:challenges, :index)
  end
end

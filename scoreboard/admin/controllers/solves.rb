Scoreboard::Admin.controllers :solves do
  get :index do
    @title = "Solves"
    @solves = Solve.all
    render 'solves/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'solve')
    @solve = Solve.new
    render 'solves/new'
  end

  post :create do
    @solve = Solve.new(params[:solve])
    if @solve.save
      @title = pat(:create_title, :model => "solve #{@solve.id}")
      flash[:success] = pat(:create_success, :model => 'Solve')
      params[:save_and_continue] ? redirect(url(:solves, :index)) : redirect(url(:solves, :edit, :id => @solve.id))
    else
      @title = pat(:create_title, :model => 'solve')
      flash.now[:error] = pat(:create_error, :model => 'solve')
      render 'solves/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "solve #{params[:id]}")
    @solve = Solve.get(params[:id])
    if @solve
      render 'solves/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'solve', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "solve #{params[:id]}")
    @solve = Solve.get(params[:id])
    if @solve
      if @solve.update(params[:solve])
        flash[:success] = pat(:update_success, :model => 'Solve', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:solves, :index)) :
          redirect(url(:solves, :edit, :id => @solve.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'solve')
        render 'solves/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'solve', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Solves"
    solve = Solve.get(params[:id])
    if solve
      if solve.destroy
        flash[:success] = pat(:delete_success, :model => 'Solve', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'solve')
      end
      redirect url(:solves, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'solve', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Solves"
    unless params[:solve_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'solve')
      redirect(url(:solves, :index))
    end
    ids = params[:solve_ids].split(',').map(&:strip)
    solves = Solve.all(:id => ids)
    
    if solves.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Solves', :ids => "#{ids.to_sentence}")
    end
    redirect url(:solves, :index)
  end
end

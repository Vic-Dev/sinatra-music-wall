# Homepage (Root path)
enable :sessions

helpers do
  def current_user
    if session.has_key?(:user_session)
      user = User.find_by_login_token(session[:user_session])
    else
      nil
    end
  end
end

def authenticate_user
  redirect '/users/login' unless current_user
end

get '/' do
  session[:user_session] ||= nil
  erb :index
end

get '/tracks' do
  authenticate_user
  @users = User.all
  @tracks = Track.all
  @votes = Vote.all
  erb :'tracks/index'
end

get '/tracks/form' do
  if session[:user_session]
    @users = User.all
    @track = Track.new
    erb :'tracks/form'
  else
    redirect '/users/login'
  end
end

get '/tracks/:id' do
  authenticate_user
  @users = User.all
  @track = Track.find params[:id]
  @reviews = Review.all
  @reviews_for_track = Review.where(track_id: params[:id]).order(updated_at: :desc)
  erb :'tracks/show'
end

post '/tracks' do
  @track = Track.new(
    author: params[:author],
    title: params[:title],
    URL: params[:URL],
    user_id: current_user.id
    )
  if @track.save
    redirect '/tracks'
  else
    erb :'tracks/form'
  end
end

get '/users' do
  @users = User.all
  erb :'users/index'
end

get '/users/signup' do
  @user = User.new
  erb :'users/signup'
end

post '/users/signup' do
  @user = User.new(
    name: params[:name],
    password: params[:password]
  )
  if @user.save
    redirect '/users/login'
  else
    "<h1>Sign up error</h1>"
  end
end

get '/users/login' do
  @users = User.all
  erb :'users/login'
end

post '/users/login' do
  @user = User.find_by_name(params[:name])
  if @user && @user.authenticate(params[:password])
    session[:user_session] = SecureRandom.hex
    @user.login_token = session[:user_session]

    @user.save
    redirect '/tracks'
  else
    erb :'users/login'
  end

end

get '/users/logout' do
  @users = User.all
  erb :'users/logout'
end

post '/users/logout' do
  session.clear
  erb :'users/login'
end

post '/votes/:id' do
  MAX_UPVOTE = 1
  MAX_DOWNVOTE = -1
  UPVOTE = 1
  EXIST = 1
  NOT_EXIST = 0
  vote_array = Vote.where("track_id = ? AND user_id = ?", params[:id], current_user.id)
  vote = vote_array[0]
  if vote_array.length == EXIST
    if params[:upvote] && vote.value < MAX_UPVOTE
      vote.value += UPVOTE
    elsif params[:downvote] && vote.value > MAX_DOWNVOTE
      vote.value -= UPVOTE
    end
  elsif vote_array.length == NOT_EXIST
    if params[:upvote]
      vote = Vote.new(
        track_id: params[:id],
        user_id: current_user.id,
        value: UPVOTE
        )
    elsif params[:downvote]
      vote = Vote.new(
        track_id: params[:id],
        user_id: current_user.id,
        value: DOWNVOTE
        )
    end
  end
  vote.save
  redirect '/tracks'
end
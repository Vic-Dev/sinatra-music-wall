# Homepage (Root path)
enable :sessions

def current_user
  if cookies.has_key? :remember_me
    user = User.find_by_remember_token(cookies[:remember_me])
    return user if user
  end

  if session.has_key?(:user_session)
    user = User.find_by_login_token(session[:user_session])
  else
    nil
  end
end

get '/' do
  session["user"] ||= nil
  erb :index
end

get '/tracks' do
  @users = User.all
  @tracks = Track.all
  @votes = Vote.all
  erb :'tracks/index'
end

get '/tracks/form' do
  if session["user"]
    @users = User.all
    @track = Track.new
    erb :'tracks/form'
  else
    redirect '/users/login'
  end
end

get '/tracks/:id' do
  @users = User.all
  @track = Track.find params[:id]
  erb :'tracks/show'
end

post '/tracks' do
  @track = Track.new(
    author: params[:author],
    title: params[:title],
    URL: params[:URL],
    user_id: session["user"].id
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
  if user = User.find_by(name: params[:name])
    user_password = user.password
    entered_password = params[:password]
    if user_password == entered_password
      session["user"] = user.id
      redirect '/tracks'
    end
  else
    "<h1>Login error</h1>"
  end
end

get '/users/logout' do
  @users = User.all
  erb :'users/logout'
end

post '/users/logout' do
  session["user"] = nil
  erb :'users/login'
end

post '/votes/:id' do
  MAX_UPVOTE = 1
  MAX_DOWNVOTE = -1
  UPVOTE = 1
  EXIST = 1
  NOT_EXIST = 0
  vote_array = Vote.where("track_id = ? AND user_id = ?", params[:id], session["user"])
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
        user_id: session["user"],
        value: upvote
        )
    elsif params[:downvote]
      vote = Vote.new(
        track_id: params[:id],
        user_id: session["user"],
        value: downvote
        )
    end
  end
  vote.save
  redirect '/tracks'
end
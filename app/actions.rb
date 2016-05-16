# Homepage (Root path)
enable :sessions

get '/' do
  session["user"] ||= nil
  erb :index
end

get '/tracks' do
  @tracks = Track.all
  erb :'tracks/index'
end

get '/tracks/form' do
  if session["user"]
    @track = Track.new
    erb :'tracks/form'
  else
    redirect '/users/login'
  end
end

get '/tracks/:id' do
  @track = Track.find params[:id]
  erb :'tracks/show'
end

post '/tracks' do
  @track = Track.new(
    author: params[:author],
    title: params[:title],
    URL: params[:URL],
    user_id: params[:user][:id]
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
  erb :'users/login'
end

post '/users/login' do
  user_password = User.find_by(name: params[:user][:name]).password
  entered_password = params[:user][:password]
  if user_password == entered_password
    session["user"] = params[:user][:name]
    redirect '/tracks'
  else
    "<h1>Login error</h1>"
  end
end

get '/users/logout' do
  erb :'users/logout'
end

post '/users/logout' do
  session["user"] = nil
  erb :'users/login'
end
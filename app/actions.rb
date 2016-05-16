# Homepage (Root path)
get '/' do
  erb :index
end

get '/tracks' do
  @tracks = Track.all
  erb :'tracks/index'
end

get '/tracks/form' do
  @track = Track.new
  erb :'tracks/form'
end

get '/tracks/:id' do
  @track = Track.find params[:id]
  erb :'tracks/show'
end

post '/tracks' do
  @track = Track.new(
    author: params[:author],
    title: params[:title],
    URL: params[:URL]
  )
  if @track.save
    redirect '/tracks'
  else
    erb :'tracks/form'
  end
end
Simpler.application.routes do
  get '/tests', 'tests#index'
  get '/tests/:id/:name', 'tests#show'
  post '/tests', 'tests#create'
end

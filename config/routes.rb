Ideasbulb::Application.routes.draw do
  devise_for :users
  root :to => "ideas#index"
  resources :topics
  resources :ideas do
    match 'tab',:on => :collection
    match 'tag',:on => :collection
    match 'promotion',:on => :collection
    put 'handle',:on => :member
    match 'search',:on => :collection
    match 'favoriate',:on => :member
    match 'unfavoriate',:on => :member
    resources :comments,:shallow => :true
    resources :solutions,:shallow => :true
  end
  resources :users do
    put 'authority',:on => :member
  end
  resources :preferences do
    get 'dashboard',:on => :collection
  end
  resources :votes
end

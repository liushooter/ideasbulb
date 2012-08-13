Ideasbulb::Application.routes.draw do
  devise_for :users
  root :to => "ideas#index"
  resources :topics
  resources :ideas do
    match 'tab',:on => :collection
    match 'promotion',:on => :collection
    put 'handle',:on => :member
    match 'search',:on => :collection
    match 'favoriate',:on => :member
    match 'unfavoriate',:on => :member
    match 'more_solutions',:on => :member
    match 'more_comments',:on => :member
    resources :comments,:shallow => :true
    resources :solutions,:shallow => :true do
      put 'pick',:on => :member
      put 'unpick',:on => :member
    end
  end
  resources :users do
    put 'authority',:on => :member
    get 'inbox',:on => :collection
  end
  resources :preferences do
    get 'dashboard',:on => :collection
    put 'update_basic',:on => :collection
  end
  resources :votes
  resources :messages
  resources :tags
end

Rails.application.routes.draw do
  root 'home#top'
  get 'home/about' =>'home#about'
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update,:create,:destroy,] do
  	member do
  		get :following, :followers

  	end
  end
  resources :books,only: [:index,:edit,:show,:update,:create,:destroy] do
  	resource :favorites, only:[:create, :destroy]
  	resource :book_comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy]

  get "search" => "users#search"
  
end

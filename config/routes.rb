class Authenticated
  def self.matches?(request)
    request.session[:user_id].present?
  end
end

Rails.application.routes.draw do

  scope "(:locale)" do
    get "/auth/auth0/callback" => "auth0#callback"
    get "/auth/failure" => "auth0#failure"

    get "login" => "sessions#new", as: :login
    get "invitations/:token" => "invitations#accept", as: :accept_invitation
    delete "logout" => "sessions#destroy", as: :logout
    get "add-item" => "welcome#add_items", as: :add_items

    # WELCOME
    root to: "welcome#dashboard", constraints: Authenticated
    root to: "welcome#landing"
    get '/pricing' => "welcome#pricing", as: :pricing
    get '/team' => "welcome#team", as: :team
    get '/contact-us' => "welcome#contact", as: :contact
    post '/contact' => "welcome#send_message", as: :send_message
    post '/subscribe' => "welcome#subscribe", as: :subscribe

    constraints(uuid: /\d{10}/) do
      get '/brands/:uuid/:title' => 'brands#show',  as: :slugged_brand
      get '/commodities/:uuid/:title' => 'commodities#show',  as: :slugged_commodity
      get '/packagings/:uuid/:title' => 'packagings#show',  as: :slugged_packaging
      get '/standards/:uuid/:title' => 'standards#show',  as: :slugged_standard
    end

    resources :commodities do
      collection do
        get :autocomplete
        get :prefetch
      end

      resources :barcodes
    end

    resources :packagings, only: [:index]

    resources :brands do
      collection do
        get :autocomplete
      end

      resources :standards
    end
    resources :searches
    resources :standards do
      get :autocomplete, on: :collection
    end

    resources :apps do
      resources :classifications do
        resources :levels
      end

      resources :invitations, only: [:new, :create]
      resources :commodity_references, path: "commodities" do
        resources :states, :specifications, :references, :images
        resources :links, except: [:index, :show]

        resources :packagings do
          resources :specifications, :barcodes
        end
      end
      resources :custom_units, path: "custom-units"
    end

    resources :hscode_chapters, :hscode_headings, :hscode_subheadings
    resources :unspsc_segments, :unspsc_families, :unspsc_classes, :unspsc_commodities
    resources :ownerships, path: "claims"
    resources :standardizations, :lists
    resources :uoms, only: [:index]
  end

  # API STUFF

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users
      resources :apps
      resources :commodities
    end
  end
end

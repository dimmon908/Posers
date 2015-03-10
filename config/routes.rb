Xposers::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions", 
                                       :confirmations => 'confirmations',
                                       :registrations => 'registrations' } do
    get "login", :to => "sessions#new"
    get 'loguit', :to => "sessions#destroy", :as => :logout
    get 'aanmelden', :to => "devise/registrations#new", :as => :register
    get 'gebruiker/wachtwoordkwijt', :to => "devise/passwords#new", :as => :wachtwoordkwijt
    get 'profiel/wachtwoord' => "devise/registrations#edit", :as => :wachtwoord
  end

  resources :abuses, :only => [:index] do
    get :destroy, :on => :member
  end

  scope :module => :forum do
    controller :topic do
      match 'forum/editmessage/:id' => :editmessage, :as => :forumeditmessage
      match 'forum/reportmessage/:id' => :reportmessage, :as => :forumreportmessage
      match 'forum/newtopic/:id' => :new, :as => :newtopic
      match 'forum/edittopic/:id' => :edit, :as => :edittopic
      match 'forum/deletetopic/:id' => :delete, :as => :deletetopic
      match 'forum/movetopic/:id' => :movetopic, :as => :movetopic
      match 'forum/viewreports/:id' => :viewreports, :as => :viewreports
      match 'forum/deletereport/:id' => :deletereport, :as => :deletereport
      match 'forum/topic/newmessage/:id/:cite' => :newmessage
      match 'forum/topic/newmessage/:id' => :newmessage, :as => :forum_newmessage
      match 'forum/topic/new/:id' => :new
      match 'forum/topic/:id/:page' => :index
      match 'forum/topic/:id' => :index, :as => :viewtopic
      match 'forum/topic/:id/:page' => :index, :as => :viewtopicpage

    end
    controller :activetopics do
      match 'forum/activetopics' => :index, :as => :activetopics
      match 'forum/mymessages' => :mymessages, :as => :myforummessages
      match 'forum/mytopics' => :mytopics, :as => :mytopics
    end
    controller :forum do
      match 'forum' => :index, :as => :viewforumindex
      match 'forum/:id' => :subforum, :as => :viewforum
      match 'forum/:id/:page' => :subforum, :as => :viewforumpage
    end
    get 'messages/:id' => 'messages#destroy', :as => :message
  end

  scope :module => :admin do
    controller :home do
      match 'admin' => :index, :as => :admin
    end
    
    controller :users do
      match 'admin/users' => :index, :as => :users
      match 'admin/users/user/:id' => :user
      match 'admin/users/deleteuser/:id' => :deleteuser
      match 'admin/users/csv' => :csv
      match 'admin/users/roles' => :roles
      match 'admin/users/roles/:id' => :role
      match 'admin/users/deletepermission/:id' => :deletepermission
    end
    
    controller :kunst do
      match 'admin/kunst' => :index
      match 'admin/kunst/edittype/:id' => :edittype, :as => :admin_kunst_edittype
      match 'admin/kunst/deletetype/:id' => :deletetype
      match 'admin/kunst/show/:id' => :show
      match 'admin/kunst/createcontainer/:id' => :createcontainer
      match 'admin/kunst/editcontainer/:id' => :editcontainer
      match 'admin/kunst/deletecontainer/:id' => :deletecontainer
      match '/admin/kunst/createproperty/:id' => :createproperty
      match '/admin/kunst/editproperty/:id' => :editproperty
    end
    
    controller :pages do
      match 'admin/page/:id' => :show, :as => :page
    end
    
    controller :aankopen do
      match "admin/aankopen" => :index
      match "admin/aankopen/view/:id" => :view, :as => :aankoop
    end
    
    controller :prefabmail do
      match 'admin/prefabmail' => :index
      match 'admin/prefabmail/edit/:id' => :edit
      match 'admin/prefabmail/delete/:id' => :delete
      match 'admin/prefabmail/create' => :create
      match 'admin/prefabmail/intmails' => :intmails
      match 'admin/prefabmail/editintmail/:id' => :editintmail
    end
    
    controller :forums do
      match 'admin/forums' => :index
      match 'admin/forums/createparentcategory' => :createparentcategory
      match 'admin/forums/createcategory/:id' => :createcategory
      match 'admin/forums/editcategory/:id' => :editcategory
      match 'admin/forums/deletecategory/:id' => :deletecategory
      match 'admin/forums/editforum/:id' => :editforum
      match 'admin/forums/deleteforum/:id' => :deleteforum
      match 'admin/forums/forumpermissions/:id' => :forumpermissions
      match 'admin/forums/createpermission/:id' => :createpermission
      match 'admin/forums/permissions/:id' => :permissions
    end
    
    controller :mailer do
      match 'admin/mailer' => :index
      match 'admin/mailer/delete/:id' => :delete
      match 'admin/mailer/create' => :create
      match 'admin/mailer/deleteall' => :deleteall
    end
    
    controller :webimages do
      match 'admin/webimages' => :index
      match 'admin/webimages/delete/:id' => :delete
    end
    
  end
  
  namespace :admin do
    resources :news, :except => :show
    resources :pages
    resources :rents, only: [:index, :show, :update] do
      get 'mailing', on: :member
      post 'send_email', on: :member
    end
  end
  
  resources :gebruiker, only: [:upload] do
    post :upload, on: :collection
  end

  controller :gebruiker do
    match 'gebruikerprofiel/:id' => :n, :as => :viewprofile
    match 'profiel/avatar' => :avatar, :as => :avatar
    match 'gebruiker/uploadavatar' => :uploadavatar, :as => :uploadavatar
    match 'gebruiker/deleteavatar/:id' => :deleteavatar, :as => :deleteavatar
    match 'gebruiker/setdefaultavatar/:id' => :setdefaultavatar
    match 'profiel/mijnkunst' => :mijnkunst, :as => :mijnkunst
    match 'profiel' => :profiel, :as => :profile
  end

  match 'tellafriend/:id' => "tellafriend#index", :as => :tellafriend

  match 'pagina/:id' => "page#index", as: :pagina

  controller :interieur do
    match 'interieur/upload' => :upload
    match 'interieur'=> :index
    match 'interieur/verwijder/:id' => :verwijder
  end

  controller :kunstenaar do
    match 'kunstenaar/:name/:kunstid/:page' => :index, :as => :werkext
    match 'kunstenaar/:name/:kunstid' => :index, :as => :werk
    match 'kunstenaar/:name' => :show, :as => :kunstenaar
    match 'kunstenaars' => :kunstenaars, :as => :kmenu
    match 'kunstenaars/:page' => :kunstenaars, :as => :kunstenaars
  end

  resources :aankoop, except: [:index, :create, :new, :show, :update] do
    get :order, on: :member
    post :confirm, on: :member
    get :done, on: :member
  end

  resources :closeup, only: :destroy

  scope(:path_names => { new: "nieuw", edit: "wijzig" }) do
    resources :artworks, path: :kunstwerken, only: [:new, :create] do
      get 'verras_me', on: :collection

      resources :rents, path: :huren, only: [:new, :create]
    end
  end
  
  controller :kunst do
    get :misbruik
    post :misbruik

    match 'zoeken' => :search, :as => :search
    match 'zoekresultaten' => :results, :as => :searchresults
    match 'kunst/closeup/:id' => :closeup
    match 'kunst/bekijkwerk/:id' => :bekijkwerk
    match 'kunst/verwijder/:id' => :verwijder
    match 'kunst/wijzig/:id' => :wijzig
    match 'kunst/fav/:id' => :fav
    match 'kunst/app/:id' => :app
    match 'kunst/interieur/:id' => :interieur
    match 'kunst/interieur/:id/:int' => :interieur
    match 'kunst/verwijderreactie/:id' => :verwijderreactie, as: :verwijderreactie
    match 'kunst/wijzigreactie/:id' => :wijzigreactie, as: :wijzigreactie
  end

  resources :xpose, only: [:index, :update]

  controller :xpose do
    match 'xpose/nieuw' => :nieuw, as: :nieuw
    get 'xpose/omzetten' => :omzetten, as: :omzetten
    match 'xpose/plaatsafbeelding/:id' => :plaatsafbeelding, as: :plaatsafbeelding
  end

  controller :site do
    match 'contact' => :contact, :as => :contact
    match 'overxposers' => :overxposers, :as => :overxposers
    match 'disclaimer' => :disclaimer, :as => :disclaimer
  end

  root :to => "site#index"


  #404 error
  match '*path' => "application#rescue_404"

  match ':controller(/:action(/:id(.:format)))'
end

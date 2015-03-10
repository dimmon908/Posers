class Admin::UsersController < ApplicationController
  before_filter :require_admin
  layout 'admin'
  def index
    @title = 'Gebruikers'
    @users = User.paginate :page => params[:page], :include => 'role', :order => 'nickname ASC', :per_page => 300
  end

  def user
    if !params[:id]
      redirect_to :action => 'index'
    else
      @roles = Role.find(:all)
      @user = User.find(params[:id])
      @title = 'Gebruiker: ' + @user.nickname
    end
    if request.post? and params[:user]
      if @user.update_attributes(params[:user]) and @user.update_attribute('role_id', params[:user][:role_id]) and @user.update_attribute('activated', params[:user][:activated]) and @user.update_attribute('nickname', params[:user][:nickname])
        flash[:notice] = "User successfully updated"
      else
        flash[:notice] = "probs"
      end
    end
  end

  def deleteuser
    if params[:id]
      @user = User.find(params[:id])
      if request.post?
        @user.kunstvoorwerps.destroy_all
        @user.destroy
        redirect_to :action => 'index'
      end
    end
  end

  def roles
     @title = "Roles"
     @roles = Role.find(:all)
     @role = Role.new();
     if request.post? and params[:role]
       @role.name = params[:role][:name]
       @role.save
       flash[:notice] = "Role successfully created."
       redirect_to :action => 'roles'
     end
   end
   def csv
     data = "0, Gebruikersnaam, Voornaam, Achternaam, Rol, Email adres, Geboorteplaats, Geboortedatum, Adres, Woonplaats, Postcode, Land, Bankrekening, Telefoonnummers\n"
     @users = User.find(:all, :include => 'role')
     @users.each do |u|
       if !u.role.blank?
         rol = u.role.name
       else
         rol = 'geen'
       end
       data = data + "#{u.id}, #{u.nickname}, #{u.voornaam}, #{u.achternaam}, #{rol}, #{u.email}, #{u.profile_geboorteplaats}, #{u.profile_geboortedatum}, #{u.prive_adres}, #{u.prive_woonplaats}, #{u.prive_postcode}, #{u.prive_land}, #{u.prive_bankrek}, #{u.prive_telefoonnummer}\n"
     end
     send_data(data,:type => 'text/csv; charset=iso-8859-1; header=present',:filename => 'leden.csv', :disposition =>'attachment', :encoding => 'utf8')
   end
   def role
     if !params[:id]
       redirect_to :action => 'index'
       return nil
     end
     @role = Role.find(params[:id])
     if request.post? and params[:permission]
       @role.permissions.create(params[:permission])
       flash[:notice] = "Permission succesfully created"
     end
   end
   def deletepermission
     if request.post? 
       if params[:permission][:role_id]
         @role = Role.find_by_id(params[:permission][:role_id])
         @permission = @role.permissions.find(params[:permission][:id])
         @role.permissions.delete(@permission)
         redirect_to :action => 'role', :id => params[:permission][:role_id]
       else
         Permission.delete(params[:permission][:id])
         redirect_to :action => 'roles'
       end
     end

     if params[:role_id]
       @role_id = params[:role_id]
     else
       @role_id = nil
     end
   end
end

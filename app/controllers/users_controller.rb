class UsersController < ApplicationController
  
  before_filter :authenticate_user!,:except => [:applicant]
  inherit_resources

  def show
    @user = User.find params[:id]
    if @user.eql? current_user
      redirect_to invites_path
    end

  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params)

    if @user.save
      flash[:notice] = "User information successfully updated!"
      redirect_to profile_path
    else
      render action: edit
    end
    #update!(notice: 'User information successfully updated!') { redirect_to profile_path }
  end

  def show_profile
    @user = current_user
  end

  def show_applicant
    @user = User.find(params[:id])
    @graph = Koala::Facebook::GraphAPI.new(@user.access_token)
    
    #mutual friends (change this to reflect HR Groups username)
    @friends =  @graph.get_connections("me", "mutualfriends/"+current_user.username+"?fields=name,email,username,picture")
    #@friends =  @graph.get_connections("me", "mutualfriends/godstrikerharvey?fields=name,email,username,picture")
     
    @friends.each do |friend|
      unless @user.mutual_friends.collect(&:username).include? friend["username"]
        @user.mutual_friends.create!(email: friend["email"], name: friend["name"], username: friend["username"], picture: friend["picture"]["data"]["url"])
      end
    end
  end
  
  def invites
    @applicant = User.new
  end

  def invitation
      @user = User.where(:email => params[:email])
      if not_email_domain(params[:email])
        flash[:notice] = "Sorry, your invitation was not sent successfully."
        redirect_to '/invites'
      else
        if @user.any?
          flash[:notice] = "Sorry, your invitation was not sent successfully." 
          redirect_to '/invites'
        else
          @applicant = User.invite!(email: params[:email])
          @user = User.last
          @user.destroy
          current_user.invitation_count += 1
          current_user.save 
          flash[:notice] = "Congratulations, your invitation was successfuly sent.."
          redirect_to '/invites'
        end
      end
  end

  def not_email_domain(email_address)
    !(email_address =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i )
  end
end

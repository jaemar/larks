class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  def pull_facebook_data(user)
    @applicant = User.find(user.id)
    @graph = Koala::Facebook::GraphAPI.new(@applicant.access_token)

    @profile, @likes, @photos, @groups,@events =  @graph.batch do |batch_api|
      #personal details
      batch_api.get_object("me")


      #user likes
      batch_api.get_connections("me","likes?fields=category,link,name")

      #user posts
      batch_api.get_connections("me","photos?fields=source&limit=4")

      #user groups
      batch_api.get_connections("me","groups?fields=description,name,link,bookmark_order")

      #user events
      batch_api.get_connections("me","events")
    end


     @events.each do |event|
       user.events.create!(name: event["name"], place: event["location"], time: event["start_time"])
     end
       #user.friends.create!(name: "", email: "", username: "")
     @groups.each do |group|
       user.groups.create!(name: group["name"], description: group["description"], link: group["link"], bookmard_order: group["bookmark_order"])
     end

     @photos.each do |image|
       user.images.create!(link: image["source"])
     end 
    
     if @profile["hometown"] == nil
       user.informations.create!(address: "",birthday: @profile["birthday"], email: @profile["email"], gender: @profile["gender"], relationship_status: @profile["relationship_status"])
     else
       user.informations.create!(address: @profile["hometown"]["name"],birthday: @profile["birthday"], email: @profile["email"], gender: @profile["gender"], relationship_status: @profile["relationship_status"])
     end
     
     @likes.each do |like|
       user.likes.create!(category: like["category"], link: like["link"], name: like["name"])
     end
     
     @profile["work"].each do |work|
       if work["position"] == nil
         user.works.create!(name: work["employer"]["name"], position: "")
       else
         user.works.create!(name: work["employer"]["name"], position: work["position"]["name"])
       end
     end
  end
end

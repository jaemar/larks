class StartupsController < ApplicationController

  def info
    @startup = current_startup
  end

  def update
    @startup = Startup.find(params[:id])
    @startup.update_attributes(params[:startup])

    if @startup.save
      redirect_to thank_you_path
    else
      redirect_to info_startups_path
    end
  end
end

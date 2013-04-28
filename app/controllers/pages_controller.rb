class PagesController < ApplicationController
  def index
  end

  def features
  end

  def pricing

  end
  
  def about
  end

  def search
  end

  def filter
    @applicants = []
    User.applicants.each do |applicant|
      @applicants << applicant if applicant.full_name.downcase.include? params[:applicant].downcase
    end
    render 'search'
  end
end

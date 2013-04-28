module PagesHelper
  def active_page? (params = nil)
    if params.present?
      'active' if request.path.include? params
    else
      'active' if request.url.eql? root_url
    end
  end
end

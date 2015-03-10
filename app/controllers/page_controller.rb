class PageController < ApplicationController
  layout 'wide'
  def index
    if !params[:id]
      return hit_error(404)
    end
    @page = Page.find_by_id(params[:id])
    if !@page or @page.blank?
      return hit_error(404)
    end
  end
end

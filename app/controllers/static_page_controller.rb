class StaticPageController < ApplicationController

  def home
    authorize! :index, :staticpage

  end
end

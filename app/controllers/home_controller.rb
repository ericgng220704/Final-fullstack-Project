class HomeController < ApplicationController
  def index
    @about_page = Page.find_by(title: "About")
    @contact_page = Page.find_by(title: "Contact")
  end
end

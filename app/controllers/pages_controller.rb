class PagesController < ApplicationController
  def show
    @page = Page.find_by(title: params[:id])

    if @page.nil?
      render plain: "Page not found", status: :not_found
    end
  end

  def contact
    flash[:notice] = "Thank you for reaching out! We'll get back to you soon."
    redirect_to contact_path
  end
end

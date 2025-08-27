class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "authenticated"

  def index
    @calculations = current_user.calculations
                                .order(created_at: :desc)
                                .page(params[:page])
  end
end

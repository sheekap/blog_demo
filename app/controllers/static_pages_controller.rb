class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:profile]

  def profile
  end
end

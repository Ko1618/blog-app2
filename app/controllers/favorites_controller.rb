class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @article = current_user.favorite_articles
  end
end

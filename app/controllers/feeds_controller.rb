# frozen_string_literal: true

class FeedsController < ApplicationController
  before_action :authenticate_user!

  def index
    @feeds = current_user.feeds
    @new_feed = Feed.new
  end

  def new
    @new_feed = Feed.new
  end

  def create
    url = feed_params[:url]
    raise Feedjira::NoParserAvailable if url.blank?

    feed = Feeds::FeedBuilder.new.call(url)
    current_user.feeds << feed if feed.valid?
    flash[:success] = 'Feed created!'
    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid
    redirect_with_error 'You have this feed on your list already!'
  rescue Feedjira::NoParserAvailable
    redirect_with_error 'Invalid URL!'
  end

  private

  def redirect_with_error(error)
    flash[:error] = error
    redirect_to action: :new
  end

  def feed_params
    params.require(:feed).permit(:url)
  end
end

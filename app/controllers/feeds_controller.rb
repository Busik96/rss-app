# frozen_string_literal: true

class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :search_feed, only: %i[destroy show]
  before_action :user_feeds, only: %i[index show settings]

  def index
    @new_feed = Feed.new
  end

  def show
    @details = @feed.details
    @entries = []
    @details.entries.each do |entry|
      @entries << EntryDecorator.new(entry)
    end
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

  def destroy
    @user_feed = current_user.user_feeds.find_by(feed_id: params[:id])
    @user_feed.destroy
    flash[:success] = "Feed #{@feed.title} removed correctly"
    redirect_to feeds_path
  end

  def settings; end

  private

  def user_feeds
    @feeds = current_user.feeds
  end

  def search_feed
    @feed = Feed.find(params[:id])
  end

  def redirect_with_error(error)
    flash[:error] = error
    redirect_to action: :new
  end

  def feed_params
    params.require(:feed).permit(:url)
  end
end

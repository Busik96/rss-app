# frozen_string_literal: true

class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :preload_feeds, only: %i[index show]

  def index
    @new_feed = Feed.new
  end

  def show
    @feed = Feed.find(params[:id])
    @entries = @feed.details.entries.map { |entry| EntryDecorator.new(entry) }
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
    current_user.user_feeds.find(params[:id]).destroy
    flash[:success] = 'Feed removed correctly'
    redirect_to feeds_path
  end

  def settings
    @user_feeds = current_user.user_feeds.includes(:feed)
  end

  def notify
    user_feed = current_user.user_feeds.find(params[:id])
    user_feed.update(notify: !user_feed.notify)
    redirect_to settings_feeds_path, notice: 'Saved!'
  end

  private

  def preload_feeds
    @feeds = current_user.feeds.order(created_at: :asc)
  end

  def redirect_with_error(error)
    flash[:error] = error
    redirect_to action: :new
  end

  def feed_params
    params.require(:feed).permit(:url)
  end
end

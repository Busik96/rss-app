# frozen_string_literal: true

class EntryDecorator
  def initialize(entry)
    @entry = entry
  end

  def title
    @entry.title
  end

  def url
    @entry.url.strip
  end

  def img
    html = Nokogiri::HTML.fragment(@entry.summary.strip)
    html.css('img').collect(&:to_s).first
  end

  def description
    html = Nokogiri::HTML.fragment(@entry.summary.strip)
    html.text.strip
  end

  def published
    @entry.published
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: feeds
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Feed, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:user_feeds) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
  end

  describe '#self.cache_key' do
    url = 'https://tvn24.pl/najnowsze.xml'
    key = Feed.cache_key(url)
    it 'generates cache key' do
      expect(key).to eq('feed-8a7ffae329f4182edfdfa590e3b62278')
    end
  end

  describe '#details' do
    let(:feed) { create :feed }

    let(:fake_response) { instance_double('fake_response', body: fake_body) }
    let(:fake_body) { File.read(Rails.root.join('spec', 'support', 'najnowsze.xml')) }

    before do
      allow(HTTParty).to receive(:get).and_return(fake_response)
    end

    it 'returns parsed rss' do
      expect(feed.details).to be_a(Feedjira::Parser::RSS)
      expect(feed.details).to respond_to(:title)
    end
  end
end

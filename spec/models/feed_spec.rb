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
end

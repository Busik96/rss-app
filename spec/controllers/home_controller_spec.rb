# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET home#index' do
    before do
      get :index
    end

    it 'renders index view' do
      expect(response).to render_template('index')
    end

    it 'assigns new user to user' do
      expect(assigns(:user)).to_not be(nil)
    end
  end
end

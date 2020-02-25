# frozen_string_literal: true

require 'rails_helper'

describe OmniauthCallbacksController, type: :controller do
  let(:current_user) { create :user }

  context 'when user presisted' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
        provider: provider,
        uid: rand(5**10)
      )
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
      allow(User).to receive(:from_omniauth) { current_user }
    end

    describe '#facebook' do
      context 'new user' do
        let(:provider) { 'facebook' }
        before { get :facebook }

        it 'authenticate user' do
          expect(warden.authenticated?(:user)).to be_truthy
        end

        it 'set current_user' do
          expect(current_user).not_to be_nil
        end

        it 'redirect to root_path' do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe '#github' do
      context 'new user' do
        let(:provider) { 'github' }
        before { get :github }

        it 'authenticate user' do
          expect(warden.authenticated?(:user)).to be_truthy
        end

        it 'set current_user' do
          expect(current_user).not_to be_nil
        end

        it 'redirect to root_path' do
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  context 'when user not persisted' do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(provider: provider)

      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
      allow(User).to receive(:from_omniauth) { OmniAuth.config.mock_auth[provider] }
    end

    describe '#facebook' do
      context 'new user' do
        let(:provider) { 'facebook' }
        before { get :facebook }

        it 'not authenticate user' do
          expect(warden.authenticated?(:user)).to be_falsey
        end

        it 'set current_user' do
          expect(current_user).not_to be_nil
        end

        it 'redirect to root_path' do
          expect(response).to redirect_to(new_user_registration_url)
        end
      end
    end

    describe '#github' do
      context 'new user' do
        let(:provider) { 'github' }
        before { get :github }

        it 'authenticate user' do
          expect(warden.authenticated?(:user)).to be_falsey
        end

        it 'set current_user' do
          expect(current_user).not_to be_nil
        end

        it 'redirect to root_path' do
          expect(response).to redirect_to(new_user_registration_url)
        end
      end
    end
  end
end

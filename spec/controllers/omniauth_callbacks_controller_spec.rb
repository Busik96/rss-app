# frozen_string_literal: true

require 'rails_helper'

describe OmniauthCallbacksController, type: :controller do
  let(:current_user) { create :user }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = auth_hash
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
    allow(Users::UserAuthorization).to receive(:new) { fake_authorization }
  end

  context 'when user presisted' do
    let(:fake_authorization) { instance_double('fake_auth', call: current_user) }
    let(:auth_hash) { OmniAuth::AuthHash.new(provider: provider, uid: rand(5**10)) }

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

        it 'redirect to feeds_path' do
          expect(response).to redirect_to(feeds_path)
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

        it 'redirect to feeds_path' do
          expect(response).to redirect_to(feeds_path)
        end
      end
    end
  end

  context 'when user not persisted' do
    let(:fake_authorization) do
      instance_double('fake_auth', call: OmniAuth.config.mock_auth[provider])
    end
    let(:auth_hash) { OmniAuth::AuthHash.new(provider: provider) }

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

        it 'redirect to new_user_registration_url' do
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

        it 'redirect to new_user_registration_url' do
          expect(response).to redirect_to(new_user_registration_url)
        end
      end
    end
  end
end

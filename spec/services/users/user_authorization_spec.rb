# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::UserAuthorization, type: :services do
  subject(:service) { described_class.new.call(auth) }

  context 'when authorization present' do
    let(:user) { create :user }
    let(:authorization) { create :authorization, user: user }
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: authorization.provider,
        uid: authorization.uid,
        info: {
          name: user.name,
          email: user.email
        }
      )
    end

    it 'authorize user' do
      expect(service).to eq(authorization.user)
    end
  end

  context 'when authorization not present' do
    let(:user) { create :user }
    let(:authorization) { create :authorization, user: user }
    context 'when user email exist' do
      let(:auth) do
        OmniAuth::AuthHash.new(
          provider: authorization.provider,
          uid: '1212121',
          info: {
            name: 'Jack',
            email: user.email
          }
        )
      end

      it 'returns user' do
        expect(service).to eq(user)
      end

      it 'create new user authorization' do
        service
        expect(user.authorizations.last.uid).to eq('1212121')
      end
    end

    context 'when user email not exist' do
      let(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'facebook',
          uid: '1212121',
          info: {
            name: 'Jack',
            email: 'email@example.com'
          }
        )
      end

      it 'create new user authorization' do
        expect { service }.to change(User, :count).by(1)
      end

      it 'returns user' do
        expect(service).to eq(User.last)
      end
    end
  end
end

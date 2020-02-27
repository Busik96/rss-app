# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:user) { create :user, feeds: [feed] }
  let(:feed) { create :feed }

  describe 'GET feeds#index' do
    it_behaves_like 'only-for-signed-in', :index

    context 'with signed in user' do
      before do
        sign_in user
        get :index
      end

      it 'renders index view' do
        expect(response).to render_template('index')
      end

      it 'assigns all current user feeds to @feeds' do
        expect(assigns(:feeds).to_a).to eq([feed])
      end

      it 'assigns new feed object to @new_feed' do
        expect(assigns(:new_feed)).to_not be(nil)
      end
    end
  end

  describe 'GET feeds#new' do
    it_behaves_like 'only-for-signed-in', :new

    context 'with signed in user' do
      before do
        sign_in user
        get :new
      end

      it 'renders new view' do
        expect(response).to render_template('new')
      end

      it 'assigns new feed object to @new_feed' do
        expect(assigns(:new_feed)).to_not be(nil)
      end
    end
  end

  describe 'POST feeds#create' do
    context 'with sign in user' do
      before do
        sign_in user
      end

      subject(:call) { post :create, params: params }
      let(:params) do
        {
          feed: {
            url: url
          }
        }
      end

      context 'with params blank' do
        let(:url) { nil }

        it 'redirects to new_feed_path' do
          call
          expect(response).to redirect_to(new_feed_path)
        end
      end

      context 'with valid attributes' do
        let(:url) { 'https://tvn24.pl/whatever.xml' }
        let(:fake_response) { instance_double('fake_response', body: fake_body) }
        let(:fake_body) { File.read(Rails.root.join('spec', 'support', 'najnowsze.xml')) }

        before do
          allow(HTTParty).to receive(:get).and_return(fake_response)
        end

        it 'creates a new feed' do
          expect { call }.to change(user.reload.user_feeds, :count).by(1)
        end

        it 'redirects to index' do
          call
          expect(response).to redirect_to(feeds_path)
        end

        context 'when feed already exists' do
          let(:url) { 'https://tvn24.pl/najnowsze.xml' }

          it 'does not create a new feed' do
            expect { call }.not_to change(user.reload.user_feeds, :count)
          end
        end
      end

      context 'with invalid attributes' do
        let(:url) { 'https://facebook.com' }

        it 'does not save the new feed' do
          expect { call }.to_not change(Feed, :count)
        end

        it 'redirects to new' do
          call
          expect(response).to redirect_to(new_feed_path)
        end
      end
    end
  end

  # describe 'DELETE feeds#destroy' do
  #   before do
  #     sign_in user
  #   end
  #   subject(:call) { delete :destroy, params: { id: feed.id } }

  #   it 'remove feed from user' do
  #     expect { call }.to change(user.user_feeds, :count).by(-1)
  #   end

  #   it 'redirect to feeds index' do
  #     call
  #     expect(response).to redirect_to(feeds_path)
  #   end
  # end
end


# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:user) { create :user }
  let!(:user_feed) { user.user_feeds.create(feed_id: feed.id) }
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

  describe 'GET feeds#show' do
    it_behaves_like 'only-for-signed-in', :show, id: 1

    context 'with signed in user' do
      before do
        sign_in user
        allow(HTTParty).to receive(:get).and_return(fake_response)
      end

      subject(:call) { get :show, params: { id: feed.id } }

      let(:fake_response) { instance_double('fake_response', body: fake_body) }
      let(:fake_body) { File.read(Rails.root.join('spec', 'support', 'najnowsze.xml')) }

      it 'renders show view' do
        call
        expect(response).to render_template('show')
      end

      it 'assigns all feed entries to @entries' do
        call
        expect(assigns(:entries).first).to be_a(EntryDecorator)
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
        let(:fake_response) { instance_double('fake_response', body: fake_body) }
        let(:fake_body) { File.read(Rails.root.join('spec', 'support', 'invalid.xml')) }

        before do
          allow(HTTParty).to receive(:get).and_return(fake_response)
        end

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

  describe 'DELETE feeds#destroy' do
    before do
      sign_in user
    end
    subject(:call) { delete :destroy, params: { id: feed.id } }

    it 'remove feed from user' do
      expect { call }.to change(user.user_feeds, :count).by(-1)
    end

    it 'redirect to feeds index' do
      call
      expect(response).to redirect_to(feeds_path)
    end
  end

  describe 'GET feeds#settings' do
    it_behaves_like 'only-for-signed-in', :settings

    context 'with signed in user' do
      before do
        sign_in user
        get :settings
      end

      it 'renders index view' do
        expect(response).to render_template('settings')
      end

      it 'assigns all current user feeds to @feeds' do
        expect(assigns(:user_feeds).to_a).to eq([user_feed])
      end
    end
  end

  describe 'PATCH feeds#notify' do
    before do
      sign_in user
    end
    subject(:call) { patch :notify, params: { id: user_feed.id } }

    it 'changes notify boolean value' do
      expect { call }.to change { user_feed.reload.notify }
    end

    it 'redirect to feeds settings' do
      call
      expect(response).to redirect_to(settings_feeds_path)
    end
  end
end

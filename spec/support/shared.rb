# frozen_string_literal: true

shared_examples 'only-for-signed-in' do |action, params|
  context 'without sign in' do
    it 'renders log in view' do
      if params.present?
        get action, params: params
      else
        get action
      end
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end

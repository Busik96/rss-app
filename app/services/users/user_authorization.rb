# frozen_string_literal: true

module Users
  class UserAuthorization
    def call(auth)
      authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid)
      if authorization.present?
        authorization.user
      else
        create_authorizations_or_create_user(auth)
      end
    end

    private

    def create_authorizations_or_create_user(auth)
      user = User.where(email: auth.info.email).first_or_create do |new_user|
        new_user.email = auth.info.email
        new_user.password = Devise.friendly_token[0, 20]
        new_user.name = auth.info.name
        new_user.skip_confirmation_notification!
        new_user.confirmed_at = DateTime.current
      end
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
      user
    end
  end
end

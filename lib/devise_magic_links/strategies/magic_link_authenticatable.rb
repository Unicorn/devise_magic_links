# frozen_string_literal: true

module Devise
  module Strategies
    class MagicLinkAuthenticatable < Authenticatable

      def valid?
        valid_for_magic_link_auth?
      end

      def authenticate!
        resource = mapping.to.find_for_magic_link_authentication(authentication_hash)
        return fail(:invalid_magic_link) unless resource

        redirect_path = resource.magic_link_redirect_path

        if validate(resource) { resource.authenticate_magic_link! }
          session["#{scope}_return_to"] = redirect_path
          resource.after_magic_link_authentication
          success!(resource)
        end
      end

      private

      def valid_for_magic_link_auth?
        valid_magic_link_request? && with_authentication_hash(:magic_link_auth, magic_link_auth_hash)
      end

      def valid_magic_link_request?
        !!env['devise.allow_magic_link_authentication']
      end

      def magic_link_auth_hash
        params
      end

      def authentication_keys
        @authentication_keys ||= [:magic_link_token]
      end
    end
  end
end

Warden::Strategies.add(:magic_link_authenticatable, Devise::Strategies::MagicLinkAuthenticatable)

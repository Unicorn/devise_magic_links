# frozen_string_literal: true

module DeviseMagicLinks
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      def after_magic_link_sign_in_path_for(resource)
        after_sign_in_path_for(resource)
      end

      def after_sending_magic_link_instructions_path_for(resource_name)
        new_session_path(resource_name) if is_navigational_format?
      end

      def allow_magic_link_authentication!
        request.env['devise.allow_magic_link_authentication'] = true
      end
    end
  end
end

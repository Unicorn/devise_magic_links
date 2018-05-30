# frozen_string_literal: true

module Devise
  module Models
    module MagicLinkAuthenticatable
      extend ActiveSupport::Concern

      def self.required_fields(klass)
        [:magic_link_token, :magic_link_sent_at, :magic_link_redirect_path]
      end

      def send_magic_link_instructions(redirect_path = nil)
        token = set_magic_link_token(redirect_path)
        send_magic_link_instructions_notification(token)

        token
      end

      def magic_link_sent?
        persisted? && !magic_link_token.nil?
      end

      def magic_link_period_valid?
        magic_link_sent_at && magic_link_sent_at.utc >= magic_link_expires_in.ago.utc
      end

      def magic_link_authentication_failed?
        !!@magic_link_authentication_failed
      end

      def authenticate_magic_link!
        if magic_link_sent? && magic_link_period_valid?
          @magic_link_authentication_failed = false
          clear_magic_link_token
          true
        else
          @magic_link_authentication_failed = true
          false
        end
      end

      def unauthenticated_message
        return super unless magic_link_authentication_failed?
        if magic_link_sent? && !magic_link_period_valid? && !Devise.paranoid
          :expired_magic_link
        else
          :invalid_magic_link
        end
      end

      def after_magic_link_authentication
      end

      def magic_link_expires_in
        self.class.magic_link_expires_in || 15.minutes
      end

      def magic_link_confirmation_page?
        !self.class.magic_link_confirmation_page.nil? && self.class.magic_link_confirmation_page
      end

      protected

      def clear_magic_link_token
        self.magic_link_token = nil
        self.magic_link_sent_at = nil
        self.magic_link_redirect_path = nil
        save(validate: false)
      end

      def set_magic_link_token(redirect_path = nil)
        raw, enc = Devise.token_generator.generate(self.class, :magic_link_token)

        self.magic_link_token = enc
        self.magic_link_sent_at = Time.now.utc
        self.magic_link_redirect_path = redirect_path
        save(validate: false)
        raw
      end

      def send_magic_link_instructions_notification(token)
        send_devise_notification(:magic_link_instructions, token, {})
      end

      module ClassMethods

        def find_for_magic_link_authentication(tainted_conditions)
          raw = tainted_conditions.delete(:magic_link_token)
          enc = Devise.token_generator.digest(self, :magic_link_token, raw)
          find_for_authentication(tainted_conditions.merge(magic_link_token: enc))
        end

        def send_magic_link_instructions(attributes = {}, redirect_path = nil)
          resource = find_or_initialize_with_errors(magic_link_keys, attributes, :not_found)
          resource.send_magic_link_instructions(redirect_path) if resource.persisted?
          resource
        end

        Devise::Models.config(self, :magic_link_keys, :magic_link_expires_in, :magic_link_confirmation_page)
      end
    end
  end
end

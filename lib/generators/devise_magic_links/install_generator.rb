# frozen_string_literal: true

require 'rails/generators/base'

module DeviseMagicLinks
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Add config variables to the Devise initializer and copy locale files to your application.'

      def add_config_options_to_initializer
        initializer_path = 'config/initializers/devise.rb'
        return unless File.exist?(initializer_path)

        initializer_content = File.read(initializer_path)
        initializer_match_line = "  # ==> Configuration for :%{module_name}\n"
        return if initializer_content.match(/#{ initializer_match_line % { module_name: :magic_link_authenticatable } }/)

        inject_into_file(initializer_path, before: initializer_match_line % { module_name: :database_authenticatable }) do
<<-CONTENT
  # ==> Configuration for :magic_link_authenticatable
  # Defines which keys will be used when requesting a magic link.
  # Default is: [:email]
  # config.magic_link_keys = [:email]

  # Time interval that the magic link can be used before it expires.
  # Default is: 15 minutes
  # config.magic_link_expires_in = 15.minutes

  # Display a confirmation page after the magic link email has been sent.
  # Default is: true
  # config.magic_link_confirmation_page = true

CONTENT
        end
      end

      def copy_locale
        copy_file '../../../config/locales/en.yml', 'config/locales/devise_magic_links.en.yml'
      end
    end
  end
end

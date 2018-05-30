# frozen_string_literal: true

require 'rails/generators/named_base'

module DeviseMagicLinks
  module Generators
    class DeviseMagicLinksGenerator < Rails::Generators::NamedBase
      namespace 'devise_magic_links'

      desc 'Add :magic_link_authenticatable module and generate migration for required magic link columns.'

      def add_module_to_model
        inject_into_file(model_path, 'magic_link_authenticatable, :', after: 'devise :') if File.exists?(model_path)
      end

      hook_for :orm

      private

      def model_path
        @model_path ||= File.join('app', 'models', "#{file_path}.rb")
      end
    end
  end
end

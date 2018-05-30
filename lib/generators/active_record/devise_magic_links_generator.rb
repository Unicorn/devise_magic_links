# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseMagicLinksGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_devise_migration
        migration_template 'migration.rb', "#{migration_path}/add_devise_magic_links_to_#{table_name}.rb", migration_version: migration_version
      end

      private

      def migration_path
        if Rails.version >= '5.0.3'
          db_migrate_path
        else
          @migration_path ||= File.join('db', 'migrate')
        end
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if Rails.version.start_with?('5')
      end
    end
  end
end

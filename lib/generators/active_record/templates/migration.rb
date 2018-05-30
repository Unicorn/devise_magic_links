# frozen_string_literal: true

class AddDeviseMagicLinksTo<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :<%= table_name %>, :magic_link_token, :string
    add_column :<%= table_name %>, :magic_link_sent_at, :datetime
    add_column :<%= table_name %>, :magic_link_redirect_path, :text

    add_index :<%= table_name %>, :magic_link_token, unique: true
  end
end

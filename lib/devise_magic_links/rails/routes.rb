# frozen_string_literal: true

module ActionDispatch::Routing
  class Mapper

    protected

    def devise_magic_link(mapping, controllers)
      options = {
        only: [:new, :create],
        controller: controllers[:magic_links],
        path: mapping.path_names[:magic_link],
        path_names: {
          new: '',
          authenticate: mapping.path_names[:authenticate]
        }
      }
      resource :magic_link, options do
        get :authenticate
      end
    end
  end
end

# frozen_string_literal: true

module Devise
  module Models
    module Authenticatable
      BLACKLIST_FOR_SERIALIZATION.concat(
        [:magic_link_token, :magic_link_sent_at, :magic_link_redirect_path]
      )
    end
  end
end

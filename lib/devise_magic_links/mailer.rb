# frozen_string_literal: true

module DeviseMagicLinks
  module Mailer
    def magic_link_instructions(record, token, opts = {})
      @token = token
      devise_mail(record, :magic_link_instructions, opts)
    end
  end
end

# frozen_string_literal: true

module DeviseMagicLinks
  autoload :Mailer, 'devise_magic_links/mailer'
  module Controllers
    autoload :Helpers, 'devise_magic_links/controllers/helpers'
  end
end

require 'devise'
require 'devise_magic_links/rails'
require 'devise_magic_links/models'
require 'devise_magic_links/strategies'

module Devise
  # Defines which keys will be used when requesting a magic link.
  # Default is: [:email]
  mattr_accessor :magic_link_keys
  @@magic_link_keys = [:email]

  # Time interval that the magic link can be used before it expires.
  # Default is: 15 minutes
  mattr_accessor :magic_link_expires_in
  @@magic_link_expires_in = 15.minutes

  # Display a confirmation page after the magic link email has been sent.
  # Default is: true
  mattr_accessor :magic_link_confirmation_page
  @@magic_link_confirmation_page = true
end

Devise.add_module(
  :magic_link_authenticatable,
  model: true,
  strategy: true,
  controller: :magic_links,
  route: { magic_link: [nil, :new, :authenticate] }
)

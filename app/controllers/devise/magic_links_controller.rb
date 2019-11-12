# frozen_string_literal: true

class Devise::MagicLinksController < DeviseController
  prepend_before_action :require_no_authentication
  prepend_before_action :allow_magic_link_authentication!, only: :authenticate
  prepend_before_action(only: :authenticate) { request.env['devise.skip_timeout'] = true }

  # GET /resource/magic_link
  def new
    self.resource = resource_class.new
  end

  # POST /resource/magic_link
  def create
    self.resource = resource_class.send_magic_link_instructions(resource_params, redirect_path)
    yield resource if block_given?

    if successfully_sent?(resource)
      if is_navigational_format? && resource.magic_link_confirmation_page?
        flash.delete(:notice)
        respond_with_navigational(resource) { render :confirm }
      else
        respond_with({}, location: after_sending_magic_link_instructions_path_for(resource_name))
      end
    else
      respond_with(resource)
    end
  end

  # GET /resource/magic_link/authenticate?magic_link_token=abcdef
  def authenticate
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with_navigational(resource) { redirect_to after_magic_link_sign_in_path_for(resource) }
  end

  protected

  def redirect_path
    # We do not want to remove the value from the session, so we can't use the stored_location_for helper.
    # Also, would be nice to have access to stored_location_key_for so we can use it outside of the helper.
    scope = Devise::Mapping.find_scope!(resource_name)
    session["#{scope}_return_to"]
  end

  def auth_options
    { scope: resource_name }
  end

  def translation_scope
    'devise.magic_links'
  end

end

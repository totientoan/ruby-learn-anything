require 'google/apis/oauth2_v2'
require 'googleauth'
class SessionsController < ApplicationController
    def google_login
        client_id = ENV['google_client_id']
        client_secret = ENV['google_client_secret']
        id_token = params[:id_token]
        access_token = params[:access_token]

        begin
            oauth_client = Google::Apis::Oauth2V2::Oauth2Service.new
            oauth_client.authorization = Google::Auth::UserRefreshCredentials.new(
                client_id: client_id,
                access_token: access_token
            )
            user_info = oauth_client.get_userinfo

            # Find or create user based on email
            user = User.find_or_create_by(email: user_info.email) do |u|
                u.full_name = user_info.name
                u.avatar_url = user_info.picture
                u.provider = 'google'
                u.password = SecureRandom.hex(8) # Set a random password
                # Set additional attributes based on your requirements
            end
            user.save()

            token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
            refresh_token = generate_refresh_token(user)

            # Return the token as a response or handle further actions
            # render json: user, serializer: UserSerializer, meta: { token: token }, adapter: :json
            render json: {
                user: UserSerializer.new(user),
                token: token,
                refresh_token: refresh_token
            }, status: :ok

        rescue Google::Apis::AuthorizationError, Google::Apis::ClientError => e
            # Handle the authorization or client error
            render json: { error: e.message }, status: :unprocessable_entity
        rescue Google::Apis::SignatureError => e
            # Handle the signature error
            render json: { error: 'Invalid token signature' }, status: :unprocessable_entity
        rescue => e
            # Handle any other exceptions that may occur
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    def refresh_token
        def refresh_token
            refresh_token = params[:refresh_token]
            user = User.find_by(refresh_token: refresh_token)
        
            if user
                # Refresh the token and return the new token
                new_token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
                new_refresh_token = generate_refresh_token(user)
                render json: {
                    user: UserSerializer.new(user),
                    token: new_token,
                    refresh_token: new_refresh_token
                }, status: :ok    
            else
                render json: { error: 'Invalid refresh token' }, status: :unprocessable_entity
            end
        end
    end

    private

    def generate_refresh_token(user)
        # Generate a refresh token and store it in the database or other secure storage
        refresh_token = SecureRandom.hex(32)
        user.update(refresh_token: refresh_token)
        refresh_token
    end
end

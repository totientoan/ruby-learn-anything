require 'jwt'
class UsersController < ApplicationController
    before_action :authorize_request
    def get_info_by_token
        token = extract_token_from_header
        decoded_token = JWT.decode(token, ENV['secret_key_base'])
        user_id = decoded_token.first['user_id']
        user = User.find(user_id)

        render json: {
            user: UserSerializer.new(user)
        }, status: :ok
    end

    def logout
        token = extract_token_from_header
        if token
            decoded_token = JWT.decode(token, ENV['secret_key_base'], true, algorithm: 'HS256')
            jti = decoded_token[0]['jti']
            BlacklistedToken.create(jti: jti)

            render json: { message: 'Logout successful' }, status: :ok
        else
            render json: { error: 'Invalid token' }, status: :unauthorized
        end
    end

    private

    def extract_token_from_header
        authorization_header = request.headers['Authorization']
        authorization_header.sub('Bearer ', '')
    end
end

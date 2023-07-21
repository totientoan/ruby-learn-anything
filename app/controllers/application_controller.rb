class ApplicationController < ActionController::API
    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JWT.decode(header, Rails.application.secrets.secret_key_base)
          @current_user = User.where(id: @decoded[0]['user_id']).first()
          jti = @decoded[0]['jti']
          if BlacklistedToken.exists?(jti: jti)
            render json: { error: 'Invalid token' }, status: :unauthorized
          else
          end 
        rescue ActiveRecord::RecordNotFound, JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end
    end
end

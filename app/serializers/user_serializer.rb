class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :avatar_url, :provider, :rule
end

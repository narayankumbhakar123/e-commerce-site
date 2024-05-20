class CartSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id
end

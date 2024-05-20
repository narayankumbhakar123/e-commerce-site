class OrderSerializer
  include JSONAPI::Serializer
  attributes :id, :status, :description
end

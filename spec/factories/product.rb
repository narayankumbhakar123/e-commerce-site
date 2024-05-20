FactoryBot.define do
    factory :product do
        name { "laptop" }
        manufacturer { "asus"}
        prod_desc { "one year brand warrenty"}
        prod_feature { "intel core inside"}
        price { 50000 }
    end
end
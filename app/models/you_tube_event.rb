class YouTubeEvent < ApplicationRecord
    enum status: {
        pending: 0,
        processing: 1,
        processed: 2,
        error: 3
    }
end

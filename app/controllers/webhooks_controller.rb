class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        event = YouTubeEvent.create!(
            data: request.body.read,
        )
        YouTubeEventHandlerJob.perform_later(event)
        render json: {status: 'ok'}
    end

    def index
        if params['hub.challenge']
            render plain: params['hub.challenge']
        end
    end
end

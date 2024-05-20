class UsersController < ApplicationController
    # skip_before_action :authenticate_request, only: [:create]
    before_action :set_user, only: %i[ show edit update destroy ]

    def index
        @users = User.all
        render(json: UserSerializer.new(@users).serializable_hash.to_json)
    end

    def show
        render(json: UserSerializer.new(@user).serializable_hash.to_json)
    end

    def create
        @user = User.new(user_params)
        if @user.save
        send_welcome_message(@user)
        @user.cart = Cart.create(user_id: @user.id )
        render(json: UserSerializer.new(@user).serializable_hash.to_json)
        else
        render json: { errors: @user.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    def update
        if @user.update(user_params)
            render json: @user
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
        render json: { message: "user successfully deleted"}
    end

    private

    def set_user
        @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
        params.permit(:name, :username, :email, :password, :phone_number)
    end

    def send_welcome_message(user)
    client = Twilio::REST::Client.new
    
    message = client.messages.create(
        body: "Welcome, #{user.name}! Thank you for joining our service in whatsapp.",
        from: 'whatsapp:+14155238886',  # Your Twilio phone number with the 'whatsapp:' prefix
        to: "whatsapp:#{user.phone_number}"  # User's WhatsApp number with the 'whatsapp:' prefix
    )
    puts message.sid  # Output the message SID for tracking purposes
    # message = {
    #     body: {
    #       whatsapp: {
    #         template_name: 'your_template_name',
    #         namespace: 'your_template_namespace',
    #         language: {
    #           code: 'en'
    #         },
    #         components: [
    #           {
    #             type: 'header',
    #             parameters: [
    #               {
    #                 type: 'text',
    #                 text: "Welcome, #{user.name}!"
    #               }
    #             ]
    #           },
    #           {
    #             type: 'body',
    #             parameters: [
    #               {
    #                 type: 'text',
    #                 text: 'Thank you for joining our service.'
    #               }
    #             ]
    #           },
    #           {
    #             type: 'button',
    #             parameters: [
    #               {
    #                 type: 'text',
    #                 text: 'Order Now'
    #               },
    #               {
    #                 type: 'url',
    #                 url: 'https://example.com/order-now'
    #               }
    #             ]
    #           }
    #         ]
    #       }
    #     },
    #     from: 'whatsapp:+14155238886',  # Your Twilio phone number with the 'whatsapp:' prefix
    #     to: "whatsapp:#{user.phone_number}"  # User's WhatsApp number with the 'whatsapp:' prefix
    #   }
      
    #   response = client.messages.create(message)
    # Send SMS text message
    sms_message = client.messages.create(
        body: "Welcome, #{user.name}! Thank you for joining our service in sms.",
        from: '+16186022417',  # Your Twilio phone number without the 'whatsapp:' prefix
        to: user.phone_number
    )
    puts sms_message.sid
    end
end

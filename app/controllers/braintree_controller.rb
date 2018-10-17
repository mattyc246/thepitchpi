class BraintreeController < ApplicationController

  def new
    if current_user
      @user = User.find(current_user.id)
      @client_token = Braintree::ClientToken.generate
    end
  end

  def checkout

    @user = User.find(current_user.id)

    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]

    result = Braintree::Transaction.sale(
     :amount => "#{braintree_params[:price]}",
     :payment_method_nonce => nonce_from_the_client, #braintree generate token
     :options => {
        :submit_for_settlement => true
      }
     )

    if result.success?
      @user.subscription_status = true
      @user.save
      Twilio::REST::Client.new.messages.create({
        from: ENV['twilio_phone_number'],
        to: '+60102362993',
        body: 'You have made a successful transaction to LocknRoll.'
      })
      redirect_to root_path, :flash => { :success => "Transaction successful!" }
    else
      redirect_to root_path, :flash => { :error => "Transaction failed. Please try again." }
    end
  end

  private

  def braintree_params

    params.require(:checkout_form).permit(:price)

  end

end

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
     :amount => "10.00",
     :payment_method_nonce => nonce_from_the_client, #braintree generate token
     :options => {
        :submit_for_settlement => true
      }
     )

    if result.success?
      @user.subscription_status = true
      @user.save
      redirect_to root_path, :flash => { :success => "Transaction successful!" }
    else
      redirect_to root_path, :flash => { :error => "Transaction failed. Please try again." }
    end
  end

end

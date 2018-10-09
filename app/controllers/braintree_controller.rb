class BraintreeController < ApplicationController

  def new

    @user = User.find(params[:id])
    @client_token = Braintree::ClientToken.generate

  end


  def checkout

    @user = User.find(params[:id])

    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]


    result = Braintree::Transaction.sale(
     :amount => "10.00",
     :payment_method_nonce => nonce_from_the_client, #braintree generate token
     :options => {
        :submit_for_settlement => true
      }
     )

    if result.success?
      redirect_to root_path, :flash => { :success => "Transaction successful!" }
    else
      redirect_to root_path, :flash => { :error => "Transaction failed. Please try again." }
    end
  end

end

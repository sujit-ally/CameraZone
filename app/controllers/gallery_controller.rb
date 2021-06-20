class GalleryController < ApplicationController
  before_action :authenticate_user!
  def index
    @cameras = Store.all
  end

  def checkout

    if request.post?
      puts session[:price]
      amount_to_charge = session[:price].to_i
      ActiveMerchant::Billing::Base.mode = :test

      gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password => 'password',
        :test => 'true')

      # ActiveMerchant accepts all amounts as Integer values in cents
      # $10.00

      # The card verification value is also known as CVV2, CVC2, or CID
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name         => params[:first_name],
        :last_name          => params[:last_name],
        :number             => params[:credit_no],
        :month              => params[:check][:month],
        :year               => params[:check][:year],
        :verification_value => params[:verification_number])

      # Validating the card automatically detects the card type
      if credit_card.validate.empty?
        #auth = gateway.authorize(amount_to_charge , credit_card)
        # Capture $10 from the credit card
        response = gateway

        response = gateway.purchase(amount_to_charge, credit_card)
        puts response.inspect
        if response.success?
          flash[:notice]="Thank You for using Pink Flowers. The oreder details are sent to your mail"
          session[:cart_id]=nil
          redirect_to :action=>:purchase_complete
          #puts "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
        else
          flash[:notice] = "Gateway failure.Please try again"
          render :action=>"checkout"
        end
      else
        flash[:notice]= "Invalid card details"
        redirect_to :action=>"checkout"
        #UserNotifier.purchase_complete(session[:user],current_cart).deliver
      end

    end

  end

  def search
    # Post.find_by_sql ["SELECT body FROM comments WHERE author = :user_id OR approved_by = :user_id", { :user_id => user_id }]

    @cameras = Store.find_by_sql ["Select * from stores WHERE model like :m or description like :d or brand like :b ",{:m => params[:query], :d => params[:query], :b => params[:query]}]

  end

end
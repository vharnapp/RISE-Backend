module Admin
  class AffiliateDiscountCodesController < Admin::ApplicationController
    include DefaultSort
    
    
    def index
      @resources = AffiliateDiscountCode.page(params[:page]).per(30)
    end

    def new
      @clubs = Club.select(:id, :name).order(:name)
      @code = AffiliateDiscountCode.new()

      @code.code = ""
      @code.affiliation_rate = 0
      @code.discount_type = "amount"
      @code.discount = 0
      @code.max_users = 0
    end

    def create
      @clubs = Club.select(:id, :name)
      @code = AffiliateDiscountCode.new(codes_params)

      @code.affiliation_rate = @code.affiliation_rate.nil? ? 0 : @code.affiliation_rate
      @code.discount = @code.discount.nil? ? 0 : @code.discount
      @code.max_users = @code.max_users.nil? ? 0 : @code.max_users

      if @code.save
        redirect_to admin_affiliate_discount_codes_path
      else
        render 'new'
      end
    end


    def edit
    end

    private
      def codes_params
        params.require(:affiliate_discount_code).permit(
          :code,
          :contact_name,
          :contact_email,
          :payment_info,
          :affiliation_rate,
          :discount_type,
          :discount,
          :max_users,
          :start_date,
          :end_date,
          :club_id
        )
      end
    
  end
end

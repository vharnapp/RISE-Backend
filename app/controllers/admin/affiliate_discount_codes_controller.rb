module Admin
  class AffiliateDiscountCodesController < Admin::ApplicationController
    include DefaultSort
    
    
    def index
      order = ["code", "start_date", "end_date"].include?(params[:order]) ? params[:order] : "code"
      direction = ["asc", "desc"].include?(params[:direction]) ? params[:direction] : "asc"

      @resources = AffiliateDiscountCode.order("#{order} #{direction}").page(params[:page]).per(30)
    end

    def new
      @code = AffiliateDiscountCode.new()
      @clubs = Club.select(:id, :name).order(:name)
      @teams = Team.select(:id, :name).where(club_id: @code[:club_id]).order(:name)

      @code.code = ""
      @code.club_id = ""
      @code.team_id = ""
      @code.affiliation_rate = ""
      @code.discount_type = "amount"
      @code.discount = ""
      @code.max_users = ""
    end

    def create
      @code = AffiliateDiscountCode.new(codes_params)
      @clubs = Club.select(:id, :name).order(:name)
      @teams = Team.select(:id, :name).where(club_id: @code[:club_id]).order(:name)

      @code.affiliation_rate = @code.affiliation_rate.nil? ? "" : @code.affiliation_rate
      @code.discount = @code.discount.nil? ? "" : @code.discount
      @code.max_users = @code.max_users.nil? ? "" : @code.max_users

      if @code.save
        redirect_to admin_affiliate_discount_codes_path
      else
        render 'new'
      end
    end

    def edit
      @code = AffiliateDiscountCode.find(params[:id])
      @clubs = Club.select(:id, :name).order(:name)
      @teams = Team.select(:id, :name).where(club_id: @code[:club_id]).order(:name)
    end
 
    def update
      @code = AffiliateDiscountCode.find(params[:id])
      @clubs = Club.select(:id, :name).order(:name)
      @teams = Team.select(:id, :name).where(club_id: @code[:club_id]).order(:name)
     
      if @code.update(codes_params)
        redirect_to admin_affiliate_discount_code_path
      else
        render 'edit'
      end
    end

    def show
      @code = AffiliateDiscountCode.find(params[:id])
      @code_purchases = AffiliateCodePurchase.where(affiliate_discount_code_id: params[:id])
      puts @code_purchases.to_json
    end

    def destroy
      @code = AffiliateDiscountCode.find(params[:id])
      @code.destroy

      redirect_to admin_affiliate_discount_codes_path
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
          :club_id,
          :team_id
        )
      end
    
  end
end

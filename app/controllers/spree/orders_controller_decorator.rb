Spree::OrdersController.class_eval do
  def populate
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    if populator.populate(params[:variant_id], params[:quantity], option_params_with_roles)
      respond_with(@order) do |format|
        format.html { redirect_to cart_path }
      end
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_back_or_default(spree.root_path)
    end
  end

  private

  def option_params_with_roles
    option_params = params[:options] || {}

    role_ids = try_spree_current_user.try(:price_book_role_ids)
    return option_params.merge({ role_ids: role_ids }) if role_ids.present?

    option_params
  end
end

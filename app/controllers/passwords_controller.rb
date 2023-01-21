class PasswordsController < ApplicationController

	def create
		@user = User.find_by(email: params[:user][:email].downcase)
		if @user
			if @user.confirmed?
				@user.send_password_reset_token!
				redirect_to root_path, notice: "If that user exists we've sent instructions to their email."
			else
				redirect_to new_confirmation_path, alert: "Please confirm your email first."
			end
		else
			redirect_to root_path, alert: "Invalid or expired token."
		end
	end

	def edit
		@user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
		if @user.present? && @user.unconfirmed?
			redirect_to new_confirmation_path, notice: "You must confirm your email first."
		elsif @user.nil?
			redirect_to new_password_path, alert: "Invalid or expired token."
		end
	end

	def new
	end

	def update
		@user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
		if @user
			if @user.unconfirmed?
				redirect_to new_confirmation_path, notice: "You must confirm your email first."
			elsif @user.update(password_params)
				redirect_to login_path, notice: "Sign in."
			else
				flass.now[:alert] = @user.error.full_messages.to_sentence
				render :edit, status: :unprocessable_entity
			end
		else
			flast.now[:alert] = "Invalid or expire token."
			render :new, status: :unprocessable_entity
		end
	end

	private

	def password_params
		params.require(:user).permit(:password, :password_confirmation)
	end
end

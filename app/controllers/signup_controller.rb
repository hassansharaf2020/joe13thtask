class SignupController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production? )

      render json: { csrf: tokens[:csrf] }
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def uploadimages
    uploaded_io = params[:file]
    folder = params[:folder]
    File.open(Rails.root.join('public', 'uploads', folder, uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
    end
    render json: { avatar: base_url + 'uploads/' + folder + '/' + uploaded_io.original_filename , url: base_url + 'uploads/' + folder + '/' + uploaded_io.original_filename }
  end

  private

    def user_params
      params.permit(:first_name, :last_name, :avatar, :email, :password , :password_confirmation)
    end
end

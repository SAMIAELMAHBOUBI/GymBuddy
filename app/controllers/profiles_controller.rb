class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update]

  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      if params[:profile][:photo].present?
        upload_image(params[:profile][:photo], @profile)
      end
      redirect_to new_profile_objective_path(@profile), notice: 'Profile created successfully.'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :age, :gender, :location, :bio, :availability, :level, :profile_image)
  end

  def upload_image(file, profile)
    upload = Cloudinary::Uploader.upload(file.path)
    profile_image = profile.build_profile_image(image: upload['secure_url'])
    profile_image.save
  end
end

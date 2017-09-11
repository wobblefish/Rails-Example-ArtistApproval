class ArtistApprovalStatusesController < ApplicationController
	before_filter :authorize, :setup_current_user

	def index
		@artist_approval_statuses = ArtistApprovalStatus.organization(@co.id)
	end

	def show
		@artist_approval_status = ArtistApprovalStatus.find(params[:id])
		return unless check_organization @artist_approval_status
		redirect_to edit_artist_approval_status_path(@artist_approval_status)
	end

	def new
		@artist_approval_status = ArtistApprovalStatus.new
	end

	def edit
		@artist_approval_status = ArtistApprovalStatus.find(params[:id])
		return unless check_organization @artist_approval_status
		next_prev
		if @artist_approval_status.required_approval_status?
				flash[:error] = tr("This Artist Approval Status type cannot be changed")
				redirect_to artist_approval_statuses_path
		end
	end

	def create
		@artist_approval_status = ArtistApprovalStatus.new(params[:artist_approval_status])

		if @artist_approval_status.save
			flash[:notice] = tr("Artist Approval Status type was successfully created")
			redirect_to artist_approval_statuses_path
		else
			render :action => "new"
		end
	end

	def update
		@artist_approval_status = ArtistApprovalStatus.find(params[:id])
		if @artist_approval_status.update_attributes(params[:artist_approval_status])
			flash[:notice] = tr("Artist Approval Status type was successfully updated")
			redirect_to artist_approval_statuses_path
		else
			@artist_approval_status = ArtistApprovalStatus.find(params[:id])
			next_prev
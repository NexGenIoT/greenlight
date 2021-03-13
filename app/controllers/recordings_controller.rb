
class RecordingsController < ApplicationController
  before_action :find_room
  before_action :verify_room_ownership

  META_LISTED = "gl-listed"

  # POST /:meetingID/:record_id
  def update
    meta = {
      "meta_#{META_LISTED}" => (params[:state] == "public"),
    }

    res = update_recording(params[:record_id], meta)

    # Redirects to the page that made the initial request
    redirect_back fallback_location: root_path if res[:updated]
  end

  # PATCH /:meetingID/:record_id
  def rename
    update_recording(params[:record_id], "meta_name" => params[:record_name])

    redirect_back fallback_location: room_path(@room)
  end

  # DELETE /:meetingID/:record_id
  def delete
    delete_recording(params[:record_id])

    # Redirects to the page that made the initial request
    redirect_back fallback_location: root_path
  end

  private

  def find_room
    @room = Room.find_by!(bbb_id: params[:meetingID])
  end

  # Ensure the user is logged into the room they are accessing.
  def verify_room_ownership
    redirect_to root_path if !@room.owned_by?(current_user) && !current_user&.role&.get_permission("can_manage_rooms_recordings")
  end
end

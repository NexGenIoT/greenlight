
module RoomsHelper
  # Helper to generate the path to a Google Calendar event creation
  # It will have its title set as the room name, and the location as the URL to the room
  def google_calendar_path
    "http://calendar.google.com/calendar/r/eventedit?text=#{@room.name}&location=#{request.base_url + request.fullpath}"
  end

  def room_authentication_required
    @settings.get_value("Room Authentication") == "true" &&
      current_user.nil?
  end

  def current_room_exceeds_limit(room)
    # Get how many rooms need to be deleted to reach allowed room number
    limit = @settings.get_value("Room Limit").to_i

    return false if current_user&.has_role?(:admin) || limit == 15

    @diff = current_user.rooms.count - limit
    @diff.positive? && current_user.rooms.pluck(:id).index(room.id) + 1 > limit
  end

  def room_configuration(name)
    @settings.get_value(name)
  end

  def preupload_allowed?
    @settings.get_value("Preupload Presentation") == "true"
  end

  def display_joiner_consent
    # If the require consent setting is checked, then check the room setting, else, set to false
    if recording_consent_required?
      room_setting_with_config("recording")
    else
      false
    end
  end

  # Array of recording formats not to show for public recordings
  def hidden_format_public
    ENV.fetch("HIDDEN_FORMATS_PUBLIC", "").split(",")
  end

  # Returns the total number of visibile rooms for the current user
  def total_room_count(user)
    total = user.rooms.length
    total += user.shared_rooms.length if shared_access_allowed
    total
  end
end

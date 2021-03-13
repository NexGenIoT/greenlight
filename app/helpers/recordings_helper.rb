
module RecordingsHelper
  def recording_length(playbacks)
    # Looping through playbacks array and returning first non-zero length value
    playbacks.each do |playback|
      length = playback[:length]
      return recording_length_string(length) unless length.zero?
    end
    # Return '< 1 min' if length values are zero
    "< 1 min"
  end

  # Prevents single images from erroring when not passed as an array.
  def safe_recording_images(images)
    Array.wrap(images)
  end

  def room_uid_from_bbb(bbb_id)
    Room.find_by(bbb_id: bbb_id)[:uid]
  end

  # returns whether recording thumbnails are enabled on the server
  def recording_thumbnails?
    Rails.configuration.recording_thumbnails
  end

  private

  # Returns length of the recording as a string
  def recording_length_string(len)
    if len > 60
      "#{(len / 60).to_i} h #{len % 60} min"
    else
      "#{len} min"
    end
  end
end

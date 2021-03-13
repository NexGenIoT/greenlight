
module Queries
  extend ActiveSupport::Concern

  def created_at_text
    active_database = Rails.configuration.database_configuration[Rails.env]["adapter"]
    # Postgres requires created_at to be cast to a string
    if active_database == "postgresql"
      "created_at::text"
    else
      "created_at"
    end
  end

  def like_text
    active_database = Rails.configuration.database_configuration[Rails.env]["adapter"]
    # Use postgres case insensitive like
    if active_database == "postgresql"
      "ILIKE"
    else
      "LIKE"
    end
  end
end

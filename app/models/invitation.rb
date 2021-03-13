
class Invitation < ApplicationRecord
  has_secure_token :invite_token

  scope :valid, -> { where(updated_at: (Time.now - 48.hours)..Time.now) }

  def self.admins_search(string)
    return all if string.blank?

    search_query = "email LIKE :search"

    search_param = "%#{sanitize_sql_like(string)}%"
    where(search_query, search: search_param)
  end
end

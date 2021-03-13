
module Deleteable
  extend ActiveSupport::Concern

  included do
    # By default don't include deleted if the column has been created
    default_scope { where(deleted: false) } if column_names.include? 'deleted'
    scope :include_deleted, -> { unscope(where: :deleted) }
    scope :deleted, -> { include_deleted.where(deleted: true) }
  end

  def destroy(permanent = false)
    if permanent
      super()
    else
      run_callbacks :destroy do end
      update_attribute(:deleted, true)
    end
  end

  def delete(permanent = false)
    destroy(permanent)
  end

  def undelete!
    update_attribute(:deleted, false)
  end

  def permanent_delete
    destroy(true)
  end

  def deleted?
    deleted
  end
end


class Ability
  include CanCan::Ability

  def initialize(user)
    if !user
      cannot :manage, AdminsController
    elsif user.has_role? :super_admin
      can :manage, :all
    else
      highest_role = user.role
      if highest_role.get_permission("can_edit_site_settings")
        can [:site_settings, :room_configuration, :update_settings,
             :update_room_configuration, :coloring, :registration_method, :log_level], :admin
      end

      if highest_role.get_permission("can_edit_roles")
        can [:roles, :new_role, :change_role_order, :update_role, :delete_role], :admin
      end

      if highest_role.get_permission("can_manage_users")
        can [:index, :edit_user, :promote, :demote, :ban_user, :unban_user,
             :approve, :invite, :reset, :undelete, :merge_user, :merge_list], :admin
      end

      can [:server_recordings, :server_rooms], :admin if highest_role.get_permission("can_manage_rooms_recordings")

      if !highest_role.get_permission("can_edit_site_settings") && !highest_role.get_permission("can_edit_roles") &&
         !highest_role.get_permission("can_manage_users") && !highest_role.get_permission("can_manage_rooms_recordings")
        cannot :manage, AdminsController
      end
    end
  end
end

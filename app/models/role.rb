##
# Role model for Rolify.
# Represents user roles that can be assigned to users.
# Supports resource-scoped roles (e.g., admin of a specific asset).
#
class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :name, presence: true, uniqueness: { scope: [ :resource_type, :resource_id ] }
  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify

  has_paper_trail

  ##
  # Find or create a role by name.
  #
  # @param role_name [String] name of the role (e.g., "admin", "manager", "viewer")
  # @param resource [ActiveRecord::Base, nil] optional resource to scope the role
  # @return [Role] the found or created role
  # @example Create a global admin role
  #   admin_role = Role.find_or_create_by_name("admin")
  # @example Create a resource-scoped manager role
  #   asset = Asset.find_by(name: "Main Building")
  #   manager_role = Role.find_or_create_by_name("manager", resource: asset)
  def self.find_or_create_by_name(role_name, resource: nil)
    find_or_create_by(name: role_name, resource: resource)
  end

  ##
  # RailsAdmin label.
  #
  # @return [String]
  def rails_admin_label
    label = name
    label += " (#{resource_type})" if resource_type.present?
    label += " - #{resource.name}" if resource.respond_to?(:name)
    label
  end
end

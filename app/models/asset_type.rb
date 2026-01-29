##
# Represents a category or type of asset in the system.
#
# Asset types define the schema and behavior for groups of assets.
# Each asset belongs to exactly one asset type, which determines
# what attributes and methods are available on the asset.
#
# @example Creating an asset type
#   AssetType.create!(name: "SolarArray", display_name: "Solar Array")
#
# @example Finding assets by type
#   solar_array_type = AssetType.find_by(name: "SolarArray")
#   solar_arrays = solar_array_type.assets
#
class AssetType < ApplicationRecord
  include TestExpectations

  has_many :assets, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  # Feature declarations
  feature :validates, :name, presence: true, uniqueness: true
  feature :associates, :has_many, :assets, dependent: :destroy
  feature :provides, :rails_admin_label
  feature :scopes, :with_assets, :by_name

  has_paper_trail

  # Scopes
  # Indexed: name (unique index already exists)
  scope :with_assets, -> { joins(:assets).distinct }
  scope :by_name, ->(name) { where(name: name) }

  # RailsAdmin object label
  def rails_admin_label
    display_name.presence || name
  end

  ##
  # Check if this asset type has any assets.
  #
  # @return [Boolean]
  def has_assets?
    assets.exists?
  end

  ##
  # Get count of assets of this type.
  #
  # @return [Integer]
  def assets_count
    assets.count
  end
end

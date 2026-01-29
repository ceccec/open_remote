##
# Represents an asset in the OpenRemote system.
#
# Assets are hierarchical entities that can have a parent and children,
# belong to an asset type, and contain flexible attribute data.
#
# @example Creating an asset
#   asset_type = AssetType.find_by(name: "SolarArray")
#   asset = Asset.create!(
#     name: "Solar Farm 1",
#     asset_type: asset_type,
#     attributes_data: { capacity: 1000, location: "California" }
#   )
#
class Asset < ApplicationRecord
  include TestExpectations

  belongs_to :asset_type
  belongs_to :parent, class_name: "Asset", optional: true, inverse_of: :children
  has_many :children, class_name: "Asset", foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent
  has_many :data_points, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true
  validate :attributes_data_presence

  # Feature declarations
  feature :validates, :name, presence: true
  feature :associates, :belongs_to, :asset_type
  feature :associates, :belongs_to, :parent, optional: true, class_name: "Asset"
  feature :associates, :has_many, :children, dependent: :destroy
  feature :associates, :has_many, :data_points, dependent: :destroy
  feature :associates, :has_many, :notifications, dependent: :destroy
  feature :provides, :attributes_data_pretty_json, :from_openremote_json, :to_openremote_json_tree
  feature :scopes, :root_assets, :with_parent, :by_type, :solar_arrays, :solar_parks, :of_type

  include Type::Dispatch
  include Querying
  include Mapping::AttributeNormalization
  include Mapping::JsonImport
  include Mapping::JsonExport
  include Asset::References
  include BatchActions

  has_paper_trail

  # Scopes
  # Indexed: parent_id (with partial index for NULL), asset_type_id, asset_types.name
  scope :root_assets, -> { where(parent_id: nil) }
  scope :with_parent, -> { where.not(parent_id: nil) }
  scope :by_type, ->(type_name) { joins(:asset_type).where(asset_types: { name: type_name }) }
  # Additional scopes are provided by Assets::Querying concern:
  # - solar_arrays
  # - solar_parks
  # - of_type(type_name)
  # - solar_array_power_outputs
  # - with_numeric_attribute_greater_than(attr_name, value)

  ##
  # Pretty JSON representation of `attributes_data` for admin UI.
  #
  # @return [String]
  def attributes_data_pretty_json
    JSON.pretty_generate(attributes_data || {})
  end

  ##
  # Check if asset is a root asset (has no parent).
  #
  # @return [Boolean]
  def root?
    parent_id.nil?
  end

  ##
  # Get the depth of this asset in the hierarchy.
  #
  # @return [Integer] depth level (0 for root assets)
  def depth
    return 0 if root?
    parent.depth + 1
  end

  ##
  # Get all ancestors of this asset.
  #
  # @return [Array<Asset>] ancestors from root to parent
  def ancestors
    return [] if root?
    parent.ancestors + [ parent ]
  end

  ##
  # Get all descendants of this asset (recursive).
  #
  # @return [ActiveRecord::Relation<Asset>] all descendant assets
  def descendants
    result = children.to_a
    children.each { |child| result.concat(child.descendants) }
    Asset.where(id: result.map(&:id))
  end

  private

  def attributes_data_presence
    errors.add(:attributes_data, :blank) if attributes_data.nil?
  end
end

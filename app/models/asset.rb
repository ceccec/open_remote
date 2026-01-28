class Asset < ApplicationRecord
  belongs_to :asset_type
  belongs_to :parent, class_name: "Asset", optional: true
  has_many :children, class_name: "Asset", foreign_key: :parent_id, dependent: :destroy
  has_many :data_points, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true
  validate :attributes_data_presence

  include Type::Dispatch
  include Querying
  include Mapping::AttributeNormalization
  include Mapping::JsonImport
  include Mapping::JsonExport

  has_paper_trail

  # Scopes
  scope :root_assets, -> { where(parent_id: nil) }
  scope :with_parent, -> { where.not(parent_id: nil) }
  scope :by_type, ->(type_name) { joins(:asset_type).where(asset_types: { name: type_name }) }

  ##
  # Pretty JSON representation of `attributes_data` for admin UI.
  #
  # @return [String]
  def attributes_data_pretty_json
    JSON.pretty_generate(attributes_data || {})
  end

  private

  def attributes_data_presence
    errors.add(:attributes_data, :blank) if attributes_data.nil?
  end
end

class AssetType < ApplicationRecord
  has_many :assets, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  has_paper_trail

  # Scopes
  scope :with_assets, -> { joins(:assets).distinct }
  scope :by_name, ->(name) { where(name: name) }

  # RailsAdmin object label
  def rails_admin_label
    display_name.presence || name
  end
end

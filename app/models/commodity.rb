class Commodity < ApplicationRecord
  include Uuideable
  include Visibility

  belongs_to :brand, optional: true
  has_many :commodity_references
  has_many :specifications, through: :commodity_references
  has_many :packagings, through: :commodity_references
  has_many :standards, through: :commodity_references
  has_many :references, through: :commodity_references
  has_many :links, through: :commodity_references
  has_many :images, through: :commodity_references
  has_many :barcodes, as: :barcodeable
  has_many :classification_commodities

  validates_presence_of :measured_in, :name
  validates_presence_of :brand_id, unless: "generic?"

  scope :generic, -> { where(generic: true )}
  scope :not_generic, -> { where(generic: false )}
  scope :recent, -> { order("created_at DESC") }

  before_update :update_references

  searchkick word_start: [:name, :short_description, :long_description]

  # http://stackoverflow.com/questions/1680627/activerecord-findarray-of-ids-preserving-order
  scope :where_with_order, ->(ids) {
    order = sanitize_sql_array(
        ["position((',' || id::text || ',') in ?)", ids.join(',') + ',']
    )
    where(:id => ids).order(order)
  }

  def state(app)
    return commodity_references.first.state if app.nil?
    cr = commodity_references.find_by(app_id: app.id)
    return nil unless cr
    cr.state
  end

  def create_reference(user)
    app = user.default_app
    attributes = self.class.attribute_names.select{|a|
      ["measured_in","generic","moderated","brand_id","name"].include?(a)
    }
    attributes = attributes.each_with_object({}) do |attribute,hash|
      hash[attribute] = self.send(attribute)
    end
    self.commodity_references.create!(attributes.merge(app_id: app.id))
  end

  private

  def update_references
    commodity_references.update_all(name: name, short_description: short_description, long_description: long_description)
  end
end

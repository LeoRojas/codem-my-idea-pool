class Idea < ApplicationRecord
  include ActiveModel::Serializers::JSON
  belongs_to :user
  validates_presence_of :content, :impact, :ease, :confidence, :user_id
  validates_inclusion_of :impact, :ease, :confidence, in: 1..10
  before_save :set_average_score

  # attr_accessor :name, :content, :impact, :ease, :confidence, :average_score, :created_at

  # def attributes
  #   {'id' => nil,
  #    'content' => nil,
  #    'impact' => nil,
  #    'ease' => nil,
  #    'confidence' => nil,
  #    'average_score' => nil,
  #    'created_at' => nil,
  #   }
  # end

  def set_average_score
    byebug
    self.average_score = ((impact+ease+confidence)/3.0).round(2)
  end
end
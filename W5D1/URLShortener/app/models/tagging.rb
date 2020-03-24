# == Schema Information
#
# Table name: taggings
#
#  id     :bigint           not null, primary key
#  tag_id :integer          not null
#  url_id :integer          not null
#
class Tagging < ApplicationRecord
  validates :tag_id, presence: true
  validates :url_id, presence: true

  belongs_to :topic,
             primary_key: :id,
             foreign_key: :tag_id,
             class_name: :TagTopic

  belongs_to :url,
             primary_key: :id,
             foreign_key: :url_id,
             class_name: :ShortenedUrl

  def self.record_tag!(topic, url)
    Tagging.new(tag_id: topic, url_id: url).save!
  end
end

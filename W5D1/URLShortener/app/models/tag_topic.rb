# == Schema Information
#
# Table name: tag_topics
#
#  id    :bigint           not null, primary key
#  topic :string           not null
#
class TagTopic < ApplicationRecord
  validates :topic, presence: true
  validates :topic, uniqueness: true

  has_many :tags,
           primary_key: :id,
           foreign_key: :tag_id,
           class_name: :Tagging

  has_many :urls,
           through: :tags,
           source: :url

  has_many :distinct_links,
           -> { distinct },
           through: :tags,
           source: :url

  def popular_links
    links = self.distinct_links.limit(5)
    puts "Most popular links for this Topic: "
    links.each.with_index do |link, i|
      puts "#{i + 1}"
      puts link.short_url
      puts "Clicks: #{link.num_clicks}"
      puts "----------------"
    end
  end
end

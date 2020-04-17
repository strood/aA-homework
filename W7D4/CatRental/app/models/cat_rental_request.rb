class CatRentalRequest < ApplicationRecord
  STATUSES = [
    "PENDING",
    "APPROVED",
    "DENIED",
  ].freeze

  validates :cat_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true
  validates :status, inclusion: STATUSES


  validate :start_must_come_before_end
  validate :does_not_overlap_approved_request

  after_initialize :assign_pending_status

  belongs_to :cat,
             primary_key: :id,
             foreign_key: :cat_id,
             class_name: :Cat

  def overlapping_requests
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: cat_id)
      .where.not("start_date > :end_date OR end_date < :start_date",
                 start_date: start_date, end_date: end_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "PENDING")
  end

  def does_not_overlap_approved_request
    unless overlapping_approved_requests.exists?
      return true
    end
    false
  end

  def pending?
    self.status == "PENDING"
  end

  def approved?
    self.status == "APPROVED"
  end

  def denied?
    self.status == "DENIED"
  end

  def assign_pending_status
    self.status ||= "PENDING"
  end

  def start_must_come_before_end
    return if start_date < end_date
      errors[:start_date] << 'must come before end date'
      errors[:end_date] << 'must come after start date'
  end


  def approve!
    # This transaction means all or nothing, wont save anything if whole thing doesnt work.
    transaction do
      if self.does_not_overlap_approved_request
        self.status = "APPROVED"
        self.save!
        self.overlapping_pending_requests.each do |req|
          req.deny!
        end
      else
        raise "Error approving due to overlap with approved requests"
      end
    end
  end

  def deny!
    transaction do
      self.status = "DENIED"
      self.save!
    end
  end
end

class CatRentalRequest < ApplicationRecord
  include ActionView::Helpers::DateHelper
  STATUSES = [
    "PENDING",
    "APPROVED",
    "DENIED",
  ].freeze


  # N.B. Remember, Rails 5 automatically validates the presence of
  # belongs_to associations, so we can leave the validation of cat and
  # user out here.
  validates :start_date, :end_date, :status, presence: true
  validates :status, inclusion: STATUSES

  # validates nobody tampered with user, and is submitting an invalid user.
  validate :requester_exists?

  # validate :request_in_future
  validate :start_must_come_before_end
  before_commit :does_not_overlap_approved_request

  after_initialize :assign_pending_status

  belongs_to :cat,
             primary_key: :id,
             foreign_key: :cat_id,
             class_name: :Cat

  belongs_to :requester,
            primary_key: :id,
            foreign_key: :user_id,
            class_name: :User



  # We look at the overlapping requests that wouldnt be overlapping, and work
  # backwards from there to find which are overlapping. Done usingf start and
  #  end dates, and comparing to make sure the start is not less than end, visa versa
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
    # Dont bother searching if alreaady denied
    return if self.denied?

    unless overlapping_approved_requests.exists?
      errors[:request] << 'conflicts with existing approved request'
    end
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
    errors[:start_date] << 'must be specified' unless start_date
    errors[:end_date] << 'must be specified' unless end_date
    if start_date && end_date
      errors[:start_date] << 'must come before end date' if start_date > end_date
      errors[:request] << 'must be in the future' if start_date < Time.now
    end
  end


  def approve
    # This transaction means all or nothing, wont save anything if whole thing doesnt work.
    raise 'not pending' unless self.status == 'PENDING'

    if does_not_overlap_approved_request
      transaction do
          self.status = "APPROVED"
          self.save!

          # Automatically deny any overlapping pending requests.
          self.overlapping_pending_requests.each do |req|
            req.deny!
          end
        end
    end
  end


  def requester_exists?
    errors[:user] << 'must be valid' unless User.exists?(id: user_id)
  end

  def deny!
    transaction do
      self.status = "DENIED"
      self.save!
    end
  end
end

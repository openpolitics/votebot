# frozen_string_literal: true

#
# An interaction between a User and a Proposal.
# Records whether a user is voting, or just commenting, and if voting, how.
#
class Interaction < ApplicationRecord
  belongs_to :user
  belongs_to :proposal

  validates :user, presence: true
  validates :proposal, presence: true

  validates :last_vote, inclusion: { in: %w(yes block no abstention), allow_nil: true }

  scope :yes, -> { where(last_vote: "yes") }
  scope :no, -> { where(last_vote: "no") }
  scope :abstention, -> { where(last_vote: "abstention") }
  scope :block, -> { where(last_vote: "block") }
  scope :participating, -> { where(last_vote: nil) }

  def yes!
    update_attributes! last_vote: "yes"
  end

  def no!
    update_attributes! last_vote: "no"
  end

  def abstention!
    update_attributes! last_vote: "abstention"
  end

  def block!
    update_attributes! last_vote: "block"
  end

  def state
    last_vote || "participating"
  end
end

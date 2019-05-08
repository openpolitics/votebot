# frozen_string_literal: true

def update_prs!
  Rails.logger.info "Updating proposals"
  Octokit.pull_requests(ENV.fetch("GITHUB_REPO"), state: "all").each do |pr|
    Rails.logger.info " - #{pr["number"]}: #{pr["title"]}"
    pr = Proposal.find_or_create_by!(number: pr["number"].to_i)
    pr.update_from_github!
  end
end


def update_users!
  Rails.logger.info "Updating existing users"
  User.all.each do |user|
    Rails.logger.info " - #{user.login}"
    user.load_from_github
    Rails.logger.info "     has become a contributor" if user.contributor_changed?
    user.save! if user.changed?
  end
  Rails.logger.info "Updating new contributors from GitHub"
  Octokit.contributors(ENV.fetch("GITHUB_REPO")).each do |contributor|
    params = { login: contributor["login"] }
    unless User.find_by(params)
      Rails.logger.info " - #{contributor["login"]}"
      user = User.create!(params)
      user.contributor = true
      user.save!
    end
  end
end

task update: :environment do
  Rails.logger = ActiveSupport::Logger.new(STDOUT)
  update_users!
  update_prs!
end

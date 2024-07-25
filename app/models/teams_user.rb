class TeamsUser < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_one :team_user_node, foreign_key: 'node_object_id', dependent: :destroy
  has_paper_trail
  # attr_accessible :user_id, :team_id # unnecessary protected attributes

  def name(ip_address = nil)
    name = user.name(ip_address)

    # E2115 Mentor Management
    # Indicate that someone is a Mentor in the UI. The view code is
    # often hard to follow, and this is the best place we could find
    # for this to go.
    name += ' (Mentor)' if MentorManagement.user_a_mentor?(user)
    name
  end

  def delete
    TeamUserNode.find_by(node_object_id: id).destroy
    team = self.team
    destroy
    team.delete if team.teams_users.empty?
  end
end

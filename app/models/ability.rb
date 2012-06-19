class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read,:search,:tab,:tag],Idea
    can [:show,:more_ideas,:more_favored], User
    if user
      can [:promotion,:create,:update,:favoriate,:unfavoriate], Idea
      can :manage, Comment
      can :manage, Solution
      can [:edit,:update,:inbox], User
      can :manage, Vote
      can :manage, Message

      if user.admin?
        can :manage, :all
      end
    end
  end
end

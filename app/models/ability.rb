class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read,:search,:tab,:tag,:more_solutions,:more_comments],Idea
    can [:show,:more_ideas,:more_favored], User
    can :show,Topic
    can :show,Tag
    if user
      can [:promotion,:create,:update,:favoriate,:unfavoriate], Idea
      can :manage, Comment
      can [:create,:update,:destroy], Solution
      can [:edit,:update,:inbox], User
      can :manage, Vote
      can :manage, Message

      if user.admin?
        can :manage, :all
      end
    end
  end
end

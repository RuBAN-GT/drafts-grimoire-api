class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :admin
      can :manage, :all

      can :access, :rails_admin
      can :dashboard
    else
      can :read, :all
    end

    if user.persisted?
      can :read, Card
      can :unread, Card
    end

    can :search, Card
  end
end

require 'grape'

module Rankings
  class API < Grape::API
    version 'v1', using: :path
    format :json

    desc 'top 10 for all scores'
    get :index do
      Rankings::Toplist.top(10, :all)
    end

    desc 'top 10 for overall points'
    get :overall do
      Rankings::Toplist.top(10, 'overall')
    end

    desc 'top 10 for xp points'
    get :xp do
      Rankings::Toplist.top(10, 'xp')
    end

    desc 'top 10 for might'
    get :might do
      Rankings::Toplist.top(10, 'might')
    end

    desc 'top 10 for honor points'
    get :honor do
      Rankings::Toplist.top(10, 'honor')
    end

  end
end


require_relative '../spec_helper'
require_relative '../../lib/rankings/config'
require_relative '../../lib/rankings/user'

Rankings::Config.redis = Redis.new

describe Rankings::User do

  it 'has a redis instance' do
    Rankings::User.redis.should_not be_nil
  end

  describe 'instance' do
    subject{ Rankings::User.create('123', 'John', {'overall' => 10}) }

    before do
      subject
    end

    it 'persists user' do
      Rankings::User.exists?('123').should be_true
    end

    it 'creates user' do
      subject.should_not be_nil
      subject.name.should eql 'John'
    end

    it 'finds user' do
      user = Rankings::User.find('123')
      user.should_not be_nil
      user.name.should eql 'John'
    end

    it 'adds points to user overall score' do
      subject.add('overall', 10)
      subject.scores['overall'].should eql 20
    end

    it 'deducts points from user overall score' do
      subject.deduct('overall', 10)
      subject.scores['overall'].should eql 0
    end

    it 'does not create existing user' do
      subject = Rankings::User.create('123', 'John', {'overall' => 100, 'xp' => 100})
      subject.should be_nil
    end

    it 'creates user with scores' do
      subject = Rankings::User.create('345', 'Bob', {'overall' => 100, 'xp' => 100})
      subject.scores['overall'].should eql 100
      subject.scores['xp'].should eql 100
    end
  end

end

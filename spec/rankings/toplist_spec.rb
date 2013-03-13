require_relative '../spec_helper'

require_relative '../../lib/rankings/config'
require_relative '../../lib/rankings/user'
require_relative '../../lib/rankings/toplist'

Rankings::Config.redis = Redis.new

describe Rankings::Toplist do
  describe 'many users' do

    before do
      20.times do |i|
        points = rand(i*10).to_i+10
        Rankings::User.create(i, "User #{i}", { 'overall' => points, 'xp' => points, 'might' => points, 'honor' => points })
      end
    end

    it 'return nil if count <= 0' do
      Rankings::Toplist.top(0, 'overall').should be_nil
    end

    it 'return nil if type is unknown' do
      Rankings::Toplist.top(10, 'something').should be_nil
    end

    it 'finds top 10 users by overall score' do
      list = Rankings::Toplist.top(10, 'overall')
      (list[0].scores['overall'] >= list[1].scores['overall']).should be_true
      (list[1].scores['overall'] >= list[2].scores['overall']).should be_true
    end

    it 'finds top 10 users by honor score' do
      list = Rankings::Toplist.top(10, 'honor')
      (list[0].scores['overall'] >= list[1].scores['overall']).should be_true
      (list[1].scores['overall'] >= list[2].scores['overall']).should be_true
    end

    it 'finds top 10 users by xp score' do
      list = Rankings::Toplist.top(10, 'xp')
      (list[0].scores['overall'] >= list[1].scores['overall']).should be_true
      (list[1].scores['overall'] >= list[2].scores['overall']).should be_true
    end

    it 'finds top 10 users by might score' do
      list = Rankings::Toplist.top(10, 'might')
      (list[0].scores['overall'] >= list[1].scores['overall']).should be_true
      (list[1].scores['overall'] >= list[2].scores['overall']).should be_true
    end

    it 'finds all rankings as hash' do
      list = Rankings::Toplist.top(10, :all)
      list.should be_kind_of(Hash)
      list.keys.sort.should eql Rankings::User::TYPES.sort
    end

    it 'finds all rankings' do
      list = Rankings::Toplist.top(10, :all)

      overall = list['overall']
      (overall[0].scores['overall'] >= overall[1].scores['overall']).should be_true

      xp = list['xp']
      (xp[0].scores['xp'] >= xp[1].scores['xp']).should be_true

      honor = list['honor']
      (honor[0].scores['honor'] >= honor[1].scores['honor']).should be_true

      might = list['might']
      (might[0].scores['might'] >= might[1].scores['might']).should be_true
    end
  end
end

require 'spec_helper'

describe Topic do
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:bookmarks).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }


  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:title) }
  it { should_not validate_presence_of(:content) }
  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:content) }
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:comments_closed) }

  it "should have default hit value" do
    topic = create(:topic)
    topic.hit.should == Topic::DEFAULT_HIT
  end

  it "should send notifications to mentioned users" do
    user = create(:user)
    topic = create(:topic, :title => "@#{user.nickname} hello")
    user.unread_notification_count.should be > 0
  end

  it "should not create topic if any node's present" do
    node = create(:node)
    user = create(:user)

    topic = Topic.new(:title => 'Hello, world')
    topic.user = user
    result = topic.save
    result.should_not == true
  end

  it "should create topic if no nodes are present" do
    Node.destroy_all
    user = create(:user)

    topic = Topic.new(:title => 'Hello, world')
    topic.user = user
    result = topic.save
    result.should == true
  end
end

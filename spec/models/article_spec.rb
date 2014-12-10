require 'rails_helper'

describe Article do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :content }
    it { should validate_presence_of :author_id }
  end
  describe "associations" do
    # Choose a style and stick to it. This goes for spacing, too.
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should belong_to(:author).class_name("User") }

    it { should have_many(:topics) }
    it { should have_many(:genre_topics) }
    it { should have_many(:game_topics) }
    it { should have_many(:console_topics) }
  end
end

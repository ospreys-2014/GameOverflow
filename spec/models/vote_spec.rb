require 'rails_helper'

describe Vote do
  describe "validations" do
    it { should validate_presence_of :voter_id }
    it { should validate_presence_of :voteable }
    it { should validate_uniqueness_of(:voter_id).scoped_to(:voteable_id) }
  end
  describe "associations" do
    it { should belong_to(:voter).class_name("User") }
    it { should belong_to :voteable }
  end
end
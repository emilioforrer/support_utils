require 'spec_helper'
require 'publisher_spec'
require 'subscriber_spec'
require 'support_utils'

describe "GEM" do

  let(:main_module) { SupportUtils }
  let(:publisher) { SupportUtils::PublisherTest }
  let(:subscriber) { SupportUtils::SubscriberTest }
  let(:logger) { Rails.logger }

  let(:user){ create(:user) }

  context "When broadcast event 'test_event'" do
    it do
      data = {}
      logger.debug "\nBEFORE EVENT\n"
      logger.debug "\n\nDATA: #{data.inspect}\n\n"
      expect {
        subscriber.subscribe_to('support_utils_test')
        publisher.broadcast_event('test_event', data: data)
     }.to change { data }.from({})
     logger.debug "\nAFTER EVENT\n"
     logger.debug "\n\nDATA: #{data.inspect}\n\n"
    end
  end

  context "When Module is loaded" do
    it do
      expect{main_module}.not_to raise_error
    end
  end

  context "When User is loaded" do
    it do
      expect{user}.not_to raise_error
    end
  end

  context "When Valid User is saved" do
    it do
      expect(user.save).to be_truthy
    end
  end

  context "When Invalid User is saved" do
    it do
      user.email = nil
      expect(user.save).to be_falsey
    end
  end

  context "When Valid User is updated" do
    it do
      expect(user.update_attributes(email: Faker::Internet.email)).to be_truthy
    end
  end

  context "When Invalid User is updated" do
    it do
      expect(user.update_attributes(email: nil)).to be_falsey
    end
  end

  describe 'User#utils' do
    it do
      expect(user.utils).to  be_instance_of(SupportUtils::Core::ActiveRecord::Utils)
    end
  end

  describe 'User#utils#parse_time' do

    context "when parse a valid date" do
      it do
        expect(user.utils.parse_time("2015-04-16")).to be_kind_of(::Time)
      end
    end

    context "when parse a invalid date" do
      it do
        expect(user.utils.parse_time "2015-99-99").to  be_nil
      end
    end

  end


end

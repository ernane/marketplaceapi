require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe '#current_user' do
    before do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] = @user.auth_token
      authentication.stub(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe '#authenticate_with_token' do
    before do
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(authentication).to receive(:render) do |args|
        args
      end
    end

    it 'returns error' do
      expect(authentication.authenticate_with_token![:json][:errors]).to eq 'Not authenticated'
    end

    it 'returns unauthorized status' do
      expect(authentication.authenticate_with_token![:status]).to eq :unauthorized
    end
  end

  describe '#user_signed_in?' do
    context "when there is a user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        authentication.stub(:current_user).and_return(@user)
      end

      it { expect(authentication.user_signed_in?).to be_truthy }
    end

    context "when there is no user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        authentication.stub(:current_user).and_return(nil)
      end

      it { expect(authentication.user_signed_in?).to be_falsey }
    end
  end
end

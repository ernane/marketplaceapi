# frozen_string_literal: true
require 'spec_helper'

describe Api::V1::OrdersController do
  describe 'GET #index' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, user_id: current_user.id
    end

    it 'returns 4 order records from the user' do
      orders_response = json_response[:orders]
      expect(orders_response.length).to eq(4)
    end

    it { should respond_with 200 }
  end
end

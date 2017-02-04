ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'simplecov'
require 'email_spec'
SimpleCov.start

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include Rails.application.routes.url_helpers
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include(Shoulda::Matchers::ActionController, type: :controller)
  config.include(Devise::Test::ControllerHelpers, type: :controller)
  config.include(Request::JsonHelpers, type: :controller)
  config.include(Request::HeadersHelpers, type: :controller)
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.before(:each, type: :controller) do
    include_default_accept_headers
  end

  config.fuubar_progress_bar_options = { format: 'Progress %c/%C <%B> %p%% %a' }
end

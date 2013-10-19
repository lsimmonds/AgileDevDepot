require 'test_helper'

class AdminStoriesTest < ActionDispatch::IntegrationTest
  #A User has tried to access an order with an invalid id
  #Sent an email to the admin telling then of this occurance
  test "accessing invalid object" do
    get "/orders/-1"
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["lsimmonds@reachlocal.com"], mail.to
    assert_equal 'system_error@depot.com', mail[:from].value
    assert_equal "Object Access Error Occured", mail.subject
  end

end

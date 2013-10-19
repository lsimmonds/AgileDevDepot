require 'test_helper'

class AdminNotifierTest < ActionMailer::TestCase
  test "not_found_error" do
    params = {id: -1, test: "lalalala"}
    mail = AdminNotifier.not_found_error params
    assert_equal ["lsimmonds@reachlocal.com"], mail.to
    assert_equal 'system_error@depot.com', mail[:from].value
    assert_equal "Object Access Error Occured", mail.subject
  end

end

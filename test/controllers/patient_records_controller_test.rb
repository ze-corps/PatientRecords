require 'test_helper'

class PatientRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get patient_records_index_url
    assert_response :success
  end

  test "should get import" do
    get patient_records_import_url
    assert_response :success
  end

end

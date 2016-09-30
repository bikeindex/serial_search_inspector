shared_context :log_line_fixtures do
  let(:log_line_fixture) { Rails.root.join('spec', 'fixtures', 'log_line.json') }
  let(:log_line_fixture_single_serial) { Rails.root.join('spec', 'fixtures', 'log_line_parse_log_single_serial.json') }
  let(:log_line_fixture_empty_serial) { Rails.root.join('spec', 'fixtures', 'log_line_parse_log_empty_serial.json') }
  let(:log_line_fixture_no_serial) { Rails.root.join('spec', 'fixtures', 'log_line_parse_log_no_serial.json') }
  let(:log_line_fixture_dirty_serial) { Rails.root.join('spec', 'fixtures', 'log_line_dirty_serial.json') }
  let(:log_line_fixture_attributes_from_entry) { Rails.root.join('spec', 'fixtures', 'log_line_attributes_from_entry.json') }
  let(:log_line_fixture_find_search_source_html) { Rails.root.join('spec', 'fixtures', 'log_line_find_source_html.json') }
  let(:log_line_fixture_find_search_source_apiv1) { Rails.root.join('spec', 'fixtures', 'log_line_find_source_apiv1.json') }
  let(:log_line_fixture_find_search_source_apiv2) { Rails.root.join('spec', 'fixtures', 'log_line_find_source_apiv2.json') }
  let(:log_line_fixture_find_search_source_apiv3) { Rails.root.join('spec', 'fixtures', 'log_line_find_source_apiv3.json') }
  let(:log_line_fixture_find_search_type_widget) { Rails.root.join('spec', 'fixtures', 'log_line_find_type_widget.json') }
  let(:log_line_fixture_find_search_type_multi) { Rails.root.join('spec', 'fixtures', 'log_line_find_type_multi.json') }
  let(:log_line_fixture_find_search_type_nil) { Rails.root.join('spec', 'fixtures', 'log_line_find_type_nil.json') }
  let(:log_line_fixture_serial_length_shorter) { Rails.root.join('spec', 'fixtures', 'log_line_check_length_shorter.json') }
  let(:log_line_fixture_serial_length_ok) { Rails.root.join('spec', 'fixtures', 'log_line_check_length_ok.json') }
  let(:log_line_fixture_find_location_present) { Rails.root.join('spec', 'fixtures', 'log_line_find_location_present.json') }
  let(:log_line_fixture_find_location_not_present) { Rails.root.join('spec', 'fixtures', 'log_line_find_location_not_present.json') }
  let(:log_line_fixture_find_location_empty_string) { Rails.root.join('spec', 'fixtures', 'log_line_find_location_empty_string.json') }
  let(:log_line_fixture_find_request_at) { Rails.root.join('spec', 'fixtures', 'log_line_find_request_at.json') }
end

shared_context :log_file_fixtures do
  let(:papertrail_log_fixture_path) { Rails.root.join('spec', 'fixtures', 'papertrail_output.log') }
end

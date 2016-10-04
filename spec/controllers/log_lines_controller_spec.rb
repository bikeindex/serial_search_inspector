require 'rails_helper'

RSpec.describe LogLinesController, type: :controller do
  describe 'create' do
    context 'valid payload' do
      let(:payload) do
        {
          events: [
            {
              id: 7711561783320576,
              received_at: '2011-05-18T20:30:02-07:00',
              display_received_at: 'May 18 20:30:02',
              source_ip: '208.75.57.121',
              source_name: 'abc',
              message: '{"method":"GET","path":"/bikes","format":"html","controller":"BikesController","action":"index","status":200,"duration":1176.41,"view":49.69,"db":1113.07,"remote_ip":"107.57.240.125","params":{"utf8":"✓","serial":"5903706","button":"","location":"","distance":"100","stolenness":""},"@timestamp":"2016-09-29T10:30:51.774Z","@version":"1","message":"[200] GET /bikes (BikesController#index)"}'
            },
            {
              id: 77115617833205712,
              received_at: '2016-09-18T20:30:02-07:00',
              display_received_at: 'May 18 20:30:02',
              source_ip: '208.75.57.121',
              source_name: 'abc',
              message: '{"status":200,"method":"GET","path":"/api/v2/bikes_search/stolen","params":{"per_page":"10","widget_from":"bikeindex.org","serial":"Marin"},"remote_ip":"66.87.163.118","format":"json","db":936.9,"view":11.690000000000055,"duration":948.59}'
            }
          ],
          saved_search: {
            id: 42,
            name: 'serial search',
            query: 'serial',
            html_edit_url: 'https://papertrailapp.com/searches/42/edit',
            html_search_url: 'https://papertrailapp.com/searches/42'
          },
          max_id: 7711582041804800,
          min_id: 7711561783320576
        }
      end
      it 'receives payload of logs' do
        expect do
          post :create, payload: payload.to_json, headers: { 'Content-Type' => 'application/json' }
        end.to change(LogLine, :count).by 2
        log_line = LogLine.first # with @timestamp
        log_line_2 = LogLine.last # without @timestamp
        expect(log_line.request_at).to be_within(1.second).of Time.parse('2016-09-29T10:30:51.774Z')
        expect(log_line.entry_ip_address).to eq '107.57.240.125'
        expect(log_line_2.request_at).to be_within(1.second).of Time.parse('2016-09-18T20:30:02-07:00')
        expect(log_line_2.entry_ip_address).to eq '66.87.163.118'
      end
    end
    context 'invalid payload' do
      let(:payload) { { hampsters: [franky: 5, abigail: 'apples'], snakes: 'ibis' } }
      xit 'returns correct error code' do
        post :create, payload: payload.to_json, headers: { 'Content-Type' => 'application/json' }
        expect(response.status).to eq 400
      end
    end
  end
end

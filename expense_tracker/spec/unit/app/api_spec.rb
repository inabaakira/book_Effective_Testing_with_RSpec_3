require_relative '../../../app/api'
require_relative '../../../app/xml'
require 'rack/test'
require 'logger'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:parsed_from_json) { JSON.parse(last_response.body) }
    let(:parsed_gotten_from_xml) { xml_get_response_to_obj(last_response.body) }
    let(:parsed_posted_from_xml) { xml_post_response_to_obj(last_response.body) }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { { 'some' => 'data' } }
        let(:expense_in_xml) { '<some>data</some>' }
        before do
          allow(ledger).to receive(:record)
                             .with(expense)
                             .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense_id as JSON' do
          post '/expenses', JSON.generate(expense)
          expect(parsed_from_json).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK) for the request in JSON' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end

        it 'returns the expense_id as XML' do
          header "Content-Type", "text/xml"
          post '/expenses', expense_in_xml
          expect(parsed_posted_from_xml).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK) for the request in XML' do
          header "Content-Type", "text/xml"
          post '/expenses', expense_in_xml
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { { 'some' => 'data' } }
        let(:expense_in_xml) { "<some>data</some>" }

        before do
          allow(ledger).to receive(:record)
                             .with(expense)
                             .and_return(RecordResult.new(false, 417,
                                                          'Expense incomplete'))
        end

        it 'returns an error message for JSON request' do
          post '/expenses', JSON.generate(expense)
          expect(parsed_from_json).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity) for JSON request' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end

        it 'returns an error message in xml for XML request' do
          header 'Content-Type', 'text/xml'
          post '/expenses', expense_in_xml
          expect(parsed_posted_from_xml).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity) for XML request' do
          header "Content-Type", 'text/xml'
          post '/expenses', expense_in_xml
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
                             .with('2019-08-13')
                             .and_return(['expense_1', 'expense_2'])
        end

        it 'returns the espense record as JSON' do
          get '/expenses/2019-08-13'
          expect(parsed_from_json).to eq(['expense_1', 'expense_2'])
        end

        it 'responds with a 200 (OK) for JSON request' do
          get '/expenses/2019-08-13'
          expect(last_response.status).to eq(200)
        end

        it 'returns the expense record as XML' do
          header 'Accept', 'text/xml'
          get '/expenses/2019-08-13'
          expect(parsed_gotten_from_xml).to eq(['expense_1', 'expense_2'])
        end

        it 'responds with a 200 (OK) for XML request' do
          header 'Accept', 'text/xml'
          get '/expenses/2019-08-13'
          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
                             .with('2019-08-13')
                             .and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2019-08-13'
          expect(parsed_from_json).to eq([])
        end

        it 'responds with a 200 (OK) for JSON request' do
          get '/expenses/2019-08-13'
          expect(last_response.status).to eq(200)
        end

        it 'returns an empty array as XML' do
          header 'Accept', 'text/xml'
          get '/expenses/2019-08-13'
          expect(parsed_gotten_from_xml).to eq([])
        end

        it 'responds with a 200 (OK) for XML request' do
          header 'Accept', 'text/xml'
          get '/expenses/2019-08-13'
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end

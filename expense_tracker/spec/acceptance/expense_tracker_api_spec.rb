require 'rack/test'
require 'json'
require_relative '../../app/api'
require_relative '../../app/xml'
require 'logger'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API', :db do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense_in_json(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    def post_expense_in_xml(expense)
      xml_post_request = build_xml_post_request(expense)
      header 'Content-Type', 'text/xml'
      post '/expenses', xml_post_request
      xml_post_response = xml_post_response_to_obj(last_response.body)
      expense.merge("id" => xml_post_response['expense_id'])
    end

    it 'records submitted expense' do
      coffee = post_expense_in_json(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )

      zoo = post_expense_in_json(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      )

      groceries = post_expense_in_json(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      )

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)

      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end

    it 'recods submitted expense in XML' do
      coffee = post_expense_in_xml(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )

      zoo = post_expense_in_xml(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      )

      groceries = post_expense_in_xml(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      )

      header 'Accept', 'text/xml'
      get '/expenses/2017-06-10'
      expect(xml_get_response_to_obj(last_response.body)).to contain_exactly(coffee, zoo)
    end
  end
end

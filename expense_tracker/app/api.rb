require 'sinatra/base'
require 'json'
require_relative 'ledger'
require_relative 'xml'

module ExpenseTracker
  class API < Sinatra::Base
    attr_reader :ledger

    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do
      pass if request.content_type == "text/xml"
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    post '/expenses' do
      pass if request.content_type != "text/xml"
      result = @ledger.record(xml_post_request_to_obj(request.body.read))

      if result.success?
        "<expense_id>#{result.expense_id}</expense_id>"
      else
        status 422
        "<error>#{result.error_message}</error>"
      end
    end

    get '/expenses/:date' do
      pass unless request.accept? "application/json"
      JSON.generate(@ledger.expenses_on(params['date']))
    end

    get '/expenses/:date' do
      pass unless request.accept? "text/xml"

      res = @ledger.expenses_on(params['date'])
      build_xml_get_response(res)
    end
  end
end

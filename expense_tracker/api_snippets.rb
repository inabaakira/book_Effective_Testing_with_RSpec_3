class API < Sinatra::Base
  def initialize(ledger: Ledger.new)
    @ledger = ledger
    super() # rest of initialization from Sinatra
  end
end

# Later, caller do this:
app = API.new

# Pseudocode for what happens inside the API class:
result = @ledger.record({ 'some' => 'data' })
result.success?
result.expense_id
result.error_message

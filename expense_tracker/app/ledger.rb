module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(message)
    end

    def expenses_on(date)
    end
  end
end

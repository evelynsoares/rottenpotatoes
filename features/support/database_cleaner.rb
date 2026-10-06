# The :transaction strategy (env.rb) only rolls back what each scenario
# creates; rows already in the test database (e.g. fixtures loaded by
# `bin/rails test`) would leak into every scenario. Start from an empty
# database so steps like "I should see all of the movies" only count the
# movies created by the scenario itself.
BeforeAll do
  DatabaseCleaner.clean_with(:truncation)
end

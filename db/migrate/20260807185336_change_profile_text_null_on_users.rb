class ChangeProfileTextNullOnUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :profile_text, true
  end
end

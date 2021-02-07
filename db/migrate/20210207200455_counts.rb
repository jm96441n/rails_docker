# frozen_string_literal: true

# Counts is the migration for the counter record
class Counts < ActiveRecord::Migration[6.0]
  def change
    create_table :counts do |t|
      t.integer :user_count, default: 0
      t.timestamps
    end
  end
end

class CreateDelayedJobs < ActiveRecord::Migration
  def up
    create_table :delayed_jobs do |table|
      table.timestamps
      table.integer :priority, default: 0, null: false
      table.integer :attempts, default: 0, null: false
      table.text :handler, null: false
      table.text :last_error
      table.datetime :run_at
      table.datetime :locked_at
      table.datetime :failed_at
      table.string :locked_by
      table.string :queue
    end

    add_index :delayed_jobs, [:priority, :run_at], name: 'delayed_jobs_priority'
  end

  def down
    drop_table :delayed_jobs
  end
end

#File: hw2-part2.rb
require "active_record"

# Connection to SQLite3
ActiveRecord::Base::establish_connection(:adapter => "sqlite3", :database => "reminders.sqlite")

# Define database schema , and create database " people "
class ReminderTable < ActiveRecord::Migration
	def self.up
		create_table :reminders do | t |
			t.text :task
			t.date :due_date
			t.boolean :accomplished
		end
	end

	def self.down
		drop_table :reminders
	end
end

# Store the reminder record
ReminderTable.up

class Reminder < ActiveRecord::Base

	def initialize( task, due_date)
		super()		
		self.task = task
		self.due_date = due_date
		self.accomplished = false
		self.save
	end

	def due_tomorrow?
		self.due_date == Date.tomorrow
	end

	def enter_task task
		self.task = task
		self.save
		return self
	end

	def enter_date user_date
		self.due_date = user_date
		self.save
		return self
	end

	def compleated
		self.accomplished = true
		self.save
		return self
	end

end

def overdue
	Reminder.find(:all, :conditions => [ "due_date < ? AND comp = ?", Date.today, false])
end

def due_on str
	date_str = Date.parse str	
	Reminder.find(:all, :conditions => [ "due_date = ?", date_str])
end

def due_tomorrow
	Reminder.find(:all, :conditions => [ "due_date = ?", Date.tomorrow])
end

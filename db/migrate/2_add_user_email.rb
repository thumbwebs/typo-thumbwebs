class AddUserEmail < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :text
    add_column :users, :name, :text

    User.find(:all).each do |u|
      u.name=u.login
      u.save
    end
  end

  def self.down
    remove_column :users, :email
    remove_column :users, :text
  end
end
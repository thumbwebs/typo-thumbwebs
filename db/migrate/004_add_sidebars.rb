class Bare4Sidebar < ActiveRecord::Base
  include BareMigration

  # there's technically no need for these serialize declaration because in
  # this script active_config and staged_config will always be NULL anyway.
  serialize :active_config
  serialize :staged_config
end

class AddSidebars < ActiveRecord::Migration
  def self.up
    STDERR.puts "Creating sidebars"
    Bare4Sidebar.transaction do
      create_table :sidebars do |t|
        t.column :controller, :string
        t.column :active_position, :integer
        t.column :active_config, :text
        t.column :staged_position, :integer
        t.column :staged_config, :text
      end

      Bare4Sidebar.create(:active_position=>0, :controller=>'page', :active_config=>'--- !map:HashWithIndifferentAccess 
      maximum_pages: "10"')
      Bare4Sidebar.create(:active_position=>1, :controller=>'category', :active_config=>'--- !map:HashWithIndifferentAccess 
      empty: false
      count: true')
      Bare4Sidebar.create(:active_position=>2, :controller=>'archives', :active_config=>'--- !map:HashWithIndifferentAccess 
      show_count: true
      count: "10"')
      Bare4Sidebar.create(:active_position=>3, :controller=>'static', :active_config=>'--- !map:HashWithIndifferentAccess 
      title: Links
      body: |+
        <ul>
          <li><a href="http://www.typosphere.org" title="Typo">Typo</a></li>
          <li><a href="http://blog.typosphere.org" title="Typo official blog">Typo official blog</a></li>
          <li><a href="http://scottstuff.net" title="Scottstuff">Scott Laird</a></li>
          <li><a href="http://www.bofh.org.uk" title="Just a Summary">Piers Cawley</a></li>
          <li><a href="http://kevin.sb.org/">Kevin Ballard</a></li>
          <li><a href="http://fredericdevillamil.com">Frédéric de Villamil</a></li>
          <li><a href="http://typoforums.org" title="Typo Forums">Typo Forums</a></li>
        </ul>')
      Bare4Sidebar.create(:active_position=>4, :controller=>'xml', :active_config=>'--- !map:HashWithIndifferentAccess 
      format: rss20
      trackbacks: true
      comments: true
      articles: true')
    end
  end

  def self.down
    drop_table :sidebars
  end
end



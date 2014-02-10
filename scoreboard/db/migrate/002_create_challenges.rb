migration 2, :create_challenges do
  up do
    create_table :challenges do
      column :id, Integer, :serial => true
      column :title, DataMapper::Property::Text
      column :body, DataMapper::Property::Text
      column :link, DataMapper::Property::Text
      column :category, DataMapper::Property::Text
      column :points, DataMapper::Property::Integer
      column :flag, DataMapper::Property::Text
      column :visible, DataMapper::Property::Boolean
    end
  end

  down do
    drop_table :challenges
  end
end

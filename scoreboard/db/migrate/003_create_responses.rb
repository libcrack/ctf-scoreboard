migration 3, :create_responses do
  up do
    create_table :responses do
      column :id, Integer, :serial => true
      column :title, DataMapper::Property::Text
      column :team, DataMapper::Property::Text
      column :challengeid, DataMapper::Property::Integer
      column :flag, DataMapper::Property::Text
    end
  end

  down do
    drop_table :responses
  end
end

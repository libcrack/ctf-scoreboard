migration 4, :create_solves do
  up do
    create_table :solves do
      column :id, Integer, :serial => true
      column :title, DataMapper::Property::Text
      column :team, DataMapper::Property::Text
      column :challengeid, DataMapper::Property::Integer
      column :points, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :solves
  end
end

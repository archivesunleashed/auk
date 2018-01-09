class CreateWasapiFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :wasapi_files do |t|
      t.string :checksum_md5
      t.string :checksum_sha1
      t.string :filetype
      t.integer :size, :limit => 8
      t.string :filename
      t.string :crawl_time
      t.string :crawl_start
      t.integer :crawl
      t.integer :account
      t.integer :collection_id
      t.string :location_archive_it
      t.string :location_internet_archive

      t.timestamps
    end
  end
end

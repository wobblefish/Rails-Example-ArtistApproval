class CreateArtistApprovalStatuses < ActiveRecords::Migration
	def self.up
		create_table :artist_approval_statuses do |t|
			t.string :title
			t.integer :organization_id
		end

		add_column :artists, :artist_approval_status_id, :integer

		#after creating the new artist_approval_status table, loop through the old hardcoded values and recreate them for each organization

		FestivalOrganization.all.each do |org, index|
			ARTIST_ACCEPTANCE.each do |label, value|
				next if value == 0
				@approval_status = ArtistApprovalStatus.new
				@approval_status.title = label
				@approval_status.organization_id = org.id
				@approval_status.save
				execute("UPDATE artists SET artists.artist_approval_status_id = #{@approval_status_id} WHERE organization_id = #{@approval_status.organization_id} and artists.accepted = #{value}")
			end
		end

		execute("UPDATE artists SET artists.artist_approval_status_id = '' WHERE artists.accepted = 0")

		remove_column :artists, :accepted
	end

	def self.down
		drop_table :artist_approval_statuses
	end
end
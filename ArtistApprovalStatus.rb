class ArtistApprovalStatus < ActiveRecord::Base

	belongs_to :organization
	has_many :artists, :dependent => :nullify
	named_scope :organization, lambda { |organization| { :conditions => ["organization_id = ?", organization], :order => "title"} }
	validates_presence_of :title, :organization_id

	#This method returns true if the title of the status matches one of the two required statuses ("Approved" and "Rejected")
	def required_approval_status?
		if self.title == "Approved" or self.title == "Rejected"
			return true
		end
	end

end
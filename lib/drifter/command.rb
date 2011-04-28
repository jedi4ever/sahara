require 'drifter/session'

module Drifter
	class Command < Vagrant::Command::GroupBase
	  register "sandbox","Manages a sandbox"

	  desc "status [NAME]", "Shows the status of the sandbox"
	  def status(boxname=nil)
	    Drifter::Session.status(boxname)
	  end

	  desc "on [NAME]", "Enters sandbox state"
	  def on(boxname=nil)
	    Drifter::Session.on(boxname)
	  end

	  desc "commit [NAME]", "Commits changes - moves sandbox initial state to currentstate"
	  def commit(boxname=nil)
	    Drifter::Session.commit(boxname)
	  end

	  desc "rollback [NAME]", "Rollback changes since sandbox state was entered "
	  def rollback(boxname=nil)
	    Drifter::Session.rollback(boxname)
	  end
	  
	  desc "off [NAME] ", "Leaves sandbox state"
	  def off(boxname=nil)
	    Drifter::Session.off(boxname)
	  end
    
	end
end

class DatabaseNotifications < ApplicationJob

	def perform
		ActiveRecord::Base.connection_pool.with_connection do |connection|
		  	conn = connection.instance_variable_get(:@connection)
		  	begin
		  	    conn.async_exec "LISTEN trigger_changes"
		  	    loop do
		  	      	conn.wait_for_notify do |channel, pid, payload|
		  	        puts "Received NOTIFY on channel #{channel} with payload: #{payload}"
		  	        notif = Notification.create(event: channel, payload: {})
		  	    end
		  	end
		  	ensure
		  		conn.async_exec "UNLISTEN *"
		  	end
	  	end  
	end
end
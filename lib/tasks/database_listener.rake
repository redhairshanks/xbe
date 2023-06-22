desc "Running DatabaseNotifications Job"
task database_listener: :environment do 
	DatabaseNotifications.perform_later
end
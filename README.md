# README

## To run the code
- Clone the repository
- Change directory to xbe `cd xbe` 
- Install dependencies `bundle install`
- You need a postgres server running with username as 'root' and password as 'root' and database xbe with root getting all privileges
- Create database `rake db:create`
- Install db changes `rake db:migrate`
- In new terminal run to start sidekiq `bundle exec sidekiq -e development -C config/sidekiq.yml`
- In new terminal run `rake database_listener`

## Gems used
1. gem 'hairtrigger', '~> 1.0' // For creating triggers within rails env
2. gem 'sidekiq', '~> 7.1', '>= 7.1.2' # For background processes
3. gem "rspec-rails" # For testing.

## Models
1. Invoices - id (uuid), invoice_no(string), total_amount(int), timestamps
2. Invoice_items - id(uuid), invoice_id(foreign_key), quantity(int), amount_per_unit(int), total_amount(int), timestamps
   - Triggers on create, update, delete
   - Every trigger contains pg_notify which sends messages on 'trigger_changes' channel
3. Notifications - event(string), payload(json)

## Rake Tasks
1. database_listener - This queues DatabaseNotifications background job which in turn listens to pg_notify()

## My thought process
- Have used postgres triggers as we need the application to get notified even if changes are directly done on database 
- Installed hair-trigger gem which lets me create triggers in model files itself
- 3 tables - invoice, invoice_items(references invoice table via foreign key), notifications
- In invoice_item.rb file I have created triggers when quantity, amount_per_unit changes for invoice_item. It changes total_amount in invoice_table. 
- The invoice_items trigger also use pg_notify() for inter-process communication and sends message to rails application
- Created an ApplicationJob which uses Sidekiq and listens to pg_notify commands. It also writes to Notifications table whenever a prompt is received. 
- Created rake task "database_listener" which queues the above job
- Have written just 1 rspec test but have could not proceed for paucity of time. 
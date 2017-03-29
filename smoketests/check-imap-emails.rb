#!/usr/bin/env ruby
require 'net/imap'

timespan = 120 # in sec
imap_server = ENV['IMAP_SERVER'] || 'imap-mail.outlook.com'
imap_user = ENV.fetch('IMAP_USER')
imap_password = ENV.fetch('IMAP_PASSWORD')
env_name = ENV.fetch('ENVIRONMENT_NAME')

def bye()
  @imap.logout()
  @imap.disconnect()
end

@imap = Net::IMAP.new(imap_server, port: 993, ssl: true)
@imap.login(imap_user, imap_password)
@imap.select('INBOX')
msg_ids = @imap.search(['SUBJECT',"#{env_name} notifications smoketest", 'UNSEEN'])
if msg_ids.empty?
  STDERR.puts "No new mail found"
  bye
  exit 1
else
  STDERR.puts "found the following msg: #{msg_ids}"
end

latest_id = msg_ids.last

# set flags as SEEN.
@imap.store(msg_ids, "+FLAGS", [:Seen])

mail = @imap.fetch(latest_id,"BODY[HEADER.FIELDS (SUBJECT)]").first
bye
subject = mail.attr.values.first
now = Time.now.to_i
timestamp = subject.scan(/\d{10}/).first
if timestamp.nil?
  STDERR.puts "No timestamp find in email subject, please check email format."
  exit 1
end

if timestamp.to_i < now - timespan
  STDERR.puts "The latest email I can find is older than #{timespan} seconds old."
  exit 1
else
  STDERR.puts "Email received :)"
end

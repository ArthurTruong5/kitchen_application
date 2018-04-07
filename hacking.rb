#! /usr/bin/env ruby

# NOTE: Requires Ruby 2.1 or greater.

# This script can be used to parse and dump the information from
# the 'html/contact_info.htm' file in a Facebook user data ZIP download.
#
# It prints all cell phone call + SMS message + MMS records, plus a summary of each.
#
# It also dumps all of the records into CSV files inside a 'CSV' folder, that is created
# in whatever the working directory of the program is when executed.
#
# Place this script inside the extracted Facebook data download folder
# alongside the 'html' folder.
#
# This script requires Ruby and the Nokogiri library to be installed.
#
# Open source licensing
# ---------------------
#
# Dual-licensed under the MIT and Apache 2.0 open source licenses. Either license can be chosen
# by any user of the program.
#
# The MIT license is duplicated here, the Apache 2.0 license can be found here
# https://opensource.org/licenses/Apache-2.0
#
# The MIT License (MIT)
# Copyright (c) 2018 Dylan McKay
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'nokogiri'
require 'time'
require 'fileutils'

def hr
  $stdout.puts "-" * 24
end

def indent(level = 1)
  $stdout.print "   " * (level - 1)
  $stdout.flush
end

def section(title, level: 1)
  indent(level) and hr
  indent(level) and $stdout.puts title
  indent(level) and $stdout.puts
  yield
  indent(level) and hr
  indent(level) and $stdout.puts
end

# Extracts metadata from a call/text/sms/mms table
# Returns nil if there is no metadata in this table.
# Returns a 2d list of row/colums
def extract_table_metadata(metadata_table)
  headings = metadata_table.css('tr').first.css('th').map(&:text).map(&:chomp)
  records = metadata_table.css('tr')[1..-1]
  return nil if records.size <= 1 # many tables are empty (excluding headings).

  [headings] + records.map do |call_record|
    call_record.css('td').map(&:text).map(&:chomp).map do |field|
      if field.include? ' at ' # some fields are dates/times
        # Time example: "Wednesday, 14 June 2017 at 19:02 UTC+12"
        Time.strptime(field, "%A, %e %B %Y at %R UTC%z") rescue field
      else
        field # no special processing
      end
    end
  end
end

def dig_out_metadata(container:)
  # If a specific type of metadata is missing (calls, texts, ..), the
  # container div will simply not be present.
  return [] if container.nil?

  contact_tables = container.children.select { |c| c.name == "table" }

  contact_tables.map do |contact_table|
    metadata_table = contact_table.css('table')[0]
    extract_table_metadata(metadata_table)
  end.compact.select { |t| t.size > 1 } # must include non-header rows
end

def print_metadata(metadata, metadata_title:)
  section(metadata_title) do
    metadata.each do |phone_records|
      puts
      indent(2) and puts "Another phone number"
      puts
      phone_records.each do |record|
        indent(2) and puts record.join(", ")
      end
    end
  end
end

def print_timestamps(metadata, metadata_name:)
  timestamps = metadata.map { |r| r[1].to_s.chomp }.select { |s| s.size > 0 }.map do |t|
    begin
      Time.parse(t)
    rescue ArgumentError # do not parse timestamp if unparseable
      t
    end
  end

  if timestamps.size > 0
    puts "The oldest #{metadata_name} is from #{timestamps.min.to_date}, the most recent at #{timestamps.max.to_date}"
  end
end

def print_status_breakdown(metadata, metadata_name:)
  grouped_statuses = metadata.flatten(1).group_by(&:first)

  if grouped_statuses.size > 0
    puts "This includes " + grouped_statuses.map { |status,records| "#{records.size} #{status.downcase} #{metadata_name}"}.join(", ")
  end
end

def metadata_to_csv(metadata)
  metadata.flatten(1).map { |record| record.join(',') }.join("\n")
end

def dump_metadata_csv(html_doc)
  call_history_container = html_doc.xpath("//h2[text()='Call History']/following-sibling::div")[0]
  sms_history_container = html_doc.xpath("//h2[text()='SMS History']/following-sibling::div")[0]
  mms_history_container = html_doc.xpath("//h2[text()='MMS History']/following-sibling::div")[0]

  FileUtils.mkdir_p("csv")

  call_metadata = dig_out_metadata(:container => call_history_container)
  sms_metadata = dig_out_metadata(:container => sms_history_container)
  mms_metadata = dig_out_metadata(:container => mms_history_container)

  File.write(File.join("csv", "call.csv"), metadata_to_csv(call_metadata))
  File.write(File.join("csv", "sms.csv"), metadata_to_csv(sms_metadata))
  File.write(File.join("csv", "mms.csv"), metadata_to_csv(mms_metadata))
end

def print_metadata_human(html_doc)
  call_history_container = html_doc.xpath("//h2[text()='Call History']/following-sibling::div")[0]
  sms_history_container = html_doc.xpath("//h2[text()='SMS History']/following-sibling::div")[0]
  mms_history_container = html_doc.xpath("//h2[text()='MMS History']/following-sibling::div")[0]

  call_metadata = dig_out_metadata(:container => call_history_container)
  sms_metadata = dig_out_metadata(:container => sms_history_container)
  mms_metadata = dig_out_metadata(:container => mms_history_container)

  if call_history_container
    phone_numbers = call_history_container.xpath("//b[text()='Number:']/following-sibling::text()")
      .map(&:text).sort.uniq
  else
    phone_numbers = []
  end

  print_metadata(call_metadata, :metadata_title => "Call History")
  print_metadata(sms_metadata, :metadata_title => "SMS History")
  print_metadata(mms_metadata, :metadata_title => "MMS History")

  section("The full list of phone numbers that have stored data") do
    phone_numbers.each_slice(8).to_a.map { |g| g.join(", ") }.each do |line|
      indent(2) and $stdout.puts line
    end
  end

  $stdout.puts "A brief summary of phone records"
  hr
  $stdout.puts "There are phone records for #{phone_numbers.size} distinct phone numbers"
  $stdout.puts "There are records of #{call_metadata.flatten(1).size} distinct cell phone calls"
  indent(2) and print_timestamps(call_metadata, :metadata_name => "cell phone call")
  indent(2) and print_status_breakdown(call_metadata, :metadata_name => "cell phone calls")
  $stdout.puts "There are records of #{sms_metadata.flatten(1).size} distinct SMS messages"
  indent(2) and print_timestamps(sms_metadata, :metadata_name => "SMS message")
  indent(2) and print_status_breakdown(sms_metadata, :metadata_name => "SMS messages")
  $stdout.puts "There are records of #{mms_metadata.flatten(1).size} distinct MMS messages"
  indent(2) and print_timestamps(mms_metadata, :metadata_name => "MMS message")
  indent(2) and print_status_breakdown(mms_metadata, :metadata_name => "MMS messages")
  hr
end

html_text = File.read('html/contact_info.htm')
html_doc = Nokogiri::HTML(html_text)

print_metadata_human(html_doc)

$stdout.puts
hr
$stdout.puts "dumped metadata to CSV files at #{Dir.pwd}/csv"
dump_metadata_csv(html_doc)

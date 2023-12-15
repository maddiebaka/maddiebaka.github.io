#!/usr/bin/env ruby

require 'date'
require 'yaml'
require 'pathname'

filename_title = ARGV.join('-').downcase
title = ARGV.join(' ')

header = {
  'layout' => 'single',
  'title' => title,
  'date' => DateTime.now.to_s,
  'categories' => "#TODO fill me in",
}.to_yaml.gsub("'", "")

filename = Date.today.strftime("%Y-%m-%d-#{filename_title}.markdown")
pathname = Pathname.new("_posts").join(filename)

post_file = File.open(pathname, 'w')

post_file.write(header)
post_file.write("---")
post_file.write("\n\n#TODO Write your post here.")

post_file.close()

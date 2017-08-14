#!/usr/bin/env ruby
require 'fileutils'

def backup_and_patch(path, from_pattern, to_pattern)
  lines = File.open(path).read.lines
  from = lines.find_index {|l| l.match(from_pattern)}
  if from == nil
    STDERR.puts "#{path} seems already patched, skipping..."
    return
  end
  to = lines.find_index {|l| l.match(to_pattern)}
  STDERR.puts "backup the file #{path}"
  FileUtils.cp(path, path+'.bak')
  (from...to).each { |i| lines[i] = '#'+lines[i] }
  File.open(path, 'w+') {|f| f.write(lines.join)}
end

path='/home/tempest-web/tempest/web/app/models/tempest/installation_steps/product_install_builder.rb'
from_pattern = '^ .*InstallationSteps::DeployProduct.new'
to_pattern = 'CompoundStep.new'
backup_and_patch(path,from_pattern, to_pattern)

path='/home/tempest-web/tempest/web/app/models/tempest/installation_steps/clean_up_bosh.rb'
from_pattern = '^ .*BaseStep.with_step_info'
to_pattern = ']'
backup_and_patch(path,from_pattern, to_pattern)


# inject neutered key
path = '/home/tempest-web/tempest/web/app/controllers/api/v0/diagnostic_report_controller.rb'
from_pattern = "versions: versions"
lines = File.open(path).read.lines
from = lines.find_index {|l| l.match(from_pattern)}
if lines[from].match("neutered")
  STDERR.puts("neutered key is already there. skipping ...")
else
  lines[from]="          neutered: true, versions: versions,\n"
  STDERR.puts "backup the file #{path}"
  FileUtils.cp(path, path+'.bak')
  File.open(path, 'w+') {|f| f.write(lines.join)}
end

STDERR.puts "opsman neutered"

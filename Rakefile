require 'rake/packagetask'
require "digest/md5"

PROJECT = 'objectlua'
File.new('WhatsNew.txt').gets
PROJECT_VERSION = $_[/[0-9.]+/]
readme = File.new('Readme.txt')
SUMMARY  = readme.gets
readme.gets ''
DETAILED = $_.chomp

PACKAGE = "#{PROJECT}-#{PROJECT_VERSION}"
ARCHIVE = "pkg/#{PACKAGE}.tar.gz"

FILES = FileList.new('./**/*') do |list|
    list.exclude "#{PROJECT}*"
    list.exclude './pkg'
end

Rake::PackageTask.new(PROJECT, PROJECT_VERSION) do |p|
    p.need_tar_gz = true
    p.package_files = FILES
end

task :default => :test
task :all => [:package, :distcheck, :rockspec]

task :test do
    LUA_PATH_COMMAND = "package.path = package.path .. ';' .. '../src/?.lua'"
    sh "cd test && lua -e \"#{LUA_PATH_COMMAND}\" TestObjectLua.lua"
end

task :distcheck_clean do
    sh "rm -rf tmp"
end

task :distcheck => [ARCHIVE, :distcheck_clean] do
# 	mkdir -p tmp
# 	cd tmp && tar -xzf ../$(ARCHIVE)
# 	cd tmp/$(DISTDIR) && make test
# 	make distcheck-clean
end

# .PHONY: rockspec
task :rockspec do
    md5 = Digest::MD5.hexdigest(File.read ARCHIVE)
# 	sed "s/VERSION/$(PROJECT_VERSION)/g;\
# 	     s/SUMMARY/$(SUMMARY)/;\
# 	     s/DETAILED/$(DETAILED)/;\
# 	     s/MD5/$(md5)/"\
# 	  template.rockspec > $(PROJECT)-$(PROJECT_VERSION)-1.rockspec
# 	cat #{PACKAGE}-1.rockspec
end

task :rockspec_clean do
    sh "rm -f #{PROJECT}-*.rockspec"
end

task :clean => [:distcheck_clean, :rockspec_clean]

task :tag do
# 	svn copy . https://objectlua.googlecode.com/svn/tags/$(PROJECT_VERSION) -m '$(PROJECT_VERSION) version tag'
end

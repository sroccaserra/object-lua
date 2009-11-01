require 'rake/packagetask'
require 'digest/md5'
require 'erb'

PROJECT = 'objectlua'
PROJECT_VERSION = File.new('WhatsNew.txt').gets[/[0-9.]+/]
readme = File.new('Readme.txt')
SUMMARY  = readme.gets
readme.gets ''
DETAILED = $_.chomp

PACKAGE = "#{PROJECT}-#{PROJECT_VERSION}"
ARCHIVE = "pkg/#{PACKAGE}.tar.gz"

FILES = FileList.new('./**/*') do |files|
    files.exclude "#{PROJECT}*"
    files.exclude './pkg'
end

Rake::PackageTask.new(PROJECT, PROJECT_VERSION) do |p|
    p.need_tar_gz = true
    p.package_files = FILES
end

task :default => :test
task :all => [:package, :distcheck, :rockspec]

task :test do
    lua_path_command = "package.path = package.path .. ';' .. '../src/?.lua'"
    sh "cd test && lua -e \"#{lua_path_command}\" TestObjectLua.lua"
end

# task :distcheck_clean do
#     sh "rm -rf tmp"
# end

# task :distcheck => [ARCHIVE, :distcheck_clean] do
# # 	mkdir -p tmp
# # 	cd tmp && tar -xzf ../$(ARCHIVE)
# # 	cd tmp/$(DISTDIR) && make test
# # 	make distcheck-clean
# end

task :rockspec => ARCHIVE do
    $md5 = Digest::MD5.hexdigest(File.read ARCHIVE)
    template = File.new('rockspec.erb').read
    erb = ERB.new template
    rockspec = erb.result
    File.new("#{PACKAGE}-1.rockspec", 'w').write rockspec
end

task :rockspec_clean do
    sh "rm -f #{PROJECT}-*.rockspec"
end

task :clean => [:clobber_package, :rockspec_clean]

task :tag do
# 	svn copy . https://objectlua.googlecode.com/svn/tags/$(PROJECT_VERSION) -m '$(PROJECT_VERSION) version tag'
end

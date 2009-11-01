require 'rake/packagetask'
require 'digest/md5'
require 'erb'

Project = 'objectlua'
Project_version = File.new('WhatsNew.txt').gets[/[0-9.]+/]
readme = File.new('Readme.txt')
Summary  = readme.gets
readme.gets ''
Detailed = $_.chomp

Package = "#{Project}-#{Project_version}"
Archive = "pkg/#{Package}.tar.gz"

Files = FileList.new('./**/*') do |files|
    files.exclude "#{Project}*"
    files.exclude './pkg'
end

Rake::PackageTask.new(Project, Project_version) do |p|
    p.need_tar_gz = true
    p.package_files = Files
end

task :default => :test
task :all => [:package, :distcheck, :rockspec]

task :test do
    Lua_path_command = "package.path = package.path .. ';' .. '../src/?.lua'"
    sh "cd test && lua -e \"#{Lua_path_command}\" TestObjectLua.lua"
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

task :rockspec => Archive do
    $Md5 = Digest::MD5.hexdigest(File.read Archive)
    Template = File.new('rockspec.erb').read
    erb = ERB.new Template
    Rockspec = erb.result
    File.new("#{Package}-1.rockspec", 'w').write Rockspec
end

task :rockspec_clean do
    sh "rm -f #{Project}-*.rockspec"
end

task :clean => [:clobber_package, :rockspec_clean]

# task :tag do
# # 	sh "svn copy . https://objectlua.googlecode.com/svn/tags/$(PROJECT_VERSION) -m '$(PROJECT_VERSION) version tag'"
# end

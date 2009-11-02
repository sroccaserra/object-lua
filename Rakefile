require 'rake/packagetask'
require 'digest/md5'
require 'erb'

Project = 'objectlua'
Project_version = File.new('WhatsNew.txt').gets[/[0-9.]+/]

# Tasks

task :default => :test
task :all => [:package, :test_package, :rockspec]
task :clean => [:clobber_package, :rockspec_clean]

Package_task = Rake::PackageTask.new Project, Project_version do |p|
    p.need_tar_gz = true
    p.package_files = FileList.new './**/*' do |files|
        files.exclude './pkg'
        files.exclude './old'
    end
end

def test base_dir
    lua_path_command = "package.path = '../src/?.lua;' .. package.path"
    cd "#{base_dir}/test" do
        sh "lua -e \"#{lua_path_command}\" TestObjectLua.lua"
    end
end

task :test do
    test '.'
end

task :test_package => :package do
    test "pkg/#{Package_task.package_name}"
end

task :rockspec => :package do
    # Gather data from files...
    Md5 = Digest::MD5.hexdigest File.read "pkg/#{Package_task.tar_gz_file}"
    readme = File.new 'Readme.txt'
    readme.gets
    Summary  = $_.chomp
    readme.gets ''
    Detailed = $_.chomp

    Template = File.new('rockspec.erb').read
    erb = ERB.new Template
    Rockspec = erb.result
    File.new("pkg/#{Package_task.package_name}-1.rockspec", 'w').write Rockspec
end

task :rockspec_clean do
    rm_f "pkg/#{Project}-*.rockspec"
end

task :tag do
    Message = "version #{Project_version}"
    sh "hg tag -m '#{Message} tag' '#{Message}'"
end

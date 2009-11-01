PROJECT = 'objectlua'
PROJECT_VERSION = sh "sed -n \"/What's new in version/s/[^0-9.]//gp;q\" 'WhatsNew.txt'"
SUMMARY  = sh "sed -n '1,1 p' 'Readme.txt'"
DETAILED = sh "sed -n '3 p' 'Readme.txt'"

DISTDIR  = "#{PROJECT}-#{PROJECT_VERSION}"
DISTFILE = "#{DISTDIR}.tar.gz"
MD5      = sh "md5sum #{DISTFILE} | cut -d\\  -f1"

FILES    = sh "find ./* -maxdepth 0 '(' -path '*.svn*' -o -path './$(PROJECT)*' ')' -prune -o -print"

task :default => :test

task :all => [:dist, :distcheck, :rockspec]

task :test do
    LUA_PATH_COMMAND = "package.path = package.path .. ';' .. '../src/?.lua'"
    sh "cd test && lua -e \"#{LUA_PATH_COMMAND}\" TestObjectLua.lua"
end

task :dist => [:dist_clean, :test] do
# 	@echo "Distribution temp directory: $(DISTDIR)"
# 	@echo "Distribution file: $(DISTFILE)"
# 	@echo "Version: $(PROJECT_VERSION)"
# 	mkdir $(DISTDIR)
# 	cp -r $(FILES) $(DISTDIR)
# 	tar --exclude '.svn*' --exclude '*Trait*' --exclude '*Mixin*' -cvzf $(DISTFILE) $(DISTDIR)/*
# 	rm -rf $(DISTDIR)
end

task :dist_clean do
    sh "rm -rf #{PROJECT}-*.tar.gz"
end

task :distcheck => [DISTFILE, :distcheck_clean] do
# 	mkdir -p tmp
# 	cd tmp && tar -xzf ../$(DISTFILE)
# 	cd tmp/$(DISTDIR) && make test
# 	make distcheck-clean
end

task :distcheck_clean do
    sh "rm -rf tmp"
end

# .PHONY: rockspec
task :rockspec do
# 	sed "s/VERSION/$(PROJECT_VERSION)/g;\
# 	     s/SUMMARY/$(SUMMARY)/;\
# 	     s/DETAILED/$(DETAILED)/;\
# 	     s/MD5/$(MD5)/"\
# 	  template.rockspec > $(PROJECT)-$(PROJECT_VERSION)-1.rockspec
# 	cat $(PROJECT)-$(PROJECT_VERSION)-1.rockspec
end

task :rockspec_clean do
    sh "rm -f objectlua-*.rockspec"
end

task :clean => [:dist_clean, :distcheck_clean, :rockspec_clean]

task :tag do
# 	svn copy . https://objectlua.googlecode.com/svn/tags/$(PROJECT_VERSION) -m '$(PROJECT_VERSION) version tag'
end

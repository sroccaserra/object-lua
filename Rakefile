PROJECT = 'objectlua'
VERSION = sh "sed -n \"/What's new in version/s/[^0-9.]//gp;q\" 'WhatsNew.txt'"
# SUMMARY  := $(shell sed -n '1,1 p' 'Readme.txt')
# DETAILED := $(shell sed -n '3 p' 'Readme.txt')
# MD5      = $(shell md5sum $(DISTFILE) | cut -d\  -f1)

DISTDIR  = "#{PROJECT}-#{VERSION}"
DISTFILE = "#{DISTDIR}.tar.gz"
# FILES    = $(shell find ./* -maxdepth 0 '(' -path '*.svn*' -o -path './$(PROJECT)*' ')' -prune -o -print)

task :default => :test

task :all => [:dist, :distcheck, :rockspec]

task :test do
    LUA_PATH_COMMAND = "package.path = package.path .. ';' .. '../src/?.lua'"
    sh "cd test && lua -e \"#{LUA_PATH_COMMAND}\" TestObjectLua.lua"
end

task :dist => [:dist_clean, :test] do
# 	@echo "Distribution temp directory: $(DISTDIR)"
# 	@echo "Distribution file: $(DISTFILE)"
# 	@echo "Version: $(VERSION)"
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
# rockspec:
# 	sed "s/VERSION/$(VERSION)/g;\
# 	     s/SUMMARY/$(SUMMARY)/;\
# 	     s/DETAILED/$(DETAILED)/;\
# 	     s/MD5/$(MD5)/"\
# 	  template.rockspec > $(PROJECT)-$(VERSION)-1.rockspec
# 	cat $(PROJECT)-$(VERSION)-1.rockspec

task :rockspec_clean do
    sh "rm -f objectlua-*.rockspec"
end

task :clean => [:test_clean, :dist_clean, :distcheck_clean, :rockspec_clean]

task :tag do
# 	svn copy . https://objectlua.googlecode.com/svn/tags/$(VERSION) -m '$(VERSION) version tag'
end

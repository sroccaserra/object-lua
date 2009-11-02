# Don't use me, I'm not maintained!
# Please use Rakefile instead.

PROJECT  := objectlua
VERSION  := $(shell sed -n "/What's new in version/s/[^0-9.]//gp;q" 'WhatsNew.txt')
SUMMARY  := $(shell sed -n '1,1 p' 'Readme.txt')
DETAILED := $(shell sed -n '3 p' 'Readme.txt')
MD5      = $(shell md5sum $(DISTFILE) | cut -d\  -f1)

DISTDIR  = $(PROJECT)-$(VERSION)
DISTFILE = $(DISTDIR).tar.gz
FILES    = $(shell find ./* -maxdepth 0 '(' -path '*.svn*' -o -path './$(PROJECT)*' ')' -prune -o -print)

all: dist distcheck rockspec

.PHONY: test
test:
	lua -e 'package.path = "./src/?.lua;./test/?.lua;"..package.path' \
	    test/TestObjectLua.lua

dist: dist-clean test
	@echo "Distribution temp directory: $(DISTDIR)"
	@echo "Distribution file: $(DISTFILE)"
	@echo "Version: $(VERSION)"
	mkdir $(DISTDIR)
	cp -r $(FILES) $(DISTDIR)
	tar --exclude '.svn*' --exclude '*Trait*' --exclude '*Mixin*' -cvzf $(DISTFILE) $(DISTDIR)/*
	rm -rf $(DISTDIR)

dist-clean:
	rm -rf $(PROJECT)-*.tar.gz

distcheck: $(DISTFILE) distcheck-clean
	mkdir -p tmp
	cd tmp && tar -xzf ../$(DISTFILE)
	cd tmp/$(DISTDIR) && make test
	make distcheck-clean

distcheck-clean:
	rm -rf tmp

.PHONY: rockspec
rockspec:
	sed "s/VERSION/$(VERSION)/g;\
	     s/SUMMARY/$(SUMMARY)/;\
	     s/DETAILED/$(DETAILED)/;\
	     s/MD5/$(MD5)/"\
	  template.rockspec > $(PROJECT)-$(VERSION)-1.rockspec
	cat $(PROJECT)-$(VERSION)-1.rockspec

rockspec-clean:
	rm -f objectlua-*.rockspec

clean: dist-clean distcheck-clean rockspec-clean

tag:
	svn copy . https://objectlua.googlecode.com/svn/tags/$(VERSION) -m '$(VERSION) version tag'

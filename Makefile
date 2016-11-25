CXX          = g++
LDFLAGS      = -Iinclude
CXXFLAGS     = -pedantic -Wall -Wextra -march=native
DEBUGFLAGS   = -O0 -ggdb3
RELEASEFLAGS = -O3 -DNDEBUG
PROFILEFLAGS = $(RELEASFLAGS) -pg

TARGET       = a.out
SOURCEDIR    = src/
SOURCES      = $(shell find $(SOURCEDIR) -name '*.cc')
INCLUDEDIR   = include/
HEADERS      = $(shell find $(INCLUDEDIR) -name '*.h')
COMMON       = LICENSE README Makefile .gitignore
OBJECTS      = $(SOURCES:.cc=.o)

PREFIX       = $(DESTDIR)/usr/local
BINDIR       = $(PREFIX)/bin


all: debug

release: CXXFLAGS += $(RELEASEFLAGS)
release: $(TARGET)

debug: CXXFLAGS += $(DEBUGFLAGS)
debug: $(TARGET)

profile: CXXFLAGS += $(PROFILEFLAGS)
profile: $(TARGET)


install: release
	install -D $(TARGET) $(BINDIR)/$(TARGET)

install-strip: release
	install -D -s $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	rm $(BINDIR)/$(TARGET)


clean:
	rm -f $(OBJECTS) gmon.out

distclean: clean
	rm -f $(TARGET)


rebuild: clean all


tarball:
	tar -cvzf $(TARGET).tar.gz $(HEADERS) $(SOURCES) $(COMMON)


$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(CXXFLAGS) -o $(TARGET) $(OBJECTS)


%.o: %.cc
	$(CXX) $(LDFLAGS) $(CXXFLAGS) -o $@ -c $<


.PHONY: all release debug profile install install-strip uninstall clean distclean rebuild tarball


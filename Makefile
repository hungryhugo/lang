# taken from 
# http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/

PROJNAME = lang

ORGDIR = org
IDIR = include
SDIR = src
ODIR = obj
DDIR = doc

CFLAGS = -g -Wall -I$(IDIR)
CC = gcc

TEX = pdflatex


# org-mode files to be considered
_ORGS = main.org
ORGS = $(patsubst %,$(ORGDIR)/%,$(_ORGS))

# header files created in org files
_DEPS = #error.h logging.h test.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

# source files created in org files
_SRC = #error.c logging.c
SRC = $(patsubst %, $(ODIR)/%, $(_SRC))

OBJ = $(patsubst %.c, %.o, $(SRC))

# tests created in org files
TESTS = #logging_test

# pdfs created from org files, one pdf for one org
PDFS = main.pdf

# org preprocessors
TANGLE = ./org-babel-tangle
WEAVE = ./org-babel-weave


# exporting source code and compiling
all: $(PROJNAME)

# creates all source code files
tangle: $(ORGS)
	mkdir -p $(ODIR) $(IDIR) $(SDIR)
	$(TANGLE) $^

# creates a c file from the org file with the same name
$(SDIR)/%.c: $(ORGDIR)/%.org
	$(TANGLE) $^

# compiles one c file
$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(CC) -c $< -o $@ $(CFLAGS)

# compiles the project
$(PROJNAME): $(OBJ)
	$(MAKE) tangle
	$(CC) $(SDIR)/main.c -o $@ $^ $(CFLAGS)

# compiles the given test
%_test: $(SDIR)/%_test.c $(OBJ)
	$(CC) $^ -o $(ODIR)/$@ $(CFLAGS)

# runs a given test
run_%_test: %_test
	$(ODIR)/$^

# run all tests
tests: run_$(TESTS)

# create all documentation files
weave: $(ORGS)
	mkdir -p $(DDIR)
	$(WEAVE) $^

# compile a tex file to pdf
$(DDIR)/%.pdf: $(DDIR)/%.tex
	$(TEX) $^

# compile all tex files
doc: $(DDIR)/$(PDFS)


.PHONY: clean

clean:
	rm -rf $(IDIR) $(SDIR) $(DDIR) $(ODIR) $(PROJNAME) $(PROJNAME).dSYM *~ \#*

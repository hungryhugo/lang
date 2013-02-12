# taken from 
# http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/

PROJNAME = lang

ORGDIR = org
IDIR = include
SDIR = src
CFLAGS = -g -Wall -I$(IDIR)
CC = gcc
TEX = pdflatex

ODIR = obj
LDIR = lib
DDIR = doc

LIBS = 

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

# org preprocessor
TANGLE = ./org-babel-tangle

all: $(PROJNAME)

# creates all source code and documentation files
tangle: 
	$(TANGLE) $(ORGS)

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

# compile a tex file to pdf
$(DDIR)/%.pdf: $(DDIR)/%.tex
	$(TEX) $^

# compile all tex files
doc: $(DDIR)/$(PDFS)


.PHONY: clean

clean:
	rm -rf $(IDIR)/* $(SDIR)/* $(DDIR)/* $(ODIR)/* $(PROJNAME) $(PROJNAME).dSYM *~ \#*

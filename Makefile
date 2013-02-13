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

TFLAGS = -output-directory=$(DDIR)
TEX = pdflatex


# org-mode files to be considered
_ORGS = main.org
ORGS = $(patsubst %,$(ORGDIR)/%,$(_ORGS))

# header files created in org files
_DEPS = main.h #error.h logging.h test.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

# source files created in org files
_SRC = main.c #error.c logging.c
SRC = $(patsubst %, $(SDIR)/%, $(_SRC))

_OBJ = $(patsubst %.c, %.o, $(_SRC))
OBJ = $(patsubst %, $(ODIR)/%, $(_OBJ))

# tests created in org files
TESTS = #logging_test

# pdfs created from org files, one pdf for one org
_DOCS = $(patsubst %.org, %.tex, $(_ORGS))
DOCS = $(patsubst %,$(DDIR)/%,$(_DOCS))
_PDFS = $(patsubst %.org, %.pdf, $(_ORGS))
PDFS = $(patsubst %,$(DDIR)/%,$(_PDFS))

# org preprocessors
TANGLE = ./org-babel-tangle
WEAVE = ./org-babel-weave


# exporting source code and compiling
all: $(PROJNAME)

# creates all source code files
tangle: $(ORGS)
	mkdir -p $(ODIR) $(IDIR) $(SDIR)
	$(TANGLE) $(ORGS)


# creation of the source code files
$(DEPS): tangle

$(SRC): tangle

# compiles one c file
$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(CC) -c $< -o $@ $(CFLAGS)

# compiles the project
$(PROJNAME): $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

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

$(DOCS): weave

# compile a tex file to pdf
$(DDIR)/%.pdf: $(DDIR)/%.tex
	$(TEX) $(TFLAGS) $^

# compile all tex files
doc: $(PDFS)


.PHONY: clean

clean:
	rm -rf $(IDIR) $(SDIR) $(DDIR) $(ODIR) $(PROJNAME) $(PROJNAME).dSYM *~ \#*

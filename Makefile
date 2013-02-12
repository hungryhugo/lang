# taken from 
# http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/

PROJNAME = lang

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
ORGS = main.org syntax.org

_DEPS = error.h logging.h test.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_SRC = error.c logging.c
SRC = $(patsubst %, $(ODIR)/%, $(_SRC))

OBJ = $(patsubst %.c, %.o, $(SRC))

TESTS = logging_test

PDFS = main.pdf syntax.pdf

TANGLE = ./org-babel-tangle

all: tangle

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(CC) -c $< -o $@ $(CFLAGS)

tangle: clean $(ORGS)
	mkdir $(IDIR) $(SDIR) $(ODIR) $(DDIR)
	$(TANGLE) $(ORGS)

$(PROJNAME): $(OBJ)
	$(CC) $(SDIR)/main.c -o $@ $^ $(CFLAGS)

%_test: $(SDIR)/%_test.c $(OBJ)
	$(CC) $^ -o $(ODIR)/$@ $(CFLAGS)

run_%_test: %_test
	$(ODIR)/$^

tests: run_$(TESTS)

$(DDIR)/%.pdf: $(DDIR)/%.tex
	$(TEX) $^

doc: $(DDIR)/$(PDFS)


.PHONY: clean

clean:
	rm -rf $(IDIR) $(SDIR) $(DDIR) $(ODIR) $(PROJNAME) $(PROJNAME).dSYM *~ \#*

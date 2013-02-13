lang
====

Directory Structure
-------------------

The directory `org` contains the literate programming `.org` files
from which the source code and the documentation will be generated.
All other directories are filled when building the project and are
automatically emptied with `make clean`, so do not put files in there
or modify existing ones.

What source code and documentation files will be created is specified
by the `.org` files alone.


Building
--------

Creating source code and documentation files from the `.org` files is
done using

```make tangle```

and

```make weave```

Compiling the source is done simply with

```make```

and compiling the documentation into `.pdf` files is done using

```make pdfs```

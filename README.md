# Entropy Analyzer Tool (EAT)

Entropy Analyzer Tool is a simple shell script that analyzes file entropy by
compressing it using **gzip** or **bzip2** compression algorithms and shows the
file size percentage after compression from original file size.

This might be very useful when reverse-engineering some unknown binary files to
get a basic understanding of its internal structure and answer some of the
questions, like "is it encrypted?" or "is it compressed?".

For example, if you have file some\_document.txt which shows 16% - this
means that the size of some\_document.txt after compression is only 16% from
original file size.

Basically, if file can't be compressed much - it has a high entropy
and if the compressed size is much smaller than the original - the
entropy is pretty low.

# Usage

Before running this tool, you need to have **gzip** and **bzip2** archivers
installed on your system (usually those two are installed on most Linux
distibutions and most Unix'es)

To see all available options, run:
```
$ ./eat.sh --help
```
and to analyze some files, pass the script some file path(s):
```
$ ./eat.sh some_file.bin some_other_file.dat
97% some_file.bin
23% some_other_file.dat
```

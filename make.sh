#!/bin/sh
TRG=hhpresentation

echo ${TRG}.tex
pdflatex ${TRG}.tex
rm ${TRG}.snm ${TRG}.dvi ${TRG}.log ${TRG}.d ${TRG}.aux ${TRG}.nav ${TRG}.out ${TRG}.toc >/dev/null 2>&1

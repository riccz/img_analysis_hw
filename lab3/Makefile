ZIPFILE = lab3.zip
CODE_FILES = matlab/*.m

all: clean $(ZIPFILE)

$(ZIPFILE): $(ZIPFILE:.zip=.pdf) $(CODE_FILES)
	zip -9 -r $@ $^

%.pdf: %.tex
	pdflatex $<
	biber $(<:.tex=)
	pdflatex $<
	pdflatex $<

clean:
	rm *.pdf 2>/dev/null || true
	rm *.aux 2>/dev/null || true
	rm *.out 2>/dev/null || true
	rm *.bcf 2>/dev/null || true
	rm *.blg 2>/dev/null || true
	rm *.bbl 2>/dev/null || true
	rm *.run.xml 2>/dev/null || true
	rm $(ZIPFILE) 2>/dev/null || true

.PHONY: clean all

all: lab6.zip

lab6.zip: clean lab6.pdf matlab/*.m
	zip lab6.zip lab6.pdf matlab/*.m

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

clean:
	rm *.pdf || true
	rm *.aux || true
	rm *.out || true
	rm matlab/*.pdf || true
	rm lab*.zip || true

.PHONY: clean all

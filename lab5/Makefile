all: lab5.zip

lab5.zip: clean lab5.pdf matlab/*.m
	zip lab5.zip lab5.pdf matlab/*.m

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

all: lab4.zip

lab4.zip: lab4.pdf matlab/*.m
	zip lab4.zip lab4.pdf matlab/*.m

%.pdf: %.tex clean
	pdflatex $<
	pdflatex $<

clean:
	rm *.pdf || true
	rm *.aux || true
	rm *.out || true
	rm matlab/*.pdf || true
	rm lab*.zip || true

.PHONY: clean all

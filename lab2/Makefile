all: lab2.zip

lab2.zip: lab2.pdf matlab/*.m matlab/*.mat
	zip lab2.zip lab2.pdf matlab/*.m matlab/*.mat

%.pdf: %.tex clean
	pdflatex $<
	pdflatex $<

clean:
	rm *.pdf || true
	rm *.aux || true
	rm *.out || true
	rm lab2.zip || true

.PHONY: clean

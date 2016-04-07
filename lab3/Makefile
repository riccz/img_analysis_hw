all: lab3.zip

lab3.zip: lab3.pdf matlab/*.m matlab/*.mat
	zip lab3.zip lab3.pdf matlab/*.m matlab/*.mat

%.pdf: %.tex clean
	pdflatex $<
	pdflatex $<

clean:
	rm *.pdf || true
	rm *.aux || true
	rm *.out || true
	rm lab3.zip || true

.PHONY: clean

all: lab4.zip

lab4.zip: lab4.pdf matlab/*.m
	zip lab4.zip lab4.pdf matlab/*.m

%.pdf: %.tex matlab/cil_imgs/c6.png clean
	pdflatex $<
	pdflatex $<

matlab/cil_imgs/%.png: matlab/cil_imgs/%.bmp
	convert $< $@

clean:
	rm *.pdf || true
	rm *.aux || true
	rm *.out || true
	rm matlab/*.pdf || true
	rm lab*.zip || true

.PHONY: clean all

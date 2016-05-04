all: lab4.zip

lab4.zip: clean images lab4.pdf matlab/*.m
	zip lab4.zip lab4.pdf matlab/*.m

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

images: matlab/cil_imgs/c6.png matlab/panoramic_img.png

%.png: %.bmp
	convert $< $@

clean:
	rm *.pdf || true
	rm *.aux || true
	rm *.out || true
	rm matlab/*.pdf || true
	rm matlab/*.png || true
	rm matlab/cil_imgs/*.png || true
	rm lab*.zip || true

.PHONY: clean all images

ZIPFILE = lab3.zip
CODE_FILES = matlab/*.m images/kodim*.png
EXTRA_IMGS = matlab/*demosaic_kodim*.png matlab/*demosaic*.jpg

all: clean $(ZIPFILE)

tmp := $(shell mktemp -d)
pwd := $(shell pwd)
$(ZIPFILE): $(ZIPFILE:.zip=.pdf) $(CODE_FILES)
	zip -9 -r $@ $^
	mkdir "${tmp}/images"
	cp $(EXTRA_IMGS) "${tmp}/images/"
	cd "${tmp}" && zip -9 -r "${pwd}/${ZIPFILE}" images/

%.pdf: %.tex %.bib img_details
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
	rm include_imgs/generated/* 2>/dev/null || true
	rm $(ZIPFILE) 2>/dev/null || true

img_details:
	convert matlab/demosaic_kodim19.png -crop 200x150+20+415 include_imgs/generated/demosaic_kodim19_wall.png
	convert matlab/matlab_demosaic_kodim19.png -crop 200x150+20+415 include_imgs/generated/matlab_demosaic_kodim19_wall.png
	convert matlab/prsh_demosaic_kodim19.png -crop 200x150+20+415 include_imgs/generated/prsh_demosaic_kodim19_wall.png
	convert images/kodim19.png -crop 200x150+20+415 include_imgs/generated/kodim19_wall.png

	convert images/kodim01.png -crop 350x262+210+250 include_imgs/generated/kodim01_door.png
	convert matlab/demosaic_kodim01.png -crop 350x262+210+250 include_imgs/generated/demosaic_kodim01_door.png
	convert matlab/matlab_demosaic_kodim01.png -crop 350x262+210+250 include_imgs/generated/matlab_demosaic_kodim01_door.png
	convert matlab/prsh_demosaic_kodim01.png -crop 350x262+210+250 include_imgs/generated/prsh_demosaic_kodim01_door.png

	convert images/macbeth_color.JPG -resize 400x400 include_imgs/generated/macbeth_color_small.png
	convert matlab/demosaic_macbeth_color.jpg -resize 400x400 include_imgs/generated/demosaic_macbeth_color_small.png
	convert matlab/matlab_demosaic_macbeth_color.jpg -resize 400x400 include_imgs/generated/matlab_demosaic_macbeth_color_small.png
	convert matlab/prsh_demosaic_macbeth_color.jpg -resize 400x400 include_imgs/generated/prsh_demosaic_macbeth_color_small.png

	convert images/DEI_park.JPG -crop 1333x1000+0+3000 -resize 400x400 include_imgs/generated/DEI_park_small.png
	convert matlab/demosaic_DEI_park.jpg -crop 1333x1000+0+3000 -resize 400x400 include_imgs/generated/demosaic_DEI_park_small.png
	convert matlab/matlab_demosaic_DEI_park.jpg -crop 1333x1000+0+3000 -resize 400x400 include_imgs/generated/matlab_demosaic_DEI_park_small.png
	convert matlab/prsh_demosaic_DEI_park.jpg -crop 1333x1000+0+3000 -resize 400x400 include_imgs/generated/prsh_demosaic_DEI_park_small.png

	convert images/students2.JPG -crop 1333x1000+0+2600 -resize 400x400 include_imgs/generated/students2_small.png
	convert matlab/demosaic_students2.jpg -crop 1333x1000+0+2600 -resize 400x400 include_imgs/generated/demosaic_students2_small.png
	convert matlab/matlab_demosaic_students2.jpg -crop 1333x1000+0+2600 -resize 400x400 include_imgs/generated/matlab_demosaic_students2_small.png
	convert matlab/prsh_demosaic_students2.jpg -crop 1333x1000+0+2600 -resize 400x400 include_imgs/generated/prsh_demosaic_students2_small.png

.PHONY: clean all img_details

all: anoles properties

anoles:
	R --vanilla < anoles.R
	mv Rplots.pdf anoles.pdf

properties:
	R --vanilla < properties.R
	mv Rplots.pdf properties.pdf

clean:
	rm -f Rplots.pdf anoles.pdf properties.pdf

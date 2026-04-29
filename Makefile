PDF    = document.pdf
SOURCE = main.mom style.mom \
         $(wildcard chapitres/*/index.mom)
ASSETS = $(wildcard chapitres/*/assets/*)

all: $(PDF)

$(PDF): $(SOURCE) $(ASSETS)
	soelim main.mom | preconv -e utf8 | groff -M . -mom -Tpdf > $(PDF) 2>groff.log
	@if [ -s groff.log ]; then \
	  echo "=== Avertissements groff ===" ; cat groff.log ; fi

watch:
	while inotifywait -e modify $(SOURCE); do make; done

clean:
	rm -f $(PDF) groff.log

.PHONY: all watch clean

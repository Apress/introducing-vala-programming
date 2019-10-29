VALA = valac

SOURCES = \
  netRadio.vala \
  mainWindow.vala \
  fontAwesomeButton.vala \
  \
  stationModel.vala \
  genreModel.vala \
  streamModel.vala \
  imageModel.vala \
  \
  directoryClient.vala \
  playerController.vala \
  \
  dbusInterface.vala \
  dbusServer.vala

CSOURCES = \
  netRadio.c \
  mainWindow.c \
  stationModel.c \
  genreModel.c \
  streamModel.c \
  imageModel.c \
  directoryClient.c \
  fontAwesomeButton.c \
  playerController.c \
  dbusInterface.c \
  dbusServer.c

DEPS = \
  --pkg=gtk+-3.0 \
  --pkg=json-glib-1.0 \
  --pkg=libsoup-2.4 \
  --pkg=gstreamer-player-1.0 \
  --pkg=gio-2.0

.PHONY: clean

netradio: $(SOURCES)
	$(VALA) -g -o $@ --save-temps $(DEPS) $(SOURCES)

netradio2: $(CSOURCES)
	gcc -g `pkg-config --cflags --libs gtk+-3.0 json-glib-1.0 libsoup-2.4 gstreamer-player-1.0 gio-2.0` -O0 $(CSOURCES) -o $@

netradio-client: netradio-client.vala
	$(VALA) -g -o $@ --save-temps --pkg=gio-2.0 dbusInterface.vala netradio-client.vala

all: netradio netradio2 netradio-client

clean:
	rm -rf netradio netradio2 netradio-client *.c *.o *.dSYM


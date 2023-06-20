include config.mak

all: cinelerra-8-x86_64.tar.xz bcast
	time podman build --tag $(TAGNAME) -f ./Dockerfile

bcast:
	mkdir bcast

cinelerra-8-x86_64.tar.xz:
	xdg-open 'https://cinelerra.org/download'


distclean:
	rm -f config.mak

remove: rm

rm:
	podman rm $(NAME)

list: ls

ls:
	podman ps -a

.PHONY: all remove rm list ls

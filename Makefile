all:
	for dir in `find . -mindepth 2 -maxdepth 2 -type d | xargs`; do createrepo --update --database `pwd`/$$dir ; done


REPO := ../..

tag: Dockerfile $(REPO)/.zshrc $(REPO)/.dima.shellrc
	docker build -f Dockerfile $(REPO)
	docker build -f Dockerfile -q $(REPO) >$@

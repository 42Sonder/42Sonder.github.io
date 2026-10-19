.PHONY: markdown-check markdown-format markdown-format-check mynotes-format new-post

new-post:
	./script/new-post.sh

markdown-check:
	rumdl check .

markdown-format:
	rumdl fmt .

markdown-format-check:
	rumdl fmt --check .

mynotes-format:
	rumdl fmt _SNotes

.PHONY: markdown-check markdown-format markdown-format-check mynotes-format

markdown-check:
	rumdl check .

markdown-format:
	rumdl fmt .

markdown-format-check:
	rumdl fmt --check .

mynotes-format:
	rumdl fmt _SNotes

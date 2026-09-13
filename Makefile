.PHONY: markdown-check markdown-format markdown-format-check

markdown-check:
	rumdl check .

markdown-format:
	rumdl fmt .

markdown-format-check:
	rumdl fmt --check .

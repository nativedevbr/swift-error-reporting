.PHONY: format
format:
	@swift format \
		--ignore-unparsable-files \
		--recursive \
		--in-place \
		./Sources \
		./Tests \
		./Package.swift


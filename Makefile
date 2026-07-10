EMACS ?= emacs

.PHONY: test syntax unit

test: syntax unit

syntax:
	$(EMACS) -Q --batch -l test/check-syntax.el

unit:
	$(EMACS) -Q --batch -l test/agentic-systems-test.el \
		-f ert-run-tests-batch-and-exit

;;; smoke.el --- Installed-layer smoke tests -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

(require 'ert)

(ert-deftest agentic-systems-layer-is-enabled ()
  (should (configuration-layer/layer-used-p 'agentic-systems)))

(ert-deftest agentic-systems-default-packages-are-installed ()
  (dolist (package '(ai-code acp agent-shell agent-review agent-recall))
    (should (package-installed-p package))))

(ert-deftest agentic-systems-default-packages-load ()
  (dolist (feature '(ai-code acp agent-shell agent-review agent-recall))
    (should (require feature nil t))))

(ert-deftest agentic-systems-entry-points-exist ()
  (dolist (command '(ai-code-menu agent-shell agent-review
                                  agent-recall-search agent-recall-browse))
    (should (fboundp command))))

(ert-run-tests-batch-and-exit)

;;; smoke.el ends here

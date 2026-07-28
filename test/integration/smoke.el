;;; smoke.el --- Installed-layer smoke tests -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

(require 'ert)

(ert-deftest agentic-systems-layer-is-enabled ()
  (should (configuration-layer/layer-used-p 'spacemacs-agentic)))

(ert-deftest agentic-systems-default-packages-are-installed ()
  (dolist (package '(ai-code acp agent-shell alert agent-shell-notifications
                     agent-review agent-recall agent-shell-manager))
    (should (package-installed-p package))))

(ert-deftest agentic-systems-default-packages-load ()
  (dolist (feature '(ai-code acp agent-shell alert agent-shell-notifications
                     agent-review agent-recall agent-shell-manager))
    (should (require feature nil t))))

(ert-deftest agentic-systems-entry-points-exist ()
  (dolist (command '(ai-code-menu agent-shell agent-review
                                  agent-recall-search agent-recall-browse
                                  agent-shell-manager-toggle
                                  agent-shell-notifications-mode
                                  agentic-systems-test-agent-shell-notification))
    (should (fboundp command))))

(ert-run-tests-batch-and-exit)

;;; smoke.el ends here

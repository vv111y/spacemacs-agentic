;;; init.el --- Minimal Spacemacs integration-test configuration -*- lexical-binding: nil; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

(defun dotspacemacs/layers ()
  "Declare the layer under test."
  (setq-default
   dotspacemacs-distribution 'spacemacs-base
   dotspacemacs-configuration-layers
   '((spacemacs-agentic
      :variables
      agentic-systems-ai-code-backend 'agent-shell))))

(defun dotspacemacs/init ())
(defun dotspacemacs/user-init ())
(defun dotspacemacs/config ())
(defun dotspacemacs/user-config ())

;;; init.el ends here

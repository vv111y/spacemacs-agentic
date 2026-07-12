;;; packages.el --- Agentic systems packages for Spacemacs -*- lexical-binding: nil; -*-

;; Copyright (C) 2026 Willy Rempel
;; SPDX-License-Identifier: GPL-3.0-or-later

(defconst spacemacs-agentic-packages
  '((ai-code :toggle agentic-systems-enable-ai-code)
    (acp :toggle agentic-systems-enable-agent-shell)
    (agent-shell :toggle agentic-systems-enable-agent-shell)
    (agent-review
     :toggle agentic-systems-enable-agent-review
     :location (recipe :fetcher github :repo "nineluj/agent-review"
                       :files ("*.el")))
    (agent-recall :toggle agentic-systems-enable-agent-recall)
    (agent-shell-manager
     :toggle agentic-systems-enable-agent-shell-manager
     :location (recipe :fetcher github :repo "jethrokuan/agent-shell-manager"
                       :files ("*.el")))
    (agent-shell-workspace
     :toggle agentic-systems-enable-agent-shell-workspace
     :location (recipe :fetcher github :repo "gveres/agent-shell-workspace"
                       :files ("*.el")))
    (agent-shell-org-transcript
     :toggle agentic-systems-enable-org-transcripts
     :location (recipe :fetcher github
                       :repo "lllShamanlll/agent-shell-org-transcript"
                       :files ("*.el")))
    (ob-agent-shell
     :toggle agentic-systems-enable-org-babel
     :location (recipe :fetcher github :repo "eddof13/ob-agent-shell"
                       :files ("*.el")))
    (meta-agent-shell
     :toggle agentic-systems-enable-meta-agent-shell
     :location (recipe :fetcher github :repo "ElleNajt/meta-agent-shell"
                       :files ("*.el")))))

(defun spacemacs-agentic/init-ai-code ()
  "Initialize `ai-code'."
  (use-package ai-code
    :defer t
    :commands (ai-code-menu ai-code-select-backend)
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/set-leader-keys
      "$A" #'ai-code-menu)
    :config
    (when agentic-systems-ai-code-backend
      (ai-code-set-backend agentic-systems-ai-code-backend))))

(defun spacemacs-agentic/init-acp ()
  "Initialize `acp'."
  (use-package acp
    :defer t))

(defun spacemacs-agentic/init-agent-shell ()
  "Initialize `agent-shell'."
  (use-package agent-shell
    :defer t
    :commands (agent-shell agent-shell-new-shell agent-shell-toggle
                           agent-shell-help-menu agent-shell-view-traffic)
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/declare-prefix "$s" "Agent Shell")
    (spacemacs/set-leader-keys
      "$ss" #'agent-shell
      "$sn" #'agent-shell-new-shell
      "$st" #'agent-shell-toggle
      "$sh" #'agent-shell-help-menu
      "$sl" #'agent-shell-view-traffic)
    :config
    (evil-define-key 'motion agent-shell-mode-map
      (kbd "C-<tab>") #'agent-shell-cycle-session-mode)))

(defun spacemacs-agentic/init-agent-review ()
  "Initialize `agent-review'."
  (use-package agent-review
    :defer t
    :commands agent-review
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/set-leader-keys "$r" #'agent-review)))

(defun spacemacs-agentic/init-agent-recall ()
  "Initialize `agent-recall'."
  (use-package agent-recall
    :defer t
    :commands (agent-recall-search agent-recall-browse agent-recall-resume
                                   agent-recall-reindex agent-recall-stats
                                   agent-recall-track-sessions)
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/declare-prefix "$h" "Agent history")
    (spacemacs/set-leader-keys
      "$hs" #'agent-recall-search
      "$hb" #'agent-recall-browse
      "$hr" #'agent-recall-resume
      "$hi" #'agent-recall-reindex
      "$ht" #'agent-recall-stats)
    (when (configuration-layer/package-used-p 'agent-shell)
      (add-hook 'agent-shell-mode-hook #'agent-recall-track-sessions))
    :config
    (when agentic-systems-agent-recall-search-paths
      (setq agent-recall-search-paths
            agentic-systems-agent-recall-search-paths))))

(defun spacemacs-agentic/init-agent-shell-manager ()
  "Initialize `agent-shell-manager'."
  (use-package agent-shell-manager
    :defer t
    :commands agent-shell-manager-toggle
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/set-leader-keys "$m" #'agent-shell-manager-toggle)))

(defun spacemacs-agentic/init-agent-shell-workspace ()
  "Initialize `agent-shell-workspace'."
  (use-package agent-shell-workspace
    :defer t
    :commands agent-shell-workspace-toggle
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/set-leader-keys "$w" #'agent-shell-workspace-toggle)))

(defun spacemacs-agentic/init-agent-shell-org-transcript ()
  "Initialize `agent-shell-org-transcript'."
  (use-package agent-shell-org-transcript
    :defer t
    :commands agent-shell-org-transcript-migrate
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/set-leader-keys "$o" #'agent-shell-org-transcript-migrate)
    :config
    (when agentic-systems-org-transcript-directory
      (setq agent-shell-org-transcript-directory
            agentic-systems-org-transcript-directory))))

(defun spacemacs-agentic/init-ob-agent-shell ()
  "Initialize `ob-agent-shell'."
  (use-package ob-agent-shell
    :defer t
    :init
    (with-eval-after-load 'org
      (add-to-list 'org-babel-load-languages '(agent-shell . t))
      (add-to-list 'org-src-lang-modes '("agent-shell" . text)))))

(defun spacemacs-agentic/init-meta-agent-shell ()
  "Initialize `meta-agent-shell'."
  (use-package meta-agent-shell
    :defer t
    :commands (meta-agent-shell-start
               meta-agent-shell-jump-to-dispatcher
               meta-agent-shell-heartbeat-start
               meta-agent-shell-heartbeat-stop
               meta-agent-shell-heartbeat-send-now
               meta-agent-shell-big-red-button)
    :init
    (spacemacs/declare-prefix "$" "AI")
    (spacemacs/declare-prefix "$M" "Meta agent")
    (spacemacs/set-leader-keys
      "$MM" #'meta-agent-shell-start
      "$Md" #'meta-agent-shell-jump-to-dispatcher
      "$Mh" #'meta-agent-shell-heartbeat-start
      "$MH" #'meta-agent-shell-heartbeat-stop
      "$Ms" #'meta-agent-shell-heartbeat-send-now
      "$M!" #'meta-agent-shell-big-red-button)))

;;; packages.el ends here

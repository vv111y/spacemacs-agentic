;;; config.el --- Agentic systems layer configuration -*- lexical-binding: nil; -*-

;; Copyright (C) 2026 Willy Rempel
;; SPDX-License-Identifier: GPL-3.0-or-later

(defgroup agentic-systems nil
  "Agentic development and orchestration in Spacemacs."
  :group 'spacemacs)

(defcustom agentic-systems-enable-ai-code t
  "When non-nil, enable the `ai-code' workflow frontend."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-agent-shell t
  "When non-nil, enable `agent-shell' and its ACP dependency."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-eca nil
  "When non-nil, enable ECA (Editor Code Assistant)."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-claude-code nil
  "When non-nil, enable the `claude-code.el' integration."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-claude-code-ide nil
  "When non-nil, enable `claude-code-ide.el'.

This is experimental and overlaps with Spacemacs's Claude Code layer."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-agent-review t
  "When non-nil, enable structured cross-agent code review."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-agent-recall t
  "When non-nil, enable transcript indexing, search, and resume."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-agent-shell-manager nil
  "When non-nil, enable the tabulated Agent Shell manager."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-agent-shell-workspace nil
  "When non-nil, enable the Agent Shell tab-bar workspace.

This overlaps with `agent-shell-manager' and may overlap with Spacemacs
workspaces, so it is disabled by default."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-org-transcripts nil
  "When non-nil, save Agent Shell transcripts as Org files."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-org-babel nil
  "When non-nil, enable Agent Shell Org Babel source blocks."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-meta-agent-shell nil
  "When non-nil, enable experimental multi-agent coordination."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-ai-code-backend 'agent-shell
  "Backend selected by `ai-code' when the layer initializes.

Set this to nil to leave backend selection entirely to AI Code."
  :type '(choice (const :tag "Do not select a backend" nil)
                 (symbol :tag "Backend symbol"))
  :group 'agentic-systems)

(defcustom agentic-systems-agent-recall-search-paths nil
  "Directories searched for Agent Shell transcripts.

When nil, retain `agent-recall-search-paths' defaults."
  :type '(repeat directory)
  :group 'agentic-systems)

(defcustom agentic-systems-org-transcript-directory nil
  "Directory for Org Agent Shell transcripts.

When nil, `agent-shell-org-transcript' chooses its default, normally
`org-roam-directory'."
  :type '(choice (const :tag "Package default" nil) directory)
  :group 'agentic-systems)

;;; config.el ends here

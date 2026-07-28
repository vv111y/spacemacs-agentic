;;; config.el --- Agentic systems layer configuration -*- lexical-binding: nil; -*-

;; Copyright (C) 2026 Willy Rempel
;; SPDX-License-Identifier: GPL-3.0-or-later

(defvar alert-default-style)

(defgroup agentic-systems nil
  "Agentic development and orchestration in Spacemacs."
  :group 'spacemacs)

(defcustom agentic-systems-enable-ai-code t
  "When non-nil, enable the `ai-code' workflow frontend."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-ai-code-evil nil
  "When non-nil, bind SPC in Evil normal state in AI session buffers."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-ai-code-magit nil
  "When non-nil, add AI Code commands to Magit popups."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-ai-code-auto-revert nil
  "When non-nil, use one-second global auto-revert for AI file changes.

Spacemacs normally configures auto-revert already; this option only changes
that behavior when explicitly enabled."
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

(defcustom agentic-systems-enable-agent-shell-manager t
  "When non-nil, enable the tabulated Agent Shell manager."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-agent-shell-workspace nil
  "When non-nil, enable the Agent Shell tab-bar workspace.

This provides a focused sidebar and tiled agent view.  It overlaps with
`agent-shell-manager' for status and lifecycle controls, and its tab-bar and
buffer-isolation behavior may overlap with Spacemacs perspectives."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-enable-agent-shell-notifications t
  "When non-nil, notify when Agent Shell completes or needs permission.

Notifications use `alert' for visual delivery.  On macOS, the layer also
plays `agentic-systems-agent-shell-notification-sound' with `afplay'."
  :type 'boolean
  :group 'agentic-systems)

(defcustom agentic-systems-agent-shell-alert-style nil
  "The `alert' style used for Agent Shell notifications.

When nil, choose `notifier' or `osx-notifier' on macOS, `libnotify' or
`notifications' when available on other systems, and otherwise retain
`alert-default-style'."
  :type '(choice (const :tag "Choose automatically" nil)
                 (symbol :tag "Alert style"))
  :group 'agentic-systems)

(defcustom agentic-systems-agent-shell-notification-sound
  (when (eq system-type 'darwin)
    "/System/Library/Sounds/Glass.aiff")
  "Sound played for Agent Shell notifications on macOS.

Set this to nil to disable audio, or to another readable audio file.  Playback
uses the macOS `afplay' command and never blocks Emacs."
  :type '(choice (const :tag "No sound" nil)
                 (file :tag "Audio file"))
  :group 'agentic-systems)

(defun agentic-systems--agent-shell-alert-style ()
  "Return the effective `alert' style for Agent Shell notifications."
  (or agentic-systems-agent-shell-alert-style
      (cond
       ((eq system-type 'darwin)
        (if (executable-find "terminal-notifier")
            'notifier
          'osx-notifier))
       ((executable-find "notify-send") 'libnotify)
       ((featurep 'notifications) 'notifications)
       (t alert-default-style))))

(defun agentic-systems--play-agent-shell-notification-sound ()
  "Play the configured Agent Shell notification sound on macOS."
  (when (and (eq system-type 'darwin)
             agentic-systems-agent-shell-notification-sound
             (file-readable-p
              agentic-systems-agent-shell-notification-sound)
             (executable-find "afplay"))
    (start-process
     "agent-shell-notification-sound" nil
     "afplay"
     (expand-file-name agentic-systems-agent-shell-notification-sound))))

(defun agentic-systems--send-agent-shell-notification (notification)
  "Send an Agent Shell NOTIFICATION plist through `alert'."
  (agentic-systems--play-agent-shell-notification-sound)
  (require 'alert)
  (let ((title (or (plist-get notification :title) "Agent Shell")))
    (alert (or (plist-get notification :body) title)
           :title title
           :icon (plist-get notification :app-icon)
           :category 'agent-shell
           :severity 'high
           :style (agentic-systems--agent-shell-alert-style)))
  nil)

;;;###autoload
(defun agentic-systems-test-agent-shell-notification ()
  "Send a visual and audio test notification using the layer configuration."
  (interactive)
  (agentic-systems--send-agent-shell-notification
   '(:title "Agent Shell test"
     :body "Visual and audio notifications are working.")))

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

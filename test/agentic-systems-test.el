;;; agentic-systems-test.el --- Tests for agentic-systems -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

(require 'ert)

(defvar agentic-systems-test--dependencies nil)
(defvar agentic-systems-test--initialized-packages nil)
(defvar agentic-systems-test--leader-bindings nil)

(defun configuration-layer/declare-layer-dependencies (dependencies)
  "Record layer DEPENDENCIES in the test harness."
  (setq agentic-systems-test--dependencies dependencies))

(defun configuration-layer/package-used-p (_package)
  "Treat every package as enabled in the test harness."
  t)

(defun spacemacs/declare-prefix (&rest _arguments)
  "Stub Spacemacs prefix declarations."
  nil)

(defun spacemacs/set-leader-keys (&rest bindings)
  "Record BINDINGS and reject duplicate keys in the test harness."
  (should (= 0 (% (length bindings) 2)))
  (while bindings
    (let ((key (pop bindings))
          (command (pop bindings)))
      (should-not (assoc key agentic-systems-test--leader-bindings))
      (push (cons key command) agentic-systems-test--leader-bindings))))

(defmacro use-package (name &rest arguments)
  "Record NAME and evaluate only its :init forms from ARGUMENTS."
  (let ((tail (cdr (memq :init arguments)))
        forms)
    (while (and tail (not (keywordp (car tail))))
      (push (pop tail) forms))
    `(progn
       (push ',name agentic-systems-test--initialized-packages)
       ,@(nreverse forms))))

(let ((root (expand-file-name
             ".." (file-name-directory (or load-file-name buffer-file-name)))))
  (load (expand-file-name "config.el" root) nil t)
  (load (expand-file-name "layers.el" root) nil t)
  (load (expand-file-name "packages.el" root) nil t))

(defun agentic-systems-test--package-name (specification)
  "Return the package name in SPECIFICATION."
  (if (consp specification) (car specification) specification))

(ert-deftest agentic-systems-defaults-are-coherent ()
  (should agentic-systems-enable-ai-code)
  (should agentic-systems-enable-agent-shell)
  (should agentic-systems-enable-agent-review)
  (should agentic-systems-enable-agent-recall)
  (should-not agentic-systems-enable-agent-shell-manager)
  (should-not agentic-systems-enable-agent-shell-workspace)
  (should-not agentic-systems-enable-org-transcripts)
  (should-not agentic-systems-enable-org-babel)
  (should-not agentic-systems-enable-meta-agent-shell)
  (should (eq agentic-systems-ai-code-backend 'agent-shell)))

(ert-deftest agentic-systems-declares-required-layers ()
  (should (equal agentic-systems-test--dependencies '(git org))))

(ert-deftest agentic-systems-owns-every-declared-package ()
  (dolist (specification agentic-systems-packages)
    (let* ((package (agentic-systems-test--package-name specification))
           (initializer
            (intern (format "agentic-systems/init-%s" package))))
      (should (fboundp initializer)))))

(ert-deftest agentic-systems-keeps-general-llm-clients-out-of-scope ()
  (let ((packages (mapcar #'agentic-systems-test--package-name
                          agentic-systems-packages)))
    (dolist (package '(gptel gptel-agent ellama mcp))
      (should-not (memq package packages)))))

(ert-deftest agentic-systems-github-recipes-are-pinned-to-expected-repositories ()
  (let ((expected
         '((agent-review . "nineluj/agent-review")
           (agent-shell-manager . "jethrokuan/agent-shell-manager")
           (agent-shell-workspace . "gveres/agent-shell-workspace")
           (agent-shell-org-transcript
            . "lllShamanlll/agent-shell-org-transcript")
           (ob-agent-shell . "eddof13/ob-agent-shell")
           (meta-agent-shell . "ElleNajt/meta-agent-shell"))))
    (dolist (entry expected)
      (let* ((specification (assq (car entry) agentic-systems-packages))
             (location (plist-get (cdr specification) :location)))
        (should (eq (car location) 'recipe))
        (should (eq (plist-get (cdr location) :fetcher) 'github))
        (should (equal (plist-get (cdr location) :repo) (cdr entry)))))))

(ert-deftest agentic-systems-initializers-register-packages-and-unique-bindings ()
  (setq agentic-systems-test--initialized-packages nil
        agentic-systems-test--leader-bindings nil)
  (dolist (specification agentic-systems-packages)
    (funcall
     (intern
      (format "agentic-systems/init-%s"
              (agentic-systems-test--package-name specification)))))
  (should
   (equal
    (sort (copy-sequence agentic-systems-test--initialized-packages)
          #'string-lessp)
    (sort (mapcar #'agentic-systems-test--package-name
                  agentic-systems-packages)
          #'string-lessp)))
  (dolist (key '("$aa" "$ss" "$r" "$hs" "$m" "$w" "$o" "$MM"))
    (should (assoc key agentic-systems-test--leader-bindings))))

;;; agentic-systems-test.el ends here

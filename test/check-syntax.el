;;; check-syntax.el --- Parse layer files in batch mode -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

(let* ((test-directory (file-name-directory (or load-file-name buffer-file-name)))
       (root (expand-file-name ".." test-directory))
       (files (directory-files-recursively root "\\.el\\'")))
  (dolist (file files)
    (with-temp-buffer
      (insert-file-contents file)
      (condition-case error-data
          (while t (read (current-buffer)))
        (end-of-file nil)
        (error (error "%s: %s" file (error-message-string error-data))))))
  (message "Parsed %d layer files" (length files)))

;;; check-syntax.el ends here

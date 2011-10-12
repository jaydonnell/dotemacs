;; This is the Aquamacs Preferences file.
;; Add Emacs-Lisp code here that should be executed whenever
;; you start Aquamacs Emacs. If errors occur, Aquamacs will stop
;; evaluating this file and print errors in the *Messags* buffer.
;; Use this file in place of ~/.emacs (which is loaded as well.)

;; This file assumes the following packages have been installed from package.el
;; - anything
;; - anything-config
;; - anything-match-plugin
;; - coffee-mode
;; - clojurescript-mode
;; - haml-mode
;; - sass-mode
;; - scss-mode
;; - starter-kit-ruby
;; - starter-kit-js
;; - color-theme
;; - color-theme-sanityinc-solarized



(tool-bar-mode -1)

(require 'ido)
(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-auto-merge-work-directories-length nil
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-use-virtual-buffers t
      ido-handle-duplicate-virtual-buffers 2
      ido-max-prospects 10)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)

(require 'package)
;; Marmalade
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
;; The original ELPA archive still has some useful
;; stuff.
;; (add-to-list 'package-archives<br />
;;              '("elpa" . "http://tromey.com/elpa/"))
(package-initialize)

(require 'rainbow-delimiters)
;; Add hooks for modes where you want it enabled, for example:
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(require 'anything)
(require 'anything-match-plugin)
(require 'anything-config)

(setq recentf-max-saved-items 500)

(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((pwd (shell-command-to-string "echo -n `pwd`"))
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
     (format "*Anything git project in %s*" pwd))))

(global-set-key (kbd "A-j") 'find-file)
(global-set-key (kbd "A-0") 'delete-window)
(global-set-key (kbd "A-d") 'anything)
(global-set-key (kbd "A-1") 'delete-other-windows)
(global-set-key (kbd "A-2") 'split-window-vertically)
(global-set-key (kbd "A-3") 'split-window-horizontally)
(global-set-key (kbd "A-i") 'hippie-expand)
(global-set-key (kbd "A-/") 'comment-region)
(global-set-key (kbd "A-o") 'other-window)
;;(global-set-key (kbd "A-f") 'ido-find-file)
(global-set-key (kbd "A-k") 'ido-kill-buffer)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "A-r") 'eval-last-sexp)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(global-set-key (kbd "M-n") 'anything-git-project)

(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer 
          (delq (current-buffer) 
                (remove-if-not 'buffer-file-name (buffer-list)))))

(require 'smex)
(smex-initialize)

(require 'color-theme)
(require 'color-theme-sanityinc-solarized)
(color-theme-sanityinc-solarized-dark)

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))
(add-hook 'clojure-mode-hook           (lambda () (paredit-mode +1)))
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))

(global-auto-revert-mode)
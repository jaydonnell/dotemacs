(setq default-tab-width 2)
(setq longlines-auto-wrap nil)

# using the CMD key with my thumb is much nicer
# than using CTR with my pinky
(global-set-key (kbd "A-j") 'find-file)
(global-set-key (kbd "A-b") 'switch-to-buffer)

(ido-mode t)                        ; for both buffers and files
(setq 
   ido-ignore-buffers               ; ignore these guys
   '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido")
   ido-work-directory-list '("~/" "~/Desktop" "~/Documents")
   ido-case-fold  t                 ; be case-insensitive
   ido-use-filename-at-point nil    ; don't use filename at point (annoying)
   ido-use-url-at-point nil         ;  don't use url at point (annoying)
   ido-enable-flex-matching t       ; be flexible
   ido-max-prospects 6              ; don't spam my minibuffer
   ido-confirm-unique-completion t) ; wait for RET, even with unique completion


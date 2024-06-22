;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;;; Emacs Keybings search precedence
;;(or (if overriding-terminal-local-map
;;        (find-in overriding-terminal-local-map))
;;    (if overriding-local-map
;;        (find-in overriding-local-map)
;;      (or (find-in (get-char-property (point) 'keymap))
;;          (find-in-any emulation-mode-map-alists)
;;          ------->Evil-key-map
;;          (find-in-any minor-mode-overriding-map-alist)
;;          (find-in-any minor-mode-map-alist)
;;          (if (get-text-property (point) 'local-map)
;;              (find-in (get-char-property (point) 'local-map))
;;            (find-in (current-local-map)))))
;;    (find-in (current-global-map)))
;;; Evil keymap's order. Evil map locate in emulation-mode-map-alist
;;        Intercept keymaps - evil-make-intercept-map
;;        Local state keymap - evil-local-set-key
;;        Minor-mode keymaps - evil-define-minor-mode-key
;;        Auxiliary keymaps - evil-define-key
;;        Overriding keymaps - evil-make-overriding-map
;;        Global state keymap - evil-global-set-key

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "noZ"
      user-mail-address "i@emacs")

;; solve stick when long-line REF:https://emacs-china.org/t/topic/25811/9?u=mezi
(setq-default bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;

(eval-if! IS-WINDOWS
    (setq
     use-default-font-for-symbols nil
     doom-font (font-spec :family "Cascadia Code" :size 14)
     doom-serif-font doom-font
     doom-cjk-font (font-spec :family "WenQuanYi Micro Hei Mono" :size 14)
     doom-symbol-font (font-spec :family "Symbola")
     doom-variable-pitch-font (font-spec :family "Zpix"))
  (setq
   use-default-font-for-symbols nil
   doom-font (font-spec :family "Monaco" :size 12)
   doom-serif-font doom-font
   doom-cjk-font (font-spec :family "Zpix" :size 14)
   doom-symbol-font (font-spec :family "Symbola")
   doom-variable-pitch-font (font-spec :family "Zpix")))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;;
;;;Coustom keymap.
(defvar doom-mp-keymap (make-sparse-keymap))
(define-key global-map "\M-P" doom-mp-keymap)

(defun doom--join-keys (&rest keys)
  "Join key sequences KEYS. Empty strings and nils are discarded.
\(doom--join-keys \"\\[doom-keymap] e\" \"e i\")
  => \"\\[doom-keymap] e e i\"
\(doom--join-keys \"\\[doom-keymap]\" \"\" \"e i\")
  => \"\\[doom-keymap] e i\""
  (string-join (remove "" (mapcar #'string-trim (remove nil keys))) " "))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(defun doom-adjust-font-size-h ()
  "Ajust font size acording monitor"
  (let ((pixel (cond ((eq 'x window-system) (x-display-pixel-width))
                     ((eq 'w32 window-system) (display-pixel-width))
                     ((eq 'ns window-system) (display-pixel-width)))))
    (set-face-attribute 'default nil :height (if (> pixel 1920) 110 105))))
(add-hook! '(after-init-hook doom-load-theme-hook) :depth 100 #'doom-adjust-font-size-h)

(setq minibuffer-message-properties '(face minibuffer-prompt))

;; pixel-scroll
(customize-set-variable 'pixel-scroll-precision-large-scroll-height 40)
(customize-set-variable 'pixel-scroll-precision-interpolation-factor 8.0)
(pixel-scroll-precision-mode +1)

;; we don't use `which-key'
(eval-after-load 'embark
  '(advice-remove 'embark-completing-read-prompter
    #'+vertico--embark-which-key-prompt-a))

(add-hook 'doom-first-file-hook #'global-tree-sitter-mode)

;; slip window
(defun split-window-func-with-other-buffer (split-function)
  (lambda (&optional arg)
    "Split this window and switch to the new window unless ARG is provided."
    (interactive "P")
    (funcall split-function)
    (let ((target-window (next-window)))
      (set-window-buffer target-window (other-buffer))
      (unless arg
        (select-window target-window)))))

(defun doom/toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

;; Rearrange split windows
(defun split-window-horizontally-instead ()
  "Kill any other windows and re-split such that the current window is
on the top half of the frame."
  (interactive)
  (let ((other-buffer (and (next-window) (window-buffer (next-window)))))
    (delete-other-windows)
    (split-window-horizontally)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(defun split-window-vertically-instead ()
  "Kill any other windows and re-split such that the current window is
on the left half of the frame."
  (interactive)
  (let ((other-buffer (and (next-window) (window-buffer (next-window)))))
    (delete-other-windows)
    (split-window-vertically)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(defun doom/split-window()
  "Split the window to see the most recent buffer in the other window.
Call a second time to restore the original window configuration."
  (interactive)
  (if (eq last-command 'doom/split-window)
      (progn
        (jump-to-register :doom/split-window)
        (setq this-command 'doom/unsplit-window))
    (window-configuration-to-register :doom/split-window)
    (switch-to-buffer-other-window nil)))

(defun doom/toggle-current-window-dedication ()
  "Toggle whether the current window is dedicated to its current buffer."
  (interactive)
  (let* ((window (selected-window))
         (was-dedicated (window-dedicated-p window)))
    (set-window-dedicated-p window (not was-dedicated))
    (message "Window %sdedicated to %s"
             (if was-dedicated "no longer " "")
             (buffer-name))))

(map!
 :desc "M-x"  :nvom                 ";"    #'execute-extended-command

 ;;windows manage
 "C-x 3"      (split-window-func-with-other-buffer 'split-window-horizontally)
 "C-x 2"      (split-window-func-with-other-buffer 'split-window-vertically)
 "C-x 1"      #'doom/toggle-delete-other-windows
 "C-x \\"     #'split-window-horizontally-instead
 "C-x -"      #'split-window-vertically-instead
 "<f7>"       #'doom/split-window
 "C-c <down>" #'doom/toggle-current-window-dedication
 ;;buffer
 ;; "C-x C-b"    #'switch-to-buffer
 ;; "C-x b"      #'list-buffers
 ;; "C-x C-k"    #'kill-buffer
 ;;windmove
 "S-<left>"   #'windmove-swap-states-left
 "S-<right>"  #'windmove-swap-states-right
 "S-<up>"     #'windmove-swap-states-up
 "S-<down>"   #'windmove-swap-states-down
 ;;capitalize
 "M-c"        #'capitalize-dwim
 "M-l"        #'downcase-dwim
 "M-u"        #'upcase-dwim)

;; (defun doom-reverse-region-characters (beg end)
;;   "Reverse the characters in the region from BEG to END.
;; Interactively, reverse the characters in the current region."
;;   (interactive "*r")
;;   (insert (reverse (delete-and-extract-region beg end))))

(eval-when! IS-MAC (define-key global-map (kbd "s-f") #'+default/search-buffer))

;; Isearch use my prefer Isearch workflow.
(map!  ;:desc "isearch" :m "/"  #'isearch-forward-regexp
 (:map minibuffer-local-isearch-map
       [?\t] #'isearch-complete-edit
       "\r" #'isearch-forward-exit-minibuffer)
 (:map isearch-mode-map
       [remap isearch-delete-char] #'isearch-del-char
       "M-s -" #'isearch-toggle-symbol
       "M-s a" #'isearch-beginning-of-buffer
       "M-s e" #'isearch-end-of-buffer
       "M-s ." #'isearch-forward-symbol-at-point
       "M-s t" #'isearch-forward-thing-at-point
       "<escape>" #'isearch-abort
       "," #'isearch-repeat-backward
       ";" #'isearch-repeat-forward
       "/" #'isearch-edit-string))
(customize-set-variable 'isearch-lazy-count t)
(customize-set-variable 'lazy-highlight t)
(customize-set-variable 'lazy-count-prefix-format nil)
(customize-set-variable 'lazy-count-suffix-format "[%s/%s]")
(customize-set-variable 'isearch-allow-motion t)
(customize-set-variable 'isearch-repeat-on-direction-change t)
(customize-set-variable 'isearch-motion-changes-direction t)

;; (defun iwcz-add-string-to-evil-search (string)
;;   (cl-destructuring-bind (success pattern offset)
;;       (evil-ex-search-full-pattern string 1 'forward)
;;     (ignore success)
;;     (setq evil-ex-search-pattern pattern
;;           evil-ex-search-offset offset
;;           evil-ex-search-direction 'forward)))

;; ;; combine the Isearch and Evil-ex-search.
;; (defun evil-isearch--turn-on ()
;;   (add-hook 'isearch-mode-end-hook
;;             (lambda () (iwcz-add-string-to-evil-search isearch-string)) -1 t))
;; (define-globalized-minor-mode global-evil-isearch-mode nil evil-isearch--turn-on)
;; (global-evil-isearch-mode +1)

;; ;; combine the consult with Evil-ex-search
;; (after! consult
;;   (defun +consult--line-hist-evil-a (&rest args)
;;     "after `consult--line' copy the car of `consult--line-history'to Evil"
;;     (ignore args)
;;     (when-let ((hist (car consult--line-history)))
;;       (iwcz-add-string-to-evil-search hist)))
;;   (advice-add 'consult--read :after #'+consult--line-hist-evil-a))

;; Feature `whitespace' provides a minor mode for highlighting
;; whitespace in various special ways.
;;;; Whitespace
(defun doom-highlight-non-default-indentation-h ()
  "Highlight whitespace at odds with `indent-tabs-mode'.
That is, highlight tabs if `indent-tabs-mode' is `nil', and highlight spaces at
the beginnings of lines if `indent-tabs-mode' is `t'. The purpose is to make
incorrect indentation in the current buffer obvious to you.

Does nothing if `whitespace-mode' or `global-whitespace-mode' is already active
or if the current buffer is read-only or not file-visiting."
  (unless (or (eq major-mode 'fundamental-mode)
              (bound-and-true-p global-whitespace-mode)
              (null buffer-file-name))
    (require 'whitespace)
    (set (make-local-variable 'whitespace-style)
         (cl-union (if indent-tabs-mode
                       '(indentation)
                     '(tabs tab-mark))
                   (when whitespace-mode
                     (remq 'face whitespace-active-style))))
    (cl-pushnew 'face whitespace-style) ; must be first
    (whitespace-mode +1)))
(add-hook 'after-change-major-mode-hook
          #'doom-highlight-non-default-indentation-h 'append)

(define-minor-mode doom-highlight-long-lines-mode
  "Minor mode for highlighting long lines."
  :after-hook
  (if doom-highlight-long-lines-mode
      (progn
        (setq-local whitespace-style '(face lines-tail))
        (setq-local whitespace-line-column 79)
        (whitespace-mode +1))
    (whitespace-mode -1)
    (kill-local-variable 'whitespace-style)
    (kill-local-variable 'whitespace-line-column)))
(add-hook 'prog-mode-hook #'doom-highlight-long-lines-mode)
(defun toggle-doom-highlight-long-lines-mode ()
  (if doom-highlight-long-lines-mode
      (doom-highlight-long-lines-mode -1)
    (doom-highlight-long-lines-mode +1)))
(add-hook! '(ediff-prepare-buffer-hook ediff-quit-hook) #'toggle-doom-highlight-long-lines-mode)

;;
;;; frame-alist
(appendq! initial-frame-alist
          `((tool-bar-lines . 0)
            (menu-bar-lines . 0)
            (scroll-bar . nil)
            (vertical-scroll-bars . nil)
            (internal-border-width . 0)
            (alpha . (90 . 80))
            ;; (fullscreen . maximized)
            ;; (undecorated . t)
            ,@(eval-if! IS-LINUX
                  '((icon-type . nil)
                    (alpha-background . 80)))
            ,@(eval-if! IS-MAC
                  '((ns-transparent-titlebar . t)
                    (ns-appearance . t)))))
(appendq! default-frame-alist initial-frame-alist)

;;
;;; title-format
(setq frame-title-format
      '(""
        (:eval
         (if (eq major-mode 'org-mode)
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?  (or buffer-file-name "Null")))
           "%b"))
        (:eval (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s")
                       (doom-project-name))))
      icon-title-format frame-title-format)

;;
;;;; mode-line
;;;; Default Mode-line format
;; Normally the buffer name is right-padded with whitespace until it
;; is at least 12 characters. This is a waste of space, so we
;; eliminate the padding here. Check the docstrings for more
;; information.
(setq-default mode-line-buffer-identification
              (propertized-buffer-identification "%b"))
;; Make `mode-line-position' show the column, not just the row.
(column-number-mode +1)


(when (modulep! :ui modeline +light)
  (customize-set-variable '+modeline-height 28))

;; ;; open `emacs.d' directory.
;; (defun open-doom-file ()
;;   "Open conf file conveniently"
;;   (interactive)
;;   (let ((default-directory doom-emacs-dir))
;;     (call-interactively #'find-file)))
;; (map! (:map doom-zip-keymap "f" #'open-doom-file))


(defmacro doom-register-dotfile
    (filename &optional keybinding pretty-filename)
  "Establish functions and keybindings to open a dotfile.

The FILENAME should be a path relative to the user's home
directory. Two interactive functions are created: one to find the
file in the current window, and one to find it in another window.

If KEYBINDING is non-nil, the first function is bound to that key
sequence after it is prefixed by \"\\[doom-mp-keymap] e\", and the
second function is bound to the same key sequence, but prefixed
instead by \"\\[doom-mp-keymap] o\".

This is best demonstrated by example. Suppose FILENAME is
\".emacs.d/init.el\" and KEYBINDING is \"e i\". Then
`doom-register-dotfile' will create the interactive functions
`doom-find-init-el' and `doom-find-init-el-other-window', and
it will bind them to the key sequences \"\\[doom-mp-keymap] e e
i\" and \"\\[doom-mp-keymap] o e i\" respectively.

If PRETTY-FILENAME, a string, is non-nil, then it will be used in
place of \"init-el\" in this example. Otherwise, that string will
be generated automatically from the basename of FILENAME.

To pass something other than a literal string as FILENAME,
unquote it using a comma."
  (when (and (listp filename) (eq (car filename) '\,))
    (setq filename (eval (cadr filename))))
  (let* ((bare-filename (replace-regexp-in-string ".*/" "" filename))
         (full-filename (expand-file-name filename "~"))
         (defun-name (intern
                      (replace-regexp-in-string
                       "-+"
                       "-"
                       (concat
                        "doom-find-"
                        (or pretty-filename
                            (replace-regexp-in-string
                             "[^a-z0-9]" "-"
                             (downcase
                              bare-filename)))))))
         (defun-other-window-name
          (intern
           (concat (symbol-name defun-name)
                   "-other-window")))
         (docstring (format "Edit file %s." full-filename))
         (docstring-other-window
          (format "Edit file %s, in another window."
                  full-filename))
         (defun-form `(defun ,defun-name ()
                        ,docstring
                        (interactive)
                        (when (or (file-exists-p ,full-filename)
                                  (yes-or-no-p
                                   ,(format
                                     "Does not exist, really visit %s? "
                                     (file-name-nondirectory
                                      full-filename))))
                          (find-file ,full-filename))))
         (defun-other-window-form
          `(defun ,defun-other-window-name ()
             ,docstring-other-window
             (interactive)
             (when (or (file-exists-p ,full-filename)
                       (yes-or-no-p
                        ,(format
                          "Does not exist, really visit %s? "
                          (file-name-nondirectory
                           full-filename))))
               (find-file-other-window ,full-filename))))
         (full-keybinding
          (when keybinding
            (doom--join-keys "e" keybinding)))
         (full-other-window-keybinding
          (doom--join-keys "o" keybinding)))
    `(progn
       ,defun-form
       ,defun-other-window-form
       ,@(when full-keybinding
           `((define-key doom-mp-keymap (kbd ,full-keybinding) #',defun-name)))
       ,@(when full-other-window-keybinding
           `((define-key doom-mp-keymap
              (kbd ,full-other-window-keybinding)
              #',defun-other-window-name)))
       ;; Return the symbols for the two functions defined.
       (list ',defun-name ',defun-other-window-name))))

;; Now we register shortcuts to files relevant to Doom.
(doom-register-dotfile ,doom-emacs-dir "r a" "doom-repo")
;; Emacs
(doom-register-dotfile
 ,(expand-file-name "early-init.el" doom-emacs-dir) "e e")
(doom-register-dotfile
 ,(expand-file-name "lisp/doom-start.el" doom-emacs-dir) "e t")
(doom-register-dotfile
 ,(expand-file-name "lisp/doom.el" doom-emacs-dir) "e d")
(doom-register-dotfile
 ,(expand-file-name "lisp/doom-lib.el" doom-emacs-dir) "e b")
;; Private config
(doom-register-dotfile
 ,(expand-file-name "init.el" doom-private-dir) "e i")
(doom-register-dotfile
 ,(expand-file-name "config.el" doom-private-dir) "e c")


(defun doom-indent-defun ()
  "Indent the surrounding defun."
  (interactive)
  (save-excursion
    (when (beginning-of-defun)
      (let ((beginning (point)))
        (end-of-defun)
        (let ((end (point)))
          (let ((inhibit-message t)
                (message-log-max nil))
            (indent-region beginning end)))))))
(define-key global-map (kbd "C-x TAB") #'doom-indent-defun)


;;
;;; pretty formfeed
(defun xah-insert-formfeed ()
  "Insert a form feed char (codepoint 12)"
  (interactive)
  (insert "\u000c\n"))
(defun xah-show-formfeed-as-line (&optional frame)
  "Display the formfeed ^L char as line."
  (interactive)
  (letf! (defun pretty-formfeed-line (window)
           (with-current-buffer (window-buffer window)
             (with-selected-window window
               (when (not buffer-display-table)
                 (setq buffer-display-table (make-display-table)))
               (aset buffer-display-table ?\^L
                     (vconcat (make-list 70 (make-glyph-code ?─ 'font-lock-comment-face))))
               (redraw-frame))))
    (unless (minibufferp)
      (mapc 'pretty-formfeed-line (window-list frame 'no-minibuffer)))))
(dolist (hook '(window-configuration-change-hook
                window-size-change-functions
                after-setting-font-hook
                display-line-numbers-mode-hook))
  (add-hook hook #'xah-show-formfeed-as-line))


(eval-after-load 'smartparens
  '(progn (sp-use-paredit-bindings)
          (sp-local-pair '(org-mode) "<<" ">>" :actions '(insert))))

(after! tramp
  (setenv "SHELL" "/bin/bash")
  (setq tramp-shell-prompt-pattern "\\(?:^\\|
\\)[^]#$%>\n]*#?[]#$%>] *\\(\\[[0-9;]*[a-zA-Z] *\\)*"))


;; (set-lookup-handlers! 'lisp-mode :documentation #'sly-hyperspec-lookup)

;;org-mode
(setq org-directory "~/org/"
      org-id-locations-file (expand-file-name ".orgids" org-directory))
(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a.")))
(add-hook 'org-mode-hook #'+org-pretty-mode)
(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.25)
  '(outline-2 :weight bold :height 1.15)
  '(outline-3 :weight bold :height 1.12)
  '(outline-4 :weight semi-bold :height 1.09)
  '(outline-5 :weight semi-bold :height 1.06)
  '(outline-6 :weight semi-bold :height 1.03)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold)
  '(org-document-title :height 1.2))
(after! org-superstar
  (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-superstar-prettify-item-bullets t ))
(setq org-ellipsis " ▾ "
      org-hide-leading-stars t
      org-priority-highest ?A
      org-priority-lowest ?E
      org-priority-faces
      '((?A . 'all-the-icons-red)
        (?B . 'all-the-icons-orange)
        (?C . 'all-the-icons-yellow)
        (?D . 'all-the-icons-green)
        (?E . 'all-the-icons-blue)))

;; For some file types, we overwrite defaults in the [[file:./snippets][snippets]] directory, others
;; need to have a template assigned.
(set-file-template! "\\.tex$" :trigger "__" :mode 'latex-mode)
(set-file-template! "\\.org$" :trigger "__" :mode 'org-mode)
(set-file-template! "/LICEN[CS]E$" :trigger '+file-templates/insert-license)

;; It's nice to see ANSI colour codes displayed
(after! text-mode
  (add-hook! 'text-mode-hook
             ;; Apply ANSI color codes
             (with-silent-modifications
               (ansi-color-apply-on-region (point-min) (point-max)))))

(when (modulep! :lang common-lisp)
  (setq inferior-lisp-program "ros -Q run")

  (after! hyperspec (setq common-lisp-hyperspec-root (concat "file://C:/Users/ez/Zadian/doom/docs/HyperSpec/")))
  ;; buifix the warnings, when use the roswell to start sly.
  (after! sly
    (defadvice! +common-lisp-init-sly-h-a ()
      "advise the sly start"
      :override #'+common-lisp-init-sly-h
      (cond ((or (doom-temp-buffer-p (current-buffer))
                 (sly-connected-p)))
            ((executable-find (car (split-string inferior-lisp-program " +")))
             (let ((sly-auto-start 'always))
               (sly-auto-start)
               (add-hook 'kill-buffer-hook #'+common-lisp--cleanup-sly-maybe-h nil t)))
            ((message "WARNING: Couldn't find `inferior-lisp-program' (%s)"
                      inferior-lisp-program))))))

;; lsp-bridge
(add-hook 'doom-first-buffer-hook #'global-lsp-bridge-mode)
(customize-set-variable 'acm-enable-quick-access t)
(customize-set-variable 'acm-enable-yas nil)
(customize-set-variable 'acm-candidate-match-function 'orderless-flex)

;; Evil
(customize-set-variable 'evil-escape-key-sequence (kbd "kj"))

(appendq! +evil-collection-disabled-list
          '(magit
            magit-section
            magit-todos))
;;
;;; Command;
(defalias #'doom/kill-current-buffer #'kill-current-buffer)

;;
;;;bugfix
;; +format:region may call `apheleia--get-fomatters' before loading `apheleia'
(autoload #'apheleia--get-formatters "apheleia-core")

;;
;;; Backport

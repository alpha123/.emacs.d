;; ELPA
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;; For themes not in ELPA/MELPA/Marmalade
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/base16-emacs/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/tomorrow-theme/GNU Emacs")


;; Install required packages if they don't exit
;; From https://github.com/bbatsov/prelude/blob/master/core/prelude-packages.el
(defvar required-packages
  (list 'ace-jump-mode 'ack-and-a-half 'auto-complete 'auto-indent-mode 'autopair
        'coffee-mode 'expand-region 'icicles 'jump-char 'key-chord 'magit 'markdown-mode
        'multiple-cursors 'rainbow-mode 'rainbow-delimiters 'slime-js 'stylus-mode
        'undo-tree 'wgrep-ack 'yasnippet 'zencoding-mode)
  "A list of packages to ensure are installed at launch.")

(while required-packages
  (if (not (package-installed-p (car required-packages)))
      (package-install (car required-packages)))
  (setq required-packages (cdr required-packages)))

;; SLIME

;; Clozure
(setq inferior-lisp-program "C:/CommonLisp/ccl/wx86cl.exe")

;; SBCL
;(setq inferior-lisp-program "C:/CommonLisp/SBCL/1.0.52/sbcl.exe")

;; For some reason, I get errors with the SLIME installed from package.el
(add-to-list 'load-path "C:/CommonLisp/slime/")
(require 'slime-autoloads)
(slime-setup '(slime-fancy slime-js))

;; slime-js
(global-set-key [f5] 'slime-js-reload)
(add-hook 'js2-mode-hook
          (lambda ()
            (slime-js-minor-mode 1)))

(add-hook 'css-mode-hook
          (lambda ()
            (define-key css-mode-map "\M-\C-x" 'slime-js-refresh-css)
            (define-key css-mode-map "\C-c\C-r" 'slime-js-embed-css)))


;; Syntax modes

;; CoffeeScript
(autoload 'coffee-mode "coffee-mode.el" "CoffeeScript mode" t)
(setq auto-mode-alist (append '(("\\.coffee$" . coffee-mode))
			      auto-mode-alist))

(autoload 'stylus-mode "stylus-mode.el" "Stylus mode" t)
(setq auto-mode-alist (append '(("\\.styl$" . coffee-mode))
                              auto-mode-alist))

;; Zen coding
(autoload 'zencoding-mode "zencoding-mode.el" "Zen Coding mode" t)
(add-hook 'sgml-mode-hook 'zencoding-mode)

;; Markdown
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist (append '(("\\.md$" . markdown-mode))
			      auto-mode-alist))
(setq markdown-command "marked")


;; Pretty stuff
(set-face-attribute 'default nil :font "Source Code Pro-10")
(set-face-attribute 'default nil :background "#fefefe")
(set-face-attribute 'region nil :background "#9dd3ff")

;; A pretty theme
(load-theme 'tomorrow t)

;; Replace certain strings with equivalent symbols (lambda -> Greek lambda symbol, etc)
(add-to-list 'load-path "~/.emacs.d/pretty-mode/")  ; Use my version instead of the ELPA/MELPA/Marmalade one
(require 'pretty-mode)
(global-pretty-mode 1)


;; Use UTF-8
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)


;; Ack
(require 'ack-and-a-half)
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)
(require 'wgrep-ack)


;; Rainbow Delimiters
;; http://www.emacswiki.org/emacs/RainbowDelimiters
(require 'rainbow-delimiters)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)


;; More vertical space!
(tool-bar-mode -1)

;; I much prefer to overwrite the selection
(delete-selection-mode 1)

;; And I also like to reopen my buffers on the rare occasions when I have to
;; close and reopen Emacs.
(desktop-save-mode 1)

;; Just y or n please.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Sensible undoing
(require 'undo-tree)
(global-undo-tree-mode)
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-S-z") 'undo-tree-redo)

;; Why the heck does Emacs use such a weird indenting style by default?
(setq-default indent-tabs-mode nil)

;; Automatically activate rainbow-mode for CSS files
(add-hook 'css-mode-hook 'rainbow-mode)


;; Multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; expand region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Ace Jump
;; http://www.emacswiki.org/emacs/AceJump
(require 'ace-jump-mode)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;; jump-char
(require 'jump-char)
(global-set-key (kbd "C-c f") 'jump-char-forward)
(global-set-key (kbd "C-c F") 'jump-char-backward)

;; Auto indent -- this has to be loaded before Yasnippets and Autopair
(require 'auto-indent-mode)
(auto-indent-global-mode)

;; Yasnippets
(require 'yasnippet)
(yas-global-mode 1)
(setq yas/root-directory "~/.emacs.d/yasnippets/")
(yas/load-directory yas/root-directory)

;; Autopair
(require 'autopair)
(autopair-global-mode)

;; Autocompletion, dude.
(require 'auto-complete)
(global-auto-complete-mode)

;; Key chords -- press two keys at the same time, run a command.
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define-global ",." "<>\C-b")
(key-chord-define-global "fg" 'jump-char-forward)
(key-chord-define-global "fd" 'jump-char-backward)
(key-chord-define-global "xc" 'ace-jump-mode)


;; Show line numbers when invoking goto-line
;; From http://whattheemacsd.com/key-bindings.el-01.html
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (call-interactively 'goto-line))
    (linum-mode -1)))


;; Cursor styles
;; From http://emacs-fu.blogspot.com/2009/12/changing-cursor-color-and-shape.html
;; Change cursor color according to mode; inspired by
;; http://www.emacswiki.org/emacs/ChangingCursorDynamically
(setq djcb-read-only-color       "black")
;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar. HEIGHT); see the docs for set-cursor-type

(setq djcb-read-only-cursor-type 'hbar)
(setq djcb-overwrite-color       "#333333")
(setq djcb-overwrite-cursor-type 'box)
(setq djcb-normal-color          "#333333")
(setq djcb-normal-cursor-type    'bar)

(defun djcb-set-cursor-according-to-mode ()
  "change cursor color and type according to some minor modes."

  (cond
    (buffer-read-only
      (set-cursor-color djcb-read-only-color)
      (setq cursor-type djcb-read-only-cursor-type))
    (overwrite-mode
      (set-cursor-color djcb-overwrite-color)
      (setq cursor-type djcb-overwrite-cursor-type))
    (t 
      (set-cursor-color djcb-normal-color)
      (setq cursor-type djcb-normal-cursor-type))))

(add-hook 'post-command-hook 'djcb-set-cursor-according-to-mode)


;; Icicles
(require 'icicles)
(icy-mode)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#ffffff" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#4271ae" "#4d4d4c"])
 '(custom-safe-themes (quote ("d05303816026cec734e26b59e72bb9e46480205e15a8a011c62536a537c29a1a" "a64e1e2ead17a9322f6011f6af30f41bd6c2b3bbbf5e62700c8c3717aac36cbf" "8643546ef586d1bc6e887c0aceab520b086126f13a86631c917f293b2c660cf1" "545287ef14b1b686cd88a99cf6ab3629e55ef6b73d59a76253eec65f4ead4fee" "bd6e539f641b33aeaf21ae51266bd9dfd6c1f2d550d109192e1c678b440242ad" "1cc69add80a116d4ceee9ab043bb3d372f034586da54c9677d0fff99231e5eb9" "a0aca9963b34ddf04767e2fe85abd67009bdf975027b81bac385a7e9d549f54d" "1d9f2295049aacd2ba2cf0068b8b6985b78e1913c001135cc7d9930b037493e5" "03b649ae49a7d40c7115611f1da3e126c33c10b96dd18ee45bdd8319ed375a78" "e9a1226ffed627ec58294d77c62aa9561ec5f42309a1f7a2423c6227e34e3581" "944f3086f68cc5ea9dfbdc9e5846ad91667af9472b3d0e1e35a9633dcab984d5" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "746b83f9281c7d7e34635ea32a8ffa374cd8e83f438b13d9cc7f5d14dc826d56" default)))
 '(fci-rule-color "#383838")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-tail-colors (quote (("#eee8d5" . 0) ("#B4C342" . 20) ("#69CABF" . 30) ("#69B7F0" . 50) ("#DEB542" . 60) ("#F2804F" . 70) ("#F771AC" . 85) ("#eee8d5" . 100))))
 '(js2-highlight-level 3)
 '(js2-include-gears-externs nil)
 '(js2-include-rhino-externs nil)
 '(js2-strict-missing-semi-warning nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

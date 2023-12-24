;; ------------------------------------------------------------------------------
;; globals
;; ------------------------------------------------------------------------------
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq use-dialog-box nil)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))
(setq column-number-mode t)

(set-frame-font "JetBrainsMono Nerd Font 13" nil t)

(recentf-mode 1)
(save-place-mode 1)

(global-auto-revert-mode )
(setq global-auto-revert-non-file-buffers t)

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; ------------------------------------------------------------------------------
;; package management
;; ------------------------------------------------------------------------------
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
    (load bootstrap-file nil 'nomessage))

(use-package straight
  :custom
  (straight-use-package-by-default t))

;; ------------------------------------------------------------------------------
;; theme
;; ------------------------------------------------------------------------------
(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin t)
  (setq catppuccin-flavor 'latte)
  (catppuccin-reload))

;; ------------------------------------------------------------------------------
;; which-key
;; ------------------------------------------------------------------------------
(use-package which-key
  :config
  (which-key-mode))

;; ------------------------------------------------------------------------------
;; projects
;; ------------------------------------------------------------------------------
(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package magit)

;; ------------------------------------------------------------------------------
;; tramp
;; ------------------------------------------------------------------------------
(with-eval-after-load "tramp"
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; ------------------------------------------------------------------------------
;; treesitter
;; ------------------------------------------------------------------------------
(use-package go-mode)

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp")
	(c "https://github.com/tree-sitter/tree-sitter-c")
	(go "https://github.com/tree-sitter/tree-sitter-go")
	(gomod "https://github.com/camdencheek/tree-sitter-go-mod")
	(json "https://github.com/tree-sitter/tree-sitter-json")
	(python "https://github.com/tree-sitter/tree-sitter-python")
	(rust "https://github.com/tree-sitter/tree-sitter-rust")
	(toml "https://github.com/tree-sitter/tree-sitter-toml")
	(typescript "https://github.com/tree-sitter/tree-sitter-typecsript")
	(yaml "https://github.com/tree-sitter/tree-sitter-yml")))

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode))
(add-to-list 'major-mode-remap-alist '(go-mod-mode . go-mod-ts-mode))
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))

;; ------------------------------------------------------------------------------
;; lsp
;; ------------------------------------------------------------------------------
(add-hook 'prog-mode-hook '(lambda ()
			     (setq truncate-lines t
				   word-wrap nil)))

(use-package company
  :after eglot
  :hook (eglot-managed-mode . company-mode))

(add-hook 'c-ts-mode-hook 'eglot)
(add-hook 'c++-ts-mode-hook 'eglot)
(add-hook 'go-ts-mode-hook 'eglot-ensure)
(add-hook 'python-ts-mode-hook 'eglot-ensure)

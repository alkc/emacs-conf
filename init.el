;; FOR EARLY-INIT:
;; (push '(menu-bar-lines . 0) default-frame-alist)
;; (push '(tool-bar-lines . 0) default-frame-alist)
;; (push '(vertical-scroll-bars) default-frame-alist)

;; Setup central bkp dir:
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; PKG CONF
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Not required after emacs 30 <=
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

;; BASIC UI

(setq inhibit-startup-message t)

(scroll-bar-mode -1)   ; No scrollbar
(tool-bar-mode -1)     ; No toolbar
(tooltip-mode -1)      ; No tooltips?
(set-fringe-mode 10)
(menu-bar-mode -1)     ; No menu bar

;; Yes to visible bell
(setq visible-bell t)

;; THEME
(use-package doom-themes
  :config
  (load-theme 'doom-gruvbox t)
  (doom-themes-visual-bell-config)
  )

;; UI/LOOKS:
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)   ;; INIT is configured before/right after the pkg is loaded by use-package
  :custom (doom-modeline-time t) 
  )
      


;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(dolist
    (mode '(org-mode-hook
	    term-mode-hook
	    shell-mode-hook
	    eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; pkg for logging commands / keys pressed
(use-package command-log-mode)

;; Ivy autocompletion
(use-package ivy
  :diminish ;; Do not show modename in modeline
  :bind (("C-s" . swiper))
  :config                    ;; CONFIG is loaded AFTER pkg is loaded/initialized
  (ivy-mode 1))

(use-package which-key
  :init (which-key-mode 1)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3)
)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)) ;; prog-mode is the base mode of any programming mode

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  )

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  
  :config
  (setq ivy-initial-inputs-alist nil) ;; Don't start searches w/ ^
  )

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package nextflow-mode
  :config
  :vc (:fetcher github :repo edmundmiller/nextflow-mode)
  (set-docsets! 'nextflow-mode "Groovy"))

(use-package material-theme)
(use-package vundo
  :bind ("C-ä" .  vundo))

;; Config dark/light mode switcher                                                       
(use-package heaven-and-hell                                                             
  :ensure t                                                                              
  :config                                                                                
  (setq heaven-and-hell-theme-type 'dark) ;; Omit to use light by default                
  (setq heaven-and-hell-themes                                                           
        '((light . material-light)                                                    
          (dark . doom-gruvbox))) ;; Themes can be the list: (dark . (tsdh-dark wombat)) 
  ;; Optionall, load themes without asking for confirmation.                             
  (setq heaven-and-hell-load-theme-no-confirm t)                                         
  :hook (after-init . heaven-and-hell-init-hook)                                         
  :bind (("C-c <f6>" . heaven-and-hell-load-default-theme)                               
         ("<f6>" . heaven-and-hell-toggle-theme)))                                       


;; Add col indicator for prog modes. Can probably be speced by mode? 100 is nice tho
(setq-default display-fill-column-indicator-column 100)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)


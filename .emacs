(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes (quote (("left8" (0.2138728323699422 . 0.28888888888888886) (0.2138728323699422 . 0.2222222222222222) (0.2138728323699422 . 0.28888888888888886) (0.2138728323699422 . 0.17777777777777778)))))
 '(ecb-options-version "2.40")
 '(ecb-source-path nil)
 '(ecb-tip-of-the-day nil)
 '(ede-project-directories (quote ("/root/Documents")))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight bold :height 113 :width normal)))))

(add-to-list 'load-path "/private/emacs-plugs/color-theme-6.6.0/")
(add-to-list 'load-path "/private/emacs-plugs/color-theme-6.6.0/themes/");
;;(require 'color-theme)
;;(color-theme-initialize)
;;(setq color-theme-is-global t)
;;(color-theme-gray30)
(setq stack-trace-on-error t)
(setq make-backup-files nil)
(global-linum-mode 1)
(setq linum-format "%3d ")
(setq default-tab-width 4)
(setq tab-width 4)
(load-file "/private/emacs-plugs/cedet-1.1/common/cedet.el")
(global-ede-mode 1)
(add-to-list 'load-path "/private/emacs-plugs/ecb-2.40/")
(setq scroll-margin 3
scroll-conservatively 1000000)
(setq-default line-spacing 2)
(global-font-lock-mode 1)
;;(setq tags-file-name "/usr/include/TAGS")
(require 'generic-x)
(require 'ecb)

;;set for cscope
(load-file "/private/emacs-plugs/cscope-15.8a/contrib/xcscope/xcscope.el")
(require 'xcscope)

;;set for org-mode


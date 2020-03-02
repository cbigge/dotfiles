(setq inhibit-startup-message t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list `package-archives
	'("melpha" . "https://melpa.org/packages/"))

(package-initialize)

(require 'dash)
(require 'treemacs)
(require 'calibredb)
(require 'treemacs-mouse-interface)
(require 'treemacs-treelib)
(require 'treemacs-rendering)
(require 'TreemacsExt)
(require 'all-the-icons-dired)

(defun calibredb-list-ebooks()
  (interactive)
  (calibredb-search-keyword-filter calibredb-search-filter)
  ;;(list "book1" "book2" "book3")
  )

(treemacs-define-entry-node-type TreemacsExt_Calibredb
  :label (propertize "Ebooks" 'face 'font-lock-keyword-face)
  :key 'TreemacsExt_Calibredb
  :open-icon (all-the-icons-dired--icon "~/Documents")
  :closed-icon (all-the-icons-dired--icon "~/Documents")
  :children (calibredb-list-ebooks)
  :child-type 'ebook)

(treemacs-define-leaf-node-type ebook-metainfo-value
  :label item
  ;; :icon (treemacs-get-icon-value 'node)
  :icon (all-the-icons-dired--icon "catalog")
  :key item
  )

(treemacs-define-leaf-node-type ebook-metainfo-item
  :key item
  :icon (treemacs-get-icon-value 'tag-leaf)
  ;; :icon (all-the-icons-dired--icon "metadata.json")
  :label (format "%s:%s"
				 (string-trim (symbol-name (nth 0 item)) ":")
				 (nth  1 item))
  )
(defun treemacs-calibredb-open-book(&optional state)
  (message "openning book...")
  (calibredb-find-file
   (cdr (treemacs-button-get (treemacs-node-at-point) :item))
   )
  (message "book opened")
  )

(treemacs-define-expandable-node-type ebook
  ;; :closed-icon (treemacs-get-icon-value 'mail-plus)
  :closed-icon (all-the-icons-dired--icon "~/org-roam-files")
  ;; :closed-icon "+ "
  :open-icon (all-the-icons-dired--icon "README")
  :label (calibredb-getattr (cdr item) :book-title)
  :key item
  :children (--filter (not (string= "" (nth 1 it))) (nth 1 item))
  :child-type 'ebook-metainfo-item
  :ret-action #'treemacs-calibredb-open-book
  )

;; (treemacs-enable-project-extension
(treemacs-enable-top-level-extension
 :extension 'TreemacsExt_Calibredb
 :position 'bottom
 ;; :predicate (lambda (_)t)
 ;; :predicate (lambda (project) (eq project (car (treemacs-workspace->projects (treemacs-current-workspace)))))
 ;; :predicate (lambda (project) (eq project treemacs--project-of-extision-info))
 :predicate (lambda(_)(string= (treemacs-workspace->name (treemacs-current-workspace)) "Disks"))
 )

;; (treemacs-disable-project-extension
;; (treemacs-disable-top-level-extension
;;  :extension 'TreemacsExt_Calibredb
;;  :position 'top
;;  )
(provide 'TreemacsExt_Calibredb)

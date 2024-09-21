(require 'calibredb)
(require 'treemacs)
(require 'treemacs-mouse-interface)
(require 'treemacs-rendering)
(require 'TreemacsExt)


(defun calibredb-list-ebooks()
  (interactive)
  (calibredb-search-keyword-filter calibredb-search-filter)
  ;;(list "book1" "book2" "book3")
  )

(treemacs-define-entry-node-type TreemacsExt_Calibredb
  :label (propertize "Ebooks" 'face 'font-lock-keyword-face)
  :key 'TreemacsExt_Calibredb
  :open-icon (treemacs-get-icon-value 'list)
  :closed-icon (treemacs-get-icon-value 'list)
  :children (calibredb-list-ebooks)
  :child-type 'ebook)

(treemacs-define-leaf-node-type ebook-metainfo-value
  :label item
  :icon (treemacs-get-icon-value 'node)
  :key item
  )

(treemacs-define-entry-node-type ebook-metainfo-item
  :key item
  :open-icon (treemacs-get-icon-value 'list)
  :closed-icon (treemacs-get-icon-value 'list)
  :label (string-trim (symbol-name (nth 0 item)) ":")
  ;; :children (list "1" "2")
  :children (list (nth 1 item))
  :child-type 'ebook-metainfo-value
  )
(defun treemacs-calibredb-open-book(&optional state)
  (message "open book")
  (calibredb-find-file
   (cdr (treemacs-button-get (treemacs-node-at-point) :item))
   )
  ;; (prin1 (treemacs-button-get (treemacs-node-at-point) :item))
  )

(treemacs-define-expandable-node-type ebook
  ;; :closed-icon (treemacs-get-icon-value 'mail-plus)
  :closed-icon (all-the-icons-dired--icon "d:/EmacsConfig/Documents")
  ;; :closed-icon "+ "
  :open-icon (all-the-icons-dired--icon "d:/EmacsConfig/Documents")
  :label (calibredb-getattr (cdr item) :book-title)
  :key item
  ;; :children (nth 1 item)
  :children (--filter (not (string= "" (nth 1 it))) (nth 1 item))
  :child-type 'ebook-metainfo-item
  :ret-action #'treemacs-calibredb-open-book
  ;; :ret-action (lambda(arg) (calibredb-find-file (cdr item) nil)) 
  )

(treemacs-enable-project-extension
 :extension 'TreemacsExt_Calibredb
 :position 'top
 ;; :predicate (lambda (_)t)
 ;; :predicate (lambda (project) (eq project (car (treemacs-workspace->projects (treemacs-current-workspace)))))
 :predicate (lambda (project) (eq project treemacs--project-of-extision-info))
 )

(provide 'TreemacsExt_Calibredb)

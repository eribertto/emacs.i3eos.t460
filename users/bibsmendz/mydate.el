;;; mydate.el --- Insert date as per link https://emacswiki.org/emacs/InsertDate
;;; Commentary: see doc string below
;;; Code:

(defun insert-date (prefix)
  "Insert the current date. With a prefix use the ISO format. With 2 prefix args, write out the
day month date, year format."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%d.%m.%Y")
                 ((equal prefix '(4)) "%Y-%m-%d")
                 ((equal prefix '(16)) "%A %B %d, %Y")))
                 ;;((equal prefix '(16)) "%A, %d. %B %Y")))
        (system-time-locale "en_US"))
    (insert (format-time-string format)))
  )
(global-set-key (kbd "C-c d") 'insert-date)

;;(get-locale-names)
;;17.08.2023
;;2023-08-17
;;Thursday August 17, 2023

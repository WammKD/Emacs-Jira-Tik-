;;; jira-api-error.el --- functions for interfacing Jira's API Errors
;; Copyright (C) 2020

;; Author: Jonathan Schmeling <jaft.r@outlook.com>
;; Keywords: api, jira, server
;; Version: 0.1

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published
;; by the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public License
;; along with this program; see the file LICENSE.  If not, see
;; <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:
(require 'subr-x)

(cl-defstruct (tike-jira--error (:constructor tike-jira-error--create)
                                (:conc-name   tike-jira-error--get-))
  (error-messages nil) (errors nil))

(defun tike-jira-error-check (json processor)
  ""

  (if-let ((errMsgs (cdr (assoc 'errorMessages json))))
      (tike-jira-error--create :error-messages errMsgs
                               :errors         (cdr (assoc 'errors json)))
    (funcall processor json)))

(provide 'tike-jira-api-error)

;;; jira-api-error.el ends here

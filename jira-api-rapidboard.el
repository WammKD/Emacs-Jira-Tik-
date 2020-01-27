;;; jira-api-rapidboard.el --- functions for interfacing with
;;;                            Jira's Agile API Rapidboards
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
(require 'cl)
(require 'tike-utils)

(cl-deftype tike-jira--rapidboard-type ()
  '(member scrum "scrum" kanban "kanban"))


(cl-defstruct (tike-jira--rapidboard (:constructor tike-jira-rapidboard--create)
                                     (:conc-name   tike-jira-rapidboard--get-))
  (id nil) (self nil) (name nil) (type nil))

(defun tike-jira-rapidboard-create (json)
  "Create a Jira Agile Rapidboard object from a JSON object (as Elisp)."

  (tike-jira-rapidboard--create :id   (cdr-assoc 'id   json)
                                :self (cdr-assoc 'self json)
                                :name (cdr-assoc 'name json)
                                :type (cdr-assoc 'type json)))

(provide 'tike-jira-api-rapidboard)

;;; jira-api-page.el ends here

;;; tike-utils.el --- utility functions for the Tikè Jira library
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
(require 'tike-jira-api-error)

(defun cdr-assoc (key assoc-list)
  "A simple utility function to run (cdr (assoc KEY ASSOC-LIST))."

  (cdr (assoc key assoc-list)))

(defmacro tike-jira-object-create (objectName body)
  "Create a function of name tike-jira-OBJECTNAME-create to process JSON objects
returned by Jira's API. The generated function will automatically call
`tike-jira-error-check' and, assuming that the object is not an error, process
the object through BODY. Use \"obj\" in BODY to handle the returned object from
the API.

Example:

(tike-jira-object-create rapidboard
  (tike-jira-rapidboard--create :id   (cdr-assoc 'id   obj)
                                :self (cdr-assoc 'self obj)
                                :name (cdr-assoc 'name obj)
                                :type (cdr-assoc 'type obj)))"

  `(defun ,(intern (concat "tike-jira-" (symbol-name objectName) "-create")) (json)
     ,(concat
        "Create a Jira "
        (capitalize (symbol-name objectName))
        " object from a JSON object (as Elisp).")

     (tike-jira-error-check json (lambda (obj) ,body))))

(provide 'tike-utils)

;;; tike-utils.el ends here

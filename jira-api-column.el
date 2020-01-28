;;; jira-api-column.el --- functions for interfacing with Jira's API Columns
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
(require 'el)
(require 'tike-utils)

(cl-deftype tike-jira--column-config--constraint-type ()
  '(member none               "none"
           issueCount         "issueCount"
           issueCountExclSubs "issueCountExclSubs"))


(cl-defstruct (tike-jira--column-config (:constructor tike-jira-column-config--create)
                                        (:conc-name   tike-jira-column-config--get-))
  (columns nil) (constraint-type nil))

(tike-jira-object-create column-config
  (tike-jira-column-config--create :columns         (mapcar
                                                      'tike-jira-column-config-column-create
                                                      (cdr-assoc 'columns        obj))
                                   :constraint-type   (cdr-assoc 'constraintType obj)))


(cl-defstruct (tike-jira--column-config-column (:constructor tike-jira-column-config-column--create)
                                               (:conc-name   tike-jira-column-config-column--get-))
  (name nil) (statuses nil))

(tike-jira-object-create column-config-column
  (tike-jira-column-config-column--create :name     (cdr-assoc 'name obj)
                                          :statuses (mapcar
                                                      'tike-jira-group-create
                                                      (cdr-assoc 'statuses obj))))

(provide 'tike-jira-api-column)

;;; jira-api-column.el ends here

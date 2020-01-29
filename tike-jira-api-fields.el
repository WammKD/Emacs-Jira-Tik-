;;; jira-api-fields.el --- functions for interfacing with Jira's API Fieldses
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
(require 'tike-jira-api-issue-type)
(require 'tike-jira-api-priority)
(require 'tike-jira-api-status)
(require 'tike-utils)

(cl-defstruct (tike-jira--fields (:constructor tike-jira-fields--create)
                                 (:conc-name   tike-jira-fields--get-))
  (summary nil) (status nil) (issue-type nil) (priority nil))

(tike-jira-object-create fields
  (tike-jira-fields--create :summary    (cdr-assoc 'summary     obj)
                            :status     (tike-jira-status-create
                                          (cdr-assoc 'status    obj))
                            :issue-type (tike-jira-issuetype-create
                                          (cdr-assoc 'issuetype obj))
                            :priority   (tike-jira-priority-create
                                          (cdr-assoc 'priority  obj))))

(provide 'tike-jira-api-fields)

;;; jira-api-fields.el ends here

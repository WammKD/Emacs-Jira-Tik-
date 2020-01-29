;;; jira-api-issue.el --- functions for interfacing with Jira's API Issues
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
(require 'tike-jira-api-fields)
(require 'tike-utils)

(cl-defstruct (tike-jira--issueref (:constructor tike-jira-issueref--create)
                                   (:conc-name   tike-jira-issueref--get-))
  (id nil) (key nil) (self nil) (fields nil))

(tike-jira-object-create issueref
  (tike-jira-issueref--create :id     (cdr-assoc 'id       obj)
                              :key    (cdr-assoc 'key      obj)
                              :self   (cdr-assoc 'self     obj)
                              :fields (tike-jira-fields-create
                                        (cdr-assoc 'fields obj))))

(provide 'tike-jira-api-issue-reference)

;;; jira-api-issue-reference.el ends here

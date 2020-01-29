;;; jira-api-issue-link.el --- functions for interfacing with Jira's API Issue Links
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
(require 'tike-jira-api-issue-reference)
(require 'tike-utils)

(cl-defstruct (tike-jira--issuelink (:constructor tike-jira-issuelink--create)
                                    (:conc-name   tike-jira-issuelink--get-))
  (id nil) (self nil) (type nil) (inward-issue nil) (outward-issue nil))

(tike-jira-object-create issuelink
  (tike-jira-issuelink--create :id            (cdr-assoc 'id             obj)
                               :self          (cdr-assoc 'self           obj)
                               :type          (tike-jira-issuelink-type-create
                                                (cdr-assoc 'type         obj))
                               :inward-issue  (tike-jira-issueref-create
                                                (cdr-assoc 'inwardIssue  obj))
                               :outward-issue (tike-jira-issueref-create
                                                (cdr-assoc 'outwardIssue obj))))


(cl-defstruct (tike-jira--issuelink-type (:constructor tike-jira-issuelink-type--create)
                                         (:conc-name   tike-jira-issuelink-type--get-))
  (id nil) (name nil) (inward nil) (outward nil) (self nil))

(tike-jira-object-create issuelink-type
  (tike-jira-issuelink-type--create :id      (cdr-assoc 'id      obj)
                                    :name    (cdr-assoc 'name    obj)
                                    :inward  (cdr-assoc 'inward  obj)
                                    :outward (cdr-assoc 'outward obj)
                                    :self    (cdr-assoc 'self    obj)))

(provide 'tike-jira-api-issue-link)

;;; jira-api-issue-link.el ends here

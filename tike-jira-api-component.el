;;; jira-api-component.el --- functions for interfacing with Jira's API Components
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
(require 'tike-jira-api-user)
(require 'tike-utils)

(cl-defstruct (tike-jira--component (:constructor tike-jira-component--create)
                                    (:conc-name   tike-jira-component--get-))
  (self                   nil) (id            nil)
  (name                   nil) (description   nil)
  (lead                   nil) (lead-username nil)
  (assignee-type          nil) (assignee      nil)
  (real-assignee-type     nil) (real-assignee nil)
  (is-assignee-type-valid nil) (project       nil)
  (project-id             nil) (archived      nil))

(tike-jira-object-create component
  (tike-jira-component--create :self                   (cdr-assoc 'self                obj)
                               :id                     (cdr-assoc 'id                  obj)
                               :name                   (cdr-assoc 'name                obj)
                               :description            (cdr-assoc 'description         obj)
                               :lead                   (tike-jira-user-create
                                                         (cdr-assoc 'lead              obj))
                               :lead-username          (cdr-assoc 'leadUserName        obj)
                               :assignee-type          (cdr-assoc 'assigneeType        obj)
                               :assignee               (tike-jira-user-create
                                                         (cdr-assoc 'assignee          obj))
                               :real-assignee-type     (cdr-assoc 'realAssigneeType    obj)
                               :real-assignee          (tike-jira-user-create
                                                         (cdr-assoc 'realAssignee      obj))
                               :is-assignee-type-valid (cdr-assoc 'isAssigneeTypeValid obj)
                               :project                (cdr-assoc 'project             obj)
                               :project-id             (cdr-assoc 'projectId           obj)
                               :archived               (cdr-assoc 'archived            obj)))

(provide 'tike-jira-api-component)

;;; jira-api-component.el ends here

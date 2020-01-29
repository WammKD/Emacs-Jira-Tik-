;;; jira-api-project.el --- functions for interfacing with Jira's API Projects
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
(require 'tike-jira-api-avatar-urls)
(require 'tike-jira-api-issue-type)
(require 'tike-utils)

(cl-defstruct (tike-jira--project (:constructor tike-jira-project--create)
                                  (:conc-name   tike-jira-project--get-))
  (expand       nil) (self             nil) (id               nil)
  (key          nil) (description      nil) (lead             nil)
  (components   nil) (issue-types      nil) (url              nil)
  (email        nil) (assignee-type    nil) (versions         nil)
  (name         nil) (roles            nil) (avatar-urls      nil)
  (project-keys nil) (project-category nil) (project-type-key nil) (archived nil))

(tike-jira-object-create project
  (tike-jira-project--create :expand           (cdr-assoc 'expand          obj)
                             :self             (cdr-assoc 'self            obj)
                             :id               (cdr-assoc 'id              obj)
                             :key              (cdr-assoc 'key             obj)
                             :description      (cdr-assoc 'description     obj)
                             :lead             (tike-jira-user-create
                                                 (cdr-assoc 'lead          obj))
                             :components       (cdr-assoc 'components      obj)
                             :issue-types      (cdr-assoc 'issueTypes      obj)
                             :url              (cdr-assoc 'url             obj)
                             :email            (cdr-assoc 'email           obj)
                             :assignee-type    (cdr-assoc 'assigneeType    obj)
                             :versions         (cdr-assoc 'versions        obj)
                             :name             (cdr-assoc 'name            obj)
                             :roles            (cdr-assoc 'roles           obj)
                             :avatar-urls      (tike-jira-avatar-urls-create
                                                 (cdr-assoc 'avatarUrls    obj))
                             :project-keys     (cdr-assoc 'projectKeys     obj)
                             :project-category (cdr-assoc 'projectCategory obj)
                             :project-type-key (cdr-assoc 'projectTypeKey  obj)
                             :archived         (cdr-assoc 'archived        obj)))

(provide 'tike-jira-api-project)

;;; jira-api-project.el ends here

;;; jira-api-version.el --- functions for interfacing with Jira's API Versions
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
(require 'tike-jira-api-link)
(require 'tike-utils)

(cl-defstruct (tike-jira--version (:constructor tike-jira-version--create)
                                  (:conc-name   tike-jira-version--get-))
  (expand            nil) (self                   nil)
  (id                nil) (description            nil)
  (name              nil) (archived               nil)
  (released          nil) (release-date           nil)
  (overdue           nil) (user-start-date        nil)
  (user-release-date nil) (project                nil)
  (project-id        nil) (move-unfixed-issues-to nil)
  (operations        nil) (remote-links           nil))

(tike-jira-object-create version
  (tike-jira-version--create :expand                 (cdr-assoc 'expand              obj)
                             :self                   (cdr-assoc 'self                obj)
                             :id                     (cdr-assoc 'id                  obj)
                             :description            (cdr-assoc 'description         obj)
                             :name                   (cdr-assoc 'name                obj)
                             :archived               (cdr-assoc 'archived            obj)
                             :released               (cdr-assoc 'released            obj)
                             :release-date           (cdr-assoc 'releaseDate         obj)
                             :overdue                (cdr-assoc 'overdue             obj)
                             :user-start-date        (cdr-assoc 'userStartDate       obj)
                             :user-release-date      (cdr-assoc 'userReleaseDate     obj)
                             :project                (cdr-assoc 'project             obj)
                             :project-id             (cdr-assoc 'projectId           obj)
                             :move-unfixed-issues-to (cdr-assoc 'moveUnfixedIssuesTo obj)
                             :operations             (mapcar
                                                       'tike-jira-link-simple-create
                                                       (cdr-assoc 'operations        obj))
                             :remote-links           (mapcar
                                                       'tike-jira-link-remote-entity-create
                                                       (cdr-assoc 'remotelinks       obj))))

(provide 'tike-jira-api-version)

;;; jira-api-version.el ends here

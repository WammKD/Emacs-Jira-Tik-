;;; jira-api-worklog.el --- functions for interfacing with Jira's API Worklogs
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
(require 'tike-jira-api-visibility)
(require 'tike-utils)

(cl-defstruct (tike-jira--worklog (:constructor tike-jira-worklog--create)
                                  (:conc-name   tike-jira-worklog--get-))
  (self       nil) (author             nil) (update-author nil) (comment  nil)
  (created    nil) (updated            nil) (visibility    nil) (started  nil)
  (time-spent nil) (time-spent-seconds nil) (id            nil) (issue-id nil))

(tike-jira-object-create worklog
  (tike-jira-worklog--create :self               (cdr-assoc 'self             obj)
                             :author             (tike-jira-user-create
                                                   (cdr-assoc 'author         obj))
                             :update-author      (tike-jira-user-create
                                                   (cdr-assoc 'updateAuthor   obj))
                             :comment            (cdr-assoc 'comment          obj)
                             :created            (cdr-assoc 'created          obj)
                             :updated            (cdr-assoc 'updated          obj)
                             :visibility         (tike-jira-visibility-create
                                                   (cdr-assoc 'visibility     obj))
                             :started            (cdr-assoc 'started          obj)
                             :time-spent         (cdr-assoc 'timeSpent        obj)
                             :time-spent-seconds (cdr-assoc 'timeSpentSeconds obj)
                             :id                 (cdr-assoc 'id               obj)
                             :issue-id           (cdr-assoc 'issueId          obj)))

(provide 'tike-jira-api-worklog)

;;; jira-api-worklog.el ends here

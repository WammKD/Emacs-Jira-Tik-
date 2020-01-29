;;; jira-api-field-reference.el --- functions for interfacing
;;;                                 with Jira's API Field Ref.s
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
(require 'tike-jira-api-issue-type)
(require 'tike-jira-api-issue-link)
(require 'tike-jira-api-priority)
(require 'tike-jira-api-project)
(require 'tike-jira-api-resolution)
(require 'tike-jira-api-version)
(require 'tike-utils)

(cl-defstruct (tike-jira--field-agile (:constructor tike-jira-field-agile--create)
                                      (:conc-name   tike-jira-field-agile--get-))
  (issuetype       nil) (time-spent           nil) (project                          nil)
  (fix-versions    nil) (aggregate-time-spent nil) (resolution                       nil)
  (resolution-date nil) (work-ratio           nil) (last-viewed                      nil)
  (watches         nil) (created              nil) (priority                         nil)
  (labels          nil) (time-estimate        nil) (aggregate-time-original-estimate nil)
  (issue-links     nil) (assignee             nil) (updated                          nil)
  (status          nil) (components           nil) (time-original-estimate           nil)
  (description     nil) (attachment           nil) (aggregate-time-estimate          nil)
  (flagged         nil) (summary              nil) (creator                          nil)
  (subtasks        nil) (reporter             nil) (aggregate-progress               nil)
  (environment     nil) (due-date             nil) (closed-sprints                   nil)
  (progress        nil) (comment              nil) (worklog                          nil) (custom-fields nil))

(tike-jira-object-create field-agile
  (tike-jira-field-agile--create
    :issuetype                        (tike-jira-issuetype-create
                                        (cdr-assoc 'issuetype                   obj))
    :time-spent                       (cdr-assoc 'timespent                     obj)
    :project                          (tike-jira-project-create
                                        (cdr-assoc 'project                     obj))
    :fix-versions                     (mapcar
                                        'tike-jira-version-create
                                        (cdr-assoc 'fixVersions                 obj)
    :aggregate-time-spent             (cdr-assoc 'aggregatetimespent            obj)
    :resolution                       (tike-jira-resolution-create
                                        (cdr-assoc 'resolution                  obj))
    :resolution-date                  (cdr-assoc 'resolutiondate                obj)
    :work-ratio                       (cdr-assoc 'workratio                     obj)
    :last-viewed                      (cdr-assoc 'lastViewed                    obj)
    :watches                          (tike-jira-watchers-create
                                        (cdr-assoc 'watches                     obj))
    :created                          (cdr-assoc 'created                       obj)
    :priority                         (tike-jira-priority-create
                                        (cdr-assoc 'priority                    obj))
    :labels                           (cdr-assoc 'labels                        obj)
    :time-estimate                    (cdr-assoc 'timeestimate                  obj)
    :aggregate-time-original-estimate (cdr-assoc 'aggregatetimeoriginalestimate obj)
    :issue-links                      (mapcar
                                        'tike-jira-issuelink-create
                                        (cdr-assoc 'issuelinks                  obj))
    :assignee                         (cdr-assoc 'assignee                      obj)
    :updated                          (cdr-assoc 'updated                       obj)
    :status                           (cdr-assoc 'status                        obj)
    :components                       (cdr-assoc 'components                    obj)
    :time-original-estimate           (cdr-assoc 'timeoriginalestimate          obj)
    :description                      (cdr-assoc 'description                   obj)
    :attachment                       (cdr-assoc 'attachment                    obj)
    :aggregate-time-estimate          (cdr-assoc 'aggregatetimeestimate         obj)
    :flagged                          (cdr-assoc 'flagged                       obj)
    :summary                          (cdr-assoc 'summary                       obj)
    :creator                          (cdr-assoc 'creator                       obj)
    :subtasks                         (cdr-assoc 'subtasks                      obj)
    :reporter                         (cdr-assoc 'reporter                      obj)
    :aggregate-progress               (cdr-assoc 'aggregateprogress             obj)
    :environment                      (cdr-assoc 'environment                   obj)
    :due-date                         (cdr-assoc 'duedate                       obj)
    :closed-sprints                   (cdr-assoc 'closedSprints                 obj)
    :progress                         (cdr-assoc 'progress                      obj)
    :comment                          (cdr-assoc 'comment                       obj)
    :worklog                          (cdr-assoc 'worklog                       obj)
    :custom-fields                    (cl-remove-if-not
                                        (lambda (pair)
                                          (string-prefix-p "customfield_" (symbol-name (car pair))))
                                        obj)))

(provide 'tike-jira-api-field-agile)

;;; jira-api-field-agile.el ends here

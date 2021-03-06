;;; jira-api-sprint.el --- functions for interfacing with Jira's API Sprints
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
(require 'tike-utils)

(cl-defstruct (tike-jira--sprint (:constructor tike-jira-sprint--create)
                                 (:conc-name   tike-jira-sprint--get-))
  (id         nil) (self     nil) (state         nil) (name            nil)
  (start-date nil) (end-date nil) (complete-date nil) (origin-board-id nil) (goal nil))

(tike-jira-object-create sprint
  (tike-jira-sprint--create :id              (cdr-assoc 'id            obj)
                            :self            (cdr-assoc 'self          obj)
                            :state           (cdr-assoc 'state         obj)
                            :name            (cdr-assoc 'name          obj)
                            :start-date      (cdr-assoc 'startDate     obj)
                            :end-date        (cdr-assoc 'endDate       obj)
                            :complete-date   (cdr-assoc 'completeDate  obj)
                            :origin-board-id (cdr-assoc 'originBoardId obj)
                            :goal            (cdr-assoc 'goal          obj)))

(provide 'tike-jira-api-sprint)

;;; jira-api-sprint.el ends here

;;; jira-api-rapidboard.el --- functions for interfacing with
;;;                            Jira's Agile API Rapidboards
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
(require 'tike-jira-api-column)
(require 'tike-jira-api-group)
(require 'tike-utils)

(cl-deftype tike-jira--rapidboard-type ()
  '(member scrum "scrum" kanban "kanban"))

(cl-defstruct (tike-jira--rapidboard (:constructor tike-jira-rapidboard--create)
                                     (:conc-name   tike-jira-rapidboard--get-))
  (id nil) (self nil) (name nil) (type nil))

(tike-jira-object-create rapidboard
  (tike-jira-rapidboard--create :id   (cdr-assoc 'id   obj)
                                :self (cdr-assoc 'self obj)
                                :name (cdr-assoc 'name obj)
                                :type (cdr-assoc 'type obj)))


(cl-defstruct (tike-jira--rapidboard-config (:constructor tike-jira-rapidboard-config--create)
                                            (:conc-name   tike-jira-rapidboard-config--get-))
  (id     nil) (self          nil) (name       nil) (type    nil)
  (filter nil) (column-config nil) (estimation nil) (ranking nil))

(tike-jira-object-create rapidboard-config
  (tike-jira-rapidboard-config--create :id              (cdr-assoc 'id           obj)
                                       :self            (cdr-assoc 'self         obj)
                                       :name            (cdr-assoc 'name         obj)
                                       :type            (cdr-assoc 'type         obj)
                                       :filter        (tike-jira-group-create
                                                        (cdr-assoc 'filter       obj))
                                       :column-config (tike-jira-column-config-create
                                                        (cdr-assoc 'columnConfig obj))
                                       :estimation    (tike-jira-rapidboard-estimation-create
                                                        (cdr-assoc 'estimation   obj))
                                       :ranking         (cdr-assoc 'ranking      obj)))


(cl-deftype tike-jira--rapidboard-estimation-type ()
  '(member none "none" issueCount "issueCount" field "field"))

(cl-defstruct (tike-jira--rapidboard-estimation (:constructor tike-jira-rapidboard-estimation--create)
                                                (:conc-name   tike-jira-rapidboard-estimation--get-))
  (type nil) (field nil))

(tike-jira-object-create rapidboard-estimation
  (tike-jira-rapidboard-estimation--create :type  (cdr-assoc 'type obj)
                                           :field (when (string-equal
                                                          "field"
                                                          (cdr-assoc 'type obj))
                                                    (tike-jira-rapidboard-estimation-field-create
                                                      (cdr-assoc 'field obj)))))


(cl-defstruct (tike-jira--rapidboard-estimation-field (:constructor tike-jira-rapidboard-estimation-field--create)
                                                      (:conc-name   tike-jira-rapidboard-estimation-field--get-))
  (field-id nil) (display-name nil))

(tike-jira-object-create rapidboard-estimation-field
  (tike-jira-rapidboard-estimation-field--create :field-id     (cdr-assoc 'fieldId     obj)
                                                 :display-name (cdr-assoc 'displayName obj)))

(provide 'tike-jira-api-rapidboard)

;;; jira-api-rapidboard.el ends here

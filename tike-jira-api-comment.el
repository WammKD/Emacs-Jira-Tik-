;;; jira-api-comment.el --- functions for interfacing with Jira's API Comments
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

(cl-defstruct (tike-jira--comment (:constructor tike-jira-comment--create)
                                  (:conc-name   tike-jira-comment--get-))
  (self          nil) (id      nil) (author  nil) (body       nil) (rendered-body nil)
  (update-author nil) (created nil) (updated nil) (visibility nil) (properties    nil))

(tike-jira-object-create comment
  (tike-jira-comment--create :self          (cdr-assoc 'self           obj)
                             :id            (cdr-assoc 'id             obj)
                             :author        (tike-jira-user-create
                                              (cdr-assoc 'author       obj))
                             :body          (cdr-assoc 'body           obj)
                             :rendered-body (cdr-assoc 'renderedBody   obj)
                             :update-author (tike-jira-user-create
                                              (cdr-assoc 'updateAuthor obj))
                             :created       (cdr-assoc 'created        obj)
                             :updated       (cdr-assoc 'updated        obj)
                             :visibility    (tike-jira-visibility-create
                                              (cdr-assoc 'visibility   obj))
                             :properties    (cdr-assoc 'properties     obj)))

(provide 'tike-jira-api-comment)

;;; jira-api-comment.el ends here

;;; jira-api-epic.el --- functions for interfacing with Jira's API Epics
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

(cl-defstruct (tike-jira--epic (:constructor tike-jira-epic--create)
                               (:conc-name   tike-jira-epic--get-))
  (id nil) (self nil) (name nil) (summary nil) (color nil) (done nil))

(tike-jira-object-create epic
  (tike-jira-epic--create :id      (cdr-assoc 'id                         obj)
                          :self    (cdr-assoc 'self                       obj)
                          :name    (cdr-assoc 'name                       obj)
                          :summary (cdr-assoc 'summary                    obj)
                          :color   (cdr-assoc 'key     (cdr-assoc 'color obj))
                          :done    (cdr-assoc 'done                       obj)))

(provide 'tike-jira-api-epic)

;;; jira-api-epic.el ends here

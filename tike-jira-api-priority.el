;;; jira-api-priority.el --- functions for interfacing with Jira's API Prioritys
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

(cl-defstruct (tike-jira--priority (:constructor tike-jira-priority--create)
                                   (:conc-name   tike-jira-priority--get-))
  (self     nil) (status-color nil) (description nil)
  (icon-url nil) (name         nil) (id          nil))

(tike-jira-object-create priority
  (tike-jira-priority--create :self         (cdr-assoc 'self        obj)
                              :status-color (cdr-assoc 'statusColor obj)
                              :description  (cdr-assoc 'description obj)
                              :icon-url     (cdr-assoc 'iconUrl     obj)
                              :name         (cdr-assoc 'name        obj)
                              :id           (cdr-assoc 'id          obj)))

(provide 'tike-jira-api-priority)

;;; jira-api-priority.el ends here

;;; jira-api-status.el --- functions for interfacing with Jira's API Statuses
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

(cl-defstruct (tike-jira--status (:constructor tike-jira-status--create)
                                 (:conc-name   tike-jira-status--get-))
  (self     nil) (status-color nil) (description nil)
  (icon-url nil) (name         nil) (id          nil) (status-category nil))

(tike-jira-object-create status
  (tike-jira-status--create :self            (cdr-assoc 'self             obj)
                            :status-color    (cdr-assoc 'statusColor      obj)
                            :description     (cdr-assoc 'description      obj)
                            :icon-url        (cdr-assoc 'iconUrl          obj)
                            :name            (cdr-assoc 'name             obj)
                            :id              (cdr-assoc 'id               obj)
                            :status-category (tike-jira-status-category-create
                                               (cdr-assoc 'statusCategory obj))))


(cl-defstruct (tike-jira--status-category (:constructor tike-jira-status-category--create)
                                          (:conc-name   tike-jira-status-category--get-))
  (self nil) (id nil) (key nil) (color-name nil) (name nil))

(tike-jira-object-create status-category
  (tike-jira-status-category--create :self       (cdr-assoc 'self      obj)
                                     :id         (cdr-assoc 'id        obj)
                                     :key        (cdr-assoc 'key       obj)
                                     :color-name (cdr-assoc 'colorName obj)
                                     :name       (cdr-assoc 'name      obj)))

(provide 'tike-jira-api-status)

;;; jira-api-status.el ends here

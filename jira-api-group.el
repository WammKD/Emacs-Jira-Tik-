;;; jira-api-group.el --- functions for interfacing with Jira's API Groups
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

(cl-defstruct (tike-jira--group (:constructor tike-jira-group--create)
                                (:conc-name   tike-jira-group--get-))
  (id nil) (self nil))

(tike-jira-object-create group
  (tike-jira-group--create :id   (cdr-assoc 'id   obj)
                           :self (cdr-assoc 'self obj)))


(cl-defstruct (tike-jira--simple-list-wrapper (:constructor tike-jira-simple-list-wrapper--create)
                                              (:conc-name   tike-jira-simple-list-wrapper--get-))
  (size nil) (max-results nil) (items nil))

(tike-jira-object-create simple-list-wrapper
  (tike-jira-simple-list-wrapper--create :size        (cdr-assoc 'size        obj)
                                         :max-results (cdr-assoc 'max-results obj)
                                         :items       (mapcar
                                                        'tike-jira-group-create
                                                        (cdr-assoc 'items     obj))))

(provide 'tike-jira-api-group)

;;; jira-api-group.el ends here

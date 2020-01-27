;;; jira-api-user.el --- functions for interfacing with Jira's API Users
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

(cl-defstruct (tike-jira--user (:constructor tike-jira-user--create)
                               (:conc-name   tike-jira-user--get-))
  (self        nil) (key          nil) (name              nil) (email-address nil)
  (avatar-urls nil) (display-name nil) (active            nil) (time-zone     nil)
  (locale      nil) (groups       nil) (application-roles nil) (expand        nil))

(tike-jira-object-create user
  (tike-jira-user--create :self              (cdr-assoc 'self              obj)
                          :key               (cdr-assoc 'key               obj)
                          :name              (cdr-assoc 'name              obj)
                          :email-address     (cdr-assoc 'email-address     obj)
                          :avatar-urls       (cdr-assoc 'avatar-urls       obj)
                          :display-name      (cdr-assoc 'display-name      obj)
                          :active            (cdr-assoc 'active            obj)
                          :time-zone         (cdr-assoc 'time-zone         obj)
                          :locale            (cdr-assoc 'locale            obj)
                          :groups            (cdr-assoc 'groups            obj)
                          :application-roles (cdr-assoc 'application-roles obj)
                          :expand            (cdr-assoc 'expand            obj)))

(provide 'tike-jira-api-user)

;;; jira-api-user.el ends here

;;; jira-api-filter.el --- functions for interfacing with Jira's API Filters
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

(cl-defstruct (tike-jira--filter (:constructor tike-jira-filter--create)
                                 (:conc-name   tike-jira-filter--get-))
  (id                nil) (name         nil) (description   nil) (owner    nil)
  (jql               nil) (view-url     nil) (search-url    nil) (favorite nil)
  (share-permissions nil) (shared-users nil) (subscriptions nil) (editable nil))

(tike-jira-object-create filter
  (tike-jira-filter--create :id            (cdr-assoc 'id            obj)
                            :name          (cdr-assoc 'name          obj)
                            :description   (cdr-assoc 'description   obj)
                            :owner         (cdr-assoc 'owner         obj)
                            :view-url      (cdr-assoc 'view-url      obj)
                            :search-url    (cdr-assoc 'search-url    obj)
                            :favorite      (cdr-assoc 'favorite      obj)
                            :shared-users  (cdr-assoc 'shared-users  obj)
                            :subscriptions (cdr-assoc 'subscriptions obj)
                            :editable      (cdr-assoc 'editable      obj)))

(provide 'tike-jira-api-filter)

;;; jira-api-filter.el ends here

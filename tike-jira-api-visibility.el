;;; jira-api-visibility.el --- functions for interfacing with Jira's API Visibilitys
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
(require 'tike-utils)

(cl-deftype tike-jira--visibility-type ()
  '(member group "group" role "role"))

(cl-defstruct (tike-jira--visibility (:constructor tike-jira-visibility--create)
                                     (:conc-name   tike-jira-visibility--get-))
  (type nil) (value nil))

(tike-jira-object-create visibility
  (tike-jira-visibility--create :type  (cdr-assoc 'type  obj)
                                :value (cdr-assoc 'value obj)))

(provide 'tike-jira-api-visibility)

;;; jira-api-visibility.el ends here

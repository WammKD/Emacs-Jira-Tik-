;;; jira-api-issue.el --- functions for interfacing with Jira's API Issues
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

(cl-defstruct (tike-jira--issue (:constructor tike-jira-issue--create)
                                (:conc-name   tike-jira-issue--get-))
  (expand      nil) (id                       nil) (self            nil)
  (key         nil) (fields                   nil) (renderedFields  nil)
  (properties  nil) (names                    nil) (schema          nil)
  (transitions nil) (operations               nil) (editmeta        nil)
  (changelog   nil) (versionedRepresentations nil) (fieldsToInclude nil))

(tike-jira-object-create issue
  (tike-jira-issue--create
    :id                       (cdr-assoc 'id                       obj)
    :self                     (cdr-assoc 'self                     obj)
    :key                      (cdr-assoc 'key                      obj)
    :expand                   (cdr-assoc 'expand                   obj)
    :fields                   (cdr-assoc 'fields                   obj)
    :renderedFields           (cdr-assoc 'renderedFields           obj)
    :properties               (cdr-assoc 'properties               obj)
    :names                    (cdr-assoc 'names                    obj)
    :schema                   (cdr-assoc 'schema                   obj)
    :transitions              (cdr-assoc 'transitions              obj)
    :operations               (cdr-assoc 'operations               obj)
    :editmeta                 (cdr-assoc 'editmeta                 obj)
    :changelog                (cdr-assoc 'changelog                obj)
    :versionedRepresentations (cdr-assoc 'versionedRepresentations obj)
    :fieldsToInclude          (cdr-assoc 'fieldsToInclude          obj)))

(provide 'tike-jira-api-issue)

;;; jira-api-issue.el ends here

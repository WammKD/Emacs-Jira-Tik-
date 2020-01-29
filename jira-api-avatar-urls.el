;;; jira-api-avatar-urls.el --- functions for interfacing
;;;                             with Jira's API Avatar URLs
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

(cl-defstruct (tike-jira--avatar-urls (:constructor tike-jira-avatar-urls--create)
                                      (:conc-name   tike-jira-avatar-urls--get-))
  (16x16 nil) (24x24 nil) (32x32 nil) (48x48 nil))

(tike-jira-object-create avatar-urls
  (tike-jira-avatar-urls--create :16x16 (cdr-assoc '16x16 obj)
                                 :24x24 (cdr-assoc '24x24 obj)
                                 :32x32 (cdr-assoc '32x32 obj)
                                 :48x48 (cdr-assoc '48x48 obj)))

(provide 'tike-jira-api-avatar-urls)

;;; jira-api-avatar-urls.el ends here

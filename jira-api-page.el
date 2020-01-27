;;; jira-api-page.el --- functions for interfacing Jira's API Pages
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
(cl-defstruct (tike-jira--page (:constructor tike-jira-page--create)
                               (:conc-name   tike-jira-page--get-))
  (expand nil) (max-results nil) (start-at nil)
  (total  nil) (is-last     nil) (values   nil))

(provide 'tike-jira-api-page)

;;; jira-api-page.el ends here

;;; tike-jira-accounts.el --- functions for interfacing with Jira's API
;; Copyright (C) 2019

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
(require 'url-http)


;; Accounts
(defconst tike-jira--account nil
  "Jira account with domain and port info.")


  ; Account Struct.
(cl-defstruct (tike-jira--account (:constructor tike-jira-account--create)
                                  (:conc-name   tike-jira-account--get-))
  (username "admin") (domain "http://localhost")
  (port      "4502") (alias  "localhost_author"))

(defun tike-jira-account--get-uri (account)
  "Create a proper form for a URI from the domain and port of an account."

  (concat
    (tike-jira-account--get-domain account)
    ":"
    (tike-jira-account--get-port   account)))


  ; User tools to handle Accounts
(defun tike-jira-account-create (domain port username password alias)
  "Create an account for use with Jira's API."

  (setq tike-jira--account               (tike-jira-account--create :username username
                                                                    :domain   domain
                                                                    :port     port
                                                                    :alias    alias))

  (setq url-http-real-basic-auth-storage (cons
                                           (list
                                             (replace-regexp-in-string
                                               "^http[s]?://"
                                               ""
                                               (concat domain ":" port))
                                             (cons
                                               alias
                                               (base64-encode-string
                                                 (concat username ":" password))))
                                           url-http-real-basic-auth-storage)))

(provide 'tike-jira-accounts)

;;; tike-jira-accounts.el ends here

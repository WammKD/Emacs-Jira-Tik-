;;; jira-api.el --- functions for interfacing with Jira's Server API
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
(require 'json)
(require 'url)


(defconst tike--REQUEST_GET    "GET"
  "String constant for Tikè to represent choosing a GET HTTP request.")
(defconst tike--REQUEST_PUT    "PUT"
  "String constant for Tikè to represent choosing a PUT HTTP request.")
(defconst tike--REQUEST_POST   "POST"
  "String constant for Tikè to represent choosing a POST HTTP request.")
(defconst tike--REQUEST_PATCH  "PATCH"
  "String constant for Tikè to represent choosing a PATCH HTTP request.")
(defconst tike--REQUEST_DELETE "DELETE"
  "String constant for Tikè to represent choosing a DELETE HTTP request.")


;; Utility
(defun cdr-assoc (key assoc-list)
  "A simple utility function to run (cdr (assoc KEY ASSOC-LIST))."

  (cdr (assoc key assoc-list)))



;; Functions Related to Making HTTP Calls
(defun tike-jira--generate-query-args (args)
  "Converts ARGS, a list of pairs, to a string of \"key1=val1&key2=val2\"."

  (mapconcat '(lambda (p)
                (concat
                  (url-hexify-string (format "%s" (car p)))
                  "="
                  (url-hexify-string (format "%s" (cdr p))))) args "&"))

(defun tike-jira--process (buffer url type)
  "Handles and parses the returned string from a call to `url-retrieve' or
`url-retrieve-synchronously'."

  (with-temp-buffer
    (url-insert-buffer-contents buffer url)

    (pcase type
      ('json     (json-read-from-string (buffer-string)))
      ('xml                           (xml-parse-region))
      (otherwise                         (buffer-string)))))

(defun tike-jira--request (reqMeth finalDomain headers data responseType async-p)
  "Puts together the various elements needed to make various HTTP calls
using the `url.el' package."

  (let ((url-request-method                                      reqMeth)
        (url-request-extra-headers                               headers)
        (url-request-data          (tike-jira--generate-query-args data)))
    (if async-p
        (url-retrieve finalDomain `(lambda (status)
                                     (funcall ,async-p (aem--process
                                                         (current-buffer)
                                                         ,finalDomain
                                                         ',responseType))))
      (aem--process (url-retrieve-synchronously
                      finalDomain)               finalDomain responseType))))



;; Permissions

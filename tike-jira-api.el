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
(require 'cl)
(require 'json)
(require 'tike-jira-api-page)
(require 'tike-jira-api-rapidboard)
(require 'tike-utils)
(require 'url)


(defconst tike-jira-api--REQUEST_GET    "GET"
  "String constant for Tikè to represent choosing a GET HTTP request.")
(defconst tike-jira-api--REQUEST_PUT    "PUT"
  "String constant for Tikè to represent choosing a PUT HTTP request.")
(defconst tike-jira-api--REQUEST_POST   "POST"
  "String constant for Tikè to represent choosing a POST HTTP request.")
(defconst tike-jira-api--REQUEST_PATCH  "PATCH"
  "String constant for Tikè to represent choosing a PATCH HTTP request.")
(defconst tike-jira-api--REQUEST_DELETE "DELETE"
  "String constant for Tikè to represent choosing a DELETE HTTP request.")


;; Functions Related to Making HTTP Calls
(defun tike-jira-api---generate-query-args (args)
  "Converts ARGS, a list of pairs, to a string of \"key1=val1&key2=val2\"."

  (mapconcat '(lambda (p)
                (concat
                  (url-hexify-string (format "%s" (car p)))
                  "="
                  (url-hexify-string (format "%s" (cdr p))))) args "&"))

(defun tike-jira-api---process (buffer url type)
  "Handles and parses the returned string from a call to `url-retrieve' or
`url-retrieve-synchronously'."

  (with-temp-buffer
    (url-insert-buffer-contents buffer url)

    (pcase type
      ('json     (json-read-from-string (buffer-string)))
      ('xml                           (xml-parse-region))
      (otherwise                         (buffer-string)))))

(defun tike-jira-api---request (reqMeth finalDomain queryParams
                                headers data        responseType async-p)
  "Puts together the various elements needed to make various HTTP calls
using the `url.el' package."

  (let ((url-request-method                                                     reqMeth)
        (url-request-extra-headers                                              headers)
        (url-request-data                    (tike-jira-api---generate-query-args data))
        (fd                        (concat
                                     finalDomain
                                     "?"
                                     (tike-jira-api---generate-query-args queryParams))))
    (if async-p
        (url-retrieve fd `(lambda (status)
                            (funcall ,async-p (tike-jira-api---process
                                                (current-buffer)
                                                ,fd
                                                ',responseType))))
      (tike-jira-api---process (url-retrieve-synchronously fd) fd responseType))))



;;;;;;;;;;;;;;;;;;;;;;
;;;                ;;;
;;;   Normal API   ;;;
;;;                ;;;
;;;;;;;;;;;;;;;;;;;;;;

;; Permissions
(defun tike-jira-api--permissions (account &optional parameterType
                                                     parameterValue callback)
  ""
  (if (and
        parameterType
        (not (member parameterType '(projectKey "projectKey" issueKey   "issueKey"
                                     projectId  "projectId"  issueId    "issueId"))))
      (error "In `tike-jira-api--permissions', provided PARAMETERTYPE was not a symbol"
             "nor string of either projectKey, projectId, issueKey, or issueId")
    (tike-jira-api---request
      tike-jira-api--REQUEST_GET
      (concat (tike-jira-account--get-uri account) "/rest/api/2/mypermissions")
      (if (and parameterType parameterValue) `((,parameterType . ,parameterValue)) '())
      '()
      '()
      'json
      callback)))

(defun tike-jira-api--permissions-all (account &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/permissions")
    '()
    '()
    '()
    'json
    callback))



;; Applications
;; (defun tike-jira-api--application-property (account &optional callback)
;;   ""
;;   (tike-jira-api---request
;;     tike-jira-api--REQUEST_GET
;;     (concat (tike-jira-account--get-uri account) "/rest/api/2/application-properties")
;;     '()
;;     '()
;;     '()
;;     'json
;;     callback))

;; (defun tike-jira-api--application-property-set! (account &optional callback)
;;   )

;; (defun tike-jira-api--application-property-advanced-settings (account &optional callback)
;;   )



;; Application Role
(defun tike-jira-api--application-role (account &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/applicationrole")
    '()
    '()
    '()
    'json
    callback))



;; Attachments
(defun tike-jira-api--attachment-get (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/attachment/"
      (if (numberp id) (number-to-string id) id))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--attachment-remove (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/attachment/"
      (if (numberp id) (number-to-string id) id))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--attachment-expanded-for-humans (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/attachment/"
      (if (numberp id) (number-to-string id) id)
      "/expand/human")
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--attachment-expanded-for-machines (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/attachment/"
      (if (numberp id) (number-to-string id) id)
      "/expand/raw")
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--attachment-meta (account &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/attachment/meta")
    '()
    '()
    '()
    'json
    callback))



;; Auditing
(defun tike-jira-api--auditing-records-add (account record &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account) "/rest/api/2/auditing/record")
    '()
    '()
    '()  ; I'll do this later?
    'json
    callback))

(defun tike-jira-api--auditing-records-get (account    offset
                                            limit      filter
                                            from       to
                                            projectIDs userIDs &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/auditing/record")
    `((offset . ,offset) (limit      .      ,limit)
      (filter . ,filter) (from       .       ,from)
      (to     .     ,to) (projectIDs . ,projectIDs) (userIDs . ,userIDs))
    '()
    '()
    'json
    callback))



;; Avatars
(defun tike-jira-api--system-avatars-get (account type &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/avatar/"
            type                                 "/system")
    '()
    '()
    '()
    'json
    callback))



;; Dashboards
(defun tike-jira-api--dashboards-all (account &optional startAt maxResults filter callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/dashboard")
    (append
      (if filter `((filter . ,filter)) '())
      `((maxResults . ,(or maxResults 20)) (startAt . ,(or startAt 0))))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--dashboards-get (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/dashboard/"
      (if (numberp id) (number-to-string id) id))
    '()
    '()
    '()
    'json
    callback))

  ; Dashboard Item Properties
(defun tike-jira-api--dashboards--items--properties-keys (account
                                                          dashboardID
                                                               itemID &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/dashboard/"
      (if (numberp dashboardID) (number-to-string dashboardID) dashboardID)
      "/items/"
      (if (numberp      itemID) (number-to-string      itemID)      itemID)
      "/properties")
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--dashboards--items--properties-delete (account
                                                            dashboardID
                                                                 itemID
                                                             propertyKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/dashboard/"
      (if (numberp dashboardID)  (number-to-string dashboardID)  dashboardID)
      "/items/"
      (if (numberp      itemID)  (number-to-string      itemID)       itemID)
      "/properties/"
      (if (numberp  propertyKey) (number-to-string  propertyKey)  propertyKey))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--dashboards--items--properties-set (account
                                                         dashboardID
                                                              itemID
                                                          propertyKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/dashboard/"
      (if (numberp dashboardID)  (number-to-string dashboardID)  dashboardID)
      "/items/"
      (if (numberp      itemID)  (number-to-string      itemID)       itemID)
      "/properties/"
      (if (numberp  propertyKey) (number-to-string  propertyKey)  propertyKey))
    '()
    '()
    '()  ; I…ASSUME the value goes here? Perhaps we're setting the whole object…
    'json
    callback))

(defun tike-jira-api--dashboards--items--properties-get (account
                                                         dashboardID
                                                              itemID
                                                          propertyKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/dashboard/"
      (if (numberp dashboardID)  (number-to-string dashboardID)  dashboardID)
      "/items/"
      (if (numberp      itemID)  (number-to-string      itemID)       itemID)
      "/properties/"
      (if (numberp  propertyKey) (number-to-string  propertyKey)  propertyKey))
    '()
    '()
    '()
    'json
    callback))



;; Fields
(defun tike-jira-api--fields-create (account   fieldID
                                     fieldName fieldDescription
                                     fieldType fieldSearcherKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account) "/rest/api/2/field")
    '()
    '()
    `((id .          ,fieldID)          (name . ,fieldName)
      (description . ,fieldDescription) (type . ,fieldType) (searcherKey . ,fieldSearcherKey))
    'json
    callback))

(defun tike-jira-api--fields-get (account &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/field")
    '()
    '()
    '()
    'json
    callback))



;; Filters
(defun tike-jira-api--filters-get (account id &optional expand callback)
  ""
  (tike-jira-filter-create (tike-jira-api---request
                             tike-jira-api--REQUEST_GET
                             (concat
                               (tike-jira-account--get-uri account)
                               "/rest/api/2/filter/"
                               (if (numberp id) (number-to-string id) id))
                             (if expand `((expand . ,expand)) '())
                             '()
                             '()
                             'json
                             callback)))



;; Issues
(defun tike-jira-api--issues-create (account issue &optional updateHistory callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account) "/rest/api/2/issue")
    '((updateHistory . ,(if (and
                              updateHistory
                              (not (equal updateHistory "false"))) "true" "false")))
    '()
    (json-encode issue)
    'json
    callback))

(defun tike-jira-api--issues-create-bulk (account issues &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account) "/rest/api/2/issue/bulk")
    '()
    '()
    (json-encode issues)
    'json
    callback))

(defun tike-jira-api--issues-get (account idOrKey &optional fields     expand
                                                            properties updateHistory callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey))
    (append
      (if fields        `((fields        . ,fields))        '())
      (if expand        `((expand        . ,expand))        '())
      (if properties    `((properties    . ,properties))    '())
      (if updateHistory `((updateHistory . ,updateHistory)) '()))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues-delete (account
                                     idOrKey &optional deleteSubtasks callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
     (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey))
    `((deleteSubtasks . ,(if (and
                               deleteSubtasks
                               (not (equal deleteSubtasks "false"))) "true" "false")))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues-edit (account
                                   idOrKey
                                   issue   &optional notifyUsers callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey))
    `(notifyUsers . ,(if notifyUsers notifyUsers "true"))
    '()
    (json-encode issue)
    'json
    callback))

(defun tike-jira-api--issues-archive (account
                                      idOrKey &optional notifyUsers callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/archive")
    `(notifyUsers . ,(if notifyUsers notifyUsers "true"))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues-assign (account idOrKey &optional username callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/assignee")
    '()
    '()
    (if username `((name . ,username)) '())
    'json
    callback))

(defun tike-jira-api--issues-notify (account idOrKey request &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/notify")
    '()
    '()
    (json-encode request)
    'json
    callback))

(defun tike-jira-api--issues-restore (account idOrKey &optional notifyUsers callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/restore")
    `(notifyUsers . ,(if notifyUsers notifyUsers "true"))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues-archive (account issues &optional notifyUsers callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account) "/rest/api/2/issue/archive")
    `((notifyUsers . ,(if notifyUsers notifyUsers "false")))
    '()
    (concat "[" (mapconcat 'identity issues ",") "]")
    'json
    callback))

(defun tike-jira-api--issues-picker (account
                                     idOrKey
                                     query   &optional currentJQL        currentIssueKey
                                                       currentProjectID  showSubTasks
                                                       showSubTaskParent callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account) "/rest/api/2/issue/picker")
    (append
      (if currentJQL        `((currentJQL        . ,currentJQL))        '())
      (if currentIssueKey   `((currentIssueKey   . ,currentIssueKey))   '())
      (if currentProjectID  `((currentProjectId  . ,currentProjectID))  '())
      (if showSubTasks      `((showSubTasks      . ,showSubTasks))      '())
      (if showSubTaskParent `((showSubTaskParent . ,showSubTaskParent)) '())
      `((query . ,query)))
    '()
    '()
    'json
    callback))

  ; Issues Comments
(defun tike-jira-api--issues--comments-get (account
                                            idOrKey &optional startAt maxResults
                                                              orderBy expand     callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/comment")
    (append
      (if orderBy `((orderBy . ,orderBy)) '())
      (if expand  `((expand  . ,expand))  '())
      `((maxResults . ,(or maxResults 20)) (startAt . ,(or startAt 0))))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--comments-add (account
                                            idOrKey
                                            comment &optional expand callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/comment")
    (if expand  `((expand  . ,expand))  '())
    '()
    `((body . ,comment))
    'json
    callback))

(defun tike-jira-api--issues--comments-update (account idOrKey
                                               id      comment &optional expand
                                                                         callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/comment/"
      (if (numberp id)      (number-to-string id)      id))
    (if expand  `((expand  . ,expand))  '())
    '()
    `((body . ,comment))
    'json
    callback))

(defun tike-jira-api--issues--comments-delete (account
                                               idOrKey
                                               id      &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/comment/"
      (if (numberp id)      (number-to-string id)      id))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--comments-get (account
                                            idOrKey
                                            id      &optional expand callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/comment/"
      (if (numberp id)      (number-to-string id)      id))
    (if expand `((expand . ,expand)) '())
    '()
    '()
    'json
    callback))

  ; Issues Remote Links
(defun tike-jira-api--issues--remotelinks-all (account idOrKey &optional globalID callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/remotelink")
    (if globalID `((globalId . ,globalID)) '())
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--remotelinks-create-or-update (account
                                                            idOrKey
                                                            obj     &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/remotelink")
    '()
    '()
    (json-encode obj)
    'json
    callback))

(defun tike-jira-api--issues--remotelinks-delete-by-global-id (account
                                                               idOrKey
                                                               globalID &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/remotelink")
    `((globalId . ,globalID))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--remotelinks-get (account idOrKey id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/remotelink/"
      (if (numberp id)      (number-to-string id)      id))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--remotelinks-update (account idOrKey
                                                  id      obj     &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/remotelink/"
      (if (numberp id)      (number-to-string id)      id))
    '()
    '()
    (json-encode obj)
    'json
    callback))

(defun tike-jira-api--issues--remotelinks-delete-by-id (account
                                                        idOrKey
                                                        id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/remotelink/"
      (if (numberp id)      (number-to-string id)      id))
    '()
    '()
    '()
    'json
    callback))

  ; Issues Transitions
(defun tike-jira-api--issues--transitions-get (account idOrKey &optional transitionID
                                                                         expand
                                                                         callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/transitions")
    (append
      (if transitionID `((transitionId . ,transitionID)) '())
      (if expend       `((expend       . ,expend))       '()))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--transitions-do (account
                                              idOrKey
                                              transition &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/transitions")
    '()
    '()
    (json-encode transition)
    'json
    callback))

  ; Issues Votes
(defun tike-jira-api--issues--votes-remove (account idOrKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/votes")
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--votes-add (account idOrKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/votes")
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--votes-get (account idOrKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/votes")
    '()
    '()
    '()
    'json
    callback))

  ; Issues Watchers
(defun tike-jira-api--issues--watchers-get (account idOrKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/watchers")
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--watchers-add (account
                                            idOrKey
                                            username &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/watchers")
    '()
    '()
    username
    'json
    callback))

(defun tike-jira-api--issues--watchers-remove (account
                                               idOrKey
                                               username &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/watchers")
    `((username . ,username))
    '()
    '()
    'json
    callback))

  ; Issues Worklogs
(defun tike-jira-api--issues--worklogs-all (account idOrKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/worklog")
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--worklogs-add (account
                                            idOrKey
                                            worklog &optional adjustEstimate newEstimate
                                                              reduceBy       callback)
  ""
  (cond
   ((and
      adjustEstimate
      (not (member adjustEstimate '(new    "new"    leave "leave"
                                    manual "manual" auto  "auto"))))
         (error "In `tike-jira-api--issues--worklogs-add', provided ADJUSTESTIMATE "
                "was not a symbol nor string of either new, leave, manual, or auto"))
   ((and (not newEstimate) adjustEstimate (or
                                            (equal adjustEstimate 'new)
                                            (equal adjustEstimate "new")))
         (error "In `tike-jira-api--issues--worklogs-add', NEWESTIMATE "
                "is required when ADJUSTESTIMATE is a value of \"new\""))
   ((and (not reduceBy) adjustEstimate (or
                                         (equal adjustEstimate 'manual)
                                         (equal adjustEstimate "manual")))
         (error "In `tike-jira-api--issues--worklogs-add', REDUCEBY is "
                "required when ADJUSTESTIMATE is a value of \"manual\""))
   (t    (tike-jira-api---request
           tike-jira-api--REQUEST_POST
           (concat
             (tike-jira-account--get-uri account)
             "/rest/api/2/issue/"
             (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
             "/worklog")
           (append
             (if adjustEstimate `((adjustEstimate . ,adjustEstimate)) '())
             (if newEstimate    `((newEstimate    . ,newEstimate))    '())
             (if reduceBy       `((reduceBy       . ,reduceBy))       '()))
           '()
           worklog
           'json
           callback))))

(defun tike-jira-api--issues--worklogs-get (account idOrKey id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/worklog/"
      (if (numberp id)      (number-to-string id)      id))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--worklogs-update (account idOrKey
                                               id      worklog &optional adjustEstimate
                                                                         newEstimate
                                                                         callback)
  ""
  (if (and
        adjustEstimate
        (not (member adjustEstimate '(new "new" leave "leave" auto  "auto"))))
      (error "In `tike-jira-api--issues--worklogs-update', provided ADJUSTESTIMATE "
             "was not a symbol nor string of either new, leave, or auto")
    (if (and (not newEstimate) adjustEstimate (or
                                                (equal adjustEstimate 'new)
                                                (equal adjustEstimate "new")))
        (error "In `tike-jira-api--issues--worklogs-update', NEWESTIMATE "
               "is required when ADJUSTESTIMATE is a value of \"new\"")
      (tike-jira-api---request
        tike-jira-api--REQUEST_PUT
        (concat
          (tike-jira-account--get-uri account)
          "/rest/api/2/issue/"
          (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
          "/worklog/"
          (if (numberp id)      (number-to-string id)      id))
        '()
        '()
        (json-encode worklog)
        'json
        callback))))

(defun tike-jira-api--issues--worklogs-delete (account
                                               idOrKey
                                               id &optional adjustEstimate newEstimate
                                                                 increaseBy     callback)
  ""
  (cond
   ((and
      adjustEstimate
      (not (member adjustEstimate '(new    "new"    leave "leave"
                                    manual "manual" auto  "auto"))))
         (error "In `tike-jira-api--issues--worklogs-delete', provided ADJUSTESTIMATE "
                "was not a symbol nor string of either new, leave, manual, or auto"))
   ((and (not newEstimate) adjustEstimate (or
                                            (equal adjustEstimate 'new)
                                            (equal adjustEstimate "new")))
         (error "In `tike-jira-api--issues--worklogs-delete', NEWESTIMATE "
                "is required when ADJUSTESTIMATE is a value of \"new\""))
   ((and (not increaseBy) adjustEstimate (or
                                         (equal adjustEstimate 'manual)
                                         (equal adjustEstimate "manual")))
         (error "In `tike-jira-api--issues--worklogs-delete', INCREASEBY is "
                "required when ADJUSTESTIMATE is a value of \"manual\""))
   (t    (tike-jira-api---request
           tike-jira-api--REQUEST_DELETE
           (concat
             (tike-jira-account--get-uri account)
             "/rest/api/2/issue/"
             (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
             "/worklog/"
             (if (numberp id)      (number-to-string id)      id))
           (append
             (if adjustEstimate `((adjustEstimate . ,adjustEstimate)) '())
             (if newEstimate    `((newEstimate    . ,newEstimate))    '())
             (if increaseBy     `((increaseBy     . ,increaseBy))     '()))
           '()
           '()
           'json
           callback))))

  ; Issues Meta
(defun tike-jira-api--issues--meta-edit (account idOrKey &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/editmeta")
    '()
    '()
    '()
    'json
    callback))

  ; Issues Meta Issuetypes
(defun tike-jira-api--issues--meta--issuetypes-all (account idOrKey &optional startAt
                                                                              maxResults
                                                                              callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/createmeta/"               ;; project
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/issuetypes")
    `((maxResults . ,(or maxResults 50)) (startAt . ,(or startAt 0)))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues--meta--issuetypes-get (account
                                                    idOrKey
                                                    id      &optional startAt
                                                                      maxResults
                                                                      callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/api/2/issue/createmeta/"               ;; project
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey)
      "/issuetypes/"
      (if (numberp id)      (number-to-string id)      id))
    `((maxResults . ,(or maxResults 50)) (startAt . ,(or startAt 0)))
    '()
    '()
    'json
    callback))



;;;;;;;;;;;;;;;;;;;;;
;;;               ;;;
;;;   Agile API   ;;;
;;;               ;;;
;;;;;;;;;;;;;;;;;;;;;

;; Backlog
(defun tike-jira-api--backlog (account issues &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account) "/rest/agile/1.0/backlog")
    '()
    '()
    '()  ; issues
    'json
    callback))



;; (Rapid)Boards
(defun tike-jira-api--rapidboards-all (account &optional startAt maxResults
                                                         type    name       callback)
  ""
  (if (and type (not (cl-typep type 'tike-jira--rapidboard-type)))
      (error "In `tike-jira-api--rapidboards-all', provided "
             "TYPE was not \"scrum\" or \"kanban\"")
    (let ((obj (tike-jira-api---request
                 tike-jira-api--REQUEST_GET
                 (concat (tike-jira-account--get-uri account) "/rest/agile/1.0/board")
                 (append
                   (if name `((name . ,name)) '())
                   (if type `((type . ,type)) '())
                   `((maxResults . ,(or maxResults 20)) (startAt . ,(or startAt 0))))
                 '()
                 '()
                 'json
                 callback)))
      (tike-jira-page--create
        :max-results (cdr-assoc 'maxResults obj)
        :start-at    (cdr-assoc 'startAt    obj)
        :total       (cdr-assoc 'total      obj)
        :is-last     (cdr-assoc 'isLast     obj)
        :values      (mapcar 'tike-jira-rapidboard-create (cdr-assoc 'values obj))))))

(defun tike-jira-api--rapidboards-get (account id &optional callback)
  ""
  (tike-jira-rapidboard-create
    (tike-jira-api---request
      tike-jira-api--REQUEST_GET
      (concat
        (tike-jira-account--get-uri account)
        "/rest/agile/1.0/board/"
        (if (numberp id) (number-to-string id) id))
      '()
      '()
      '()
      'json
      callback)))

(defun tike-jira-api--rapidboards-get-backlog (account id &optional startAt maxResults
                                                                    jql     validateQuery
                                                                    fields  expand        callback)
  ""
  (tike-jira-error-check
    (tike-jira-api---request
      tike-jira-api--REQUEST_GET
      (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/board/"
              (if (numberp id) (number-to-string id) id) "/backlog")
      (append
        (if jql    `((jql    . ,jql))    '())
        (if fields `((fields . ,fields)) '())
        (if expand `((expand . ,expand)) '())
        `((validateQuery . ,(if validateQuery validateQuery "true"))
          (maxResults    . ,(or maxResults 20))
          (startAt       . ,(or startAt     0))))
      '()
      '()
      'json
      callback)
    (lambda (obj)
      (tike-jira-page--create :expand      (cdr-assoc 'expand     obj)
                              :start-at    (cdr-assoc 'startAt    obj)
                              :max-results (cdr-assoc 'maxResults obj)
                              :total       (cdr-assoc 'total      obj)
                              :values      (mapcar
                                             'tike-jira-issue-create
                                             (cdr-assoc 'issues   obj))))))

(defun tike-jira-api--rapidboards-get-configuration (account id &optional callback)
  ""
  (tike-jira-rapidboard-config-create
    (tike-jira-api---request
      tike-jira-api--REQUEST_GET
      (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/board/"
              (if (numberp id) (number-to-string id) id) "/configuration")
      '()
      '()
      '()
      'json
      callback)))

(defun tike-jira-api--rapidboards-get-issues (account id &optional startAt maxResults
                                                                   jql     validateQuery
                                                                   fields  expand        callback)
  ""
  (tike-jira-error-check
    (tike-jira-api---request
      tike-jira-api--REQUEST_GET
      (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/board/"
              (if (numberp id) (number-to-string id) id) "/issue")
      (append
        (if jql    `((jql    . ,jql))    '())
        (if fields `((fields . ,fields)) '())
        (if expand `((expand . ,expand)) '())
        `((validateQuery . ,(if validateQuery validateQuery "true"))
          (maxResults    . ,(or maxResults 20))
          (startAt       . ,(or startAt     0))))
      '()
      '()
      'json
      callback)
    (lambda (obj)
      (tike-jira-page--create :expand      (cdr-assoc 'expand     obj)
                              :start-at    (cdr-assoc 'startAt    obj)
                              :max-results (cdr-assoc 'maxResults obj)
                              :total       (cdr-assoc 'total      obj)
                              :values      (mapcar
                                             'tike-jira-issue-create
                                             (cdr-assoc 'issues   obj))))))

  ; (Rapid)Board Epics
(defun tike-jira-api--rapidboards--epics-get (account id &optional startAt maxResults
                                                                   done    callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/board/"
            (if (numberp id) (number-to-string id) id) "/epic")
    (append
      (if done `((done . ,done)) '())
      `((maxResults . ,(or maxResults 20)) (startAt . ,(or startAt 0))))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--rapidboards--epics--issues-get (account
                                                      boardID
                                                       epicID &optional startAt maxResults
                                                                        jql     validateQuery
                                                                        fields  expand        callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account)                      "/rest/agile/1.0/board/"
            (if (numberp boardID) (number-to-string boardID) boardID) "/epic/"
            (if (numberp  epicID) (number-to-string  epicID)  epicID) "/issue")
    (append
      (if jql    `((jql    . ,jql))    '())
      (if fields `((fields . ,fields)) '())
      (if expand `((expand . ,expand)) '())
      `((validateQuery . ,(if validateQuery validateQuery "true"))
        (maxResults    . ,(or maxResults 20))
        (startAt       . ,(or startAt     0))))
    '()
    '()
    'json
    callback))

  ; (Rapid)Board Sprints
(defun tike-jira-api--rapidboards--sprints-all (account id &optional startAt maxResults
                                                                     state   callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/board/"
            (if (numberp id) (number-to-string id) id) "/sprint")
    (append
      (if state `((state . ,state)) '())
      `((maxResults . ,(or maxResults 20)) (startAt . ,(or startAt 0))))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--rapidboards--sprints--issues-get (account
                                                         boardID
                                                        sprintID &optional startAt maxResults
                                                                           jql     validateQuery
                                                                           fields  expand        callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account)                         "/rest/agile/1.0/board/"
            (if (numberp  boardID) (number-to-string  boardID)  boardID) "/sprint/"
            (if (numberp sprintID) (number-to-string sprintID) sprintID) "/issue")
    (append
      (if jql    `((jql    . ,jql))    '())
      (if fields `((fields . ,fields)) '())
      (if expand `((expand . ,expand)) '())
      `((validateQuery . ,(if validateQuery validateQuery "true"))
        (maxResults    . ,(or maxResults 20))
        (startAt       . ,(or startAt     0))))
    '()
    '()
    'json
    callback))

  ; (Rapid)Board Versions
(defun tike-jira-api--rapidboards--versions-all (account id &optional startAt  maxResults
                                                                      released callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/board/"
            (if (numberp id) (number-to-string id) id) "/version")
    (append
      (if released `((released . ,released)) '())
      `((maxResults . ,(or maxResults 20)) (startAt . ,(or startAt 0))))
    '()
    '()
    'json
    callback))



;; Epics
(defun tike-jira-api--epics-get (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/agile/1.0/epic/"
      (if (numberp id) (number-to-string id) id))
    '()
    '()
    '()
    'json
    callback))



;; Issues
(defun tike-jira-api--issues-get (account idOrKey &optional fields expand callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/agile/1.0/issue/"
      (if (numberp idOrKey) (number-to-string idOrKey) idOrKey))
    (append
      (if fields `((fields . ,fields)) '())
      (if expand `((expand . ,expand)) '()))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--issues-rank (account rankObject &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat (tike-jira-account--get-uri account) "/rest/agile/1.0/issue/rank")
    '()
    '()
    '()
    ;; { "issues"           : ["PR-1",
    ;;                         "10001",
    ;;                         "PR-3"],
    ;;   "rankBeforeIssue"  : "PR-4",
    ;;   "rankCustomFieldId": 10521     }
    'json
    callback))



;; Sprints
(defun tike-jira-api--sprints-create (account
                                      sprintName
                                      sprintOriginBoardID &optional sprintStartDate
                                                                    sprintEndDate
                                                                    callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account) "/rest/agile/1.0/sprint")
    '()
    '()
    (append
      (if sprintStartDate `((startDate . ,sprintStartDate)) '())
      (if sprintEndDate   `((endDate   . ,sprintEndDate))   '())
      `((name . ,sprintName) (originBoardId . ,sprintOriginBoardID)))
    'json
    callback))

(defun tike-jira-api--sprints-get (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat
      (tike-jira-account--get-uri account)
      "/rest/agile/1.0/sprint/"
      (if (numberp id) (number-to-string id) id))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--sprints-update (account sprintID &optional sprintState
                                                                 sprintName
                                                                 sprintStartDate
                                                                 sprintEndDate
                                                                 sprintCompleteDate
                                                                 callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_PUT
    (concat
      (tike-jira-account--get-uri account)
      "/rest/agile/1.0/sprint/"
      (if (numberp sprintID) (number-to-string sprintID) sprintID))
    '()
    '()
    (append
      (if sprintState        `((state        . ,sprintState))        '())
      (if sprintName         `((name         . ,sprintName))         '())
      (if sprintStartDate    `((startDate    . ,sprintStartDate))    '())
      (if sprintEndDate      `((endDate      . ,sprintEndDate))      '())
      (if sprintCompleteDate `((completeDate . ,sprintCompleteDate)) '()))
    'json
    callback))

(defun tike-jira-api--sprints-update-partially (account sprintID &optional sprintState
                                                                           sprintName
                                                                           sprintStartDate
                                                                           sprintEndDate
                                                                           sprintCompleteDate
                                                                           callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat
      (tike-jira-account--get-uri account)
      "/rest/agile/1.0/sprint/"
      (if (numberp sprintID) (number-to-string sprintID) sprintID))
    '()
    '()
    (append
      (if sprintState        `((state        . ,sprintState))        '())
      (if sprintName         `((name         . ,sprintName))         '())
      (if sprintStartDate    `((startDate    . ,sprintStartDate))    '())
      (if sprintEndDate      `((endDate      . ,sprintEndDate))      '())
      (if sprintCompleteDate `((completeDate . ,sprintCompleteDate)) '()))
    'json
    callback))

(defun tike-jira-api--sprints-delete (account id &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_DELETE
    (concat
      (tike-jira-account--get-uri account)
      "/rest/agile/1.0/sprint/"
      (if (numberp id) (number-to-string id) id))
    '()
    '()
    '()
    'json
    callback))

(defun tike-jira-api--sprints--issues-get (account id &optional startAt maxResults
                                                                jql     validateQuery
                                                                fields  expand        callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_GET
    (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/sprint/"
            (if (numberp id) (number-to-string id) id) "/issue")
    (append
      (if jql    `((jql    . ,jql))    '())
      (if fields `((fields . ,fields)) '())
      (if expand `((expand . ,expand)) '())
      `((validateQuery . ,(if validateQuery validateQuery "true"))
        (maxResults    . ,(or maxResults 20))
        (startAt       . ,(or startAt     0))))
    '()
    '()
    'json
    callback))

(defun tike-jira-api--sprints--issues-move (account id issues &optional callback)
  ""
  (tike-jira-api---request
    tike-jira-api--REQUEST_POST
    (concat (tike-jira-account--get-uri account)       "/rest/agile/1.0/sprint/"
            (if (numberp id) (number-to-string id) id) "/issue")
    '()
    '()
    '()
    ;; { "issues": ["PR-1",
    ;;              "10001",
    ;;              "PR-3"]  }
    'json
    callback))

(provide 'tike-jira-api)

;;; jira-api.el ends here

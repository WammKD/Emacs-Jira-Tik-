;;; jira-api-attachment.el --- functions for interfacing with Jira's API Attachments
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
(require 'tike-jira-api-user)
(require 'tike-utils)

(cl-defstruct (tike-jira--attachment (:constructor tike-jira-attachment--create)
                                     (:conc-name   tike-jira-attachment--get-))
  (self nil) (filename  nil) (author     nil) (created nil)
  (size nil) (mime-type nil) (properties nil) (content nil) (thumbnail nil))

(tike-jira-object-create attachment
  (tike-jira-attachment--create :self       (cdr-assoc 'self       obj)
                                :filename   (cdr-assoc 'filename   obj)
                                :author     (tike-jira-user-create
                                              (cdr-assoc 'author   obj))
                                :created    (cdr-assoc 'created    obj)
                                :size       (cdr-assoc 'size       obj)
                                :mime-type  (cdr-assoc 'mimeType   obj)
                                :properties (cdr-assoc 'properties obj)
                                :content    (cdr-assoc 'content    obj)
                                :thumbnail  (cdr-assoc 'thumbnail  obj)))

(provide 'tike-jira-api-attachment)

;;; jira-api-attachment.el ends here

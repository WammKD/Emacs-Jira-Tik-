;;; jira-api-link.el --- functions for interfacing with Jira's API Links
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

(cl-defstruct (tike-jira--link-simple (:constructor tike-jira-link-simple--create)
                                      (:conc-name   tike-jira-link-simple--get-))
  (id    nil) (style-class nil) (icon-class nil)
  (label nil) (title       nil) (href       nil) (weight nil))

(tike-jira-object-create link-simple
  (tike-jira-link-simple--create :id          (cdr-assoc 'id          obj)
                                 :style-class (cdr-assoc 'style-class obj)
                                 :icon-class  (cdr-assoc 'icon-class  obj)
                                 :label       (cdr-assoc 'label       obj)
                                 :title       (cdr-assoc 'title       obj)
                                 :href        (cdr-assoc 'href        obj)
                                 :weight      (cdr-assoc 'weight      obj)))


(cl-defstruct (tike-jira--link-remote-entity (:constructor tike-jira-link-remote-entity--create)
                                             (:conc-name   tike-jira-link-remote-entity--get-))
  (self nil) (name nil) (link nil))

(tike-jira-object-create link-remote-entity
  (tike-jira-link-remote-entity--create :self (cdr-assoc 'self obj)
                                        :name (cdr-assoc 'name obj)
                                        :link (cdr-assoc 'link obj)))

(provide 'tike-jira-api-link)

;;; jira-api-link.el ends here

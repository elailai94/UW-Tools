#lang racket

;; ********************************************************************************************
;;  UW Tools
;;
;;  @description: A module for retrieving the required information from the uWaterloo API
;;  @author: Elisha Lai
;;  @version: 1.2 22/05/2014
;; ********************************************************************************************

(provide course-desc needs-consent? full-courses course-sections
         section-info next-holiday room-status)

;; DATA ANALYSIS

;; A Holiday is a non-empty list
;;   (list (list d-key d-value) (list n-key n-value)), where
;;        d-key is the String: "date",
;;        d-value is a 10-character String in the following format: YYYY-MM-DD,
;;        n-key is the String: "name",
;;        n-value is a String representing the name of the holiday.
;; A Holidays-List is a non-empty list (listof Holiday).

;; course-desc: String Int -> String
;; Conditions:
;;     PRE: subject must be non-empty.
;;          subject must represent a valid UW subject.
;;          catalog must represent a valid UW course number.
;;     POST: Produces a String.
;; Purpose: Consumes a string, subject, and an integer, catalog. Produces a string with the
;; description of the course.

;; needs-consent?: String Int -> Boolean
;; Conditions:
;;     PRE: subject must be non-empty.
;;          subject must represent a valid UW subject.
;;          catalog must represent a valid UW course number.
;;     POST: Produces a Boolean.
;; Purpose: Consumes a string, subject, and an integer, catalog. Produces #t if course
;; enrollment requires both the instructor's and department's consent. Otherwise, #f is
;; produced.

;; full-courses: String (listof Int) -> (listof Int)
;; Conditions:
;;     PRE: subject must be non-empty.
;;          subject must represent a valid UW subject.
;;          Each integer in catalog-list must represent a valid UW course number.
;;     POST: Produces a list of Int.
;;           The length of the produced list is at most the length of catalog-list.
;;           Each integer in the produced list will represent a valid UW course
;;           number.
;; Purpose: Consumes a string, subject, and a list of integers, catalog-list. Produces a
;; list of integers

;; course-sections: Int String Int -> (listof String)
;; Conditions:
;;     PRE: term is a four-digit integer.
;;          term must follow the UW term numbering system
;;          (see https://github.com/uWaterloo/api-documentation/blob/master/v2/terms/list.md).
;;          subject must be non-empty.
;;          subject must represent a valid UW subject.
;;          catalog must represent a valid UW course number.
;;     POST: Produces a list of String.
;; Purpose: Consumes a string, subject, and two integers, term and catalog. Produces a list
;; of strings corresponding to all the section names for the course.

;; section-info: Int String Int String -> String
;; Conditions:
;;     PRE: term is a four-digit integer.
;;          term must follow the UW term numbering system
;;          (see https://github.com/uWaterloo/api-documentation/blob/master/v2/terms/list.md).
;;          subject must be non-empty.
;;          subject must represent a valid UW subject.
;;          catalog must represent a valid UW course number.
;;          The length of section is 7.
;;          section must represent a valid course section.
;;     POST: Produces a String.
;;           The produced String is in the following format:
;;             "subject catalog section s-time-e-time weekdays building room instructor"
;;             (where:
;;              * subject is the course subject,
;;              * catalog is the course number,
;;              * section is the course section,
;;              * s-time is the starting time for the course section,
;;              * e-time is the ending time for the course section,
;;              * weekdays is the days when the course section occurs,
;;              * building is the building where the course section occurs,
;;              * room is the room where the course section occurs,
;;              * instructor is the instructor for the course section).
;; Purpose: Consumes two strings, subject and section, and two integers, term and catalog.
;; Produces a string containing information about a specific course section.

;; next-holiday: String -> String
;; Conditions:
;;     PRE: The length of date is 10.
;;          date must be in the following format: YYYY-MM-DD.
;;     POST: Produces a String.
;;           The produced String is in the following format:
;;             "date name"
;;             (where:
;;             * date is the date of the holiday
;;             * name is the name of the holiday).
;; Purpose: Consumes a string, date, and produces a string representing the next holiday
;; on or after date.

;; room-status: String Int String String -> String
;; Conditions:
;;     PRE: building must be non-empty.
;;          room must represent a valid room number in a particular building.
;;          The length of day is between 1 and 2 inclusively.
;;          day is one of the following string: "M", "T", "W", "Th", "F".
;;          The length of time is 5.
;;          time must follow the 24-hour format.
;;     POST: Produces a String.
;;           The produced String is in the following format:
;;             "subject catalog title"
;;             (where:
;;             * subject is the course subject,
;;             * catalog is the course number,
;;             * title is the course title).
;; Purpose: Consumes three strings, building, day, and time, and an integer, room. If the room
;; is used for a course at that time and day, then a string representing the course is
;; produced. If the room is not used, "FREE" is produced.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "uw-api.rkt")

;; lookup: String (listof (list String Any)) -> Any
;; Conditions:
;;     PRE: lst must be non-empty.
;;          lst must contain the key.
;;          All keys in lst must be distinct.
;;     POST: Produces a value of Any.
;; Purpose: Consumes a string, key, and a list of lists, lst. Produces the value associated
;; with key.

(define (lookup key lst)
  (cond
    [(string=? key (first (first lst))) (second (first lst))]
    [else (lookup key (rest lst))]))

;; see interface above
(define (course-desc subject catalog)
  ;; Input string to API query
  (define query
    (string-append "/courses/" subject "/" (number->string catalog)))
  ;; Output results from API query
  (define results (uw-api query))
  (lookup "description" results))

;; see interface above
(define (needs-consent? subject catalog)
  ;; Input string to API query
  (define query
    (string-append "/courses/" subject "/" (number->string catalog)))
  ;; Output results from API query
  (define results (uw-api query))
  (not (false? (and (lookup "needs_instructor_consent" results) 
                    (lookup "needs_department_consent" results)))))

;; see interface above
(define (full-courses subject catalog-list)
  ;; at-least-0.5?: Int -> Boolean
  ;; Conditions:
  ;;     PRE: catalog must represent a valid UW course number.
  ;;     POST: Produces a Boolean.
  ;; Purpose: Consumes an integer, catalog, and produces #t if the course units for the 
  ;; course is at least 0.5. Otherwise, #f is produced.
  (define (at-least-0.5? catalog)
    ;; Input string to API query
    (define query
      (string-append "/courses/" subject "/" (number->string catalog)))
    ;; Output results from API query
    (define results (uw-api query))
    (>= (lookup "units" results) 0.5))
  (filter at-least-0.5? catalog-list))

;; see interface above
(define (course-sections term subject catalog)
  ;; Input string to API query
  (define query
    (string-append "/terms/" (number->string term) "/" subject "/"
                   (number->string catalog) "/schedule"))
  ;; Output results from API query
  (define results (uw-api query))
  ;; lambda: (listof (list String String)) -> String
  ;; Conditions:
  ;;     PRE: lst must be non-empty.
  ;;          lst must contain the key "section".
  ;;          The key "section" in lst must be distinct.
  ;;     POST: Produces a String.
  ;; Purpose: Consumes a list of lists, lst, and produces a string representing a section name.
  (map (lambda (lst) (lookup "section" lst)) results))

;; see interface above
(define (section-info term subject catalog section)
  ;; Input string to API query
  (define query
    (string-append "/terms/" (number->string term) "/" subject "/"
                   (number->string catalog) "/schedule"))
  ;; Output results from API query
  (define results (uw-api query))
  ;; Section information for the required section
  (define section-info
    ;; lambda: (listof (list String String)) -> Boolean
    ;; Conditions:
    ;;     PRE: lst must be non-empty.
    ;;          lst must contain the key "section".
    ;;          The key "section" in lst must be distinct.
    ;;     POST: Produces a String.
    ;; Purpose: Consumes a list of lists, lst, and produces #f if a section name from lst
    ;; matches section. Otherwise, #f is produced.
    (first (filter (lambda (lst)
                     (string=? (lookup "section" lst) section)) results)))
  ;; First class information for the required class
  (define class-info (first (lookup "classes" section-info)))
  ;; List of fields required from date information
  (define date-keys (list "start_time" "end_time" "weekdays"))
  ;; List of fields from date information
  (define date-info-req
    ;; lambda: String -> String
    ;; Conditions:
    ;;     PRE: key must be non-empty.
    ;;     POST: Produces a String.
    ;; Purpose: Consumes a string, key, and produces a string.
    (map (lambda (key) (lookup key (lookup "date" class-info))) date-keys))
  ;; Instructor for the required class
  (define instructor (first (lookup "instructors" class-info)))
  ;; List of fields required from location information
  (define location-keys (list "building" "room"))
  ;; List of fields from location information
  (define location-info-req
    ;; lambda: String -> String
    ;; Conditions:
    ;;     PRE: key must be non-empty.
    ;;     POST: Produces a String.
    ;; Purpose: Consumes a string, key, and produces a string.
    (map (lambda (key) (lookup key (lookup "location" class-info)))
           location-keys))
  (string-append subject " " (number->string catalog) " " section " "
                 (first date-info-req) "-" (second date-info-req) " "
                 (third date-info-req) " " (first location-info-req) " "
                 (second location-info-req) " " instructor))

;; find-next-holiday: String Holiday-List -> String
;; Conditions:
;;     PRE: The length of date is 10.
;;          date must be in the following format: YYYY-MM-DD.
;;          holidays must be non-empty.
;;     POST: Produces a String.
;;           The produced String is in the following format:
;;             "date name"
;;             (where:
;;             * date is the date of the holiday
;;             * name is the name of the holiday).
;; Purpose: Consumes a string, date, and a Holiday-list, holidays. Produces a string
;; a string representing the next holiday on or after date.

(define (find-next-holiday date holidays)
  ;; Year field of date
  (define threshold-year (string->number (substring date 0 4)))
  ;; Month field of date
  (define threshold-month (string->number (substring date 5 7)))
  ;; Day field of date
  (define threshold-day (string->number (substring date 8)))
  ;; Date of holiday
  (define holiday-date (lookup "date" (first holidays)))
  ;; Name of holiday
  (define holiday-name (lookup "name" (first holidays)))
  ;; Year field of holiday-date
  (define holiday-year (string->number (substring holiday-date 0 4)))
  ;; Month field of holiday-date
  (define holiday-month (string->number (substring holiday-date 5 7)))
  ;; Day field of holiday-date
  (define holiday-day (string->number (substring holiday-date 8)))
  ;; String to be output if holiday-date is on or after date
  (define output-string (string-append holiday-date " " holiday-name))
  (cond
    [(> holiday-year threshold-year) output-string]
    [(= holiday-year threshold-year)
     (cond
       [(> holiday-month threshold-month) output-string]
       [(= holiday-month threshold-month)
        (cond
          [(> holiday-day threshold-day) output-string]
          [(= holiday-day threshold-day) output-string]
          [else (find-next-holiday date (rest holidays))])]
       [else (find-next-holiday date (rest holidays))])]
    [else (find-next-holiday date (rest holidays))]))

;; see interface above
(define (next-holiday date)
  ;; Input string to API query
  (define query "/events/holidays")
  ;; Output results from API query
  (define results (uw-api query))
  (find-next-holiday date results))

;; days-equal?: String String -> Boolean
;; Conditions:
;;     PRE: day1 must be non-empty.
;;          The length of day1 is between 1 and 2 inclusively.
;;          day2 must be non-empty.
;;     POST: Produces a Boolean.
;; Purpose: Consumes two strings, day1 and day2, and produces #t if they are the same day.
;; Otherwise, #f is produced.

(define (days-equal? day1 day2)
  ;; List of characters in day1
  (define loc1 (string->list day1))
  ;; List of characters in day2
  (define loc2 (string->list day2))
  (cond
    [(and (= (length loc1) 2) 
          (not (false? (member #\T loc2)))
          (not (false? (member #\h loc2)))) #t]
    [(and (= (length loc1) 1) (not (false? (member #\T loc1)))
          ;; lambda: Char -> Boolean
          ;; Conditions:
          ;;     PRE: True
          ;;     POST: Produces a Boolean.
          ;; Purpose: Consumes a character, char, and produces #t if char is equal to #\T.
          ;; Otherwise, #f is produced.
          (= (length (filter (lambda (char) (char=? char #\T)) loc2)) 2)
          (not (false? (member #\h loc2)))) #t]
    [(and (= (length loc1) 1) (not (false? (member #\T loc1)))
          (not (false? (member #\T loc2))) (false? (member #\h loc2))) #t]
    [(and (= (length loc1) 1) (false? (member #\T loc1))
          (not (false? (member (first loc1) loc2)))) #t]
    [else #f]))
  
;; free-room?: String String -> String
;; Conditions:
;;     PRE: The length of day is between 1 and 2 inclusively.
;;          day is one of the following string: "M", "T", "W", "Th", "F".
;;          The length of time is 5.
;;          time must follow the 24-hour format.
;;     POST: Produces a String.
;;           The produced String is in the following format:
;;             "subject catalog title"
;;             (where:
;;             * subject is the course subject,
;;             * catalog is the course number,
;;             * title is the course title).
;; Purpose: Consumes two strings, day and time. If the room is used for a course at that time
;; and day, then a string representing the course is produced. If the room is not used,
;; "FREE" is produced.

(define (free-room? day time classes)
  ;; Hour field of time
  (define threshold-h (string->number (substring time 0 2)))
  ;; Minutes field of time
  (define threshold-m (string->number (substring time 3)))
    (cond
      [(empty? classes) "FREE"]
      [else
       ;; Course subject of the class
       (define subject (lookup "subject" (first classes)))
       ;; Course number of the class
       (define catalog (lookup "catalog_number" (first classes)))
       ;; Course title of the classs
       (define title (lookup "title" (first classes)))
       ;; Days when the class occurs
       (define days (lookup "weekdays" (first classes)))
       ;; Starting time of the class
       (define start-time (lookup "start_time" (first classes)))
       ;; Hour field of start-time
       (define start-time-h (string->number (substring start-time 0 2)))
       ;; Minutes field of start-time
       (define start-time-m (string->number (substring start-time 3)))
       ;; Ending time of the class
       (define end-time (lookup "end_time" (first classes)))
       ;; Hours field of end-time
       (define end-time-h (string->number (substring end-time 0 2)))
       ;; Minutes field of end-time
       (define end-time-m (string->number (substring end-time 3)))
       ;; String to be output if the room is used
       (define output-string (string-append subject " " catalog " " title))
       (cond
           [(and (days-equal? day days)
                 (>= threshold-h start-time-h) (>= threshold-m start-time-m)
                 (<= threshold-h end-time-h) (<= threshold-m end-time-m)) output-string]
           [else (free-room? day time (rest classes))])]))
  
;; see interface above
(define (room-status building room day time)
  ;; Input string to API query
  (define query
    (string-append "/buildings/" building "/" (number->string room) "/" "courses"))
  ;; Output results from API query
  (define result (uw-api query))
  (free-room? day time result))

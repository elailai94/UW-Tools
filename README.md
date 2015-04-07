# uWaterloo-Tools
### About
uWaterloo Tools is a library for retrieving the required information from the University of Waterloo API (see [https://www.github.com/uWaterloo/api-documentation](https://www.github.com/uWaterloo/api-documentation) for more information). It provides seven different methods to query information from the University of Waterloo API. It is written entirely in Scheme.

### Library Import
```Racket
(require "uw-tools.rkt")
```

### Usage
#### Course Description for a Course
```Racket
(course-desc subject catalog)
```
##### Parameters
| Parameter    | Type    | Required   | Description                               |
|:-------------|:--------|:-----------|:------------------------------------------|
|**subject**   | String  | Yes        | Valid uWaterloo subject name              |
|**catalog**   | Int     | Yes        | Valid uWaterloo course number             |
##### Response
| Field Name     | Type    | Description                 |
|:---------------|:--------|:----------------------------|
|**description** | String  | Brief course description    |

#### Instructor's & Department's Consent for Course Enrolment for a Course
```Racket
(needs-consent? subject catalog)
```
##### Parameters
| Parameter    | Type    | Required   | Description                               |
|:-------------|:--------|:-----------|:------------------------------------------|
|**subject**   | String  | Yes        | Valid uWaterloo subject name              |
|**catalog**   | Int     | Yes        | Valid uWaterloo course number             |
##### Response
| Field Name     | Type    | Description                                           |
|:---------------|:--------|:------------------------------------------------------|
|**consent**     | Boolean | Requirement for Instructor's & Department's Consent   |

#### Courses That Are Worth At Least 0.5 Course Units
```Racket
(full-courses subject catalog-list)
```
##### Parameters
| Parameter         | Type           | Required   | Description                               |
|:------------------|:---------------|:-----------|:------------------------------------------|
|**subject**        | String         | Yes        | Valid uWaterloo subject name              |
|**catalog-list**   | listof Int     | Yes        | A list of valid uWaterloo course numbers  |
##### Response
| Field Name               | Type       | Description                                                                        |
|:-------------------------|:-----------|:-----------------------------------------------------------------------------------|
|**full courses list**     | listof Int | A list of valid uWaterloo course numbers that are worth at least 0.5 course units  |

#### Section Names for a Course
```Racket
(course-sections term subject catalog)
```


### License
uWaterloo Tools is licensed under the [MIT license.](https://github.com/elailai94/uWaterloo-Tools/blob/master/LICENSE)

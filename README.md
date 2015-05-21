# uWaterloo Tools
### About
uWaterloo Tools is a library for retrieving the required information from the University of Waterloo API (see [https://www.github.com/uWaterloo/api-documentation](https://www.github.com/uWaterloo/api-documentation) for more information). It provides eight different methods to query information from the University of Waterloo API. It is written entirely in Racket.

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
| Field Name            | Type       | Description                                                                        |
|:----------------------|:-----------|:-----------------------------------------------------------------------------------|
|**full courses list**  | listof Int | A list of valid uWaterloo course numbers that are worth at least 0.5 course units  |

#### Section Names for a Course
```Racket
(course-sections term subject catalog)
```
##### Parameters
| Parameter    | Type           | Required   | Description                                                       |
|:-------------|:---------------|:-----------|:------------------------------------------------------------------|
|**term**      | Int            | Yes        | Valid term following uWaterloo term numbering system              |
|**subject**   | String         | Yes        | Valid uWaterloo subject name                                      |
|**catalog**   | Int            | Yes        | Valid uWaterloo course number                                     |
##### Response
| Field Name           | Type          | Description              |
|:---------------------|:--------------|:-------------------------|
|**section names**     | listof String | A list of section names  |

#### Section Information for a Particular Section for a Course
```Racket
(section-info term subject catalog section)
```
##### Parameters
| Parameter    | Type           | Required   | Description                                                       |
|:-------------|:---------------|:-----------|:------------------------------------------------------------------|
|**term**      | Int            | Yes        | Valid term following uWaterloo term numbering system              |
|**subject**   | String         | Yes        | Valid uWaterloo subject name                                      |
|**catalog**   | Int            | Yes        | Valid uWaterloo course number                                     |
|**section**   | String         | Yes        | Valid course section                                              |
##### Response
| Field Name           | Type          | Description              |
|:---------------------|:--------------|:-------------------------|
|**section info**      | String        | Section information      |

> Note: **section info** is in the following format:
>
>     "subject catalog section s-time-e-time weekdays building room instructor"
>
>    * *subject* is the course subject,
>    * *catalog* is the course number,
>    * *section* is the course section,
>    * *s-time* is the starting time for the course section,
>    * *e-time* is the ending time for the course section,
>    * *weekdays* is the days when the course section occurs,
>    * *building* is the building where the course section occurs,
>    * *room* is the room where the course section occurs,
>    * *instructor* is the instructor for the course section.

#### Next Holiday On or After a Date
```Racket
(next-holiday date)
```
##### Parameters
| Parameter    | Type           | Required   | Description                                                       |
|:-------------|:---------------|:-----------|:------------------------------------------------------------------|
|**date**      | String         | Yes        | Date in the following format: YYYY-MM-DD                          |
##### Response
| Field Name           | Type          | Description              |
|:---------------------|:--------------|:-------------------------|
|**holiday**           | String        | Next holiday             |

> Note: **holiday** is in the following format:
>
>     "date name"
>
>   * *date* is the date of the holiday in the following format: YYYY-MM-DD,
>   * *name* is the name of the holiday.

#### Room Status
```Racket
(room-status building room day time)
```
##### Parameters
| Parameter    | Type           | Required   | Description                                                       |
|:-------------|:---------------|:-----------|:------------------------------------------------------------------|
|**building**  | String         | Yes        | Valid uWaterloo building                                          |
|**room**      | Int            | Yes        | Valid room number in the particular building                      |
|**day**       | String         | Yes        | Day from one of the following: "M", "T", "W", "Th", "F"           |
|**time**      | String         | Yes        | Time must follow the 24-hour format                               |
##### Response
| Field Name           | Type          | Description              |
|:---------------------|:--------------|:-------------------------|
|**room status**       | String        | Room status              |

> Note: **room status** is in the following format:
>
>     "subject catalog title"
>
>   * *subject* is the course subject,
>   * *catalog* is the course number,
>   * *title* is the course title.

#### Current Temperature
```Racket
(cur-temp)
```
##### Parameters
None
##### Response
| Field Name                 | Type          | Description                    |
|:---------------------------|:--------------|:-------------------------------|
|**current temperature**     | Num           | Current temperature in Celcius |

### License
* uWaterloo Tools is licensed under the [MIT license](https://github.com/elailai94/uWaterloo-Tools/blob/master/LICENSE.md).
* University of Waterloo API is licensed under the [ODL agreement v1](https://www.uwaterloo.ca/open-data/university-waterloo-open-data-license-agreement-v1).

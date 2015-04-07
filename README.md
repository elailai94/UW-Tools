# uWaterloo-Tools
### About
uWaterloo Tools is a library for retrieving the required information from the University of Waterloo API (see [https://www.github.com/uWaterloo/api-documentation](https://www.github.com/uWaterloo/api-documentation) for more information). It provides seven different methods to query information from the University of Waterloo API. It is written entirely in Scheme.

### Library Import
```Racket
(require "uw-tools.rkt")
```

### Usage
### Course Description for a Course
```Racket
(course-desc subject catalog)
```
#### Parameters
| Parameter    | Type    | Required   | Description                               |
|:-------------|:--------|:-----------|:------------------------------------------|
|**subject**   | String  | Yes        | Valid uWaterloo subject name              |
|**catalog**   | Int     | Yes        | Valid uWaterloo course number             |
#### Response
| Field Name     | Type    | Description                 |
|:---------------|:--------|:----------------------------|
|**description** | String  | Brief course description    |

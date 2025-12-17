# User Service API Documentation

This document lists the available API endpoints for the User Service, including input parameters and response structures.

## 1. Authentication (`/api/auth`)

### Register User

- **Endpoint**: `POST /api/auth/register`
- **Description**: Registers a new user (Student, Teacher, Staff, SchoolAdmin).
- **Access**: Public
- **Input (FormData/JSON)**:
  - `email` (string, required): Valid email address.
  - `password` (string, required): Minimum 6 characters.
  - `roleName` (string, required): "Student" | "Teacher" | "Staff" | "SchoolAdmin".
  - `baseUserInfo` (object, required):
    - `fullName` (string, required)
    - `gender` (string, optional)
    - `birthday` (date string, optional)
    - `phone` (string, optional)
    - `address` (string, optional)
  - `specificInfo` (object, optional): Additional info specific to the role.
  - `schoolId` (string, optional): ID of the school (required for most roles except maybe independent ones).
  - `classId` (string, optional): ID of the class (for Students).
  - `schoolData` (object, optional): Data to create a school if registering as SchoolAdmin for a new school.
  - `avatar` (file, optional): Image file.
- **Output**:
  - Success (201):
    ```json
    {
      "success": true,
      "message": "User registered successfully",
      "data": {
        "user": {
          "id": "...",
          "email": "...",
          "fullName": "...",
          "roleKey": "...",
          "schoolId": "...",
          "className": "..."
          // ...other user fields
        },
        "tokens": {
          "accessToken": "...",
          "refreshToken": "..."
        }
      }
    }
    ```

### Login

- **Endpoint**: `POST /api/auth/login`
- **Description**: Authenticates a user and returns tokens.
- **Access**: Public
- **Input (JSON)**:
  - `email` (string, required)
  - `password` (string, required)
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "message": "Login successful",
      "data": {
        "user": { ... },
        "tokens": {
          "accessToken": "...",
          "refreshToken": "..."
        }
      }
    }
    ```

### Refresh Token

- **Endpoint**: `POST /api/auth/refresh-token`
- **Description**: Refreshes the access token using a valid refresh token.
- **Access**: Public
- **Input (JSON)**:
  - `refreshToken` (string, required)
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "message": "Token refreshed successfully",
      "data": {
        "tokens": {
          "accessToken": "...",
          "refreshToken": "..."
        }
      }
    }
    ```

### Get Current User

- **Endpoint**: `GET /api/auth/me`
- **Description**: Retrieves information about the currently authenticated user.
- **Access**: Private (Requires Access Token)
- **Input**: None (Uses Bearer Token)
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "message": "User information retrieved successfully",
      "data": {
        "user": { ... },
        "account": {
          "isActive": true,
          "lastLogin": "..."
        }
      }
    }
    ```

## 2. Schools (`/api/schools`)

### Search Schools (Query)

- **Endpoint**: `GET /api/schools/search/query`
- **Description**: Search schools by education level and name.
- **Access**: Public
- **Input (Query Params)**:
  - `educationLevel` (string, required): e.g., "Primary", "Secondary".
  - `search` (string, optional): Search term for school name.
  - `limit` (number, optional)
  - `offset` (number, optional)
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "message": "Schools searched successfully",
      "data": [
        {
          "id": "...",
          "name": "...",
          "code": "...",
          "studentCount": 100
          // ...
        }
      ]
    }
    ```

### Get School Details (Admin)

- **Endpoint**: `GET /api/schools/school-admin`
- **Description**: Get details of the school managed by the current School Admin.
- **Access**: Private (SchoolAdmin)
- **Input**: None
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "data": { "id": "...", "name": "...", ... }
    }
    ```

### Get Schools (List)

- **Endpoint**: `GET /api/schools`
- **Description**: Get a list of schools with filters.
- **Access**: Public
- **Input (Query Params)**:
  - `educationLevel` (string, required)
  - `search` (string, optional)
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "data": [ { ... } ]
    }
    ```

### Get School By ID

- **Endpoint**: `GET /api/schools/:id`
- **Description**: Get details of a specific school.
- **Access**: Private
- **Input**: `id` (URL Param)
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "data": { ... }
    }
    ```

### Get Classes by School

- **Endpoint**: `GET /api/schools/:schoolId/classes`
- **Description**: Get all classes belonging to a specific school.
- **Access**: Private
- **Input**:
  - `schoolId` (URL Param)
  - `grade` (Query Param, optional)
- **Output**:
  - Success:
    ```json
    {
      "success": true,
      "data": [
        {
          "id": "...",
          "name": "...",
          "grade": "..."
          // ...
        }
      ]
    }
    ```

### Register School

- **Endpoint**: `POST /api/schools`
- **Description**: Register a new school (SuperAdmin only).
- **Access**: Private (SuperAdmin)
- **Input (JSON)**: `CreateSchoolDto`
- **Output**:
  - Success (201): `School` entity.

### Update School

- **Endpoint**: `PUT /api/schools/:id`
- **Description**: Update school details.
- **Access**: Private (SuperAdmin, SchoolAdmin)
- **Input**: `UpdateSchoolDto`
- **Output**: Success with updated school data.

### Delete School

- **Endpoint**: `DELETE /api/schools/:id`
- **Description**: Delete a school.
- **Access**: Private (SuperAdmin)
- **Input**: `id`
- **Output**: Success message.

## 3. Classes (`/api/classes`)

### Create Class

- **Endpoint**: `POST /api/classes`
- **Access**: Private (SuperAdmin, SchoolAdmin)
- **Input**: `CreateClassDto` (name, schoolId, gradeId, etc.)
- **Output**: Created class.

### Get All Classes

- **Endpoint**: `GET /api/classes`
- **Access**: Private
- **Input (Query)**: `page`, `limit`, `sortBy`, `sortOrder`, `gradeId`, `active`, `schoolId`.
- **Output**: Paginated list of classes.

### Search Classes in School

- **Endpoint**: `GET /api/classes/schools/search`
- **Access**: Private
- **Input (Query)**: `query` (search term), `schoolId`, `gradeId`, `limit`, `offset`.
- **Output**: List of classes matching search.

### Get Class By ID

- **Endpoint**: `GET /api/classes/:id`
- **Access**: Private
- **Input**: `id`
- **Output**: Class details.

### Get Students in Class

- **Endpoint**: `GET /api/classes/:id/students`
- **Access**: Private
- **Input**: `id`
- **Output**: List of students in the class.

### Add Students to Class

- **Endpoint**: `POST /api/classes/:id/students/add`
- **Access**: Private (Admin, Teacher)
- **Input**: `studentIds` (array of strings).
- **Output**: Success message.

### Remove Students from Class

- **Endpoint**: `POST /api/classes/:id/students/remove`
- **Access**: Private (Admin, Teacher)
- **Input**: `studentIds` (array of strings).
- **Output**: Success message.

### Transfer Students

- **Endpoint**: `POST /api/classes/:id/students/transfer`
- **Access**: Private (Admin, Teacher)
- **Input**: `toClassId` (string), `studentIds` (array).
- **Output**: Success message.

### Update Class

- **Endpoint**: `PUT /api/classes/:id`
- **Access**: Private (Admin)
- **Input**: `UpdateClassDto`.
- **Output**: Updated class.

### Delete Class

- **Endpoint**: `DELETE /api/classes/:id`
- **Access**: Private (Admin)
- **Output**: Success message.

## 4. Grades (`/api/grades`)

### Create Grade

- **Endpoint**: `POST /api/grades`
- **Access**: Private (Admin)
- **Input**: `CreateGradeDto`.
- **Output**: Created grade.

### Get All Grades

- **Endpoint**: `GET /api/grades`
- **Access**: Private
- **Input (Query)**: `page`, `limit`, `schoolId`, `level`, `active`, `search`, `fields`.
- **Output**: Paginated grades.

### Get Grades for Select

- **Endpoint**: `GET /api/grades/select/box`
- **Access**: Private
- **Input**: `schoolId` (optional).
- **Output**: Simplified list of grades (id, name, level).

### Get Grade By ID

- **Endpoint**: `GET /api/grades/:id`
- **Access**: Private
- **Output**: Grade details.

### Get Grades By School

- **Endpoint**: `GET /api/grades/school/:schoolId`
- **Access**: Private
- **Output**: List of grades for the school.

### Update Grade

- **Endpoint**: `PUT /api/grades/:id`
- **Access**: Private (Admin)
- **Input**: `UpdateGradeDto`.
- **Output**: Updated grade.

### Delete Grade

- **Endpoint**: `DELETE /api/grades/:id`
- **Access**: Private (Admin)
- **Output**: Success message.

### Bulk Operations

- **Bulk Create**: `POST /api/grades/bulk/create` (Body: Array of grades)
- **Bulk Update**: `PUT /api/grades/bulk/update` (Body: Array of updates)
- **Bulk Delete**: `DELETE /api/grades/bulk/delete` (Body: `{ ids: [] }`)
- **Bulk Activate**: `POST /api/grades/bulk/activate` (Body: `{ ids: [] }`)
- **Bulk Deactivate**: `POST /api/grades/bulk/deactivate` (Body: `{ ids: [] }`)

## 5. Users (`/api/users`)

### Create User (Admin)

- **Endpoint**: `POST /api/users`
- **Access**: Public/Private (Check implementation, seems routed to `userController.createUser`)
- **Input**: `CreateUserDto`
- **Output**: Created user.

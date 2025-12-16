# Plan for Enhancing User Service API

## Overview

Based on analysis of the current monolithic API service and the new user_service microservice, the following features need to be added to achieve parity and improve functionality.

## Current Status

✅ **Implemented:**

- Basic CRUD operations for Schools, Grades, Classes, Users
- Authentication (login, register, token refresh)
- Clean Architecture with CQRS pattern
- Basic routing structure

❌ **Missing Features from Monolithic API:**

### 1. **Enhanced Route Features**

#### School Routes (`/api/schools`)

Missing from user_service:

- `GET /school-admin` - Get school details for school admin
- Advanced search with filters
- Pagination support

#### Grade Routes (`/api/grades`)

Missing from user_service:

- `GET /` - Get all grades with pagination and filtering
- `GET /select/box` - Get grades for select dropdown (optimized for UI)
- Advanced filtering by schoolId, level, active status
- Sorting by name, level, order
- Pagination

#### Class Routes (`/api/classes`)

Missing from user_service:

- `GET /` - Get all classes with pagination and filtering
- `GET /view-model/class-detail` - Get classes with detailed view
- `GET /view-model/class-detail/:id` - Get specific class detail view
- `POST /:id/students/add` - Add students to class
- `POST /:id/students/remove` - Remove students from class
- `POST /:id/students/transfer` - Transfer students between classes
- `GET /schools/search` - Search classes within schools
- Class detail view with related data (Grade info, Student count, etc.)

### 2. **Middleware & Security**

Missing from user_service:

- Role-based access control (RBAC) middleware
- Request validation middleware
- Activity logging middleware
- Error handling middleware
- Rate limiting
- Request/response caching

### 3. **Validation Schemas**

Missing from user_service:

- Comprehensive input validation for all endpoints
- Header validation (authentication headers)
- Parameter validation (ObjectId validation)
- Query parameter validation for pagination, sorting, filtering
- Body validation for create/update operations

### 4. **Advanced Features**

Missing from user_service:

- Pagination for list endpoints
- Advanced search with filters
- Sorting capabilities
- Field selection (partial responses)
- Bulk operations
- Export functionality
- Import functionality

### 5. **Infrastructure Components**

Missing from user_service:

- Activity logging system
- Error monitoring
- Metrics collection
- Health check endpoints
- API documentation (Swagger/OpenAPI)
- Response caching layer

## Implementation Priority

### Phase 1: Core Missing API Endpoints (High Priority)

1. Implement missing grade endpoints:

   - GET /grades (with pagination)
   - GET /grades/select/box

2. Implement missing class endpoints:

   - GET /classes (with pagination)
   - POST /classes/:id/students/add
   - POST /classes/:id/students/remove
   - POST /classes/:id/students/transfer

3. Implement missing school endpoints:
   - GET /schools/search/query
   - GET /schools/school-admin

### Phase 2: Middleware & Security (High Priority)

1. Create validation schemas for all endpoints
2. Implement RBAC middleware
3. Add activity logging middleware
4. Implement error handling middleware

### Phase 3: Advanced Features (Medium Priority)

1. Add pagination to all list endpoints
2. Implement advanced search functionality
3. Add sorting capabilities
4. Create class detail view endpoints

### Phase 4: Infrastructure & Monitoring (Low Priority)

1. Add health check endpoints
2. Implement metrics collection
3. Set up API documentation
4. Add response caching

## Technical Considerations

1. **Database Schema Updates**:

   - Ensure MongoDB read models support new query patterns
   - Add indexes for frequently queried fields
   - Consider denormalization for performance

2. **API Consistency**:

   - Maintain consistent response formats
   - Use standard HTTP status codes
   - Implement proper error responses

3. **Performance**:

   - Implement caching for frequently accessed data
   - Use database connections efficiently
   - Consider implementing query optimization

4. **Security**:
   - Validate all inputs
   - Sanitize outputs
   - Implement proper authentication and authorization
   - Add rate limiting

## Next Steps

1. Begin with Phase 1 implementation
2. Create necessary use cases and repositories
3. Update controllers with new endpoints
4. Add validation schemas
5. Implement middleware
6. Test all new endpoints thoroughly
7. Update API documentation

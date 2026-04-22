

## API Endpoints Table
| Method | Endpoint | Description | Auth Req |
| :--- | :--- | :--- | :--- |
| `POST` | `/user/register/` | Create a new user account | No |
| `POST` | `/user/login/` | Login and receive a JWT token | No |
| `POST` | `/user/token/refresh/` | Get new JWT access token | Yes |
| `GET` | `/user/profile/` | Get details of Logged User | Yes |
| `POST` | `/user/progress/` | Update User Progress | Yes |
| `GET` | `/user/progress/<course_id>/` | Get user progress in specific course | Yes |
| `GET` | `/course/` | Get list of available courses | Yes |
| `GET` | `/course/<course_id>/` | Get details of specific course | Yes |
| `GET` | `/course/<course_id>/modules/` | List all modules in specific course  | Yes |
| `GET` | `/course/modules/<module_id>/` | Get details and content of specific module | Yes |
## Documentation
### 1. `POST` `/user/register/`
#### Parameters :
- first_name (min 3 chars)
- last_name (min 3 chars)
- username
- email
- password (min 8 chars)
#### Expected Responses :
- 201 - Success
- 400 - Bad Request

### 2. `POST` `/user/login/`
#### Parameters :
- username
- password
#### Expected Responses :
- 200 - Success (returns access and refresh tokens)
- 400 - Bad Request (insufficient parameters)
- 401 - Unauthorized (Invalid User Credentials)

### 3. `POST` `/user/token/refresh/`
#### Parameters :
- refresh (refresh token)
#### Expected Responses :
- 200 - Success (returns access and refresh tokens)
- 400 - Bad Request (insufficient parameters)
- 401 - Unauthorized (Invalid Token)

### 4. `GET` `/user/profile/`
#### Parameters :
- access token (Authorization Header)
#### Expected Responses :
- 200 - Success (returns username and full_name)
- 401 - Unauthorized (missing,expired or invalid access token)

### 5. `POST` `/user/progress/`
#### Parameters :
- access token (Authorization Header)
- course_id (for which to update user progress)
- module_index (module completed by user)
#### Expected Responses :
- 204 - Success (Progress Updated)
- 400 - Bad Request (Insufficient or invalid parameters)
- 401 - Unauthorized (missing,expired or invalid access token)

### 6. `GET` `/user/progress/<course_id>/`
#### Parameters :
- access token (Authorization Header)
#### Expected Responses :
- 200 - Success (returns course_id,module_index,completed_at)
- 400 - Bad Request (Invalid course_id)
- 401 - Unauthorized (missing,expired or invalid access token)
- 404 - Not Found (No user progress in this course , user likely not started course yet or progress not updated)


### 7. `GET` `/course/`
#### Parameters :
- access token (Authorization Header)
#### Expected Responses :
- 200 - Success (returns list of courses , each list item containing id,name,desc,author)
- 401 - Unauthorized (missing,expired or invalid access token)

### 8. `GET` `/course/<course_id>/`
#### Parameters :
- access token (Authorization Header)
#### Expected Responses :
- 200 - Success (returns course id,name,desc,author)
- 400 - Bad Request (Invalid course_id in URL)
- 401 - Unauthorized (missing,expired or invalid access token)

### 9. `GET` `/course/<course_id>/modules/`
#### Parameters :
- access token (Authorization Header)
#### Expected Responses :
- 200 - Success (returns list of modules, each module having id,title,index )
- 400 - Bad Request (Invalid course_id in URL)
- 401 - Unauthorized (missing,expired or invalid access token)

### 10. `GET` `/course/modules/<module_id>/`
#### Parameters :
- access token (Authorization Header) 
#### Expected Responses :
- 204 - Success (returns module_id and content)
- 400 - Bad Request (Invalid module_id in URL)
- 401 - Unauthorized (missing,expired or invalid access token)
- 500 - Internal Server Error

# Project Overview
Project Title: Enhanced User Authentication System

## Objective: Create a user authentication system that includes:

- User registration with email, username, and password.
- Email verification using a verification code.
- Password strength validation.
- Username uniqueness and length validation.

## Key Features
User Registration:

- Users can register with an email, username, and password.
- Check that the username is unique and meets a minimum length requirement.
- Validate the password to ensure it meets certain complexity requirements (e.g., at least 8 characters, one uppercase letter, one lowercase letter, one digit, and one special character).

## Email Verification:

- Send a verification email containing a unique code to the user's email upon registration.
- Users must verify their email by clicking on the link in the email.

## User Login:

- Authenticate users with their credentials after email verification.

## Secure Password Storage:

- Use hashing (e.g., bcrypt) to securely store passwords.

## Technologies Used

- Backend: Node.js, Express
- Database: MongoDB (using Mongoose)
- Email Service: Nodemailer (for sending verification emails)
- Password Hashing: bcrypt
- Input Validation: express-validator

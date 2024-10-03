# VerifyMail Architecture

VerifyMail is a Node.js-based email verification system with a modular architecture designed for simplicity, security, and scalability. This document outlines the high-level architecture of the system based on the current codebase.

## Core Components

1. **Email Verification Module**
   - Located in: `email/emailVerification.js`
   - Responsible for generating verification codes, sending verification emails, and handling the verification process
   - Utilizes Nodemailer for email functionality
   - Implements a command-line interface for user interaction

2. **Verification Module**
   - Split into two files:
     - `verification/codeGeneration.js`: Generates verification codes and tokens
     - `verification/codeVerification.js`: Verifies user-submitted codes
   - Uses JWT for secure token generation and verification

3. **Email Templates**
   - Located in: `utils/emailTemplates.js`
   - Generates HTML templates for verification emails
   - Includes inline base64-encoded images for better email client compatibility

4. **Configuration**
   - Located in: `config/mailConfig.js`
   - Sets up the Nodemailer transporter with Gmail SMTP settings

5. **Memory Store**
   - Located in: `memoryStore/verificationCodeStore.js`
   - Implements an in-memory storage solution for temporary token storage


## Key Files and Their Roles

- `email/emailVerification.js`: Main entry point, contains the core email verification logic and CLI interface
- `verification/codeGeneration.js`: Handles generation of verification codes and tokens
- `verification/codeVerification.js`: Manages the verification process for user-submitted codes
- `email/verificationSuccessEmail.js`: Sends a success email after successful verification
- `utils/emailTemplates.js`: Generates HTML email templates with embedded images
- `config/mailConfig.js`: Configures the Nodemailer transporter
- `memoryStore/verificationCodeStore.js`: Manages in-memory storage of verification tokens
- `package.json`: Defines project dependencies and scripts
- `.env`: Stores environment variables (not in version control)
- `README.md`: Project documentation and setup instructions

## Data Flow

1. User initiates verification process via CLI
2. System generates a unique verification code and JWT token
3. Verification email is sent to the user with the code
4. User submits the verification code via CLI
5. System validates the code and sends a success email

## Security Measures

- Environment variables for sensitive information
- JWT for secure token-based authentication

/ Leo
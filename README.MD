# VerifyMail

VerifyMail is a lightweight Node.js-based email verification system. It provides a simple and secure way to verify email addresses using one-time verification codes.

## Features

- Ask's for email address
- Generate a unique and secure JWT token
- Store the generated code
- Send an email to the user's email address with the verification code
- Request a verification code from the user
- Verify the code

## Prerequisites

- Node.js (v14 or higher recommended)
- npm (Node Package Manager)
- Gmail account for sending verification emails

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/leovxyz/verifymail.git
   cd verifymail
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   Create a `.env` file in the root directory and add the following:
   ```bash
   EMAIL_USER=your-gmail-address@gmail.com
   EMAIL_PASS=your-gmail-app-password
   JWT_SECRET_KEY=your-secret-key-for-jwt
   ```

   Note: For EMAIL_PASS, use an app password generated from your Google Account settings.

   To generate a secure JWT_SECRET_KEY, you can use the following command in your terminal:

   ```bash
   node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
   ```

   This will generate a random 64-byte hexadecimal string, which is suitable for use as a JWT secret key.

## Usage

To start the application:

```
npm start
```

For development with auto-restart, you can use nodemon:

```
npm run dev
```

To run the verification process:

```
npm run verify
```

The application will prompt you to enter an email address for verification. Follow the instructions in the console to complete the verification process.

## License

This project is licensed under the MIT License.

/Leo

# VerifyMail

VerifyMail is a lightweight Node.js-based email verification system. It provides a simple and secure way to verify email addresses using one-time verification codes.

## Features

- Generate and send verification codes via email
- Secure token generation and storage
- Email-based verification process
- JWT (JSON Web Token) integration for enhanced security
- Modular architecture for easy maintenance and scalability

## Prerequisites

- Node.js (v14 or higher recommended)
- npm (Node Package Manager)
- Gmail account for sending verification emails

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/verifymail.git
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

## Usage

To start the application:

```
node mailsender/mailToken.js
```

For development with auto-restart, you can use nodemon (if installed):

```
nodemon mailsender/mailToken.js
```

The application will prompt you to enter an email address for verification. Follow the instructions in the console to complete the verification process.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the ISC License.

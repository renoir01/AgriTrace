# AgriTrace Frontend

React.js frontend for the AgriTrace agricultural supply chain traceability platform.

## Features

- Modern React.js with functional components and hooks
- Material-UI (MUI) for responsive design
- JWT Authentication
- React Router for navigation
- Axios for API integration
- Formik and Yup for form validation
- Recharts for data visualization
- Leaflet for maps and geolocation
- Comprehensive test suite
- Docker containerization

## Directory Structure

```
frontend/
├── public/           # Static files
├── src/              # Source code
│   ├── assets/       # Images, fonts, etc.
│   ├── components/   # Reusable UI components
│   ├── contexts/     # React contexts (Auth, etc.)
│   ├── hooks/        # Custom React hooks
│   ├── layouts/      # Page layouts
│   ├── pages/        # Page components
│   ├── services/     # API services
│   ├── theme/        # MUI theme configuration
│   └── utils/        # Utility functions
├── .eslintrc.js      # ESLint configuration
├── package.json      # Dependencies and scripts
└── README.md         # Documentation
```

## Setup Instructions

### Prerequisites

- Node.js 14+
- npm 6+ or yarn 1.22+

### Local Development Setup

1. **Install dependencies**

```bash
npm install
# or
yarn install
```

2. **Set up environment variables**

Create a `.env` file in the frontend directory:

```
REACT_APP_API_URL=http://localhost:8000/api/v1
REACT_APP_ENV=development
```

3. **Start the development server**

```bash
npm start
# or
yarn start
```

4. **Access the application**

Open your browser and navigate to http://localhost:3000

## Available Scripts

- `npm start` - Start the development server
- `npm build` - Build the production-ready app
- `npm test` - Run the test suite
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

## Testing

```bash
npm test
# or
npm run test:coverage
```

## Building for Production

```bash
npm run build
```

The build artifacts will be stored in the `build/` directory.

## Docker Deployment

See the Docker Compose configuration in the root directory for containerized deployment.

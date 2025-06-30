# AgriTrace

[![CI Status](https://github.com/renoir01/AgriTrace/workflows/CI/badge.svg)](https://github.com/renoir01/AgriTrace/actions)

Agricultural supply chain traceability platform - bringing transparency from farm to consumer.

## Project Overview

AgriTrace is a comprehensive platform designed to enhance transparency and traceability in agricultural supply chains. By leveraging modern technology, AgriTrace connects farmers, distributors, retailers, and consumers in a transparent ecosystem that tracks agricultural products from their origin to the end consumer.

### Key Features

- **Farm Registration & Management**: Register farms, track production practices, and manage certifications
- **Product Traceability**: Track agricultural products through the entire supply chain with unique identifiers
- **Quality Assurance**: Record and verify quality checks at each stage of the supply chain
- **Consumer Interface**: Allow consumers to scan products and view their complete journey
- **Analytics Dashboard**: Gain insights into supply chain efficiency and sustainability metrics
- **Blockchain Integration**: Ensure data integrity and immutability of supply chain records

## Technology Stack

- **Backend**: Python/Django REST Framework
- **Frontend**: React.js with Material-UI
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Tokens)
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Cloud Deployment**: Azure/AWS

## Project Structure

```
AgriTrace/
├── backend/            # Django REST API
├── frontend/           # React.js web application
├── mobile/             # Mobile application (React Native)
├── docs/               # Documentation
├── infrastructure/     # IaC (Infrastructure as Code)
└── scripts/            # Utility scripts
```

## Getting Started

### Prerequisites

- Python 3.8+
- Node.js 14+
- PostgreSQL 12+
- Docker & Docker Compose (optional)

### Local Development Setup

1. **Clone the repository**

```bash
git clone https://github.com/renoir01/AgriTrace.git
cd AgriTrace
```

2. **Set up the backend**

```bash
cd backend
python -m venv venv
venv\Scripts\activate  # On Windows
source venv/bin/activate  # On Unix/macOS
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

3. **Set up the frontend**

```bash
cd frontend
npm install
npm start
```

4. **Access the application**

Open your browser and navigate to http://localhost:3000

### Docker Setup

```bash
docker-compose up -d
```

## Contributing

1. Create a feature branch from `develop`
2. Make your changes
3. Submit a pull request to the `develop` branch
4. Ensure CI checks pass
5. Request a code review

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Project Board

[AgriTrace Project Board](https://github.com/renoir01/AgriTrace/projects/1)

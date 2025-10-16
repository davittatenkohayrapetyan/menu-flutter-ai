# Menu Flutter AI Server

Node.js Express server with OpenAI integration for menu parsing and dish enrichment.

## Features

- **POST /parse-menu**: Parse menu images using OpenAI Vision API
- **POST /enrich-dish**: Enrich dish details with descriptions and nutrition information

## Prerequisites

- Node.js 18+ 
- OpenAI API key

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file:
```bash
cp .env.example .env
```

3. Add your OpenAI API key to `.env`:
```
OPENAI_API_KEY=sk-your-key-here
PORT=3000
```

## Running the Server

### Development
```bash
npm run dev
```

### Production
```bash
npm start
```

### Docker
```bash
# Build and run with docker-compose
docker-compose up -d

# Or build and run manually
docker build -t menu-ai-server .
docker run -p 3000:3000 -e OPENAI_API_KEY=your-key menu-ai-server
```

## API Endpoints

### Parse Menu
**POST /parse-menu**

Upload a menu image and get parsed menu items.

Request:
- Content-Type: multipart/form-data
- Body: image file

Response:
```json
{
  "items": [
    {
      "id": "unique-id",
      "name": "Dish Name",
      "description": "Description",
      "price": 12.99,
      "isEnriched": false,
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  ]
}
```

### Enrich Dish
**POST /enrich-dish**

Get detailed description and nutrition information for a dish.

Request:
```json
{
  "name": "Dish Name",
  "description": "Optional current description"
}
```

Response:
```json
{
  "id": "unique-id",
  "name": "Dish Name",
  "description": "Detailed description",
  "price": 0,
  "nutrition": {
    "calories": 500,
    "protein": 25,
    "carbs": 45,
    "fat": 15,
    "fiber": 5,
    "sugar": 8,
    "sodium": 600
  },
  "isEnriched": true,
  "createdAt": "2024-01-01T00:00:00.000Z"
}
```

## Environment Variables

- `OPENAI_API_KEY`: Your OpenAI API key (required)
- `PORT`: Server port (default: 3000)

## Notes

- Uploaded images are temporarily stored in `uploads/` directory and deleted after processing
- The server uses GPT-4 Vision for image parsing and GPT-4 for text enrichment
- CORS is enabled for all origins (configure as needed for production)

import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import multer from 'multer';
import OpenAI from 'openai';
import fs from 'fs';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Middleware
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Menu Flutter AI Server' });
});

// Parse menu from image
app.post('/parse-menu', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No image file provided' });
    }

    const imagePath = req.file.path;
    const imageBuffer = fs.readFileSync(imagePath);
    const base64Image = imageBuffer.toString('base64');

    const response = await openai.chat.completions.create({
      model: 'gpt-4-vision-preview',
      messages: [
        {
          role: 'user',
          content: [
            {
              type: 'text',
              text: 'Parse this menu image and extract all menu items. For each item, provide the name, description (if available), and price. Return the result as a JSON array with objects containing: id (generate a unique ID), name, description, and price.',
            },
            {
              type: 'image_url',
              image_url: {
                url: `data:image/jpeg;base64,${base64Image}`,
              },
            },
          ],
        },
      ],
      max_tokens: 1000,
    });

    // Clean up uploaded file
    fs.unlinkSync(imagePath);

    const content = response.choices[0].message.content;
    
    // Try to parse JSON from response
    let items = [];
    try {
      // Extract JSON from markdown code blocks if present
      const jsonMatch = content.match(/```json\n([\s\S]*?)\n```/) || content.match(/```\n([\s\S]*?)\n```/);
      const jsonStr = jsonMatch ? jsonMatch[1] : content;
      items = JSON.parse(jsonStr);
    } catch (parseError) {
      // If parsing fails, return a default structure
      items = [
        {
          id: Date.now().toString(),
          name: 'Sample Item',
          description: 'Unable to parse menu automatically',
          price: 0,
          createdAt: new Date().toISOString(),
        },
      ];
    }

    // Ensure each item has required fields
    const processedItems = items.map((item, index) => ({
      id: item.id || `${Date.now()}-${index}`,
      name: item.name || 'Unknown Item',
      description: item.description || '',
      price: typeof item.price === 'number' ? item.price : 0,
      isEnriched: false,
      createdAt: new Date().toISOString(),
    }));

    res.json({ items: processedItems });
  } catch (error) {
    console.error('Error parsing menu:', error);
    res.status(500).json({ error: 'Failed to parse menu', message: error.message });
  }
});

// Enrich dish with additional information
app.post('/enrich-dish', async (req, res) => {
  try {
    const { name, description } = req.body;

    if (!name) {
      return res.status(400).json({ error: 'Dish name is required' });
    }

    const response = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: 'You are a culinary expert and nutritionist. Provide detailed descriptions and estimated nutrition information for dishes.',
        },
        {
          role: 'user',
          content: `Provide a detailed description and estimated nutrition information for the dish "${name}". ${description ? `Current description: ${description}` : ''} 
          
          Return the result as JSON with this structure:
          {
            "name": "dish name",
            "description": "detailed description",
            "nutrition": {
              "calories": number,
              "protein": number (in grams),
              "carbs": number (in grams),
              "fat": number (in grams),
              "fiber": number (in grams),
              "sugar": number (in grams),
              "sodium": number (in mg)
            }
          }`,
        },
      ],
      response_format: { type: 'json_object' },
      max_tokens: 500,
    });

    const content = response.choices[0].message.content;
    const enrichedData = JSON.parse(content);

    res.json({
      id: req.body.id || Date.now().toString(),
      name: enrichedData.name || name,
      description: enrichedData.description || description || '',
      price: req.body.price || 0,
      nutrition: enrichedData.nutrition,
      isEnriched: true,
      createdAt: req.body.createdAt || new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error enriching dish:', error);
    res.status(500).json({ error: 'Failed to enrich dish', message: error.message });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`OpenAI API Key configured: ${!!process.env.OPENAI_API_KEY}`);
});

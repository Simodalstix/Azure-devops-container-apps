const express = require("express");
const helmet = require("helmet");
const cors = require("cors");
const morgan = require("morgan");
const appInsights = require("applicationinsights");
require("dotenv").config();

// Initialize Application Insights
if (process.env.APPLICATIONINSIGHTS_CONNECTION_STRING) {
  appInsights
    .setup(process.env.APPLICATIONINSIGHTS_CONNECTION_STRING)
    .setAutoDependencyCorrelation(true)
    .setAutoCollectRequests(true)
    .setAutoCollectPerformance(true, true)
    .setAutoCollectExceptions(true)
    .setAutoCollectDependencies(true)
    .setAutoCollectConsole(true)
    .setUseDiskRetryCaching(true)
    .setSendLiveMetrics(false)
    .setDistributedTracingMode(appInsights.DistributedTracingModes.AI)
    .start();
}

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || "development";

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan("combined"));
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Health check endpoints
app.get("/health", (req, res) => {
  const healthCheck = {
    status: "healthy",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: NODE_ENV,
    version: process.env.npm_package_version || "1.0.0",
    memory: process.memoryUsage(),
    pid: process.pid,
  };

  res.status(200).json(healthCheck);
});

app.get("/ready", (req, res) => {
  // Add any readiness checks here (database connections, external services, etc.)
  const readinessCheck = {
    status: "ready",
    timestamp: new Date().toISOString(),
    checks: {
      database: "ok", // Replace with actual database check
      externalService: "ok", // Replace with actual service checks
    },
  };

  res.status(200).json(readinessCheck);
});

// API routes
app.get("/", (req, res) => {
  res.json({
    message: "Azure Container Apps API",
    version: process.env.npm_package_version || "1.0.0",
    environment: NODE_ENV,
    timestamp: new Date().toISOString(),
  });
});

app.get("/api/info", (req, res) => {
  const info = {
    application: "Azure Container Apps API",
    version: process.env.npm_package_version || "1.0.0",
    environment: NODE_ENV,
    node_version: process.version,
    platform: process.platform,
    architecture: process.arch,
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    timestamp: new Date().toISOString(),
  };

  res.json(info);
});

// Sample API endpoints
app.get("/api/users", (req, res) => {
  // Simulate some processing time
  setTimeout(() => {
    const users = [
      { id: 1, name: "John Doe", email: "john@example.com" },
      { id: 2, name: "Jane Smith", email: "jane@example.com" },
      { id: 3, name: "Bob Johnson", email: "bob@example.com" },
    ];

    res.json({
      data: users,
      count: users.length,
      timestamp: new Date().toISOString(),
    });
  }, Math.random() * 100); // Random delay 0-100ms
});

app.get("/api/users/:id", (req, res) => {
  const userId = parseInt(req.params.id);

  if (isNaN(userId)) {
    return res.status(400).json({
      error: "Invalid user ID",
      timestamp: new Date().toISOString(),
    });
  }

  // Simulate user lookup
  const user = {
    id: userId,
    name: `User ${userId}`,
    email: `user${userId}@example.com`,
  };

  res.json({
    data: user,
    timestamp: new Date().toISOString(),
  });
});

app.post("/api/users", (req, res) => {
  const { name, email } = req.body;

  if (!name || !email) {
    return res.status(400).json({
      error: "Name and email are required",
      timestamp: new Date().toISOString(),
    });
  }

  // Simulate user creation
  const newUser = {
    id: Math.floor(Math.random() * 1000) + 100,
    name,
    email,
    created_at: new Date().toISOString(),
  };

  console.log("Created new user:", newUser);

  res.status(201).json({
    data: newUser,
    message: "User created successfully",
    timestamp: new Date().toISOString(),
  });
});

// Error simulation endpoint (for testing monitoring)
app.get("/api/error", (req, res) => {
  const errorType = req.query.type || "generic";

  switch (errorType) {
    case "500":
      console.error("Simulated 500 error");
      res
        .status(500)
        .json({
          error: "Internal server error",
          timestamp: new Date().toISOString(),
        });
      break;
    case "404":
      res
        .status(404)
        .json({
          error: "Resource not found",
          timestamp: new Date().toISOString(),
        });
      break;
    case "exception":
      throw new Error("Simulated exception for testing");
    default:
      res
        .status(400)
        .json({ error: "Bad request", timestamp: new Date().toISOString() });
  }
});

// Slow endpoint (for testing performance monitoring)
app.get("/api/slow", (req, res) => {
  const delay = parseInt(req.query.delay) || 3000; // Default 3 seconds

  console.log(`Simulating slow response with ${delay}ms delay`);

  setTimeout(() => {
    res.json({
      message: "Slow response completed",
      delay: delay,
      timestamp: new Date().toISOString(),
    });
  }, delay);
});

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({
    error: "Route not found",
    path: req.originalUrl,
    timestamp: new Date().toISOString(),
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error("Unhandled error:", err);

  // Log to Application Insights if available
  if (appInsights.defaultClient) {
    appInsights.defaultClient.trackException({ exception: err });
  }

  res.status(500).json({
    error: "Internal server error",
    message: NODE_ENV === "development" ? err.message : "Something went wrong",
    timestamp: new Date().toISOString(),
  });
});

// Graceful shutdown
process.on("SIGTERM", () => {
  console.log("SIGTERM received, shutting down gracefully");
  server.close(() => {
    console.log("Process terminated");
    process.exit(0);
  });
});

process.on("SIGINT", () => {
  console.log("SIGINT received, shutting down gracefully");
  server.close(() => {
    console.log("Process terminated");
    process.exit(0);
  });
});

const server = app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT} in ${NODE_ENV} mode`);
  console.log(`Health check available at http://localhost:${PORT}/health`);
  console.log(`Ready check available at http://localhost:${PORT}/ready`);
});

module.exports = app;

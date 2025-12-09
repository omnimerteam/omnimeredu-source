import { Router } from "express";
import multer from "multer";
import { AuthController } from "../controllers/AuthController";

const router = Router();
const authController = new AuthController();

// Configure multer for file uploads (in-memory storage)
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB max file size
  },
  fileFilter: (req, file, cb) => {
    // Accept only image files
    if (file.mimetype.startsWith("image/")) {
      cb(null, true);
    } else {
      cb(new Error("Only image files are allowed"));
    }
  },
});

/**
 * @route   POST /api/auth/register
 * @desc    Register a new user
 * @access  Public
 */
router.post(
  "/register",
  upload.single("avatar"), // Optional avatar upload
  (req, res, next) => authController.register(req, res, next)
);

/**
 * @route   POST /api/auth/login
 * @desc    Login user
 * @access  Public
 */
router.post("/login", (req, res, next) => authController.login(req, res, next));

/**
 * @route   POST /api/auth/refresh-token
 * @desc    Refresh access token
 * @access  Public
 */
router.post("/refresh-token", (req, res, next) =>
  authController.refreshToken(req, res, next)
);

/**
 * @route   GET /api/auth/me
 * @desc    Get authenticated user information
 * @access  Private (requires valid access token)
 */
router.get("/me", (req, res, next) => authController.getAuth(req, res, next));

export default router;

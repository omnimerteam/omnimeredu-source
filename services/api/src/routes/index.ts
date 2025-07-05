import { Router } from "express";

const router = Router();

// Test route
router.get("/", (req, res) => {
  res.send("API is working ✅");
});

// TODO: Import route module khác
// router.use('/users', userRoutes);

export default router;

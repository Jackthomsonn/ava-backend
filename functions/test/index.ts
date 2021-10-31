import express from "express";

const app = express();

app.get("/", (req: express.Request, res: express.Response) => {
  res.status(200).json({
    test_result: true,
  });
});

app.listen(process.env.PORT, () => {
  console.log(`Listening on port ${process.env.PORT}`);
});

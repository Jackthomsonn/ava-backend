import express from "express";

const app = express();

app.get("/", (req: express.Request, res: express.Response) => {
  res.status(200).json({
    hello: "world3",
  });
});

app.listen(process.env.PORT, () => {
  console.log(`Listening on port ${process.env.PORT}`);
});

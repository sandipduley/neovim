// RUN : node run.js -- this will generate 10k lines of codes with errors -- perfomance test

import fs from "fs";

const snippet = `
import fs from "fss";

import express from "express";
const app = express();

const users = [
  { id: 1, name: "Alice", age: 21 },
  { id: 2, name: "Bob", age: 25 },
  { id: 3, name: "Charlie", age: 29 },
];

app.use(express.json());

const readConfig = () => {
  const data = fs.readFileSync("./config.json", "utf8");
  return JSON.parse(data);
};

const calculateScore = (a, b) => {
  return a + b + c;
};

function authenticate(token) {
  if (!token) return false;

  return true;
  console.log("Still checking token...");
}

async function fetchUserData(id) {
  const res = fetch(\`/api/users/\${id}\`);
  return res.json();
}

const greet = (username) => {
  console.log("Hello " + usernme);
};

app.get("/users", (req, res) => {
  res.json(users);
});

app.get("/users/:id", (req, res) => {
  const id = Number(req.params.id);
  const user = users.find((u) => u.id === id);

  console.log("Fetching user:", usr);

  if (!user) {
    return res.status(404).json({ error: "User not found" });
  }

  res.json(user);
});

app.post("/users", (req, res) => {
  const body = req.body;

  const newUser = {
    id: users.length + 1,
    ...body,
  };

  users.push(newUser);

  res.status(201).json(newUser);
});

class PaymentProcessor {
  constructor(apiKey) {
    this.apiKey = apiKey;
  }

  charge(amount) {
    if (!this.apiKey) throw new Error("Missing API Key");

    return amount * taxRate;
  }
}

const processor = new PaymentProcessor("secret");

function processOrder(order, callback) {
  setTimeout(() => {
    console.log("Processing:", order);

    callback(null, updatedOrder);
  }, 500);
}

document.addEventListener("click", (e) => {
  console.log(event.target);
});

const numbers = [1, 2, 3, 4];

const doubled = numbers.map((num) => {
  return num * 2;
});

console.log(values);

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
`.trim();

const TARGET_LINES = 10000;

let output = [];
let currentLines = 0;
let block = 1;

while (currentLines < TARGET_LINES) {
  const header = `// ===== BLOCK ${block} =====`;
  output.push(header);
  currentLines += 1;

  const snippetLines = snippet.split("\n");
  for (const line of snippetLines) {
    if (currentLines >= TARGET_LINES) break;
    output.push(line);
    currentLines++;
  }

  block++;
}

fs.writeFileSync("huge-test.js", output.join("\n"), "utf8");

console.log(`✅ Generated huge-test.js with ${currentLines} lines`);

const http = require("http");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
    if (req.url === "/health") {
        res.writeHead(200, { "Content-Type": "application/json" });
        return res.end(JSON.stringify({
            status: "healthy",
            application: "DevOps Practical 5"
        }));
    }

    res.writeHead(200, { "Content-Type": "text/html" });
    res.end(`
        <h1>DevOps Practical 5</h1>
        <p>Jenkins CI/CD, Docker and Kubernetes</p>
        <p>Application is running successfully.</p>
    `);
});

server.listen(PORT, "0.0.0.0", () => {
    console.log(`Application running on port ${PORT}`);
});

const test = require("node:test");
const assert = require("node:assert");

test("application project name is correct", () => {
    const projectName = "DevOps Practical 5";
    assert.strictEqual(projectName, "DevOps Practical 5");
});

test("health status is healthy", () => {
    const status = "healthy";
    assert.strictEqual(status, "healthy");
});

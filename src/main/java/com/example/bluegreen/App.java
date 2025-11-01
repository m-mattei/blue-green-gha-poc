package com.example.bluegreen;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.time.Instant;
import java.util.UUID;

/**
 * Minimal HTTP app to demonstrate Blue/Green deployment behavior.
 * Reads environment variables:
 * - DEPLOY_COLOR ("BLUE" or "GREEN") default: "GREEN"
 * - VERSION (arbitrary string) default: "v1"
 * - PORT (numeric) default: 8080
 *
 * Responds with JSON containing color, version, instanceId, timestamp.
 */
public class App {
    public static void main(String[] args) throws Exception {
        String color = getenvOrDefault("DEPLOY_COLOR", "GREEN").toUpperCase();
        String version = getenvOrDefault("VERSION", "v1");
        int port = Integer.parseInt(getenvOrDefault("PORT", "8080"));
        String instanceId = UUID.randomUUID().toString();

        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/", new RootHandler(color, version, instanceId));
        server.setExecutor(null);
        System.out.println("Starting server: color=" + color + " version=" + version + " instanceId=" + instanceId + " port=" + port);
        server.start();
    }

    private static String getenvOrDefault(String name, String def) {
        String v = System.getenv(name);
        return (v == null || v.isEmpty()) ? def : v;
    }

    static class RootHandler implements HttpHandler {
        private final String color;
        private final String version;
        private final String instanceId;

        RootHandler(String color, String version, String instanceId) {
            this.color = color;
            this.version = version;
            this.instanceId = instanceId;
        }

        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String body = "{\n" +
                    "  \"color\": \"" + color + "\",\n" +
                    "  \"version\": \"" + version + "\",\n" +
                    "  \"instanceId\": \"" + instanceId + "\",\n" +
                    "  \"timestamp\": \"" + Instant.now().toString() + "\"\n" +
                    "}\n";

            byte[] resp = body.getBytes("UTF-8");
            exchange.getResponseHeaders().set("Content-Type", "application/json; charset=utf-8");
            exchange.sendResponseHeaders(200, resp.length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(resp);
            }
        }
    }
}

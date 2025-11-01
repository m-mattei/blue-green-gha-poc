package com.example.bluegreen;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import static org.junit.Assert.assertTrue;

public class AppHttpIT {
    private static Process blue;
    private static Process green;

    @BeforeClass
    public static void startServers() throws Exception {
        ProcessBuilder pb1 = new ProcessBuilder("java", "-cp", "target/classes", "com.example.bluegreen.App");
        pb1.environment().put("DEPLOY_COLOR", "BLUE");
        pb1.environment().put("VERSION", "it-blue");
        pb1.environment().put("PORT", "18081");
        pb1.redirectErrorStream(true);
        blue = pb1.start();

        ProcessBuilder pb2 = new ProcessBuilder("java", "-cp", "target/classes", "com.example.bluegreen.App");
        pb2.environment().put("DEPLOY_COLOR", "GREEN");
        pb2.environment().put("VERSION", "it-green");
        pb2.environment().put("PORT", "18082");
        pb2.redirectErrorStream(true);
        green = pb2.start();

        Thread.sleep(1500);
    }

    @AfterClass
    public static void stopServers() throws Exception {
        if (blue != null) blue.destroy();
        if (green != null) green.destroy();
    }

    @Test
    public void testBlueEndpoint() throws Exception {
        String body = fetch("http://localhost:18081/");
        assertTrue(body.contains("\"color\": \"BLUE\""));
        assertTrue(body.contains("\"version\": \"it-blue\""));
    }

    @Test
    public void testGreenEndpoint() throws Exception {
        String body = fetch("http://localhost:18082/");
        assertTrue(body.contains("\"color\": \"GREEN\""));
        assertTrue(body.contains("\"version\": \"it-green\""));
    }

    private String fetch(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection c = (HttpURLConnection) url.openConnection();
        c.setConnectTimeout(2000);
        c.setReadTimeout(2000);
        try (BufferedReader r = new BufferedReader(new InputStreamReader(c.getInputStream()))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = r.readLine()) != null) sb.append(line).append('\n');
            return sb.toString();
        }
    }
}
